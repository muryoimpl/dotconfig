#!/usr/bin/env bash
# Wayland 環境で Chrome の画面共有ができない原因を切り分ける診断スクリプト
# 使い方: bash diag-screenshare.sh
# read-only。設定の変更は一切おこないません。

hr() { printf '\n\033[1m== %s ==\033[0m\n' "$1"; }
ok()   { printf '  \033[32m[OK]\033[0m   %s\n' "$1"; }
warn() { printf '  \033[33m[WARN]\033[0m %s\n' "$1"; }
ng()   { printf '  \033[31m[NG]\033[0m   %s\n' "$1"; }
info() { printf '         %s\n' "$1"; }

VERDICTS=()

hr "1. セッション"
echo "  XDG_SESSION_TYPE   = ${XDG_SESSION_TYPE:-(未設定)}"
echo "  XDG_CURRENT_DESKTOP= ${XDG_CURRENT_DESKTOP:-(未設定)}"
echo "  WAYLAND_DISPLAY    = ${WAYLAND_DISPLAY:-(未設定)}"
echo "  DISPLAY            = ${DISPLAY:-(未設定)}"
echo "  compositor         = $(ps -eo comm= | grep -ixE 'mango|sway|Hyprland|hyprland|river|wayfire|labwc|niri|gnome-shell|kwin_wayland' | sort -u | tr '\n' ' ')"

if [ -z "${XDG_CURRENT_DESKTOP:-}" ]; then
  ng "XDG_CURRENT_DESKTOP が未設定です。ポータルはこの値でバックエンドを選ぶため、必ず解決が必要です。"
  VERDICTS+=("仮説3: XDG_CURRENT_DESKTOP 未設定")
fi

