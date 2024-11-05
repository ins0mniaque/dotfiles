# Configure default programs
$env.EDITOR = "nvim"
$env.VISUAL = "nvim"
$env.BROWSER = "open"
$env.MANPAGER = "sh -c 'col -bx | bat -l man -p'"
$env.PAGER = "less"
$env.LESS = "FRX --mouse"

# Configuration
$env.config = {
    show_banner: false
    table: { header_on_separator: true }
}

# Configure zoxide
source ~/.cache/zoxide/init.nu

# Install Starship
use ~/.cache/starship/init.nu