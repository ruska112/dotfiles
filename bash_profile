#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

if [ -z "$WAYLAND_DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
	exec sway
fi

export _JAVA_AWT_WM_NONREPARENTING=1
export QT_QPA_PLATFORM=wayland
