#!/bin/sh
# ThinkPad のファンレベルを 3 つのプロファイルで巡回させる。
# waybar の custom/fan モジュールから status / cycle を呼ぶ。
#
# 制御の入口は /proc/acpi/ibm/fan (level auto|0-7|full-speed) と
# hwmon (pwm1_enable, pwm1) の 2 つがあるが、hwmon 側だけを使う。
# 権限を udev で開ける方針なので、udev の管理下にある sysfs で統一した方が
# 「ルールが発火した時点で属性が存在する」ことを保証できる (理由の詳細は
# udev/99-thinkpad-fan.rules のコメント)。読みだけ procfs というのも
# ちぐはぐなので、状態の取得も hwmon に寄せている。
#
# pwm1_enable のセマンティクス (thinkpad_acpi):
#   2 = EC の auto / 1 = manual (pwm1 でレベル指定) / 0 = full-speed
# プロファイルの判定は必ずここから入る。pwm1 は auto モード中の現在レベルを
# 表さないため単独では使えない。auto のとき thinkpad_acpi はドライバ内部の
# fan_control_desired_level を返し、その初期値が 7 なので、ファンが完全に
# 止まっていても pwm1 は 255 を返す。実回転数は fan1_input で見る。
#
# 書き込み順序は pwm1_enable=1 -> pwm1 で固定。逆順は無効で、しかも失敗しない。
# ドライバの fan_pwm1_store は EC が AUTO か FULLSPEED のとき何もせず成功を
# 返すので、auto 中に pwm1 を書くと黙って捨てられる (実機で確認済み)。
#
# その副作用として、auto から manual に入る瞬間だけレベルが跳ねる。
# fan_pwm1_enable_store の case 1 が fan_control_desired_level をそのまま
# EC に流すため、pwm1 を書くまでの数ミリ秒は直前の manual レベル (未設定なら
# 初期値の 7) になる。実機でも auto -> enable=1 の直後に level: 7 を観測した。
# hwmon 経由では回避できない (procfs なら level 1 の 1 回書きで済む)。
# 実害は一瞬の吹き上がりだけなので、承知のうえで hwmon に寄せている。
#
# level <-> pwm の換算はドライバの実装に合わせる。
#   書き: pwm = level * 32   (fan_pwm1_store の (pwm >> 5) & 0x07 の逆関数)
#   読み: level = (pwm * 7 + 127) / 255   (fan_pwm1_show の (level * 255) / 7 の逆)
#
# 巡回に level 0 (ファン停止) と full-speed を入れていないのは事故のコストが
# 大きいため。level 0 のまま放置して高負荷になると冷却が効かず、full-speed は
# EC の制御を外して無制限に回すので、ドライバの文書もファン寿命への影響を
# 警告している。max は manual level 7 (EC が管理する上限) で足りる。
# ただし他ツールや直接 echo でその状態になることはありうるので、status では
# off / full として独立に表示し、巡回の次段は必ず auto に落ちるようにしてある。
#
# 手動プロファイルを戻し忘れると危ないが、/proc/acpi/ibm/fan の watchdog は
# hwmon に対応する属性が無い。そもそも watchdog は「N 秒書き込みが無ければ
# auto に戻る」リース方式で、thinkfan のような常駐が書き続ける前提のため、
# 「押したら固定」という今回の UI とは噛み合わない (放っておくと勝手に戻る)。
#
# 代わりに status に温度セーフガードを相乗りさせる。waybar が 5 秒ごとに
# status を呼ぶので、常駐プロセスを増やさずに監視できる。守りたいのは
# 「waybar が死んだ」ではなく「quiet のまま重い処理を始めた」なので、
# 温度を直接見るこの方式の方がリース方式より実態に合っている。
# 加えて状態ごとにアイコンと色を変え、右クリックでいつでも auto に戻せる。

WAYBAR_SIGNAL=1

QUIET_LEVEL=3
MAX_LEVEL=7

