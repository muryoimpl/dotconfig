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
