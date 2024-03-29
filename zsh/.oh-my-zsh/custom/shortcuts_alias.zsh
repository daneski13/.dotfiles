# File contains misc functions and alaises

# Refresh zsh terminal
alias f5="exec zsh"

# Open the github page for the macos zsh plugin
alias macos="open 'https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/macos'"

# fuzzy find a dir and cd into it
function fcd() {
    cd "$(fzd $1)"
}

# fzf multi select with header
# C-t will toggle all
function fzf-m() {
    fzf --multi --bind ctrl-t:toggle-all --header "$1"
}

# Open in vscode
function vs() {
    if [ $# -lt 1 ]; then
        # No args, open the whole dir
        code .
        return
    fi
    code $1
}

# Edit dotfiles
alias dotfiles="cd $HOME/.dotfiles; nvim ."

# Change wallpaper and update pywal
function wallpaper() {
    if [ $# -lt 1 ]; then
        echo "Usage: wallpaper <image path>"
        return
    fi

    # Set as wallpaper
    echo "Wallpaper Set"
    osascript -e "tell application \"Finder\" to set desktop picture to POSIX file \"$1\""

    # Generate and apply colors using flavours
    echo "Generating and applying color schemes..."
    flavours generate dark $1
    flavours apply "generated"

    # Spicetify (a hook via flavours isn't working)
    echo "Spicing Spotify..."
    spicetify-wallpaper 1> /dev/null
}

# Update Spicetify Wallpaper theme
function spicetify-wallpaper() {
    # Check if current theme is Wallpaper
    local CTHEME=$(spicetify config current_theme)
    if [[ $CTHEME != "Wallpaper" ]]; then
        return
    fi

    # Restore spotify to normal state and ensure spicetify up to date
    spicetify restore backup
    spicetify upgrade
    # Set the new theme and color scheme
    spicetify config current_theme Wallpaper
    spicetify config color_scheme wallpaper
    # Apply the changes
    spicetify backup apply
    open -a Spotify
}

# Update Spicetify themes
function spicetify-update() {
    # Update the themes
    cd ~/spicetify-themes
    gpl
    cp -r * ~/.config/spicetify/Themes
    # Apply the changes
    spicetify backup apply
    open -a Spotify
    popd
}

# Help stuff
alias help="echo zshcustom"
alias zshcustom="cd $HOME/.oh-my-zsh/custom; ofd"
