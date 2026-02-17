# ============================================
# OPTIMIZED .zshrc - Maximum Performance
# ============================================

# Uncomment these two lines to profile startup time:
# zmodload zsh/zprof

# ============================================
# Oh My Zsh Configuration
# ============================================
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""

# Minimal plugins - only keep what you actively use
plugins=(git docker)

# Disable Oh My Zsh auto-update checks (manual updates faster)
zstyle ':omz:update' mode disabled

source $ZSH/oh-my-zsh.sh

# ============================================
# PATH Configuration (consolidated)
# ============================================
typeset -U path  # Automatically deduplicate PATH entries

path=(
  "$HOME/go/bin"
  "$HOME/.jenv/bin"
  "$HOME/.bun/bin"
  "$HOME/Library/pnpm"
  "$HOME/Library/Application Support/fnm"
  "$HOME/.codeium/windsurf/bin"
  $path
)

export BUN_INSTALL="$HOME/.bun"
export PNPM_HOME="$HOME/Library/pnpm"

# ============================================
# Lazy-Loaded Tools (instant shell startup)
# ============================================

# fnm - lazy load on first use
fnm() {
  unfunction fnm
  eval "$(command fnm env --use-on-cd --shell zsh)"
  fnm "$@"
}

# Node auto-switching still works via this hook
autoload -U add-zsh-hook
load_fnm() {
  if [[ -f .node-version || -f .nvmrc ]]; then
    unfunction fnm 2>/dev/null
    eval "$(command fnm env --use-on-cd --shell zsh)"
  fi
}
add-zsh-hook chpwd load_fnm

# bun completions - lazy load
if [[ -s "$HOME/.bun/_bun" ]]; then
  fpath=("$HOME/.bun" $fpath)
  autoload -Uz compinit
  compinit -C  # -C flag skips security checks for speed
fi

# zoxide - smarter cd command
eval "$(zoxide init zsh)"

# ============================================
# Prompt (choose ONE option below)
# ============================================

# OPTION 1: Simple fast prompt (recommended for best performance)
# PROMPT='%F{cyan}%~%f %F{green}❯%f '

# OPTION 2: oh-my-posh (slower but prettier)
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/zen.toml)"

# OPTION 3: Starship (faster than oh-my-posh, still pretty)
# eval "$(starship init zsh)"

# ============================================
# Additional Optimizations
# ============================================

# Skip duplicate commands in history
setopt HIST_IGNORE_DUPS
setopt HIST_FIND_NO_DUPS

# Faster completion
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# ============================================
# Aliases & Custom Functions
# ============================================

# Local machine-only overrides (not tracked in dotfiles)
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

# Quick zsh reload
alias zshreload="source ~/.zshrc"

# Show startup time
alias zshbench="time zsh -i -c exit"

# Uncomment to see startup profiling on shell start:
# zprof