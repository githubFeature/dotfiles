#!/usr/bin/env python
"""
OnScreen menu for i3
"""
import dmenu

DMENU_RUN = (
    "dmenu_run",
    "-fn", "-misc-*-*-*-*-*-*-140-*-*-*-*-iso10646-1",
    "-b", "-l", "20", "-i",
    "-nb", "#202020", "-nf", "#7f7f7f",
    "-sb", "#AA64FF", "-sf", "#000000",
    "-p", "RUN:"
)

DMENU_APP = (
    "i3-dmenu-desktop",
    '--dmenu=dmenu -fn "-misc-*-*-*-*-*-*-140-*-*-*-*-iso10646-1" -b -l 20 '
    '-nb "#202020" -nf "#7f7f7f" -sb "#FF4F00" -sf "#FFFFFF" -p "RUN APP:"'
)

QUICKSWITCH = (
    "quickswitch.py",
    "-fn=\"-misc-*-*-*-*-*-*-140-*-*-*-*-iso10646-1\" "
    "-nb=#202020 -nf=#7f7f7f -sb=#7fFF3f -sf=#000000 -p \"SWITCH:\""
)

SWAP_WITH = (
    "sh", "-c", "wmfocus -p | xargs -I {} i3-msg swap container with con_id {}"
)

dmenu.run({
    "border": {
        "none": ["i3-msg", "border none"],
        "1 pixel": ["i3-msg", "border 1pixel"],
        "normal": ["i3-msg", "border normal"],
        "title": ["i3-msg", "border normal 0"],
    },
    "swap with": SWAP_WITH,
    "run": {
        "cmd": DMENU_RUN,
        "app": DMENU_APP,
    },
    "quickswitch": QUICKSWITCH,
    "mark": {
        "mark ..": ["i3-input", "-F", "mark %s", "-l", "1", "-P", "Mark: "],
        "go to ..":
        ["i3-input", "-F", "[con_mark=%s] focus", "-l", "1", "-P", "Go to: "],
    },
    "move w/s to": {
        "internal": ["i3-msg", "move workspace to output eDP-1"],
        "VGA": ["i3-msg", "move workspace to output DP-2"],
        "DP-1": ["i3-msg", "move workspace to output DP-1"],
        "HDMI": ["i3-msg", "move workspace to output HDMI-1"]
    }
}, {
    "prefix": "i3 "
})
