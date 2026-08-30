# dotconfig
a part of my .config

## aerospace の app-id 取得方法

```console
$ lsappinfo info -only bundleid "Discord"
"CFBundleIdentifier"="com.hnc.Discord"
```
この `com.hnc.Discord` を `~/.config/aerospace/aerospace.toml の `if.app-id =` に指定する。


## ghostty の theme を探す

```console
$ ghostty +list-themes
```
左のリストにある名前を `~/.config/ghostty/config` の `theme = ` に指定する。

## ThinkPad のファン制御 (waybar の custom/fan)

`udev/` は `symlink.rb` の対象外なので、root 権限で手動配置する。

```console
$ sudo cp udev/99-thinkpad-fan.rules /etc/udev/rules.d/
$ sudo udevadm control --reload-rules
$ sudo udevadm trigger --subsystem-match=hwmon --action=add
```

`/sys/class/hwmon/hwmon*/pwm1_enable` が `root wheel` の `664` になれば成功。

書き込みには権限のほかに `thinkpad_acpi` の `fan_control=1` も要る
(`/etc/modprobe.d/thinkfan.conf`)。`/sys/module/thinkpad_acpi/parameters/fan_control`
が `Y` であることを確認する。
