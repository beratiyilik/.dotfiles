# amazon q pre block. keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zprofile.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zprofile.pre.zsh"

# print a greeting message
echo -e "👨‍💻 $USER@$(hostname) | 📅 $(date '+%a %b %d %Y %H:%M:%S %I:%M %p %Z')"

# amazon q post block. keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zprofile.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zprofile.post.zsh"

## eof