# ScreenCast の明示マッピングが設定済みかを先に判定しておく
EXPLICIT_SCREENCAST=no
if grep -rhqi 'impl\.portal\.ScreenCast' "$HOME"/.config/xdg-desktop-portal/*.conf \
     /etc/xdg/xdg-desktop-portal/*.conf 2>/dev/null; then
  EXPLICIT_SCREENCAST=yes
fi

hr "2. ポータルのバックエンド"
SCREENCAST_BACKENDS=()
if [ -d /usr/share/xdg-desktop-portal/portals ]; then
  for p in /usr/share/xdg-desktop-portal/portals/*.portal; do
    [ -e "$p" ] || continue
    name=$(basename "$p" .portal)
    ifaces=$(grep -m1 '^Interfaces=' "$p" | cut -d= -f2-)
    usein=$(grep -m1 '^UseIn=' "$p" | cut -d= -f2-)
    printf '  %-12s UseIn=%s\n' "$name" "${usein:-(指定なし)}"
    case "$ifaces" in
      *impl.portal.ScreenCast*)
        SCREENCAST_BACKENDS+=("$name")
        printf '  %-12s \033[36m→ ScreenCast を提供\033[0m\n' "" ;;
    esac
  done
else
  ng "/usr/share/xdg-desktop-portal/portals が存在しません（xdg-desktop-portal 未インストール？）"
fi

if [ ${#SCREENCAST_BACKENDS[@]} -eq 0 ]; then
  ng "ScreenCast を提供するバックエンドが 1 つもありません。"
  info "wlroots 系なら xdg-desktop-portal-wlr、Hyprland なら xdg-desktop-portal-hyprland が必要です。"
  VERDICTS+=("仮説2: ScreenCast バックエンド未インストール")
else
  ok "ScreenCast 提供バックエンド: ${SCREENCAST_BACKENDS[*]}"
fi

# UseIn と XDG_CURRENT_DESKTOP の突き合わせ
if [ -n "${XDG_CURRENT_DESKTOP:-}" ] && [ ${#SCREENCAST_BACKENDS[@]} -gt 0 ]; then
  matched=no
  for b in "${SCREENCAST_BACKENDS[@]}"; do
    usein=$(grep -m1 '^UseIn=' "/usr/share/xdg-desktop-portal/portals/$b.portal" | cut -d= -f2-)
    IFS=':' read -ra DESKS <<< "$XDG_CURRENT_DESKTOP"
    for d in "${DESKS[@]}"; do
      case ";${usein,,};" in *";${d,,};"*) matched=yes ;; esac
    done
  done
  if [ "$matched" = no ] && [ "$EXPLICIT_SCREENCAST" = no ]; then
    ng "XDG_CURRENT_DESKTOP='$XDG_CURRENT_DESKTOP' が ScreenCast バックエンドの UseIn に無く、portals.conf の明示指定もありません。"
    info "ScreenCast が解決されず、共有ダイアログの一覧が空になります。これが原因である可能性が高いです。"
    VERDICTS+=("仮説2: UseIn 不一致 + portals.conf 未設定で ScreenCast が未解決")
  elif [ "$matched" = no ]; then
    ok "UseIn には非該当ですが、portals.conf の明示指定で解決されています（正常機と同じ構成）。"
  else
    ok "UseIn が XDG_CURRENT_DESKTOP に一致しています。"
  fi
fi

hr "3. ポータルの設定ファイル"
FOUND_CONF=no
for f in "$HOME"/.config/xdg-desktop-portal/*.conf /etc/xdg/xdg-desktop-portal/*.conf; do
  [ -f "$f" ] || continue
  FOUND_CONF=yes
  echo "  --- $f"
  sed 's/^/      /' "$f"
done
[ "$FOUND_CONF" = no ] && warn "portals.conf が 1 つもありません（UseIn 依存のデフォルト解決のみ）。"

if [ "$FOUND_CONF" = yes ]; then
  if grep -rhq 'impl.portal.ScreenCast' "$HOME"/.config/xdg-desktop-portal/*.conf /etc/xdg/xdg-desktop-portal/*.conf 2>/dev/null; then
    ok "ScreenCast の明示マッピングあり"
  else
    warn "設定はあるが ScreenCast の明示マッピングはありません。"
  fi
fi

echo "  --- xdg-desktop-portal-wlr / -hyprland の config"
for f in "$HOME"/.config/xdg-desktop-portal-wlr/config "$HOME"/.config/hypr/xdph.conf; do
  [ -f "$f" ] && { echo "  --- $f"; sed 's/^/      /' "$f"; }
done

hr "4. サービス稼働状況"
for s in pipewire.service wireplumber.service pipewire-pulse.service xdg-desktop-portal.service; do
  st=$(systemctl --user is-active "$s" 2>/dev/null)
  if [ "$st" = active ]; then ok "$s = active"; else ng "$s = ${st:-unknown}"; fi
done
echo "  --- 起動中のポータルプロセス"
ps -eo args= | grep '[x]dg-desktop-portal' | awk '{print "      " $1}' | grep '^ *[/]' | sort -u
if ! systemctl --user is-active --quiet wireplumber.service && \
   ! pgrep -x pipewire-media-session >/dev/null 2>&1; then
  VERDICTS+=("仮説4: PipeWire セッションマネージャが動いていない可能性")
fi

hr "5. ScreenCast インターフェースの生存確認（決定打）"
if command -v busctl >/dev/null 2>&1; then
  if busctl --user introspect org.freedesktop.portal.Desktop /org/freedesktop/portal/desktop 2>/dev/null \
     | grep -q 'org.freedesktop.portal.ScreenCast'; then
    ok "org.freedesktop.portal.ScreenCast インターフェースが存在します"
    ver=$(busctl --user get-property org.freedesktop.portal.Desktop /org/freedesktop/portal/desktop \
          org.freedesktop.portal.ScreenCast version 2>&1)
    src=$(busctl --user get-property org.freedesktop.portal.Desktop /org/freedesktop/portal/desktop \
          org.freedesktop.portal.ScreenCast AvailableSourceTypes 2>&1)
    echo "      version             = $ver   (正常機は: u 4)"
    echo "      AvailableSourceTypes= $src   (正常機は: u 3 = MONITOR|WINDOW)"
    case "$src" in
      "u 0"|*rror*|*ailed*)
        ng "ソース種別が取得できません。impl バックエンドがコンポジタに接続できていません。"
        VERDICTS+=("仮説2/3: ScreenCast の impl バックエンドが機能していない") ;;
      *)
        ok "ポータル側は健全と判断できます → Chrome 側（仮説1）を疑ってください" ;;
    esac
  else
    ng "ScreenCast インターフェースが存在しません。これが直接の原因です。"
    VERDICTS+=("仮説2: ScreenCast の impl バックエンドが未解決")
  fi
else
  warn "busctl が見つかりません（systemd 環境ではないか、パスが通っていません）"
fi

hr "6. Chrome の動作モード（仮説1 の決定打）"
CHROME_ARGS=$(ps -eo args= | grep -- '[-]-type=gpu-process' | grep -iE 'chrome|chromium' | head -1)
if [ -z "$CHROME_ARGS" ]; then
  warn "Chrome が起動していません。Chrome を起動してから再実行してください。"
  info "または chrome://gpu を開き 'Ozone platform' の行を確認してください。"
else
  oz=$(printf '%s' "$CHROME_ARGS" | tr ' ' '\n' | grep -m1 '^--ozone-platform=')
  echo "      ${oz:-(--ozone-platform 指定なし)}"
  case "$oz" in
    *wayland*) ok "Wayland ネイティブで動作しています（正常機と同じ）" ;;
    *x11*)     ng "XWayland(x11) で動作しています。X11 キャプチャは wlroots 上で画面を列挙できません。"
               VERDICTS+=("仮説1: Chrome が XWayland で動作している") ;;
    *)         warn "Ozone platform を判定できませんでした。chrome://gpu で確認してください。" ;;
  esac
  printf '%s' "$CHROME_ARGS" | tr ' ' '\n' | grep -iE 'pipewire' \
    && info "(上記に PipeWire capturer の指定あり)"
fi

echo
echo "  --- Chrome のインストール形態"
command -v google-chrome-stable google-chrome chromium 2>/dev/null | sed 's/^/      /'
command -v flatpak >/dev/null 2>&1 && flatpak list --app 2>/dev/null | grep -i chrom | sed 's/^/      flatpak: /'
command -v snap    >/dev/null 2>&1 && snap list 2>/dev/null | grep -i chrom | sed 's/^/      snap: /'

hr "7. ポータルの直近ログ（共有を試した直後だと有用）"
journalctl --user -u xdg-desktop-portal -u xdg-desktop-portal-wlr \
  -u xdg-desktop-portal-hyprland -u xdg-desktop-portal-gtk \
  --since "10 min ago" --no-pager 2>/dev/null | tail -30 | sed 's/^/      /'

hr "判定サマリ"
if [ ${#VERDICTS[@]} -eq 0 ]; then
  ok "自動判定では明確な異常を検出できませんでした。"
  info "セクション 5 と 6 の値を正常機と目視で比較してください。"
else
  for v in "${VERDICTS[@]}"; do ng "$v"; done
fi
echo
