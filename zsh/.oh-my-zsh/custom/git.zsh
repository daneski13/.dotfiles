# File contains git related aliases and functions

# Pushd to git root dir
__git-root-dir() {
    local root=$(git rev-parse --show-toplevel 2> /dev/null)
    if [ -n "$root" ]; then
        pushd "$root" > /dev/null 2>&1
    else
        echo "Not a git repo"
    fi
}

# Git
alias g="git"

# Fetch
alias gf="git fetch"
# Pull
alias gpl="git pull --rebase"

# Clone
alias gcl="git clone --recursive --depth 5"

# Add
alias ga="git add"
alias gaa="git add --all"
# Fuzzy add file
function gaf() {
    # tracked files
    __git-root-dir
    local tracked=$(git diff --name-only HEAD)
    local untracked=$(git ls-files --others --exclude-standard)
    local selected=("${(@f)$( printf "$tracked\n$untracked" | fzf-m "Git add files")}")
    if [ -n "$selected" ]; then
        # loop through selected files and add
        for file in $selected; do
            git add "$file"
        done
    fi
    popd > /dev/null 2>&1
}

# Commit
alias gc="git commit"

# Push
alias gp="git push"
# Push with tags
alias gpt="git push && git push --tags"

# Diff
alias gd="git diff"
# Diff files
alias gdf="git diff --name-only"
# Diff staged
alias gds="git diff --cached"
# Diff remote
alias gdr="git diff @{u}"

# Remove
alias grm="git rm"
# Remove fuzzy
function grmf() {
    __git-root-dir
    local selected=("${(@f)$(git ls-files -c --full-name | fzf-m "Delete files")}")
    echo $selected
    if [ -n "$selected" ]; then
        # loop through selected files and remove
        for file in $selected; do
            git rm $1 "./$file"
        done
    fi
    popd > /dev/null 2>&1
}
# Remove from staged
alias grms="git restore --staged"
# Remove all from staged "git rm staged all"
function grmsa() {
    __git-root-dir
    git restore --staged .
    popd > /dev/null 2>&1
}
# Remove from staged fuzzy
function grmsf() {
    __git-root-dir
    local selected=("${(@f)$(git diff --cached --name-only | fzf-m "Git remove from staged")}")
    if [ -n "$selected" ]; then
        # loop through selected files and remove from staging
        for file in $selected; do
            git restore --staged "$file"
        done
    fi
    popd > /dev/null 2>&1
}

# Restore
alias grs="git restore"
# Restore all
alias grsa="git restore ."
# Restore fuzzy
function grsf() {
    __git-root-dir
    local selected=("${(@f)$(git status -s | fzf-m "Git restore")}")
    if [ -n "$selected" ]; then
        # loop through selected files and restore
        for file in $selected; do
            # remove first 3 chars from file path
            file=${file:3}
            git restore "$file"
        done
    fi
    popd > /dev/null 2>&1
}

# Reset
alias grst="git reset"

# Status
alias gst="git status"
# Status short
alias gsts="git status --short"

# Log short
alias gl="git log --graph --date=relative --abbrev-commit --decorate --oneline --color=always"
# Log long
alias gll="git log --graph --date=relative --abbrev-commit --decorate --color=always"

# Submodules update
alias gsu="git submodule update --init --recursive"
# Submodules add
alias gsa="git submodule add"

# Banches
alias gb="git branch"
# Switch
alias gsw="git switch"
# Switch to new branch
alias gswn="git switch -c"

# Worktree
alias gwt="git worktree"
alias gwta="git worktree add"
alias gwtr="git worktree remove"
alias gwtl="git worktree list"

# Tag
alias gt="git tag -s"
# Tag list
alias gtl="git tag | sort -V"

# Auto fetch git repos
# autoload -Uz add-zsh-hook
# function _fetch() {
#     if [ -n "$(git rev-parse --git-dir 2>/dev/null)" ]; then
#         git fetch --quiet
#     fi
# }
# add-zsh-hook precmd _fetch

# Interactive rebase the last given number of commits
function g-rebase() {
    git rebase -i HEAD~$1
}

# squash a all commits
function g-squash-all() {
    # get the first commit
    local first_commit=$(git rev-list --max-parents=0 HEAD)

    # soft reset to the first commit
    git reset --soft $first_commit
}

# Git legend
function gleg() {
    echo "Status legend"
    echo "----------"
    echo "A: added"
    echo "C: copied"
    echo "D: deleted"
    echo "M: modified"
    echo "R: renamed"
    echo "T: typechange"
    echo "U: unmerged"
    echo "X: unknown"
    echo "B: broken"
    echo "?: untracked"
    echo "!: ignored"
    echo
    echo "Shell Legend"
    echo "----------"
    echo "+: Staged Files"
    echo "?: Untracked Files"
    echo "!: Changed Files"
    echo "*: Stashes"
}