# 手動固定のまま高温になったら auto に戻す閾値 (ミリ度)。
# thinkpad hwmon の temp1 (label=CPU) は EC が持つセンサで、k10temp の Tctl の
# ように設計上高値に張り付かないので閾値の材料にできる。temp2 (GPU) はこの
# 機体では ENXIO を返すので使わない。
GUARD_TEMP=85000

# name が thinkpad の hwmon を探す。platform デバイス名は固定だが配下の
# hwmonN は起動ごとに変わりうるので、まず固定パスの glob を見て、
# 外れたときだけ name で総当りする。
hwmon() {
    for dir in /sys/devices/platform/thinkpad_hwmon/hwmon/hwmon*; do
        [ -e "$dir/pwm1_enable" ] && { echo "$dir"; return 0; }
    done
    for dir in /sys/class/hwmon/hwmon*; do
        [ "$(cat "$dir/name" 2>/dev/null)" = thinkpad ] || continue
        [ -e "$dir/pwm1_enable" ] && { echo "$dir"; return 0; }
    done
    return 1
}

# sysfs が空文字を返したときに算術展開が構文エラーにならないよう既定値を置く。
level_to_pwm() {
    echo $(( ${1:-0} * 32 ))
}

pwm_to_level() {
    echo $(( (${1:-0} * 7 + 127) / 255 ))
}

# 手動固定中に閾値を超えたら auto に戻す。waybar の interval に相乗りさせて
# いるので、常駐は増やさない。
#
# 対象は auto より冷却が弱くなりうる状態だけ。max と full は auto 以上に
# 回しているので、熱いからといって auto に戻すのは逆効果になる
# (ユーザーが冷やしたくて max にした直後に勝手に戻る)。
guard() {
    dir="$1"

    case "$(current "$dir")" in
        auto|max|full|unavailable) return 0 ;;
    esac

    t=$(cat "$dir/temp1_input" 2>/dev/null)
    case "$t" in
        ''|*[!0-9]*) return 0 ;;
    esac
    [ "$t" -lt "$GUARD_TEMP" ] && return 0

    echo 2 2>/dev/null > "$dir/pwm1_enable" || return 0

    # 連打で通知が積み上がらないよう置換キーを固定する
    # (power-profile-notify.sh と同じ作法)。
    notify-send \
        -a 'Fan control' \
        -u critical \
        -t 5000 \
        -h "string:x-canonical-private-synchronous:fan-profile" \
        'Fan control' "CPU $(( t / 1000 ))°C のため auto に戻しました"
}

# 無効値 (EC の 0xFFFF) と非数値を捨てて RPM を返す。
read_rpm() {
    v=$(cat "$1" 2>/dev/null)
    case "$v" in
        ''|*[!0-9]*|65535) return 0 ;;
    esac
    echo "$v"
}

# 現在の状態を返す。auto / quiet / max / manual / off / full / unavailable。
# off (ファン停止) と full (EC 制御外の全開) は巡回に含めないが、外部要因で
# その状態になりうる。危険な状態を quiet や max のラベルで隠さないよう、
# 独立した名前で返す。
current() {
    dir="$1"
    enable=$(cat "$dir/pwm1_enable" 2>/dev/null)

    case "$enable" in
        2) echo auto ;;
        0) echo full ;;
        1)
            level=$(pwm_to_level "$(cat "$dir/pwm1" 2>/dev/null)")
            if [ "$level" -eq 0 ]; then
                echo off
            elif [ "$level" -eq "$QUIET_LEVEL" ]; then
                echo quiet
            elif [ "$level" -eq "$MAX_LEVEL" ]; then
                echo max
            else
                echo manual
            fi
            ;;
        *) echo unavailable ;;
    esac
}

# auto に戻すのは pwm1_enable に 2 を書くだけ。manual に入るときは先に
# pwm1_enable を 1 にしないと pwm1 への書き込みが黙って捨てられる。
#
# 2>/dev/null は出力リダイレクトより前に置くこと。リダイレクトは左から順に
# 適用されるので、後ろに置くと pwm1_enable への書き込みが失敗したときの
# 「許可がありません」が端末に漏れる (終了ステータスはどちらも 1)。
apply() {
    dir="$1"
    profile="$2"

    case "$profile" in
        auto)
            echo 2 2>/dev/null > "$dir/pwm1_enable"
            ;;
        quiet)
            echo 1 2>/dev/null > "$dir/pwm1_enable" &&
                level_to_pwm "$QUIET_LEVEL" 2>/dev/null > "$dir/pwm1"
            ;;
        max)
            echo 1 2>/dev/null > "$dir/pwm1_enable" &&
                level_to_pwm "$MAX_LEVEL" 2>/dev/null > "$dir/pwm1"
            ;;
    esac
}

