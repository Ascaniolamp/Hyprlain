
if command -v neofetch > /dev/null 2>&1; then
	alias neofetch='neofetch --source ~/.config/neofetch/logo'
elif command -v fastfetch > /dev/null 2>&1; then
	# neofetch is unmaintained and missing on Fedora; fastfetch reads the same logo
	alias neofetch='fastfetch --logo-type file --logo ~/.config/neofetch/fastfetch-logo'
fi

PATH="$PATH:$HOME/.config/hypr/scripts"
export PATH

# oh-my-zsh/powerlevel10k
typeset -g POWERLEVEL9K_OS_ICON_CONTENT_EXPANSION=''
