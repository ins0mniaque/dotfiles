# Configure zoxide
mkdir ~/.cache/zoxide
zoxide init nushell --cmd j | save -f ~/.cache/zoxide/init.nu

# Configure Starship
mkdir ~/.cache/starship
starship init nu | save -f ~/.cache/starship/init.nu