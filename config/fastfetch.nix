{ pkgs, ... }:
# Custom fastfetch script. Feel free to edit
{
  environment.systemPackages = [ pkgs.fastfetch ];

  environment.etc."fastfetch/config.jsonc".text = ''
    {
      "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
      "modules": [
        "title",
        "separator",
        { "type": "os", "key": "󱄅 OS  " },
        { "type": "uptime", "key": "󰅐 UP  " },
        { "type": "localip", "key": "󰩟 IP  ", "showIpv6": false },
	{
          "type": "command",
          "key": "󰩟 TS  ",
          "text": "tailscale ip -4 || echo 'Offline'"
        },
	{
          "type": "command",
          "key": "󱘎 GEN ",
          "text": "readlink /nix/var/nix/profiles/system | cut -d- -f2"
        },
        {
          "type": "command",
          "key": "󰁯 PIN ",
          "text": "ls /nix/var/nix/gcroots/pinned-* 2>/dev/null | wc -l"
        },
        "break",
        { "type": "cpu", "key": "󰻠 CPU ", "temp": true },
        { "type": "memory", "key": "󰍛 RAM " },
        { "type": "disk", "key": "󰋊 DISK", "folders": "/" },
        "break",
        {
          "type": "command",
          "key": "󱆓 DOCK",
          "text": "echo $(docker ps -q | wc -l) / $(docker ps -aq | wc -l) running"
        },
        "break",
        "colors"
      ]
    }
  '';
}
