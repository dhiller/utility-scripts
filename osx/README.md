OS X helper scripts
===

`refresh-dhcp-after-network-drop.sh`
---

Utility script to monitor WiFi connection and refresh DHCP lease
if necessary.

Pings Google DNS server and it that fails, suspects that the WiFi connection
has been interrupted. Shuts down WiFi connection, refreshes DHCP lease
and turns on WiFi again. Very hacky (i.e. `sleep` and all instead of checking)
but works for me.

Note: the sudo command used in the script requires to enter a password. You may execute `sudo chmod +s osx/refresh-dhcp-after-network-drop.sh`