# 巡回は auto -> quiet -> max -> auto。それ以外 (off / full / manual /
# unavailable) からは必ず auto に落ちるので、どんな状態になっても
# 1 クリックで安全側に戻せる。
next_profile() {
    case "$1" in
        auto)  echo quiet ;;
        quiet) echo max ;;
        *)     echo auto ;;
    esac
}

# waybar への通知。config 側に "signal": 1 を持つモジュールが居ないときに
# 撃つと、ハンドラ未登録の waybar がリアルタイムシグナルのデフォルト動作で
# 静かに死ぬ (b4e914d)。custom/fan とセットでのみ使うこと。
notify() {
    pkill -RTMIN+"$WAYBAR_SIGNAL" waybar
}

# アイコンは config の format-icons が alt をキーに選ぶ (custom/caffeine と
# 同じ作法)。class は CSS の色分け用で、読めても書けないときだけ状態と
# ずらして unavailable にする。
emit() {
    printf '{"alt":"%s","class":"%s","tooltip":"%s"}\n' "$1" "$2" "$3"
}

status() {
    dir="$1"

    if [ -z "$dir" ]; then
        emit unavailable unavailable "Fan: thinkpad hwmon が見つからない"
        return
    fi

    guard "$dir"

    state=$(current "$dir")

    if [ "$state" = unavailable ]; then
        emit unavailable unavailable "Fan: 制御できない (thinkpad_acpi の状態を確認)"
        return
    fi

    # EC はレベルを切り替えた直後などに 0xFFFF (65535) を返す。実測では数秒で
    # 実測値に落ち着くが、ポーリングがそこに当たると桁違いの数字が出るので弾く。
    # この機体は 2 つ報告するが常に同値なので、違うときだけ併記する。
    rpm=$(read_rpm "$dir/fan1_input")
    rpm2=$(read_rpm "$dir/fan2_input")
    if [ -n "$rpm2" ] && [ "$rpm2" != "$rpm" ]; then
        rpm="${rpm:-?} / $rpm2"
    fi

    case "$state" in
        auto)   label="auto (EC 制御)" ;;
        quiet)  label="quiet (手動 level $QUIET_LEVEL)" ;;
        max)    label="max (手動 level $MAX_LEVEL)" ;;
        off)    label="停止 (手動 level 0)" ;;
        full)   label="full-speed (EC 制御外)" ;;
        manual) label="手動 level $(pwm_to_level "$(cat "$dir/pwm1" 2>/dev/null)")" ;;
    esac

    # 読めても書けない場合 (udev ルール未適用) はボタンを押しても何も起きない。
    # アイコンは実状態のままにして、色だけ警告にする。
    if [ ! -w "$dir/pwm1_enable" ]; then
        emit "$state" unavailable "Fan: $label / ${rpm:-?} RPM\\n書き込み権限なし (udev ルール未適用)"
        return
    fi

    emit "$state" "$state" "Fan: $label / ${rpm:-?} RPM"
}

dir=$(hwmon)

case "${1:-status}" in
    status)
        status "$dir"
        ;;
    cycle)
        [ -n "$dir" ] || exit 0
        apply "$dir" "$(next_profile "$(current "$dir")")"
        notify
        ;;
    set)
        [ -n "$dir" ] || exit 0
        case "$2" in
            auto|quiet|max)
                apply "$dir" "$2"
                notify
                ;;
            *)
                echo "usage: $0 set <auto|quiet|max>" >&2
                exit 1
                ;;
        esac
        ;;
    *)
        echo "usage: $0 [status|cycle|set <auto|quiet|max>]" >&2
        exit 1
        ;;
esac
