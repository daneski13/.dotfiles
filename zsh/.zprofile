# Kiro CLI pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zprofile.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zprofile.pre.zsh"
# Q pre block. Keep at the top of this file.
# macOS only
if [[ "$OSTYPE" == "darwin"* ]]; then
	# homebrew
	eval "$(/opt/homebrew/bin/brew shellenv)"
	export HOMEBREW_NO_AUTO_UPDATE=1

	FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

	export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

	# Setting PATH for Python 3.10
	# The original version is saved in .zprofile.pysave
	PATH="/Library/Frameworks/Python.framework/Versions/3.10/bin:${PATH}"
	export PATH
fi

# Editor
export EDITOR='nvim'

# XDG config home
export XDG_CONFIG_HOME="$HOME/.config"

# Q post block. Keep at the bottom of this file.

# Kiro CLI post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zprofile.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zprofile.post.zsh"
