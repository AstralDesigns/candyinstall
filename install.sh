#!/bin/bash

# HyprCandy Installer Script
# This script installs Hyprland and related packages from AUR

#set -e  # Exit on any error

# Colors for outputf
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
MAGENTA='\033[1;35m'
LIGHT_BLUE='\033[1;34m'
LIGHT_GREEN='\033[1;32m'
LIGHT_RED='\033[1;31m'
NC='\033[0m' # No Color

# Global variables
DISPLAY_MANAGER="sddm"
DISPLAY_MANAGER_SERVICE="sddm"
LIBREOFFICE_CHOICE=""
SHELL_CHOICE=""
PANEL_CHOICE="waybar"
BROWSER_CHOICE=""
AUR_HELPER=""

# Function to display multicolored ASCII art
show_ascii_art() {
    clear
    echo
    # HyprCandy in gradient colors
    echo -e "${PURPLE}██╗  ██╗██╗   ██╗██████╗ ██████╗  ${MAGENTA}██████╗ █████╗ ███╗   ██╗██████╗ ██╗   ██╗${NC}"
    echo -e "${PURPLE}██║  ██║╚██╗ ██╔╝██╔══██╗██╔══██╗${MAGENTA}██╔════╝██╔══██╗████╗  ██║██╔══██╗╚██╗ ██╔╝${NC}"
    echo -e "${LIGHT_BLUE}███████║ ╚████╔╝ ██████╔╝██████╔╝${CYAN}██║     ███████║██╔██╗ ██║██║  ██║ ╚████╔╝${NC}"
    echo -e "${BLUE}██╔══██║  ╚██╔╝  ██╔═══╝ ██╔══██╗${CYAN}██║     ██╔══██║██║╚██╗██║██║  ██║  ╚██╔╝${NC}"
    echo -e "${BLUE}██║  ██║   ██║   ██║     ██║  ██║${LIGHT_GREEN}╚██████╗██║  ██║██║ ╚████║██████╔╝   ██║${NC}"
    echo -e "${GREEN}╚═╝  ╚═╝   ╚═╝   ╚═╝     ╚═╝  ╚═╝${LIGHT_GREEN} ╚═════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝    ╚═╝${NC}"
    echo
    # Installer in different colors
    echo -e "${BLUE}██╗███╗   ██╗███████╗████████╗ ${LIGHT_RED}█████╗ ██╗     ██╗     ███████╗██████╗${NC}"
    echo -e "${BLUE}██║████╗  ██║██╔════╝╚══██╔══╝${LIGHT_RED}██╔══██╗██║     ██║     ██╔════╝██╔══██╗${NC}"
    echo -e "${RED}██║██╔██╗ ██║███████╗   ██║   ${LIGHT_RED}███████║██║     ██║     █████╗  ██████╔╝${NC}"
    echo -e "${RED}██║██║╚██╗██║╚════██║   ██║   ${CYAN}██╔══██║██║     ██║     ██╔══╝  ██╔══██╗${NC}"
    echo -e "${LIGHT_RED}██║██║ ╚████║███████║   ██║   ${CYAN}██║  ██║███████╗███████╗███████╗██║  ██║${NC}"
    echo -e "${CYAN}╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝${NC}"
    echo
    # Decorative line with gradient
    echo -e "${PURPLE}════════════════════${MAGENTA}════════════════════${CYAN}════════════════════${YELLOW}═════════${NC}"
    echo -e "${WHITE}                      Welcome to the HyprCandy Installer!${NC}"
    echo -e "${PURPLE}════════════════════${MAGENTA}════════════════════${CYAN}════════════════════${YELLOW}═════════${NC}"
    echo
}

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to choose display manager
choose_display_manager() {
    print_status "For old users remove rofi-wayland through 'sudo pacman -Rnsd rofi-wayland' then clear cache through 'sudo pacman -Scc'"
    echo -e "${CYAN}Choose your display manager:${NC}"
    echo "1) SDDM with Sugar Candy theme (HyprCandy automatic background set according to applied wallpaper)"
    echo "2) GDM with GDM settings app (GNOME Display Manager and customization app)"
    echo
    
    while true; do
        echo -e "${YELLOW}Enter your choice (1 for SDDM, 2 for GDM):${NC}"
        read -r dm_choice
        case $dm_choice in
            1)
                DISPLAY_MANAGER="sddm"
                DISPLAY_MANAGER_SERVICE="sddm"
                print_status "Selected SDDM with Sugar Candy theme and HyprCandy automatic background setting"
                break
                ;;
            2)
                DISPLAY_MANAGER="gdm"
                DISPLAY_MANAGER_SERVICE="gdm"
                print_status "Selected GDM with GDM settings app"
                break
                ;;
            *)
                print_error "Invalid choice. Please enter 1 or 2."
                ;;
        esac
    done
}

choose_panel() {
    echo -e "${CYAN}Choose your panel: you can also rerun the script to switch from either or regenerate HyprCandy's default panel setup:${NC}"
    echo -e "${GREEN}1) Waybar${NC}"
    echo "   • Light with fast startup/reload for a 'taskbar' like experience"
    echo "   • Highly customizable"
    echo "   • Fast live wallpaper application through caching and easier background setup"
    echo ""
    echo -e "${GREEN}2) Hyprpanel${NC}"
    echo "   • Easy to theme through its interface"
    echo "   • Has an autohide feature when only one window is open"
    echo "   • Much slower to relaunch after manually killing (when multiple windows are open)"
    echo "   • Recommended for users who don't mind an always-on panel"
    echo "   • Longer process to set backgrounds and slower for live backgrounds"
    echo ""
    
    read -rp "Enter 1 or 2: " panel_choice
    case $panel_choice in
        1) PANEL_CHOICE="waybar" ;;
        2) PANEL_CHOICE="hyprpanel" ;;
        *) 
            print_error "Invalid choice. Please enter 1 or 2."
            echo ""
            choose_panel  # Recursively ask again
            ;;
    esac
    echo -e "${GREEN}Panel selected: $PANEL_CHOICE${NC}"
}

# Function to choose shell
choose_shell() {
    echo -e "${CYAN}Choose your shell: you can also rerun the script to switch from either or regenerate HyprCandy's default shell setup:${NC}"
    echo "1) Fish - A modern shell with builtin fzf search, intelligent autosuggestions and syntax highlighting (Fisher plugins + Starship prompt)"
    echo "2) Zsh - Powerful shell with extensive customization (Zsh plugins + Oh My Zsh + Starship prompt)"
    echo
    
    while true; do
        echo -e "${YELLOW}Enter your choice (1 for Fish, 2 for Zsh):${NC}"
        read -r shell_choice
        case $shell_choice in
            1)
                SHELL_CHOICE="fish"
                print_status "Selected Fish shell with builtin features, plugins and Starship configuration"
                break
                ;;
            2)
                SHELL_CHOICE="zsh"
                print_status "Selected Zsh with plugins, Oh My Zsh integration and Starship configuration"
                break
                ;;
            *)
                print_error "Invalid choice. Please enter 1 or 2."
                ;;
        esac
    done
}

choose_browser() {
    echo -e "${CYAN}Choose your browser:${NC}"
    echo "1) Brave (Seemless integration with HyprCandy GTK and Qt theme through its Appearance settings, fast, secure and privacy-focused browser)"
    echo "2) Firefox (Themed through python-pywalfox by running pywalfox update in the terminal, open-source browser with a focus on privacy)"
    echo "3) Zen Browser (Themed through zen mods and slightly through python-pywalfox by running pywalfox update in the terminal, open-source browser with a focus on privacy)"
    echo "4) Librewolf (Open-source browser with a focus on privacy, highly customizable manually)"
    echo "5) Other (Please install your own browser post-installation)"
    read -rp "Enter 1, 2, 3, 4 or 5: " browser_choice
    case $browser_choice in
        1) BROWSER_CHOICE="brave" ;;
        2) BROWSER_CHOICE="firefox" ;;
        3) BROWSER_CHOICE="zen-browser-bin" ;;
        4) BROWSER_CHOICE="librewolf" ;;
        5) BROWSER_CHOICE="Other" ;;
        *) print_error "Invalid choice. Please enter 1, 2, 3, 4 or 5." ;;
    esac
    echo -e "${GREEN}Browser selected: $BROWSER_CHOICE${NC}"
}

install_libreoffice() {
    echo -e "${YELLOW}Would you like to install the libreoffice suite? (n/Y)${NC}"
    read -r response
    case "$response" in
        [nN][oO]|[nN])
            print_status "Installation skipped."
            ;;
        *)
            LIBREOFFICE_CHOICE="Yes"
            ;;
    esac
}

# Function to install yay
install_yay() {
    print_status "Installing yay..."
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd /tmp
    rm -rf yay
    print_success "yay installed successfully!"
}

# Function to install paru
install_paru() {
    print_status "Installing paru..."
    cd /tmp
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si --noconfirm
    cd /tmp
    rm -rf paru
    print_success "paru installed successfully!"
}

# Check if AUR helper is installed or install one
check_or_install_aur_helper() {
    if command -v yay &> /dev/null; then
        AUR_HELPER="yay"
        print_status "Found yay - using as AUR helper"
    elif command -v paru &> /dev/null; then
        AUR_HELPER="paru"
        print_status "Found paru - using as AUR helper"
    else
        print_warning "No AUR helper found. You need to install one."
        echo
        echo "Available AUR helpers:"
        echo "1) yay - Yet Another Yogurt (Go-based, fast)"
        echo "2) paru - Paru is based on yay (Rust-based, feature-rich)"
        echo
        while true; do
            echo -e "${YELLOW}Choose which AUR helper to install (1 for yay, 2 for paru):${NC}"
            read -r choice
            case $choice in
                1)
                    # Check if base-devel and git are installed
                    print_status "Ensuring base-devel and git are installed..."
                    sudo pacman -S --needed --noconfirm base-devel git
                    install_yay
                    AUR_HELPER="yay"
                    break
                    ;;
                2)
                    # Check if base-devel and git are installed
                    print_status "Ensuring base-devel and git are installed..."
                    sudo pacman -S --needed --noconfirm base-devel git
                    install_paru
                    AUR_HELPER="paru"
                    break
                    ;;
                *)
                    print_error "Invalid choice. Please enter 1 or 2."
                    ;;
            esac
        done
    fi
}

# Function to build package list based on display manager choice
build_package_list() {
    packages=(
        # Hyprland ecosystem
        "hyprland"
        "hyprcursor"
        "hyprgraphics"
        "hypridle"
        "hyprland-protocols"
        "hyprland-qt-support"
        "hyprlang"
        "hyprlock"
        "hyprpaper"
        "hyprpicker"
        "hyprpolkitagent"
        "hyprsunset"
        "hyprutils"
        "hyprwayland-scanner"
        "xdg-desktop-portal"
        "xdg-desktop-portal-hyprland"
        "xdg-desktop-portal-gtk"
        
        # Packages
        "pacman-contrib"
        "octopi"
        "rebuild-detector"
        "equibop-bin"
        
        # Dependacies
        "meson" 
        "cpio" 
        "cmake"
        
        # GNOME components (always include gnome-control-center and gnome-tweaks)
        #"mutter"
        #"gnome-control-center"
        #"gnome-tweaks"
        "gvfs"
		"gjs"
		"gtk4-layer-shell"
        "gnome-disk-utility"
        "gnome-color-manager"
		"gnome-software"
        #"gnome-weather"
        "gnome-calendar"
        "gnome-system-monitor"
        "gnome-calculator"
        "evince"
        
        # Terminals and file manager
        "kitty"
        "nautilus"
        
        # Qt and GTK theming
        "adw-gtk-theme"
        "qt5ct-kde"
        "qt5-imageformats"
        "qt5-graphicaleffects"
        "qt5-quickcontrols2"
        "qt6ct"
		"qt6-imageformats"
        "attica"
        "frameworkintegration" 
        "knewstuff" 
        "syndication" 
        "darkly-bin"
        "archlinux-xdg-menu" 
        "kservice"
        "nwg-look"
        
        # System utilities
		"switcheroo-control"
        "nwg-displays"
        "uwsm"
        "quickshell-git"
        "flatpak"
        
        # Application launcher and menus
        "rofi"
        "rofi-emoji"
        "rofi-nerdy"
        
        # Wallpaper and screenshot tools
        "awww-bin"
        "grimblast-git"
        "wob"
        "wf-recorder"
        "slurp"
        "satty"
        
        # System tools
        "brightnessctl"
        "playerctl"
        "power-profiles-daemon"
        
        # Audio system
        "pipewire"
        "pipewire-jack"
        "pipewire-pulse"
        "pipewire-alsa"
        "alsa-utils"
        
        # System monitoring
        "btop"
        "nvtop"
        "htop"
        
        # Customization
        "matugen-bin"
		"python-pywal16"
		"python-colorthief"
        "hyprviz-bin"
        
        # Editors
        "gedit"
        "neovim"
        "micro"
        
        # Utilities
        "zip"
        "p7zip"
        "wtype"
        "cava"
        "downgrade"
        "ntfs-3g"
        "fuse"
        "video-trimmer"
        "eog"
        "inotify-tools"
        "bc"
        "libnotify"
        "pyprland"
        
        # Fonts and emojis
        "ttf-dejavu-sans-code"
        "ttf-cascadia-code-nerd"
        "ttf-cascadia-mono-nerd"
        "ttf-fantasque-nerd"
        "ttf-firacode-nerd"
        "ttf-jetbrains-mono-nerd"
        "ttf-nerd-fonts-symbols"
        "ttf-nerd-fonts-symbols-common"
        "ttf-nerd-fonts-symbols-mono"
        "ttf-meslo-nerd"
        "powerline-fonts"
        "noto-fonts-emoji"
        "noto-color-emoji-fontconfig"
        "awesome-terminal-fonts"
        
        # Clipboard
        "cliphist"
        
        # Browser and themes
        #"adw-gtk-theme"
        #"adwaita-qt6"   Keeping the libadwaita default which is themed by my matugen setup
        #"adwaita-qt-git"
        "tela-circle-icon-theme-all"
        
        # Cursor themes
        "bibata-cursor-theme-bin"
        "qogir-cursor-theme"
        
        # Entertainment
        "spotify-launcher"
        
        # System info
        "fastfetch"
        
        # GTK development libraries
        "gtkmm-4.0"
        "gtksourceview3"
        "gtksourceview4"
        "gtksourceview5"

        # Fun stuff
        "asciiquarium"
        "tty-clock"
        "cmatrix"
        "pipes.sh"
        
        # Configuration management
        "stow"
    )
    
    # Add display manager specific packages
    if [ "$DISPLAY_MANAGER" = "sddm" ]; then
        packages+=("sddm" "sddm-sugar-candy-git")
        print_status "Added SDDM and Sugar Candy theme to package list"
    elif [ "$DISPLAY_MANAGER" = "gdm" ]; then
        packages+=("gdm" "gdm-settings")
        print_status "Added GDM and GDM settings to package list"
    fi
    
    # Add shell specific packages
    if [ "$SHELL_CHOICE" = "fish" ]; then
        packages+=(
            "fish"
            "fisher"
            "starship"
        )
        print_status "Added Fish shell and modern tools to package list"
    elif [ "$SHELL_CHOICE" = "zsh" ]; then
        packages+=(
            "zsh"
            "zsh-completions"
            "zsh-autosuggestions"
            "zsh-history-substring-search"
            "zsh-syntax-highlighting"
            "starship"
            "oh-my-zsh-git"
        )
        print_status "Added Zsh and Oh My Zsh ecosystem with Starship to package list"
    fi
    
    
    # Add panel based on user choice
    if [ "$PANEL_CHOICE" = "waybar" ]; then
        echo ""
    else
        packages+=(
        "ags-hyprpanel-git"
        "mako"
        )
        print_status "Added Hyprpanel to package list"
    fi

    # Add libreoffice based on user choice
    if [ "$LIBREOFFICE_CHOICE" = "Yes" ]; then
        packages+=(
            "libreoffice-fresh"
        )
        print_status "Added LibreOffice to package list"
    fi

    # Add browser based on user choice
    if [ "$BROWSER_CHOICE" = "brave" ]; then
        packages+=(
            "brave-bin"
        )
        print_status "Added Brave to package list"
    elif [ "$BROWSER_CHOICE" = "firefox" ]; then
        packages+=(
            "firefox"
            "python-pywalfox"
        )
        print_status "Added Firefox to package list"
    elif [ "$BROWSER_CHOICE" = "zen-browser-bin" ]; then
        packages+=(
            "zen-browser-bin"
            "python-pywalfox"
        )
        print_status "Added Zen Browser to package list"
    elif [ "$BROWSER_CHOICE" = "librewolf" ]; then
        packages+=(
            "librewolf"
            "python-pywalfox"
        )
        print_status "Added Librewolf to package list"
    elif [ "$BROWSER_CHOICE" = "Other" ]; then
        print_status "Please install your own browser post-installation"
    fi
}

# Function to install packages
install_packages() {
    print_status "Handling conflicting packages first..."
    if pacman -Qi jack &>/dev/null; then
        print_status "Removing jack package..."
        $AUR_HELPER -Rdd --noconfirm jack
    else
        echo ""
    fi
    
    print_status "Starting installation of ${#packages[@]} packages using $AUR_HELPER..."
    
    # Install packages in batches to avoid potential issues
    local batch_size=10
    local total=${#packages[@]}
    local installed=0
    local failed=()
    
    for ((i=0; i<total; i+=batch_size)); do
        local batch=("${packages[@]:i:batch_size}")
        print_status "Installing batch $((i/batch_size + 1)): ${batch[*]}"
        
        if $AUR_HELPER -S --noconfirm --needed "${batch[@]}"; then
            installed=$((installed + ${#batch[@]}))
            print_success "Batch $((i/batch_size + 1)) installed successfully"
        else
            print_warning "Some packages in batch $((i/batch_size + 1)) failed to install"
            # Try installing packages individually to identify failures
            for pkg in "${batch[@]}"; do
                if ! $AUR_HELPER -S --needed "$pkg"; then
                    failed+=("$pkg")
                    print_error "Failed to install: $pkg"
                else
                    installed=$((installed + 1))
                fi
            done
        fi
        
        # Small delay between batches
        sleep 2
    done
    
    print_status "Installation completed!"
    print_success "Successfully installed: $installed packages"
    
    if [ ${#failed[@]} -gt 0 ]; then
        print_warning "Failed to install ${#failed[@]} packages:"
        printf '%s\n' "${failed[@]}"
        echo
        print_status "You can try installing failed packages manually:"
        echo "$AUR_HELPER -S ${failed[*]}"
    fi

    # Prevent notification daemon conflicts
    if [ "$PANEL_CHOICE" = "waybar" ]; then
        if pacman -Qi mako &>/dev/null; then
            print_status "Removing mako since you chose waybar to avoid conflicts with swaync..."
            $AUR_HELPER -R --noconfirm mako
			$AUR_HELPER -R --noconfirm swaync
        else
            echo ""
        fi
    else
        if pacman -Qi swaync &>/dev/null; then
            print_status "Removing swaync since you chose hyprpanel to avoid conflicts with mako..."
            $AUR_HELPER -R --noconfirm swaync
        else
            echo ""
        fi
    fi
    
    # Add flathub repo
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
}

# Function to setup Fish shell configuration
setup_fish() {
    print_status "Setting up Fish shell configuration..."
    
    # Set Fish as default shell
    if command -v fish &> /dev/null; then
        print_status "Setting Fish as default shell..."
        chsh -s $(which fish)
        print_success "Fish set as default shell"
    else
        print_error "Fish not found. Please install Fish first."
        return 1
    fi
    
    # Ensure Fisher function exists
mkdir -p ~/.config/fish/functions
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish -o ~/.config/fish/functions/fisher.fish

# Now install plugins using fisher (must be in a proper Fish shell)
fish -c '
    fisher install jorgebucaran/fisher
    fisher install \
        jorgebucaran/autopair.fish \
        jethrokuan/z \
        patrickf1/fzf.fish \
        franciscolourenco/done
'
    
    # Configure Starship prompt
    if command -v starship &> /dev/null; then
        print_status "Configuring Starship prompt for Fish..."
        
        # Add Starship to Fish config
        echo 'starship init fish | source' >> "$HOME/.config/fish/config.fish"
        
        # Create Starship config
        mkdir -p "$HOME/.config"
        cat > "$HOME/.config/starship.toml" << 'EOF'
# Starship Configuration for HyprCandy
format = """
$username\
$hostname\
$time $directory\
$git_branch\
$git_state\
$git_status\
$git_metrics\
$fill\
$nodejs\
$python\
$rust\
$golang\
$php\
$java\
$kotlin\
$haskell\
$swift\
$cmd_duration $jobs\
$line_break\
$character"""

[fill]
symbol = ""

[username]
style_user = "bold blue"
style_root = "bold red"
format = "[󱞬](blue) [](green) [](blue) [$user](grey) [](green) ($style)"
show_always = true

[directory]
style = "blue"
read_only = " 🔒"
truncation_length = 4
truncate_to_repo = false

[character]
success_symbol = "[󱞪](blue) [](green)"
error_symbol = "[󱞪](blue) [x](red)"
vimcmd_symbol = "[󱞪](blue) [](green)"

[git_branch]
symbol = "[](green) 🌱 "
truncation_length = 4
truncation_symbol = ""
style = "blue"

[git_status]
ahead = "⇡${count}"
diverged = "⇕⇡${ahead_count}⇣${behind_count}"
behind = "⇣${count}"
deleted = "x"

[nodejs]
symbol = "[](green) 💠 "
style = "bold grey"

[python]
symbol = "[](green) 🐍 "
style = "bold yellow"

[rust]
symbol = "[](green) ⚙️ "
style = "bold red"

[time]
format = '[](blue) [\[ $time \]](grey) [](green)($style)'#🕙
time_format = "%T"
disabled = false
style = "bright-white"

[cmd_duration]
format = "[](green) ⏱️ [$duration]($style)"
style = "yellow"

[jobs]
symbol = "[](green) ⚡ "
style = "bold blue"
EOF
        
        print_success "Starship configured for Fish"
    fi
    
    # Add useful Fish functions and aliases
    cat > "$HOME/.config/fish/config.fish" << 'EOF'
# HyprCandy Fish Configuration

# Set environment variables
set -gx HYPRLAND_LOG_WS 1
set -x EDITOR micro
set -x BROWSER firefox
set -x TERMINAL kitty

# Add local bin to PATH
if test -d ~/.local/bin
    set -x PATH ~/.local/bin $PATH
end

# Aliases
#alias hyprcandy="cd .hyprcandy && git pull && stow --ignore='Candy' --ignore='Candy-Images' --ignore='Dock-SVGs' --ignore='Gifs' --ignore='Logo' --ignore='transparent.png' --ignore='GJS' --ignore='Candy.desktop' --ignore='HyprCandy.png' --ignore='candy-daemon.js' --ignore='candy-launcher.sh' --ignore='toggle-control-center.sh' --ignore='toggle-media-player.sh' --ignore='toggle-system-monitor.sh' --ignore='toggle-weather-widget.sh' --ignore='toggle-hyprland-settings.sh' --ignore='candy-system-monitor.js' --ignore='resources' --ignore='src' --ignore='meson.build' --ignore='README.md' --ignore='run.log' --ignore='test_layout.js' --ignore='test_media_menu.js' --ignore='toggle.js' --ignore='toggle-main.js' --ignore='~' --ignore='candy-main.js' --ignore='gjs-media-player.desktop' --ignore='gjs-toggle-controls.desktop' --ignore='main.js' --ignore='media-main.js' --ignore='SEEK_FEATURE.md' --ignore='setup-custom-icon.sh' --ignore='weather-main.js' */"
alias ll="ls -alF"
alias la="ls -A"
alias l="ls -CF"
alias ..="cd .."
alias ...="cd ../.."
alias grep="grep --color=auto"
alias fgrep="fgrep --color=auto"
alias egrep="egrep --color=auto"
alias update="sudo pacman -Syu"
alias install="sudo pacman -S"
alias search="pacman -Ss"
alias remove="sudo pacman -R"
alias autoremove="sudo pacman -Rs (pacman -Qtdq)"
alias cls="clear"
alias h="history"
alias j="jobs -l"
alias df="df -h"
alias du="du -h"
alias mkdir="mkdir -pv"
alias wget="wget -c"

# Git aliases
alias g="git clone --depth 1"
alias ga="git add ."
alias gc="git commit -m"
function gp
    # Ensure .config/hypr are gitignored before every push
    if not grep -qF ".config/hypr" .gitignore 2>/dev/null
        echo ".config/hypr/hyprviz.conf" >> .gitignore
	    echo ".config/hypr/monitors.conf" >> .gitignore
        git add .gitignore
        git commit -m "chore: ignore personal config dirs"
    end
    git push
end
alias gl="git pull"
alias gs="git status"
alias gd="git diff"
alias gco="git checkout"
alias gb="git branch"
alias glog="git log --oneline --graph --decorate"

# System information
alias sysinfo="fastfetch"
alias weather="curl wttr.in"

# Fun stuff
alias matrix="cmatrix -a -b -r"
alias pipes="pipes.sh"
alias clock="tty-clock -s -c"
alias sea="asciiquarium"

# Start HyprCandy fastfetch
fastfetch

# Initialize Starship prompt
if type -q starship
    starship init fish | source
end

# Welcome message
function fish_greeting
end

EOF
    
    print_success "Fish shell configuration completed!"
}

# Function to setup Zsh configuration
setup_zsh() {
    print_status "Setting up Zsh shell configuration..."
    
    # Set Zsh as default shell
    if command -v zsh &> /dev/null; then
        print_status "Setting Zsh as default shell..."
        chsh -s $(which zsh)
        print_success "Zsh set as default shell"
    else
        print_error "Zsh not found. Please install Zsh first."
        return 1
    fi
    
    # Install Oh My Zsh if not already installed
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        print_status "Installing Oh My Zsh..."
        RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        print_success "Oh My Zsh installed"
    fi
    
    # Configure Starship prompt
    if command -v starship &> /dev/null; then
        print_status "Configuring Starship prompt for Zsh..."
        
        # Create Starship config (same as Fish setup)
        mkdir -p "$HOME/.config"
        cat > "$HOME/.config/starship.toml" << 'EOF'
# Starship Configuration for HyprCandy
format = """
$username\
$hostname\
$time $directory\
$git_branch\
$git_state\
$git_status\
$git_metrics\
$fill\
$nodejs\
$python\
$rust\
$golang\
$php\
$java\
$kotlin\
$haskell\
$swift\
$cmd_duration $jobs\
$line_break\
$character"""

[fill]
symbol = ""

[username]
style_user = "bold blue"
style_root = "bold red"
format = "[󱞬](blue) [](green) [](blue) [$user](grey) [](green) ($style)"
show_always = true

[directory]
style = "blue"
read_only = " 🔒"
truncation_length = 4
truncate_to_repo = false

[character]
success_symbol = "[󱞪](blue) [](green)"
error_symbol = "[󱞪](blue) [x](red)"
vimcmd_symbol = "[󱞪](blue) [](green)"

[git_branch]
symbol = "[](green) 🌱 "
truncation_length = 4
truncation_symbol = ""
style = "blue"

[git_status]
ahead = "⇡${count}"
diverged = "⇕⇡${ahead_count}⇣${behind_count}"
behind = "⇣${count}"
deleted = "x"

[nodejs]
symbol = "[](green) 💠 "
style = "bold grey"

[python]
symbol = "[](green) 🐍 "
style = "bold yellow"

[rust]
symbol = "[](green) ⚙️ "
style = "bold red"

[time]
format = '[](blue) [\[ $time \]](grey) [](green)($style)'#🕙
time_format = "%T"
disabled = false
style = "bright-white"

[cmd_duration]
format = "[](green) ⏱️ [$duration]($style)"
style = "yellow"

[jobs]
symbol = "[](green) ⚡ "
style = "bold blue"
EOF
        
        # Create .zshrc with Starship configuration
        cat > "$HOME/.zshrc" << 'EOF'
# HyprCandy Zsh Configuration with Oh My Zsh and Starship

# Oh My Zsh configuration
export ZSH="$HOME/.oh-my-zsh"

# Set environment variables
export HYPRLAND_LOG_WS=1
export EDITOR=micro
export BROWSER=firefox
export TERMINAL=kitty

# Add local bin to PATH
if [ -d "$HOME/.local/bin" ]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# Initialize Starship prompt
if command -v starship > /dev/null 2>&1; then
    eval "$(starship init zsh)"
fi

# Source Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Aliases

#alias hyprcandy="cd .hyprcandy && git pull && stow --ignore='Candy' --ignore='Candy-Images' --ignore='Dock-SVGs' --ignore='Gifs' --ignore='Logo' --ignore='transparent.png' --ignore='GJS' --ignore='Candy.desktop' --ignore='HyprCandy.png' --ignore='candy-daemon.js' --ignore='candy-launcher.sh' --ignore='toggle-control-center.sh' --ignore='toggle-media-player.sh' --ignore='toggle-system-monitor.sh' --ignore='toggle-weather-widget.sh' --ignore='toggle-hyprland-settings.sh' --ignore='candy-system-monitor.js' --ignore='resources' --ignore='src' --ignore='meson.build' --ignore='README.md' --ignore='run.log' --ignore='test_layout.js' --ignore='test_media_menu.js' --ignore='toggle.js' --ignore='toggle-main.js' --ignore='~' --ignore='candy-main.js' --ignore='gjs-media-player.desktop' --ignore='gjs-toggle-controls.desktop' --ignore='main.js' --ignore='media-main.js' --ignore='SEEK_FEATURE.md' --ignore='setup-custom-icon.sh' --ignore='weather-main.js' */"
alias ll="ls -alF"
alias la="ls -A"
alias l="ls -CF"
alias ..="cd .."
alias ...="cd ../.."
alias grep="grep --color=auto"
alias fgrep="fgrep --color=auto"
alias egrep="egrep --color=auto"
alias update="sudo pacman -Syu"
alias install="sudo pacman -S"
alias search="pacman -Ss"
alias remove="sudo pacman -R"
alias autoremove="sudo pacman -Rs $(pacman -Qtdq)"
alias c="clear"
alias h="history"
alias j="jobs -l"
alias df="df -h"
alias du="du -h"
alias mkdir="mkdir -pv"
alias wget="wget -c"

# Git aliases
alias g="git clone --depth 1"
alias ga="git add ."
alias gc="git commit -m"
gp() {
    # Ensure .config/hypr are gitignored before every push
    if ! grep -qF ".config/hypr" .gitignore 2>/dev/null; then
        echo ".config/hypr/hyprviz.conf" >> .gitignore
	    echo ".config/hypr/monitors.conf" >> .gitignore
        git add .gitignore
        git commit -m "chore: ignore personal config dirs"
    fi
    git push
}
alias gl="git pull"
alias gs="git status"
alias gd="git diff"
alias gco="git checkout"
alias gb="git branch"
alias glog="git log --oneline --graph --decorate"

# System information
alias sysinfo="fastfetch"
alias weather="curl wttr.in"

# Fun stuff
alias matrix="cmatrix -a -b -r"
alias pipes="pipes.sh"
alias clock="tty-clock -s -c"
alias sea="asciiquarium"

# Start HyprCandy fastfetch
fastfetch

# Source HyprCandy Zsh setup if it exists
if [ -f ~/.hyprcandy-zsh.zsh ]; then
    source ~/.hyprcandy-zsh.zsh
fi
EOF
        
        print_success "Starship configured for Zsh"
    fi
    
    print_success "Zsh shell configuration completed!"
}
    
# Function to automatically setup Hyprcandy configuration
setup_hyprcandy() {
    
    print_status "Setting up HyprCandy configuration..."
    
    # Check if stow is available
    if ! command -v stow &> /dev/null; then
        print_error "stow is not installed. Cannot proceed with configuration setup."
        return 1
    fi
    
    # Backup previous default config folder if it exists
	PREVIOUS_CONFIG_FOLDER="$HOME/.config/hypr"
    
    if [ ! -d "$PREVIOUS_CONFIG_FOLDER" ]; then
        print_error "Backing up: $PREVIOUS_CONFIG_FOLDER"
        cp -r "$PREVIOUS_CONFIG_FOLDER" "${PREVIOUS_CONFIG_FOLDER}.backup.$(date +%Y%m%d_%H%M%S)"
    else
        # Remove any previous backups before creating a new one
        rm -rf "${PREVIOUS_CONFIG_FOLDER}".backup.*
        cp -r "$PREVIOUS_CONFIG_FOLDER" "${PREVIOUS_CONFIG_FOLDER}.backup.$(date +%Y%m%d_%H%M%S)"
        echo -e "${GREEN}Previous default config folder backup created${NC}"
    fi
    sleep 1
    
    # Backup previous custom config folder if it exists
    PREVIOUS_CUSTOM_CONFIG_FOLDER="$HOME/.config/hyprcustom"
    
    if [ ! -d "$PREVIOUS_CUSTOM_CONFIG_FOLDER" ]; then
        print_error "Backing up: $PREVIOUS_CUSTOM_CONFIG_FOLDER"
        cp -r "$PREVIOUS_CUSTOM_CONFIG_FOLDER" "${PREVIOUS_CUSTOM_CONFIG_FOLDER}.backup.$(date +%Y%m%d_%H%M%S)"
    else
        # Remove any previous backups before creating a new one
        rm -rf "${PREVIOUS_CUSTOM_CONFIG_FOLDER}".backup.*
        cp -r "$PREVIOUS_CUSTOM_CONFIG_FOLDER" "${PREVIOUS_CUSTOM_CONFIG_FOLDER}.backup.$(date +%Y%m%d_%H%M%S)"
        echo -e "${GREEN}Previous custom config folder backup created${NC}"
    fi
    sleep 1

    # Remove existing .hyprcandy folder
    if [ -d "$HOME/.hyprcandy" ]; then
        echo "🗑️  Removing existing .hyprcandy folder..."
        rm -rf "$HOME/.hyprcandy"
		rm -rf "$HOME/.ultracandy"
        sleep 2
    else
        echo "✅ .hyprcandy dotfiles folder doesn't exist — seems to be a fresh install."
        rm -rf "$HOME/.ultracandy"
        sleep 2
    fi

	# Clone HyprCandy repository
	hyprcandy_dir="$HOME/.hyprcandy"
	store_dir="$HOME/.HCUpdates"

	echo "🌐 Cloning HyprCandy+ repository ..."
	git clone --depth 1 https://github.com/AstralDesigns/HyprC-Plus.git "$hyprcandy_dir"
	echo "✅ Cloning complete"

	echo "📦 Creating update store..."
	cp -r "$hyprcandy_dir" "$store_dir"
	echo "✅ Updates store created"
    
    # Clone overview repository
    #overview_dir="$HOME/.config/quickshell/overview"
    #if [ ! -d "$overview_dir" ]; then
        #echo "🌐 Cloning overview repository ..."
        #git clone https://github.com/Shanu-Kumawat/quickshell-overview "$overview_dir"
        #echo "✅ Cloning complete"
    #fi
    
    # Go to the home directory
    cd "$HOME"

    # Remove present .zshrc file 
    rm -rf .face.icon .hyprcandy-zsh.zsh .icons Candy GJS
    rm -rf "$HOME/Pictures/HyprCandy"

    # Ensure ~/.config exists, then remove specified subdirectories
    [ -d "$HOME/.config" ] || mkdir -p "$HOME/.config"
    cd "$HOME/.config" || exit 1
    rm -rf background background.png btop cava dolphinrc fastfetch gtk-3.0 gtk-4.0 htop hypr hyprcustom hyprcandy hyprpanel kitty matugen micro nvtop nwg-dock-hyprland nwg-look qt5ct qt6ct quickshell rofi swaync wal wallust waybar waypaper wlogout xsettingsd

    # Go to the home directory
    cd "$HOME"

    # Safely remove existing .zshrc, .hyprcandy-zsh.zsh and .icons files (only if they exist)
    # [ -f "$HOME/.zshrc" ] && rm -f "$HOME/.zshrc"
    [ -f "$HOME/.face.icon" ] && rm -f "$HOME/.face.icon"
    [ -f "$HOME/.hyprcandy-zsh.zsh" ] && rm -f "$HOME/.hyprcandy-zsh.zsh"
    [ -f "$HOME/.icons" ] && rm -f "$HOME/.icons"
    [ -f "$HOME/Candy" ] && rm -f "$HOME/Candy"
    [ -f "$HOME/GJS" ] && rm -f "$HOME/GJS"

    # 📁 Create Screenshots and Recordings directories if they don't exist
    echo "📁 Ensuring directories for screenshots and recordings exist..."
    mkdir -p "$HOME/Pictures/Screenshots" "$HOME/Videos/Recordings"
    echo "✅ Created ~/Pictures/Screenshots and ~/Videos/Recordings (if missing)"

    # Return to the home directory
    cd "$HOME"
    
    # Change to the HyprCandy dotfiles directory
    cd "$hyprcandy_dir" || { echo "❌ Error: Could not find HyprCandy directory"; exit 1; }

    # Define only the configs to be stowed
    config_dirs=(".config" ".icons" ".hyprcandy-zsh.zsh")

    # Add files/folders to exclude from deletion
    preserve_items=("GJS" "Candy" "LICENSE" "README.md" ".git" ".gitignore")

    if [ ${#config_dirs[@]} -eq 0 ]; then
        echo "❌ No configuration directories specified."
        exit 1
    fi

    echo "🔍 Found configuration directories: ${config_dirs[*]}"
    echo "📦 Automatically installing all configurations..."

    # Backup: remove everything not in the allowlist
    for item in * .*; do
        # Skip special entries
        [[ "$item" == "." || "$item" == ".." ]] && continue

        # Skip allowed config items
        if [[ " ${config_dirs[*]} " == *" $item "* ]]; then
            continue
        fi

        # Skip explicitly preserved items
        if [[ " ${preserve_items[*]} " == *" $item "* ]]; then
            echo "❎ Preserving: $item"
            continue
        fi

        echo "🗑️  Removing: $item"
        rm -rf "$item"
    done

# Stow all configurations at once, ignoring Candy folder
if stow -v -t "$HOME" --ignore='Candy' --ignore='GJS' . 2>/dev/null; then
    echo "✅ Successfully stowed all configurations"
else
    echo "⚠️  Stow operation failed — attempting restow..."
    if stow -R -v -t "$HOME" --ignore='Candy' --ignore='GJS' . 2>/dev/null; then
        echo "✅ Successfully restowed all configurations"
    else
        echo "❌ Failed to stow configurations"
    fi
fi
    # Final summary
    echo
    echo "✅ Installation completed. Successfully installed: $stow_success"
    if [ ${#stow_failed[@]} -ne 0 ]; then
        echo "❌ Failed to install: ${stow_failed[*]}"
    fi

### ✅ Setup mako config, hook scripts and needed services
echo "📁 Creating background hook scripts..."
mkdir -p "$HOME/.config/custom" "$HOME/.config/hyprcandy/hooks" "$HOME/.config/systemd/user" "$HOME/.config/pypr"

# ═══════════════════════════════════════════════════════════════
#                    	User Settings File
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/custom/custom.conf" << 'EOF'
#  ██████╗ █████╗ ███╗   ██╗██████╗ ██╗   ██╗
# ██╔════╝██╔══██╗████╗  ██║██╔══██╗╚██╗ ██╔╝
# ██║     ███████║██╔██╗ ██║██║  ██║ ╚████╔╝ 
# ██║     ██╔══██║██║╚██╗██║██║  ██║  ╚██╔╝  
# ╚██████╗██║  ██║██║ ╚████║██████╔╝   ██║   
#  ╚═════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝    ╚═╝   
# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                          User Settings                      ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
# [NOTE!!] Your personal settings added here are sourced in hyprland.conf. 
# You can also extend the sourcing to more custom folders as well if you 
# wish to be modular and not stack everythingin this single file e.g
# create ~/.config/custom/keybinds.conf and source it in this file.
EOF

# ═══════════════════════════════════════════════════════════════
#                    Gaps OUT Increase Script
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/hyprland_gaps_out_increase.sh" << 'EOF'
#!/bin/bash

CONFIG_FILE="$HOME/.config/hypr/hyprviz.conf"

CURRENT_GAPS_OUT=$(grep -E "^\s*gaps_out\s*=" "$CONFIG_FILE" | sed 's/.*gaps_out\s*=\s*\([0-9]*\).*/\1/')
NEW_GAPS_OUT=$((CURRENT_GAPS_OUT + 1))
sed -i "s/^\(\s*gaps_out\s*=\s*\)[0-9]*/\1$NEW_GAPS_OUT/" "$CONFIG_FILE"

hyprctl keyword general:gaps_out $NEW_GAPS_OUT
hyprctl reload

echo "🔼 Gaps OUT increased: gaps_out=$NEW_GAPS_OUT"
notify-send "Gaps OUT Increased" "gaps_out: $NEW_GAPS_OUT" -t 2000
EOF

chmod +x "$HOME/.config/hyprcandy/hooks/hyprland_gaps_out_increase.sh"

# ═══════════════════════════════════════════════════════════════
#                    Gaps OUT Decrease Script
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/hyprland_gaps_out_decrease.sh" << 'EOF'
#!/bin/bash

CONFIG_FILE="$HOME/.config/hypr/hyprviz.conf"

CURRENT_GAPS_OUT=$(grep -E "^\s*gaps_out\s*=" "$CONFIG_FILE" | sed 's/.*gaps_out\s*=\s*\([0-9]*\).*/\1/')
NEW_GAPS_OUT=$((CURRENT_GAPS_OUT > 0 ? CURRENT_GAPS_OUT - 1 : 0))
sed -i "s/^\(\s*gaps_out\s*=\s*\)[0-9]*/\1$NEW_GAPS_OUT/" "$CONFIG_FILE"
hyprctl keyword general:gaps_out $NEW_GAPS_OUT
hyprctl reload

echo "🔽 Gaps OUT decreased: gaps_out=$NEW_GAPS_OUT"
notify-send "Gaps OUT Decreased" "gaps_out: $NEW_GAPS_OUT" -t 2000
EOF

# ═══════════════════════════════════════════════════════════════
#                    Gaps IN Increase Script
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/hyprland_gaps_in_increase.sh" << 'EOF'
#!/bin/bash

CONFIG_FILE="$HOME/.config/hypr/hyprviz.conf"
CURRENT_GAPS_IN=$(grep -E "^\s*gaps_in\s*=" "$CONFIG_FILE" | sed 's/.*gaps_in\s*=\s*\([0-9]*\).*/\1/')
NEW_GAPS_IN=$((CURRENT_GAPS_IN + 1))
sed -i "s/^\(\s*gaps_in\s*=\s*\)[0-9]*/\1$NEW_GAPS_IN/" "$CONFIG_FILE"
hyprctl keyword general:gaps_in $NEW_GAPS_IN
hyprctl reload

echo "🔼 Gaps IN increased: gaps_in=$NEW_GAPS_IN"
notify-send "Gaps IN Increased" "gaps_in: $NEW_GAPS_IN" -t 2000
EOF

# ═══════════════════════════════════════════════════════════════
#                    Gaps IN Decrease Script
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/hyprland_gaps_in_decrease.sh" << 'EOF'
#!/bin/bash

CONFIG_FILE="$HOME/.config/hypr/hyprviz.conf"
CURRENT_GAPS_IN=$(grep -E "^\s*gaps_in\s*=" "$CONFIG_FILE" | sed 's/.*gaps_in\s*=\s*\([0-9]*\).*/\1/')
NEW_GAPS_IN=$((CURRENT_GAPS_IN > 0 ? CURRENT_GAPS_IN - 1 : 0))
sed -i "s/^\(\s*gaps_in\s*=\s*\)[0-9]*/\1$NEW_GAPS_IN/" "$CONFIG_FILE"
hyprctl keyword general:gaps_in $NEW_GAPS_IN
hyprctl reload

echo "🔽 Gaps IN decreased: gaps_in=$NEW_GAPS_IN"
notify-send "Gaps IN Decreased" "gaps_in: $NEW_GAPS_IN" -t 2000
EOF

# ═══════════════════════════════════════════════════════════════
#                Border Increase Script with Force Options
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/hyprland_border_increase.sh" << 'EOF'
#!/bin/bash

CONFIG_FILE="$HOME/.config/hypr/hyprviz.conf"
CURRENT_BORDER=$(grep -E "^\s*border_size\s*=" "$CONFIG_FILE" | sed 's/.*border_size\s*=\s*\([0-9]*\).*/\1/')
NEW_BORDER=$((CURRENT_BORDER + 1))
sed -i "s/^\(\s*border_size\s*=\s*\)[0-9]*/\1$NEW_BORDER/" "$CONFIG_FILE"
hyprctl keyword general:border_size $NEW_BORDER
hyprctl reload

echo "🔼 Border increased: border_size=$NEW_BORDER"
notify-send "Border Increased" "border_size: $NEW_BORDER" -t 2000
EOF

# ═══════════════════════════════════════════════════════════════
#                Border Decrease Script with Force Options
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/hyprland_border_decrease.sh" << 'EOF'
#!/bin/bash

CONFIG_FILE="$HOME/.config/hypr/hyprviz.conf"

CURRENT_BORDER=$(grep -E "^\s*border_size\s*=" "$CONFIG_FILE" | sed 's/.*border_size\s*=\s*\([0-9]*\).*/\1/')
NEW_BORDER=$((CURRENT_BORDER > 0 ? CURRENT_BORDER - 1 : 0))
sed -i "s/^\(\s*border_size\s*=\s*\)[0-9]*/\1$NEW_BORDER/" "$CONFIG_FILE"

hyprctl keyword general:border_size $NEW_BORDER
hyprctl reload

echo "🔽 Border decreased: border_size=$NEW_BORDER"
notify-send "Border Decreased" "border_size: $NEW_BORDER" -t 2000
EOF

# ═══════════════════════════════════════════════════════════════
#                Rounding Increase Script with Force Options
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/hyprland_rounding_increase.sh" << 'EOF'
#!/bin/bash

CONFIG_FILE="$HOME/.config/hypr/hyprviz.conf"
CURRENT_ROUNDING=$(grep -E "^\s*rounding\s*=" "$CONFIG_FILE" | sed 's/.*rounding\s*=\s*\([0-9]*\).*/\1/')
NEW_ROUNDING=$((CURRENT_ROUNDING + 1))
sed -i "s/^\(\s*rounding\s*=\s*\)[0-9]*/\1$NEW_ROUNDING/" "$CONFIG_FILE"

hyprctl keyword decoration:rounding $NEW_ROUNDING
hyprctl reload

echo "🔼 Rounding increased: rounding=$NEW_ROUNDING"
notify-send "Rounding Increased" "rounding: $NEW_ROUNDING" -t 2000
EOF

# ═══════════════════════════════════════════════════════════════
#                Rounding Decrease Script with Force Options
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/hyprland_rounding_decrease.sh" << 'EOF'
#!/bin/bash

CONFIG_FILE="$HOME/.config/hypr/hyprviz.conf"
CURRENT_ROUNDING=$(grep -E "^\s*rounding\s*=" "$CONFIG_FILE" | sed 's/.*rounding\s*=\s*\([0-9]*\).*/\1/')
NEW_ROUNDING=$((CURRENT_ROUNDING > 0 ? CURRENT_ROUNDING - 1 : 0))
sed -i "s/^\(\s*rounding\s*=\s*\)[0-9]*/\1$NEW_ROUNDING/" "$CONFIG_FILE"

hyprctl keyword decoration:rounding $NEW_ROUNDING
hyprctl reload

echo "🔽 Rounding decreased: rounding=$NEW_ROUNDING"
notify-send "Rounding Decreased" "rounding: $NEW_ROUNDING" -t 2000
EOF

# ═══════════════════════════════════════════════════════════════
#                    Gaps + Border Presets Script
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/hyprland_gap_presets.sh" << 'EOF'
#!/bin/bash

CONFIG_FILE="$HOME/.config/hypr/hyprviz.conf"

case "$1" in
    "minimal")
        GAPS_OUT=2
        GAPS_IN=1
        BORDER=2
        ROUNDING=3
        ;;
    "balanced")
        GAPS_OUT=6
        GAPS_IN=4
        BORDER=3
        ROUNDING=10
        ;;
    "spacious")
        GAPS_OUT=10
        GAPS_IN=6
        BORDER=3
        ROUNDING=10
        ;;
    "zero")
        GAPS_OUT=0
        GAPS_IN=0
        BORDER=0
        ROUNDING=0
        ;;
    *)
        echo "Usage: $0 {minimal|balanced|spacious|zero}"
        exit 1
        ;;
esac

# Apply all settings
sed -i "s/^\(\s*gaps_out\s*=\s*\)[0-9]*/\1$GAPS_OUT/" "$CONFIG_FILE"
sed -i "s/^\(\s*gaps_in\s*=\s*\)[0-9]*/\1$GAPS_IN/" "$CONFIG_FILE"
sed -i "s/^\(\s*border_size\s*=\s*\)[0-9]*/\1$BORDER/" "$CONFIG_FILE"
sed -i "s/^\(\s*rounding\s*=\s*\)[0-9]*/\1$ROUNDING/" "$CONFIG_FILE"

# Apply immediately
hyprctl keyword general:gaps_out $GAPS_OUT
hyprctl keyword general:gaps_in $GAPS_IN
hyprctl keyword general:border_size $BORDER
hyprctl keyword decoration:rounding $ROUNDING

echo "🎨 Applied $1 preset: gaps_out=$GAPS_OUT, gaps_in=$GAPS_IN, border=$BORDER, rounding=$ROUNDING"
notify-send "Visual Preset Applied" "$1: OUT=$GAPS_OUT IN=$GAPS_IN BORDER=$BORDER ROUND=$ROUNDING" -t 3000
EOF

# ═══════════════════════════════════════════════════════════════
#                    Visual Status Display Script
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/hyprland_status_display.sh" << 'EOF'
#!/bin/bash

CONFIG_FILE="$HOME/.config/hypr/hyprviz.conf"

GAPS_OUT=$(grep -E "^\s*gaps_out\s*=" "$CONFIG_FILE" | sed 's/.*gaps_out\s*=\s*\([0-9]*\).*/\1/')
GAPS_IN=$(grep -E "^\s*gaps_in\s*=" "$CONFIG_FILE" | sed 's/.*gaps_in\s*=\s*\([0-9]*\).*/\1/')
BORDER=$(grep -E "^\s*border_size\s*=" "$CONFIG_FILE" | sed 's/.*border_size\s*=\s*\([0-9]*\).*/\1/')
ROUNDING=$(grep -E "^\s*rounding\s*=" "$CONFIG_FILE" | sed 's/.*rounding\s*=\s*\([0-9]*\).*/\1/')

STATUS="🎨 Hyprland Visual Settings
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔲 Gaps OUT (screen edges): $GAPS_OUT
🔳 Gaps IN (between windows): $GAPS_IN
🔸 Border size: $BORDER
🔘 Corner rounding: $ROUNDING
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

echo "$STATUS"
notify-send "Visual Settings Status" "OUT:$GAPS_OUT IN:$GAPS_IN BORDER:$BORDER ROUND:$ROUNDING" -t 5000
EOF

# ═══════════════════════════════════════════════════════════════
#                  Make Hyprland Scripts Executable
# ═══════════════════════════════════════════════════════════════

chmod +x "$HOME/.config/hyprcandy/hooks/hyprland_gaps_out_increase.sh"
chmod +x "$HOME/.config/hyprcandy/hooks/hyprland_gaps_out_decrease.sh"
chmod +x "$HOME/.config/hyprcandy/hooks/hyprland_gaps_in_increase.sh"
chmod +x "$HOME/.config/hyprcandy/hooks/hyprland_gaps_in_decrease.sh"
chmod +x "$HOME/.config/hyprcandy/hooks/hyprland_border_increase.sh"
chmod +x "$HOME/.config/hyprcandy/hooks/hyprland_border_decrease.sh"
chmod +x "$HOME/.config/hyprcandy/hooks/hyprland_rounding_increase.sh"
chmod +x "$HOME/.config/hyprcandy/hooks/hyprland_rounding_decrease.sh"
chmod +x "$HOME/.config/hyprcandy/hooks/hyprland_gap_presets.sh"
chmod +x "$HOME/.config/hyprcandy/hooks/hyprland_status_display.sh"

echo "✅ Hyprland adjustment scripts created and made executable!"

# ═══════════════════════════════════════════════════════════════
#                BRAVE BROWSER KWALLET SUPPRESSION
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/brave-flags.conf" << 'EOF'
--password-store=basic
EOF

# ═══════════════════════════════════════════════════════════════
#                           GJS SCRIPTS
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.hyprcandy/GJS/toggle-control-center.sh" << 'EOF'
#!/bin/bash

# Check if the process is running
if pgrep -f "candy-main.js" > /dev/null; then
    # If running, kill it
    killall gjs ~/.hyprcandy/GJS/candy-main.js
else
    # If not running, start it
    gjs ~/.hyprcandy/GJS/candy-main.js &
fi
EOF

cat > "$HOME/.hyprcandy/GJS/toggle-media-player.sh" << 'EOF'
#!/bin/bash

# Check if the process is running
if pgrep -f "media-main.js" > /dev/null; then
    # If running, kill it
    killall gjs ~/.hyprcandy/GJS/media-main.js
else
    # If not running, start it
    gjs ~/.hyprcandy/GJS/media-main.js &
fi
EOF

cat > "$HOME/.hyprcandy/GJS/toggle-system-monitor.sh" << 'EOF'
#!/bin/bash

# Check if the process is running
if pgrep -f "candy-system-monitor.js" > /dev/null; then
    # If running, kill it
    killall gjs ~/.hyprcandy/GJS/candy-system-monitor.js
else
    # If not running, start it
    gjs ~/.hyprcandy/GJS/candy-system-monitor.js &
fi
EOF

cat > "$HOME/.hyprcandy/GJS/toggle-weather-widget.sh" << 'EOF'
#!/bin/bash

# Check if the process is running
if pgrep -f "weather-main.js" > /dev/null; then
    # If running, kill it
    killall gjs ~/.hyprcandy/GJS/weather-main.js
else
    # If not running, start it
    gjs ~/.hyprcandy/GJS/weather-main.js &
fi
EOF

chmod +x "$HOME/.hyprcandy/GJS/toggle-control-center.sh"
chmod +x "$HOME/.hyprcandy/GJS/toggle-media-player.sh"
chmod +x "$HOME/.hyprcandy/GJS/toggle-system-monitor.sh"
chmod +x "$HOME/.hyprcandy/GJS/toggle-weather-widget.sh"

echo "✅ Widget toggle scripts made executable!"

# ═══════════════════════════════════════════════════════════════
#             SERVICES & SCRIPTS BASED ON CHOSEN BAR
# ═══════════════════════════════════════════════════════════════

if [ "$PANEL_CHOICE" = "waybar" ]; then

# ═══════════════════════════════════════════════════════════════
#                      Waybar XDG Script
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hypr/scripts/xdg.sh" << 'EOF'
#!/bin/bash
# __  ______   ____
# \ \/ /  _ \ / ___|
#  \  /| | | | |  _
#  /  \| |_| | |_| |
# /_/\_\____/ \____|

# Kill any stale portal processes not managed by systemd
killall -e xdg-desktop-portal-hyprland 2>/dev/null
killall -e xdg-desktop-portal-gtk      2>/dev/null
killall -e xdg-desktop-portal          2>/dev/null

sleep 1

# Stop all managed services cleanly
systemctl --user stop \
    pipewire \
    wireplumber \
    xdg-desktop-portal \
    xdg-desktop-portal-hyprland \
    xdg-desktop-portal-gtk

sleep 1

# Start portals in the correct order:
# hyprland portal first (screen capture, toplevel), then gtk/gnome for file pickers
systemctl --user start xdg-desktop-portal-hyprland
sleep 1
systemctl --user start xdg-desktop-portal-gtk
systemctl --user start xdg-desktop-portal

sleep 1

# Restart audio and other services
systemctl --user start \
    pipewire \
    wireplumber \
EOF

chmod +x "$HOME/.config/hypr/scripts/xdg.sh"
else

# ═══════════════════════════════════════════════════════════════
#                      Hyprpanel XDG Script
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hypr/scripts/xdg.sh" << 'EOF'
#!/bin/bash
# __  ______   ____
# \ \/ /  _ \ / ___|
#  \  /| | | | |  _
#  /  \| |_| | |_| |
# /_/\_\____/ \____|

# Kill any stale portal processes not managed by systemd
killall -e xdg-desktop-portal-hyprland 2>/dev/null
killall -e xdg-desktop-portal-gtk      2>/dev/null
killall -e xdg-desktop-portal          2>/dev/null

sleep 1

# Stop all managed services cleanly
systemctl --user stop \
    pipewire \
    wireplumber \
    background-watcher \
    hyprpanel \
    hyprpanel-idle-monitor \
    xdg-desktop-portal \
    xdg-desktop-portal-hyprland \
    xdg-desktop-portal-gtk

sleep 1

# Start portals in the correct order:
# hyprland portal first (screen capture, toplevel), then gtk/gnome for file pickers
systemctl --user start xdg-desktop-portal-hyprland
sleep 1
systemctl --user start xdg-desktop-portal-gtk
systemctl --user start xdg-desktop-portal

sleep 1

# Restart audio and other services
systemctl --user start \
    pipewire \
    wireplumber \
    background-watcher \
    hyprnael \
    hyprpanel-idle-monitor
EOF

chmod +x "$HOME/.config/hypr/scripts/xdg.sh"
fi

if [ "$PANEL_CHOICE" = "waybar" ]; then

# ═══════════════════════════════════════════════════════════════
#                      Startup with Waybar
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/startup_services.sh" << 'EOF'
#!/bin/bash

echo "🎯 All services started successfully"
EOF

else

# ═══════════════════════════════════════════════════════════════
#                      Startup with Hyprpanel
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/startup_services.sh" << 'EOF'
#!/bin/bash

# Define colors file path
COLORS_FILE="$HOME/.config/hyprcandy/nwg_dock_colors.conf"

# Function to initialize colors file
initialize_colors_file() {
    echo "🎨 Initializing colors file..."
    
    mkdir -p "$(dirname "$COLORS_FILE")"
    local css_file="$HOME/.config/nwg-dock-hyprland/colors.css"
    
    if [ -f "$css_file" ]; then
        grep -E "@define-color (blur_background8|primary)" "$css_file" > "$COLORS_FILE"
        echo "✅ Colors file initialized with current values"
    else
        touch "$COLORS_FILE"
        echo "⚠️ CSS file not found, created empty colors file"
    fi
}

wait_for_hyprpanel() {
    echo "⏳ Waiting for hyprpanel to initialize..."
    local max_wait=30
    local count=0

    while [ $count -lt $max_wait ]; do
        if pgrep -f "gjs" > /dev/null 2>&1; then
            echo "✅ hyprpanel is running"
            sleep 0.5
            return 0
        fi
        sleep 0.5
        ((count++))
    done

    echo "⚠️ hyprpanel may not have started properly"
    return 1
}

restart_awww() {
    echo "🔄 Restarting awww-daemon..."
    pkill awww-daemon 2>/dev/null
    sleep 0.5
    awww-daemon &
    sleep 1
    echo "✅ awww-daemon restarted"
}

# MAIN EXECUTION
initialize_colors_file
    
if wait_for_hyprpanel; then
    sleep 0.5
    restart_awww
else
    echo "⚠️ Proceeding with awww restart anyway..."
    restart_awww
fi

echo "🎯 All services started successfully"
EOF

chmod +x "$HOME/.config/hyprcandy/hooks/startup_services.sh"
fi

# ═══════════════════════════════════════════════════════════════
#                      Cursor Update Script
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/watch_cursor_theme.sh" << 'EOF'
#!/bin/bash

GTK3_FILE="$HOME/.config/gtk-3.0/settings.ini"
GTK4_FILE="$HOME/.config/gtk-4.0/settings.ini"
HYPRCONF="$HOME/.config/hypr/hyprviz.conf"

get_value() {
    grep -E "^$1=" "$1" 2>/dev/null | cut -d'=' -f2 | tr -d ' '
}

extract_cursor_theme() {
    grep -E "^gtk-cursor-theme-name=" "$1" | cut -d'=' -f2 | tr -d ' '
}

extract_cursor_size() {
    grep -E "^gtk-cursor-theme-size=" "$1" | cut -d'=' -f2 | tr -d ' '
}

update_hypr_cursor_env() {
    local theme="$1"
    local size="$2"

    [ -z "$theme" ] && return
    [ -z "$size" ] && return

    # Replace each env line using sed
    sed -i "s|^env = XCURSOR_THEME,.*|env = XCURSOR_THEME,$theme|" "$HYPRCONF"
    sed -i "s|^env = XCURSOR_SIZE,.*|env = XCURSOR_SIZE,$size|" "$HYPRCONF"
    sed -i "s|^env = HYPRCURSOR_THEME,.*|env = HYPRCURSOR_THEME,$theme|" "$HYPRCONF"
    sed -i "s|^env = HYPRCURSOR_SIZE,.*|env = HYPRCURSOR_SIZE,$size|" "$HYPRCONF"
    
    # Sync GTK4 with GTK3
    sed -i "s|^gtk-cursor-theme-name=.*|gtk-cursor-theme-name=$theme|" "$GTK4_FILE"
    sed -i "s|^gtk-cursor-theme-size=.*|gtk-cursor-theme-size=$size|" "$GTK4_FILE" 

    # SDDM cursor update
    sudo sed -i "s|^CursorTheme=.*|CursorTheme=$theme|" "/etc/sddm.conf.d/sugar-candy.conf"
    sudo sed -i "s|^CursorSize=.*|CursorSize=$size|" "/etc/sddm.conf.d/sugar-candy.conf"

    # Apply changes immediately
    apply_cursor_changes "$theme" "$size"

    echo "✅ Updated and applied cursor theme: $theme / $size"
}

apply_cursor_changes() {
    local theme="$1"
    local size="$2"
    
    # Method 1: Reload Hyprland config
    hyprctl reload 2>/dev/null
    # Apply cursor changes immediately using hyprctl
    hyprctl setcursor "$theme" "$size" 2>/dev/null || {
        echo "⚠️  hyprctl setcursor failed, falling back to reload"
        hyprctl reload 2>/dev/null
    }
    
    # Method 2: Set cursor for current session (fallback)
    if command -v gsettings >/dev/null 2>&1; then
        gsettings set org.gnome.desktop.interface cursor-theme "$theme" 2>/dev/null || true
        gsettings set org.gnome.desktop.interface cursor-size "$size" 2>/dev/null || true
    fi
    
    # Method 3: Update X11 cursor (if running under Xwayland apps)
    if [ -n "$DISPLAY" ]; then
        echo "Xcursor.theme: $theme" | xrdb -merge 2>/dev/null || true
        echo "Xcursor.size: $size" | xrdb -merge 2>/dev/null || true
    fi
}

watch_gtk_file() {
    local file="$1"
    echo "👁 Watching $file for cursor changes..."
    inotifywait -m -e modify "$file" | while read -r; do
        theme=$(extract_cursor_theme "$file")
        size=$(extract_cursor_size "$file")
        update_hypr_cursor_env "$theme" "$size"
        sleep 0.5
        systemctl --user restart cursor-theme-watcher.service
    done
}

# Initial sync if file exists
for gtk_file in "$GTK3_FILE" "$GTK4_FILE"; do
    if [ -f "$gtk_file" ]; then
        theme=$(extract_cursor_theme "$gtk_file")
        size=$(extract_cursor_size "$gtk_file")
        update_hypr_cursor_env "$theme" "$size"
    fi
done

# Start watchers in background
watch_gtk_file "$GTK3_FILE" &
wait
EOF

chmod +x "$HOME/.config/hyprcandy/hooks/watch_cursor_theme.sh"

# ═══════════════════════════════════════════════════════════════
#                    Cursor Update Service
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/systemd/user/cursor-theme-watcher.service" << 'EOF'
[Unit]
Description=Watch GTK cursor theme and size changes
After=hyprland-session.target
PartOf=hyprland-session.target

[Service]
Type=simple
ExecStart=%h/.config/hyprcandy/hooks/watch_cursor_theme.sh
Restart=on-failure
RestartSec=5

# Import environment variables from the user session
Environment="PATH=/usr/local/bin:/usr/bin:/bin"
# These will be set by the ExecStartPre command
ExecStartPre=/bin/bash -c 'systemctl --user import-environment HYPRLAND_INSTANCE_SIGNATURE XDG_CURRENT_DESKTOP WAYLAND_DISPLAY DISPLAY'

[Install]
WantedBy=hyprland-session.target
EOF

# ═══════════════════════════════════════════════════════════════
#                        Pyprland Config
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/pypr/config.toml" << 'EOF'
[pyprland]
plugins = [
    "scratchpads"
]
[scratchpads.term]
animation = "fromTop"
command = "kitty --class=kitty-scratchpad"
class = "kitty-scratchpad"
EOF

if [ "$PANEL_CHOICE" = "waybar" ]; then

# ═══════════════════════════════════════════════════════════════
#                         Waybar Service
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/systemd/user/waybar.service" << 'EOF'
Unit]
Description=Waybar - Highly customizable Wayland bar
Documentation=https://github.com/Alexays/Waybar/wiki
After=graphical-session.target hyprland-session.target
Wants=graphical-session.target
PartOf=graphical-session.target
Requisite=graphical-session.target

[Service]
Type=simple
ExecStart=/usr/bin/waybar
Restart=on-failure
RestartSec=6
KillMode=mixed
KillSignal=SIGTERM
TimeoutStopSec=10

# Don't restart if manually stopped (allows keybind control)
RestartPreventExitStatus=143

[Install]
WantedBy=graphical-session.target
EOF
# Just waybar service. No awww cache clearing needed

else

# ═══════════════════════════════════════════════════════════════
#                  Clear awww Cache Script
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/clear_awww.sh" << 'EOF'
#!/bin/bash
CACHE_DIR="$HOME/.cache/awww"
[ -d "$CACHE_DIR" ] && rm -rf "$CACHE_DIR"
EOF
chmod +x "$HOME/.config/hyprcandy/hooks/clear_awww.sh"
fi

if [ "$PANEL_CHOICE" = "waybar" ]; then
# ═══════════════════════════════════════════════════════════════
#                  Background Update Script
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/update_background.sh" << 'EOF'
#!/bin/bash
#set +e

# Update ROFI background 
ROFI_RASI="$HOME/.config/rofi/colors.rasi"

if command -v sed >/dev/null; then
    sed -i "2s/, 1)/, 0.3)/" "$ROFI_RASI"
fi

# Update local background.png
if command -v magick >/dev/null && [ -f "$HOME/.config/background" ]; then
    magick "$HOME/.config/background[0]" "$HOME/.config/background.png"
fi

# ── Update SDDM background path and BackgroundColor from waypaper/colors.css ──
WP_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/wallpaper/wallpaper.ini"
WAYPAPER_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/waypaper/config.ini"
# Prefer quickshell wallpaper picker config; fall back to waypaper
[[ -f "$WP_CONFIG" ]] && WAYPAPER_CONFIG="$WP_CONFIG"
SDDM_CONF="/usr/share/sddm/themes/sugar-candy/theme.conf"
SDDM_BG_DIR="/usr/share/sddm/themes/sugar-candy/Backgrounds"
COLORS_CSS="${XDG_CONFIG_HOME:-$HOME/.config}/gtk-4.0/colors.css"

if [[ -f "$WAYPAPER_CONFIG" && -f "$SDDM_CONF" ]]; then
    # ── Wallpaper path ────────────────────────────────────────────────────────
    CURRENT_WP=$(grep -E "^\s*wallpaper\s*=" "$WAYPAPER_CONFIG" \
        | head -n1 \
        | sed 's/.*=\s*//' \
        | sed "s|~|$HOME|g" \
        | xargs)

   if [[ -n "$CURRENT_WP" && -f "$CURRENT_WP" ]]; then
        WP_FILENAME=$(basename "$CURRENT_WP")
        WP_EXT="${WP_FILENAME##*.}"

        # webp is not supported by sugar-candy — convert to jpg first
        if [[ "${WP_EXT,,}" == "webp" ]]; then
            WP_FILENAME="${WP_FILENAME%.*}.jpg"
            sudo magick "$CURRENT_WP" "$SDDM_BG_DIR/$WP_FILENAME"
            sudo chmod 644 "$SDDM_BG_DIR/$WP_FILENAME"
            #echo "🔄 Converted webp → $WP_FILENAME"
        else
            sudo magick "$CURRENT_WP" "$SDDM_BG_DIR/$WP_FILENAME"
            sudo chmod 644 "$SDDM_BG_DIR/$WP_FILENAME"
        fi

        sudo sed -i "s|^Background=.*|Background=\"Backgrounds/$WP_FILENAME\"|" "$SDDM_CONF"
        #echo "🖥️  SDDM background updated → Backgrounds/$WP_FILENAME"
    fi

    # ── BackgroundColor from inverse_primary in colors.css ───────────────────
    if [[ -f "$COLORS_CSS" ]]; then
        FULL_HEX=$(grep -E '@define-color\s+inverse_primary\s+#' "$COLORS_CSS" \
            | head -n1 \
            | grep -oP '(?<=#)[0-9a-fA-F]{6}')

        if [[ -n "$FULL_HEX" ]]; then
            sudo sed -i "s|^BackgroundColor=.*|BackgroundColor=\"#$FULL_HEX\"|" "$SDDM_CONF"
            #echo "🎨 SDDM BackgroundColor updated → #$FULL_HEX (from inverse_primary)"
        else
            echo "⚠️  Could not parse inverse_primary from $COLORS_CSS"
        fi
    else
        echo "⚠️  colors.css not found at $COLORS_CSS"
    fi

    # ── AccentColor from primary_container in colors.css ───────────────────
    if [[ -f "$COLORS_CSS" ]]; then
        FULL_HEX=$(grep -E '@define-color\s+primary_container\s+#' "$COLORS_CSS" \
            | head -n1 \
            | grep -oP '(?<=#)[0-9a-fA-F]{6}')

        if [[ -n "$FULL_HEX" ]]; then
            sudo sed -i "s|^AccentColor=.*|AccentColor=\"#$FULL_HEX\"|" "$SDDM_CONF"
            #echo "🎨 SDDM AccentColor updated → #$FULL_HEX (from primary_container)"
        else
            echo "⚠️  Could not parse primary_container from $COLORS_CSS"
        fi
    else
        echo "⚠️  colors.css not found at $COLORS_CSS"
    fi

else
    [[ ! -f "$WAYPAPER_CONFIG" ]] && echo "⚠️  waypaper config not found: $WAYPAPER_CONFIG"
    [[ ! -f "$SDDM_CONF" ]]      && echo "⚠️  SDDM config not found: $SDDM_CONF"
fi
EOF

else

cat > "$HOME/.config/hyprcandy/hooks/update_background.sh" << 'EOF'
#!/bin/bash
set +e

# Update ROFI background 
ROFI_RASI="$HOME/.config/rofi/colors.rasi"

if command -v sed >/dev/null; then
    sed -i "2s/, 1)/, 0.3)/" "$ROFI_RASI"
    echo "Rofi color updated"
fi

# Update local background.png
if command -v magick >/dev/null && [ -f "$HOME/.config/background" ]; then
    magick "$HOME/.config/background[0]" "$HOME/.config/background.png"
fi

# ── Update SDDM background path and BackgroundColor from waypaper/colors.css ──
WAYPAPER_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/waypaper/config.ini"
SDDM_CONF="/usr/share/sddm/themes/sugar-candy/theme.conf"
SDDM_BG_DIR="/usr/share/sddm/themes/sugar-candy/Backgrounds"
COLORS_CSS="${XDG_CONFIG_HOME:-$HOME/.config}/gtk-4.0/colors.css"

if [[ -f "$WAYPAPER_CONFIG" && -f "$SDDM_CONF" ]]; then
    # ── Wallpaper path ────────────────────────────────────────────────────────
    CURRENT_WP=$(grep -E "^\s*wallpaper\s*=" "$WAYPAPER_CONFIG" \
        | head -n1 \
        | sed 's/.*=\s*//' \
        | sed "s|~|$HOME|g" \
        | xargs)

    if [[ -n "$CURRENT_WP" && -f "$CURRENT_WP" ]]; then
        WP_FILENAME=$(basename "$CURRENT_WP")
        WP_EXT="${WP_FILENAME##*.}"

        # webp is not supported by sugar-candy — convert to jpg first
        if [[ "${WP_EXT,,}" == "webp" ]]; then
            WP_FILENAME="${WP_FILENAME%.*}.jpg"
            sudo magick "$CURRENT_WP" "$SDDM_BG_DIR/$WP_FILENAME"
            echo "🔄 Converted webp → $WP_FILENAME"
        else
            sudo magick "$CURRENT_WP" "$SDDM_BG_DIR/$WP_FILENAME"
        fi

        sudo sed -i "s|^Background=.*|Background=\"Backgrounds/$WP_FILENAME\"|" "$SDDM_CONF"
        echo "🖥️  SDDM background updated → Backgrounds/$WP_FILENAME"
    fi

    # ── BackgroundColor from inverse_primary in colors.css ───────────────────
    if [[ -f "$COLORS_CSS" ]]; then
        FULL_HEX=$(grep -E '@define-color\s+inverse_primary\s+#' "$COLORS_CSS" \
            | head -n1 \
            | grep -oP '(?<=#)[0-9a-fA-F]{6}')

        if [[ -n "$FULL_HEX" ]]; then
            sudo sed -i "s|^BackgroundColor=.*|BackgroundColor=\"#$FULL_HEX\"|" "$SDDM_CONF"
            echo "🎨 SDDM BackgroundColor updated → #$FULL_HEX (from inverse_primary)"
        else
            echo "⚠️  Could not parse inverse_primary from $COLORS_CSS"
        fi
    else
        echo "⚠️  colors.css not found at $COLORS_CSS"
    fi

    # ── AccentColor from primary_container in colors.css ───────────────────
    if [[ -f "$COLORS_CSS" ]]; then
        FULL_HEX=$(grep -E '@define-color\s+primary_container\s+#' "$COLORS_CSS" \
            | head -n1 \
            | grep -oP '(?<=#)[0-9a-fA-F]{6}')

        if [[ -n "$FULL_HEX" ]]; then
            sudo sed -i "s|^AccentColor=.*|AccentColor=\"#$FULL_HEX\"|" "$SDDM_CONF"
            echo "🎨 SDDM AccentColor updated → #$FULL_HEX (from primary_container)"
        else
            echo "⚠️  Could not parse primary_container from $COLORS_CSS"
        fi
    else
        echo "⚠️  colors.css not found at $COLORS_CSS"
    fi

else
    [[ ! -f "$WAYPAPER_CONFIG" ]] && echo "⚠️  waypaper config not found: $WAYPAPER_CONFIG"
    [[ ! -f "$SDDM_CONF" ]]      && echo "⚠️  SDDM config not found: $SDDM_CONF"
fi

# Create lock.png at 661x661 pixels
if command -v magick >/dev/null && [ -f "$HOME/.config/background" ]; then
    magick "$HOME/.config/background[0]" -resize 661x661^ -gravity center -extent 661x661 "$HOME/.config/lock.png"
    echo "🔒 Created lock.png at 661x661 pixels"
fi

# Update mako config colors from nwg-dock-hyprland/colors.css
MAKO_CONFIG="$HOME/.config/mako/config"
COLORS_CSS="$HOME/.config/nwg-dock-hyprland/colors.css"

if [ -f "$COLORS_CSS" ] && [ -f "$MAKO_CONFIG" ]; then
    # Extract hex values from colors.css, removing trailing semicolons and newlines
    ON_PRIMARY_FIXED_VARIANT=$(grep -E "@define-color[[:space:]]+on_primary_fixed_variant" "$COLORS_CSS" | awk '{print $3}' | tr -d ';' | tr -d '\n')
    PRIMARY_FIXED_DIM=$(grep -E "@define-color[[:space:]]+primary_fixed_dim" "$COLORS_CSS" | awk '{print $3}' | tr -d ';' | tr -d '\n')
    SCIM=$(grep -E "@define-color[[:space:]]+scrim" "$COLORS_CSS" | awk '{print $3}' | tr -d ';' | tr -d '\n')

    # Only proceed if both colors are found
    if [[ $ON_PRIMARY_FIXED_VARIANT =~ ^#([A-Fa-f0-9]{6})$ ]] && [[ $PRIMARY_FIXED_DIM =~ ^#([A-Fa-f0-9]{6})$ ]]; then
        # Update all background-color, progress-color, and border-color lines in mako config
        sed -i "s|^background-color=#.*|background-color=$ON_PRIMARY_FIXED_VARIANT|g" "$MAKO_CONFIG"
        sed -i "s|^progress-color=#.*|progress-color=$SCIM|g" "$MAKO_CONFIG"
        sed -i "s|^border-color=#.*|border-color=$PRIMARY_FIXED_DIM|g" "$MAKO_CONFIG"
        pkill -f mako
        sleep 1
        mako &
        echo "🎨 Updated ALL mako config colors: background-color=$ON_PRIMARY_FIXED_VARIANT, progress-color=$SCIM, border-color=$PRIMARY_FIXED_DIM"
    else
        echo "⚠️  Could not extract required color values from $COLORS_CSS"
    fi
else
    echo "⚠️  $COLORS_CSS or $MAKO_CONFIG not found, skipping mako color update"
fi
EOF
fi

chmod +x "$HOME/.config/hyprcandy/hooks/update_background.sh"

# ═══════════════════════════════════════════════════════════════
#                             Overview
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/scripts/overview.sh" << 'EOF'
#!/bin/bash

# If the overview instance is already running, just toggle it.
# If not, start it and then toggle open.
if pgrep -f "qs -c overview" > /dev/null; then
    qs ipc -c overview call overview toggle
else
    qs -c overview &
    # Wait for the IPC socket to be ready before calling toggle
    for i in $(seq 1 20); do
        sleep 0.1
        if qs ipc -c overview call overview toggle 2>/dev/null; then
            break
        fi
    done
fi
EOF

chmod +x "$HOME/.config/hyprcandy/scripts/overview.sh"

# ═══════════════════════════════════════════════════════════════
#              Background File & Matugen Watcher
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/watch_background.sh" << 'EOF'
#!/bin/bash
CONFIG_BG="$HOME/.config/background"
HOOKS_DIR="$HOME/.config/hyprcandy/hooks"
COLORS_FILE="$HOME/.config/hyprcandy/nwg_dock_colors.conf"
AUTO_RELAUNCH_PREF="$HOME/.config/hyprcandy/scripts/.dock-auto-relaunch"

while [ -z "$HYPRLAND_INSTANCE_SIGNATURE" ]; do
    echo "Waiting for Hyprland to start..."
    sleep 1
done
echo "Hyprland started"

# Function to execute hooks
execute_hooks() {
    echo "🎯 Executing hooks & checking dock relaunch..."
    
    # Check auto-relaunch preference
    AUTO_RELAUNCH_STATE="enabled"
    if [ -f "$AUTO_RELAUNCH_PREF" ]; then
        AUTO_RELAUNCH_STATE=$(<"$AUTO_RELAUNCH_PREF")
    fi
    
    # Only proceed with dock relaunch if auto-relaunch is enabled
    if [[ "$AUTO_RELAUNCH_STATE" == "enabled" ]]; then
        # Check if colors have changed and launch dock if different
        colors_file="$HOME/.config/nwg-dock-hyprland/colors.css"
        
        # Get current colors from CSS file
        get_current_colors() {
            if [ -f "$colors_file" ]; then
                grep -E "@define-color (blur_background8|primary)" "$colors_file"
            fi
        }
        
        # Get stored colors from our tracking file
        get_stored_colors() {
            if [ -f "$COLORS_FILE" ]; then
                cat "$COLORS_FILE"
            fi
        }
        
        # Compare colors and launch dock if different
        if [ -f "$colors_file" ]; then
            current_colors=$(get_current_colors)
            stored_colors=$(get_stored_colors)
            
            if [ "$current_colors" != "$stored_colors" ]; then
                pkill -f nwg-dock-hyprland
                gsettings set org.gnome.desktop.interface gtk-theme "''"
                sleep 0.2
                gsettings set org.gnome.desktop.interface gtk-theme "adw-gtk3-dark"
                sleep 0.5
                nohup bash -c "$HOME/.config/hyprcandy/scripts/toggle-dock.sh --relaunch" >/dev/null 2>&1 &
                mkdir -p "$(dirname "$COLORS_FILE")"
                echo "$current_colors" > "$COLORS_FILE"
                echo "🎨 Updated dock colors and launched dock"
            else
                echo "🎨 Colors unchanged, skipping dock launch"
            fi
        else
            # Fallback if colors.css doesn't exist
            echo "🎨 Colors file not found"
        fi
    else
        echo "🚫 Auto-relaunch disabled by user, skipping dock relaunch"
    fi
    
    "$HOOKS_DIR/clear_awww.sh"
    "$HOOKS_DIR/update_background.sh"
}

# Function to monitor matugen process
monitor_matugen() {
    echo "🎨 Matugen detected, waiting for completion..."
    
    # Wait for matugen to finish
    while pgrep -x "matugen" > /dev/null 2>&1; do
        sleep 1
    done
    
    echo "✅ Matugen finished, reloading dock & executing hooks"
    execute_hooks
}

# ⏳ Wait for background file to exist
while [ ! -f "$CONFIG_BG" ]; do
    echo "⏳ Waiting for background file to appear..."
    sleep 0.5
done

echo "🚀 Starting background and matugen monitoring..."

# Start background monitoring in background
{
    inotifywait -m -e close_write "$CONFIG_BG" | while read -r file; do
        echo "🎯 Detected background update: $file"
        
        # Check if matugen is running
        if pgrep -x "matugen" > /dev/null 2>&1; then
            echo "🎨 Matugen is running, will wait for completion..."
            monitor_matugen
        else
            execute_hooks
        fi
    done
} &

# Start matugen process monitoring
{
    while true; do
        # Wait for matugen to start
        while ! pgrep -x "matugen" > /dev/null 2>&1; do
            sleep 0.5
        done
        
        echo "🎨 Matugen process detected!"
        monitor_matugen
    done
} &

# Wait for any child process to exit
wait
EOF

chmod +x "$HOME/.config/hyprcandy/hooks/watch_background.sh"

# ═══════════════════════════════════════════════════════════════
#            Systemd Service: Background Watcher
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/systemd/user/background-watcher.service" << 'EOF'
[Unit]
Description=Watch ~/.config/background, clear awww cache and update background images
After=hyprland-session.target
PartOf=hyprland-session.target

[Service]
Type=simple
ExecStart=%h/.config/hyprcandy/hooks/watch_background.sh
Restart=on-failure
RestartSec=5

# Import environment variables from the user session
Environment="PATH=/usr/local/bin:/usr/bin:/bin"
# These will be set by the ExecStartPre command
ExecStartPre=/bin/bash -c 'systemctl --user import-environment HYPRLAND_INSTANCE_SIGNATURE XDG_CURRENT_DESKTOP WAYLAND_DISPLAY DISPLAY'

[Install]
WantedBy=hyprland-session.target
EOF

if [ "$PANEL_CHOICE" = "waybar" ]; then

# ═══════════════════════════════════════════════════════════════
#         	Weather script reload on session resume
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hypr/scripts/lock-watcher.sh" << 'EOF'
#!/bin/bash
# lock-watcher.sh - Watches for candylock unlock and refreshes the bar

WEATHER_CACHE_FILE="/tmp/astal-weather-cache.json"

# Wait for Hyprland to start
while [ -z "$HYPRLAND_INSTANCE_SIGNATURE" ]; do
    sleep 1
done

echo "candylock watcher started"

# Continuously monitor for candylock
while true; do
    # Wait for candylock to start
    while ! pgrep -f "qs -c candylock" >/dev/null 2>&1; do
        sleep 1
    done
    
    echo "candylock detected - waiting for unlock..."
    
    # Wait for candylock to end (unlock)
    while pgrep -f "qs -c candylock" >/dev/null 2>&1; do
        sleep 0.5
    done
    
    echo "Unlocked! Checking waybar status..."
    
    # Only refresh waybar if it was running before lock
    if pgrep -x waybar >/dev/null 2>&1; then
        echo "Waybar is running - refreshing..."
        
        # Remove cached weather file
        rm -f "$WEATHER_CACHE_FILE"
        rm -f "${WEATHER_CACHE_FILE}.tmp"
        
        # Wait a moment for system to fully resume
        sleep 0.5
        
        # Quick waybar restart
        killall -SIGUSR2 waybar
    else
        echo "Waybar was hidden before session lock - skipping refresh"
    fi
    
    # Wait a bit before checking for next lock
    sleep 3
done
EOF
chmod +x "$HOME/.config/hypr/scripts/lock-watcher.sh"

# ═══════════════════════════════════════════════════════════════
#            			   Hyprlock Service
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/systemd/user/lock-watcher.service" << 'EOF'
[Unit]
Description=Candylock Unlock Watcher - Refreshes bar on Resume
PartOf=graphical-session.target
After=graphical-session.target
Requisite=graphical-session.target

[Service]
Type=simple
ExecStart=%h/.config/hypr/scripts/lock-watcher.sh
Restart=on-failure
RestartSec=3

[Install]
WantedBy=graphical-session.target
EOF

# ═══════════════════════════════════════════════════════════════
#         waybar_idle_monitor.sh — Auto Toggle Inhibitor
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/waybar_idle_monitor.sh" << 'EOF'
#!/usr/bin/env bash
#
# waybar_idle_monitor.sh
#   - when waybar is NOT running: start our idle inhibitor
#   - when waybar IS running : stop our idle inhibitor
#   - ignores any other inhibitors

# ----------------------------------------------------------------------
# Configuration
# ----------------------------------------------------------------------
INHIBITOR_WHO="Waybar-Idle-Monitor"
CHECK_INTERVAL=5      # seconds between polls

# holds the PID of our systemd-inhibit process
IDLE_INHIBITOR_PID=""

# Wait for Hyprland to start
while [ -z "$HYPRLAND_INSTANCE_SIGNATURE" ]; do
  echo "Waiting for Hyprland to start..."
  sleep 1
done
echo "Hyprland started"
echo "🔍 Waiting for Waybar to start..."

# ----------------------------------------------------------------------
# Helpers
# ----------------------------------------------------------------------

# Returns 0 if our inhibitor is already active
has_our_inhibitor() {
  systemd-inhibit --list 2>/dev/null \
    | grep -F "$INHIBITOR_WHO" \
    >/dev/null 2>&1
}

# Returns 0 if waybar is running
is_waybar_running() {
  pgrep -x waybar >/dev/null 2>&1
}

# ----------------------------------------------------------------------
# Start / stop our inhibitor
# ----------------------------------------------------------------------

start_idle_inhibitor() {
  if has_our_inhibitor; then
    echo "$(date): [INFO] Idle inhibitor already active."
    return
  fi

  echo "$(date): [INFO] Starting idle inhibitor (waybar down)…"
  systemd-inhibit \
    --what=idle \
    --who="$INHIBITOR_WHO" \
    --why="waybar not running — keep screen awake" \
    sleep infinity &
  IDLE_INHIBITOR_PID=$!
}

stop_idle_inhibitor() {
  if [ -n "$IDLE_INHIBITOR_PID" ] && kill -0 "$IDLE_INHIBITOR_PID" 2>/dev/null; then
    echo "$(date): [INFO] Stopping idle inhibitor (waybar back)…"
    kill "$IDLE_INHIBITOR_PID"
    IDLE_INHIBITOR_PID=""
  elif has_our_inhibitor; then
    # fallback if we lost track of the PID
    echo "$(date): [INFO] Killing stray idle inhibitor by tag…"
    pkill -f "systemd-inhibit.*$INHIBITOR_WHO"
  fi
}

# ----------------------------------------------------------------------
# Cleanup on exit
# ----------------------------------------------------------------------

cleanup() {
  echo "$(date): [INFO] Exiting — cleaning up."
  stop_idle_inhibitor
  exit 0
}

trap cleanup SIGINT SIGTERM

# ----------------------------------------------------------------------
# Main
# ----------------------------------------------------------------------

echo "$(date): [INFO] Starting Waybar idle monitor…"
echo "       CHECK_INTERVAL=${CHECK_INTERVAL}s, INHIBITOR_WHO=$INHIBITOR_WHO"

# Initial state
if is_waybar_running; then
  stop_idle_inhibitor
else
  start_idle_inhibitor
fi

# Poll loop
while true; do
  if is_waybar_running; then
    stop_idle_inhibitor
  else
    start_idle_inhibitor
  fi
  sleep "$CHECK_INTERVAL"
done
EOF

chmod +x "$HOME/.config/hyprcandy/hooks/waybar_idle_monitor.sh"

# ═══════════════════════════════════════════════════════════════
#        Systemd Service: waybar Idle Inhibitor Monitor
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/systemd/user/waybar-idle-monitor.service" << 'EOF'
[Unit]
Description=Waybar Idle Inhibitor Monitor
After=graphical-session.target
Wants=graphical-session.target

[Service]
Type=simple
# Make sure this path matches where you put your script:
ExecStart=%h/.config/hyprcandy/hooks/waybar_idle_monitor.sh
Restart=always
RestartSec=10

[Install]
WantedBy=default.target
EOF

# ═══════════════════════════════════════════════════════════════
#                  Wallpaper Integration Scripts
# ═══════════════════════════════════════════════════════════════

    cat > "$HOME/.config/hyprcandy/hooks/wallpaper_integration.sh" << 'EOF'
#!/bin/bash

CONFIG_BG="$HOME/.config/background"
WP_CONFIG="$HOME/.config/wallpaper/wallpaper.ini"
WAYPAPER_CONFIG="$HOME/.config/waypaper/config.ini"
MATUGEN_CONFIG="$HOME/.config/matugen/config.toml"
RELOAD_SO="/usr/local/lib/gtk3-reload.so"
RELOAD_SRC="/usr/local/share/gtk3-reload/gtk3-reload.c"
HOOKS_DIR="$HOME/.config/hyprcandy/hooks"

get_wallpaper_background() {
    # Prefer quickshell wallpaper picker config, fall back to waypaper config
    for cfg in "$WP_CONFIG" "$WAYPAPER_CONFIG"; do
        if [ -f "$cfg" ]; then
            current_bg=$(grep -E "^wallpaper\s*=" "$cfg" | head -n1 | cut -d'=' -f2- | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
            if [ -n "$current_bg" ]; then
                current_bg=$(echo "$current_bg" | sed "s|^~|$HOME|")
                echo "$current_bg"
                return 0
            fi
        fi
    done
    return 1
}

update_config_background() {
    local bg_path="$1"
    if [ -f "$bg_path" ] && [ -f "$MATUGEN_CONFIG" ]; then
        echo "🎨 Triggering matugen color generation..."
        wal -i "$bg_path" -n --cols16 darken --backend colorthief --contrast 1.5 --saturate 0.25 2>/dev/null
		matugen image "$bg_path" --type scheme-content -m dark -r nearest --base16-backend wal --lightness-dark -0.1 --source-color-index 0 --contrast 0.2 2>/dev/null
        sleep 0.5
        magick "$bg_path" "$HOME/.config/background"
        sleep 1
        "$HOOKS_DIR/update_background.sh"
        #echo "✅ Updated ~/.config/background to point to: $bg_path"
        return 0
    else
        echo "❌ Background file not found: $bg_path"
        return 1
    fi
}

main() {
    echo "🎯 Wallpaper integration triggered"
    current_bg=$(get_wallpaper_background)
    if [ $? -eq 0 ]; then
        echo "📸 Current wallpaper background: $current_bg"
        if update_config_background "$current_bg"; then
           echo "✅ Color generation processes complete"
        fi
    else
        echo "⚠️  Could not determine current wallpaper background"
    fi
}

main
EOF
    chmod +x "$HOME/.config/hyprcandy/hooks/wallpaper_integration.sh"

else

# ═══════════════════════════════════════════════════════════════
#         hyprpanel_idle_monitor.sh — Auto Toggle Inhibitor
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/hyprpanel_idle_monitor.sh" << 'EOF'
#!/bin/bash

IDLE_INHIBITOR_PID=""
MAKO_PID=""
CHECK_INTERVAL=5
INHIBITOR_WHO="HyprCandy-Monitor"

# Wait for Hyprland to start
while [ -z "$HYPRLAND_INSTANCE_SIGNATURE" ]; do
  echo "Waiting for Hyprland to start..."
  sleep 1
done
echo "Hyprland started"
echo "🔍 Waiting for hyprpanel to start..."

has_hyprpanel_inhibitor() {
    systemd-inhibit --list 2>/dev/null | grep -i "hyprpanel\|panel" >/dev/null 2>&1
}

has_our_inhibitor() {
    systemd-inhibit --list 2>/dev/null | grep "$INHIBITOR_WHO" >/dev/null 2>&1
}

is_mako_running() {
    pgrep -x "mako" > /dev/null 2>&1
}

start_mako() {
    if is_mako_running; then return; fi
    mako &
    MAKO_PID=$!
    sleep 1
}

stop_mako() {
    if [ -n "$MAKO_PID" ] && kill -0 "$MAKO_PID" 2>/dev/null; then
        kill "$MAKO_PID"
        MAKO_PID=""
    elif is_mako_running; then
        pkill -x "mako"
    fi
}

# Function to start idle inhibitor (only if hyprpanel doesn't have one)
start_idle_inhibitor() {
    if has_hyprpanel_inhibitor; then
        echo "$(date): Hyprpanel already has inhibitor"
        return
    fi
    if has_our_inhibitor; then
        echo "$(date): Our idle inhibitor is already active"
        return
    fi
    if [ -z "$IDLE_INHIBITOR_PID" ] || ! kill -0 "$IDLE_INHIBITOR_PID" 2>/dev/null; then
        systemd-inhibit --what=idle --who="$INHIBITOR_WHO" --why="Hyprpanel not running" sleep infinity &
        IDLE_INHIBITOR_PID=$!
    fi
}

stop_idle_inhibitor() {
    if [ -n "$IDLE_INHIBITOR_PID" ] && kill -0 "$IDLE_INHIBITOR_PID" 2>/dev/null; then
        kill "$IDLE_INHIBITOR_PID"
        IDLE_INHIBITOR_PID=""
    fi
}

is_hyprpanel_running() {
    pgrep -f "gjs" > /dev/null 2>&1
}

start_fallback_services() {
    start_idle_inhibitor
    start_mako
}

stop_fallback_services() {
    stop_idle_inhibitor
    stop_mako
}

cleanup() {
    stop_idle_inhibitor
    stop_mako
    exit 0
}

trap cleanup SIGTERM SIGINT

echo "$(date): Starting enhanced hyprpanel monitor..."
echo "$(date): WHO=$INHIBITOR_WHO, CHECK_INTERVAL=${CHECK_INTERVAL}s"

if is_hyprpanel_running; then
    stop_fallback_services
else
    start_fallback_services
fi

while true; do
    if is_hyprpanel_running; then
        if [ -n "$IDLE_INHIBITOR_PID" ] && kill -0 "$IDLE_INHIBITOR_PID" 2>/dev/null; then
            stop_fallback_services
        fi
    else
        needs_inhibitor=false
        needs_mako=false
        if [ -z "$IDLE_INHIBITOR_PID" ] || ! kill -0 "$IDLE_INHIBITOR_PID" 2>/dev/null; then
            if ! has_hyprpanel_inhibitor; then
                needs_inhibitor=true
            fi
        fi
        if ! is_mako_running; then
            needs_mako=true
        fi
        if $needs_inhibitor || $needs_mako; then
            if $needs_inhibitor; then start_idle_inhibitor; fi
            if $needs_mako; then start_mako; fi
        fi
    fi
    sleep "$CHECK_INTERVAL"
done
EOF

chmod +x "$HOME/.config/hyprcandy/hooks/hyprpanel_idle_monitor.sh"

# ═══════════════════════════════════════════════════════════════
#        Systemd Service: hyprpanel Idle Inhibitor Monitor
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/systemd/user/hyprpanel-idle-monitor.service" << 'EOF'
[Unit]
Description=Monitor hyprpanel and manage idle inhibitor
After=graphical-session.target
Wants=graphical-session.target

[Service]
Type=simple
ExecStart=%h/.config/hyprcandy/hooks/hyprpanel_idle_monitor.sh
Restart=always
RestartSec=10
KillMode=mixed
KillSignal=SIGTERM
TimeoutStopSec=15

[Install]
WantedBy=default.target
EOF

# ═══════════════════════════════════════════════════════════════
#             Safe hyprpanel Killer Script (Preserve awww)
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/kill_hyprpanel_safe.sh" << 'EOF'
#!/bin/bash

echo "🔄 Safely closing hyprpanel while preserving awww-daemon..."

# Try graceful shutdown
if pgrep -f "hyprpanel" > /dev/null; then
    echo "📱 Attempting graceful shutdown..."
    hyprpanel -q
    sleep 1

    if pgrep -f "hyprpanel" > /dev/null; then
        echo "⚠️  Graceful shutdown failed, trying systemd stop..."
        systemctl --user stop hyprpanel.service
        sleep 1

        if pgrep -f "hyprpanel" > /dev/null; then
            echo "🔨 Force killing hyprpanel processes..."
            pkill -f "gjs.*hyprpanel"
        fi
    fi
fi

# Ensure awww-daemon continues running
if ! pgrep -f "awww-daemon" > /dev/null; then
    echo "🔄 awww-daemon not found, restarting it..."
    awww-daemon &
    sleep 1
    if [ -f "$HOME/.config/background" ]; then
        echo "🖼️  Restoring wallpaper..."
        awww img "$HOME/.config/background" --transition-type fade --transition-duration 1
    fi
fi

echo "✅ hyprpanel safely closed, awww-daemon preserved"
EOF

chmod +x "$HOME/.config/hyprcandy/hooks/kill_hyprpanel_safe.sh"

# ═══════════════════════════════════════════════════════════════
#             Hyprpanel Restart Script (via systemd)
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/restart_hyprpanel.sh" << 'EOF'
#!/bin/bash

echo "🔄 Restarting hyprpanel via systemd..."

systemctl --user stop hyprpanel.service
sleep 0.5
systemctl --user start hyprpanel.service

echo "✅ Hyprpanel restarted"
EOF

chmod +x "$HOME/.config/hyprcandy/hooks/restart_hyprpanel.sh"

# ═══════════════════════════════════════════════════════════════
#             Systemd Service: Hyprpanel Launcher
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/systemd/user/hyprpanel.service" << 'EOF'
[Unit]
Description=Hyprpanel - Modern Hyprland panel
After=graphical-session.target hyprland-session.target
Wants=graphical-session.target
PartOf=graphical-session.target
Requisite=graphical-session.target

[Service]
Type=simple
ExecStart=/usr/bin/hyprpanel
Restart=on-failure
RestartSec=6
KillMode=mixed
KillSignal=SIGTERM
TimeoutStopSec=10

# Don't restart if manually stopped (allows keybind control)
RestartPreventExitStatus=143

[Install]
WantedBy=graphical-session.target
EOF
fi

# ═══════════════════════════════════════════════════════════════
#      Script: Update Rofi Font from GTK Settings Font Name
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/update_rofi_font.sh" << 'EOF'
#!/bin/bash

GTK_FILE="$HOME/.config/gtk-3.0/settings.ini"
ROFI_RASI="$HOME/.config/hyprcandy/settings/rofi-font.rasi"

# Get font name from GTK settings
GTK_FONT=$(grep "^gtk-font-name=" "$GTK_FILE" | cut -d'=' -f2-)

# Escape double quotes
GTK_FONT_ESCAPED=$(echo "$GTK_FONT" | sed 's/"/\\"/g')

# Update font line in rofi rasi config
if [ -f "$ROFI_RASI" ]; then
    sed -i "s|^.*font:.*|configuration { font: \"$GTK_FONT_ESCAPED\"; }|" "$ROFI_RASI"
    echo "✅ Updated Rofi font to: $GTK_FONT_ESCAPED"
else
    echo "⚠️  Rofi font config not found at: $ROFI_RASI"
fi
EOF

chmod +x "$HOME/.config/hyprcandy/hooks/update_rofi_font.sh"

# ═══════════════════════════════════════════════════════════════
#                Sync GTK, QT and ROFI Icon Themes
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/update_icon_theme.sh" << 'EOF'
#!/bin/bash

GTK_FILE="$HOME/.config/gtk-3.0/settings.ini"
QT6CT_CONF="$HOME/.config/qt6ct/qt6ct.conf"
QT5CT_CONF="$HOME/.config/qt5ct/qt5ct.conf"
KDEGLOBALS="$HOME/.config/kdeglobals"
UC_COLORS="$HOME/.local/share/color-schemes/HyprCandy.colors"
ROFI_MENU="$HOME/.config/rofi/config.rasi"

ICON_THEME=$(grep "^gtk-icon-theme-name=" "$GTK_FILE" | cut -d'=' -f2- | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

if [ -z "$ICON_THEME" ]; then
    echo "⚠️  Could not read icon theme from $GTK_FILE"
    exit 1
fi

echo "🎨 Syncing icon theme: $ICON_THEME"

export QT_QPA_PLATFORMTHEME=qt6ct
export QT_ICON_THEME="$ICON_THEME"

# Keep user services and dbus-activated apps in sync with the new icon theme.
systemctl --user import-environment QT_QPA_PLATFORMTHEME QT_ICON_THEME 2>/dev/null || true
dbus-update-activation-environment --systemd QT_QPA_PLATFORMTHEME QT_ICON_THEME 2>/dev/null || true

for CONF in "$QT6CT_CONF" "$QT5CT_CONF"; do
    [ -f "$CONF" ] || continue
    if grep -q "^icon_theme=" "$CONF"; then
        sed -i "s|^icon_theme=.*|icon_theme=$ICON_THEME|" "$CONF"
    else
        sed -i "/^\[Appearance\]/a icon_theme=$ICON_THEME" "$CONF"
    fi
    echo "✅ $(basename $CONF) icon theme → $ICON_THEME"
done

for FILE in "$KDEGLOBALS" "$UC_COLORS"; do
    [ -f "$FILE" ] || continue
    if grep -q "^Theme=" "$FILE"; then
        sed -i "s|^Theme=.*|Theme=$ICON_THEME|" "$FILE"
    else
        sed -i "/^\[Icons\]/a Theme=$ICON_THEME" "$FILE"
    fi
    echo "✅ $(basename $FILE) icon theme → $ICON_THEME"
done

if [ -f "$ROFI_MENU" ]; then
    sed -i "16s|^.*|    icon-theme:                 \"$ICON_THEME\";|" "$ROFI_MENU"
    echo "✅ $(basename $ROFI_MENU) icon theme → $ICON_THEME"
fi

# Do not restart quickshell instances here.
# They hot-reload config; this hook only synchronizes theme config and env for new launches.
pkill -f "qs -c overview"

dbus-send --session --type=signal /kdeglobals \
    org.kde.kconfig.notify.ConfigChanged \
    'array:dict:string,variant:{"Icons":{"Theme":"'"$ICON_THEME"'"}}' 2>/dev/null || true

echo "✅ Icon theme synced to: $ICON_THEME"
EOF

chmod +x "$HOME/.config/hyprcandy/hooks/update_icon_theme.sh"

# ═══════════════════════════════════════════════════════════════
#      Watcher: React to GTK Font Changes via nwg-look
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/hyprcandy/hooks/watch_gtk_font.sh" << 'EOF'
#!/bin/bash

GTK_FILE="$HOME/.config/gtk-3.0/settings.ini"
FONT_HOOK="$HOME/.config/hyprcandy/hooks/update_rofi_font.sh"
ICON_HOOK="$HOME/.config/hyprcandy/hooks/update_icon_theme.sh"

while [ ! -f "$GTK_FILE" ]; do sleep 1; done

"$FONT_HOOK"
"$ICON_HOOK"

# Track previous values to avoid redundant hook calls
PREV_FONT=$(grep "^gtk-font-name=" "$GTK_FILE" | cut -d'=' -f2-)
PREV_ICON=$(grep "^gtk-icon-theme-name=" "$GTK_FILE" | cut -d'=' -f2-)

inotifywait -m -e modify "$GTK_FILE" | while read -r path event file; do
    CUR_FONT=$(grep "^gtk-font-name=" "$GTK_FILE" | cut -d'=' -f2-)
    CUR_ICON=$(grep "^gtk-icon-theme-name=" "$GTK_FILE" | cut -d'=' -f2-)

    if [ "$CUR_FONT" != "$PREV_FONT" ]; then
        "$FONT_HOOK"
        PREV_FONT="$CUR_FONT"
    fi

    if [ "$CUR_ICON" != "$PREV_ICON" ]; then
        "$ICON_HOOK"
        PREV_ICON="$CUR_ICON"
    fi
done
EOF

chmod +x "$HOME/.config/hyprcandy/hooks/watch_gtk_font.sh"

# ═══════════════════════════════════════════════════════════════
#      Systemd Service: GTK Font → Rofi Font Syncer
# ═══════════════════════════════════════════════════════════════

cat > "$HOME/.config/systemd/user/rofi-font-watcher.service" << 'EOF'
[Unit]
Description=Auto-update Rofi font when GTK font changes via nwg-look
After=graphical-session.target

[Service]
ExecStart=%h/.config/hyprcandy/hooks/watch_gtk_font.sh
Restart=on-failure

[Install]
WantedBy=default.target
EOF

# ═══════════════════════════════════════════════════════════════
#               		  Pinned Apps File 
# ═══════════════════════════════════════════════════════════════
PINNED_FILE="$HOME/.config/pinned"
if [ ! -f "$PINNED_FILE" ]; then
	cat > "$PINNED_FILE" << 'EOF'
org.gnome.Nautilus
io.github.timasoft.hyprviz
org.gnome.gedit
zen
kitty
nwg-displays
nwg-look
EOF

else
	echo ""
fi

# ═══════════════════════════════════════════════════════════════
#               		  	   XRAY
# ═══════════════════════════════════════════════════════════════
	cat > "$HOME/.config/hypr/scripts/xray.sh" << 'EOF'
#!/bin/bash
HYPR="$HOME/.config/hypr/hyprviz.conf"
XRAY="$HOME/.config/hyprcandy/settings/xray-on"
if [ ! -f "$XRAY" ]; then
    sed -i "s/xray = false/xray = true/" "$HYPR"
    sed -i "s/xray off/xray on/" "$HYPR"
    hyprctl reload
    touch "$XRAY"
else
    sed -i "s/xray = true/xray = false/" "$HYPR"
    sed -i "s/xray on/xray off/" "$HYPR"
    hyprctl reload
    rm "$XRAY"
fi
EOF

mkdir -p "$HOME/.config/wallpaper"
# ═══════════════════════════════════════════════════════════════
#               		  	WALLPAPER
# ═══════════════════════════════════════════════════════════════
	cat > "$HOME/.config/wallpaper/wallpaper.ini" << 'EOF'
[Settings]
wallpaper = ~/Pictures/Candy/Candy-Images/Wallpaper/brown-map5.webp
folder = ~/Pictures/Candy/Candy-Images/Wallpaper
monitors = All
fill = fill
sort = name
subfolders = True
show_hidden = False
awww_transition_type = any
awww_transition_step = 90
awww_transition_angle = 0
awww_transition_duration = 2
awww_transition_fps = 60
EOF

chmod +x "$HOME/.config/hypr/scripts/xray.sh"

# ═══════════════════════════════════════════════════════════════
#               		 POST SETUP CLEANUP
# ═══════════════════════════════════════════════════════════════
	cat > "$HOME/.config/hyprcandy/hooks/complete.sh" << 'EOF'
#!/bin/bash

bash -c "rm -rf ~/candyinstall ~/.hyprcandy/candyinstall"
pkill -f "floating-installer"
EOF

chmod +x "$HOME/.config/hyprcandy/hooks/complete.sh"

find "$HOME/.config/hyprcandy/hooks/" -name "*.sh" -exec chmod +x {} \;
find "$HOME/.config/hyprcandy/scripts/" -name "*.sh" -exec chmod +x {} \;
find "$HOME/.config/quickshell/bar/" -maxdepth 1 -name "*.sh" -exec chmod +x {} \;
find "$HOME/.config/quickshell/bar/scripts/" -name "*.sh" -exec chmod +x {} \;
find "$HOME/.config/waybar/scripts/" -name "*.sh" -exec chmod +x {} \;
find "$HOME/.hyprcandy/GJS/hyprcandydock/" -name "*.sh" -exec chmod +x {} \;
chmod +x "$HOME/.config/quickshell/candylock/auth.sh"
chmod +x "$HOME/.config/quickshell/wallpaper/wallpaper-apply.sh"
chmod +x "$HOME/.config/quickshell/wallpaper/wallpaper-cycle.sh"
mkdir -p "$HOME/.cache/quickshell/overview"
mkdir -p "$HOME/.cache/quickshell/wallpaper"

    # 🛠️ GNOME Window Button Layout Adjustment
    echo
    echo "🛠️ Disabling GNOME titlebar buttons..."

    # Check if 'gsettings' is available on the system
    if command -v gsettings >/dev/null 2>&1; then
        # Run the command to change the window button layout (e.g., remove minimize/maximize buttons)
        gsettings set org.gnome.desktop.wm.preferences button-layout ":close" \
            && echo "✅ GNOME button layout updated." \
            || echo "❌ Failed to update GNOME button layout."
    else
        echo "⚠️  'gsettings' not found. Skipping GNOME button layout configuration."
    fi
    
    # 📁 Copy Candy folder to ~/Pictures
    echo
    echo "📁 Attempting to copy 'Candy' images folder to ~/Pictures..."
    if [ -d "$hyprcandy_dir/Candy" ]; then
        if [ -d "$HOME/Pictures" ]; then
            cp -r "$hyprcandy_dir/Candy" "$HOME/Pictures/"
            echo "✅ 'Candy' copied successfully to ~/Pictures"
        else
            echo "⚠️  Skipped copy: '$HOME/Pictures' directory does not exist."
        fi
    else
        echo "⚠️  'Candy' folder not found in $hyprcandy_dir"
    fi

    # 🔐 Add sudoers entry for background script
    echo "🔄 Adding sddm background auto-update settings..."
    sudo rm -f /etc/sudoers.d/hyprcandy-background
    # Get the current username
USERNAME=$(whoami)

# Create the sudoers entries for background script and required commands
SUDOERS_ENTRIES=(
    "$USERNAME ALL=(ALL) NOPASSWD: /usr/bin/cp -r /home/$USERNAME/.icons/* /usr/share/icons/"
	"$USERNAME ALL=(ALL) NOPASSWD: /usr/bin/magick * /usr/share/sddm/themes/sugar-candy/Backgrounds/*"
    "$USERNAME ALL=(ALL) NOPASSWD: /usr/bin/sed -i s|^Background=*|* /usr/share/sddm/themes/sugar-candy/theme.conf"
    "$USERNAME ALL=(ALL) NOPASSWD: /usr/bin/sed -i s|^BackgroundColor=*|* /usr/share/sddm/themes/sugar-candy/theme.conf"
    "$USERNAME ALL=(ALL) NOPASSWD: /usr/bin/sed -i s|^AccentColor=*|* /usr/share/sddm/themes/sugar-candy/theme.conf"
    "$USERNAME ALL=(ALL) NOPASSWD: /usr/bin/tee /usr/share/sddm/themes/sugar-candy/theme.conf"
    "$USERNAME ALL=(ALL) NOPASSWD: /usr/bin/sed -i s|^CursorTheme=*|* /etc/sddm.conf.d/sugar-candy.conf"
    "$USERNAME ALL=(ALL) NOPASSWD: /usr/bin/sed -i s|^CursorSize=*|* /etc/sddm.conf.d/sugar-candy.conf"
    "$USERNAME ALL=(ALL) NOPASSWD: /usr/bin/mkdir -p /usr/local/share/gtk3-reload"
    "$USERNAME ALL=(ALL) NOPASSWD: /usr/bin/tee /usr/local/share/gtk3-reload/gtk3-reload.c"
    "$USERNAME ALL=(ALL) NOPASSWD: /usr/bin/tee /usr/local/share/gtk3-reload/.gtk3-version"
    "$USERNAME ALL=(ALL) NOPASSWD: /usr/bin/gcc * /usr/local/lib/gtk3-reload.so"
    "$USERNAME ALL=(ALL) NOPASSWD: /usr/bin/gcc -shared -fPIC -o /usr/local/lib/gtk3-reload.so /usr/local/share/gtk3-reload/gtk3-reload.c *"
    "$USERNAME ALL=(ALL) NOPASSWD: /usr/bin/dconf update"
    # GPU monitoring permissions for system monitor widget
    "$USERNAME ALL=(ALL) NOPASSWD: /bin/cat /sys/class/drm/card*/device/gpu_busy_percent"
    "$USERNAME ALL=(ALL) NOPASSWD: /bin/cat /sys/class/drm/card*/device/hwmon/hwmon*/temp*_input"
    "$USERNAME ALL=(ALL) NOPASSWD: /bin/cat /sys/class/drm/card*/device/mem_info_vram_total"
    "$USERNAME ALL=(ALL) NOPASSWD: /bin/cat /sys/class/drm/card*/device/mem_info_vram_used"
    "$USERNAME ALL=(ALL) NOPASSWD: /bin/cat /sys/class/drm/card*/device/mem_info_gtt_total"
    "$USERNAME ALL=(ALL) NOPASSWD: /bin/cat /sys/class/drm/card*/device/mem_info_gtt_used"
    "$USERNAME ALL=(ALL) NOPASSWD: /bin/cat /sys/class/drm/card*/device/product_name"
    "$USERNAME ALL=(ALL) NOPASSWD: /bin/cat /sys/class/drm/card*/device/address"
    "$USERNAME ALL=(ALL) NOPASSWD: /usr/bin/readlink -f /sys/class/drm/card*/device/driver"
	"$USERNAME ALL=(ALL) NOPASSWD: /usr/bin/sed -i s|^HeaderText=*|* /usr/share/sddm/themes/sugar-candy/theme.conf"
	"$USERNAME ALL=(ALL) NOPASSWD: /usr/bin/sed -i s|^FormPosition=*|* /usr/share/sddm/themes/sugar-candy/theme.conf"
	"$USERNAME ALL=(ALL) NOPASSWD: /usr/bin/sed -i s|^BlurRadius=*|* /usr/share/sddm/themes/sugar-candy/theme.conf"
	"$USERNAME ALL=(ALL) NOPASSWD: /usr/bin/chmod 644 /usr/share/sddm/themes/sugar-candy/Backgrounds/*"
)

# Add all entries to sudoers safely using visudo
printf '%s\n' "${SUDOERS_ENTRIES[@]}" | sudo EDITOR='tee -a' visudo -f /etc/sudoers.d/hyprcandy-background > /dev/null 2>&1

# Set proper permissions on the sudoers file
sudo chmod 440 /etc/sudoers.d/hyprcandy-background > /dev/null 2>&1

    echo "✅ Added sddm background auto-update settings successfully"
	
# Add custom cursors to /usr/share/icons 
echo "🔄 Adding custom cursors..."
sudo cp -r "$HOME"/.icons/* /usr/share/icons/
echo "✅ Cursors updated."
}

# Function to enable display manager and prompt for reboot
enable_display_manager() {
    print_status "Enabling $DISPLAY_MANAGER display manager..."
    
    # Disable other display managers first
    print_status "Disabling other display managers..."
    sudo systemctl disable lightdm 2>/dev/null || true
    sudo systemctl disable lxdm 2>/dev/null || true
    if [ "$DISPLAY_MANAGER" != "sddm" ]; then
        sudo systemctl disable sddm 2>/dev/null || true
    fi
    if [ "$DISPLAY_MANAGER" != "gdm" ]; then
        sudo systemctl disable gdm 2>/dev/null || true
    fi
    
    # Enable the selected display manager
    if sudo systemctl enable "$DISPLAY_MANAGER_SERVICE"; then
        print_success "$DISPLAY_MANAGER has been enabled successfully!"
    else
        print_error "Failed to enable $DISPLAY_MANAGER. You may need to enable it manually."
        print_status "Run: sudo systemctl enable $DISPLAY_MANAGER_SERVICE"
    fi
    
    # Additional SDDM configuration if selected
    if [ "$DISPLAY_MANAGER" = "sddm" ]; then
        print_status "Configuring SDDM with Sugar Candy theme..."
        
        sudo rm -rf /etc/sddm.conf.d/
        sleep 1
        # Create SDDM config directory if it doesn't exist
        sudo mkdir -p /etc/sddm.conf.d/
        
        # Configure SDDM to use Sugar Candy theme
        if [ -d "/usr/share/sddm/themes/sugar-candy" ]; then
            sudo tee /etc/sddm.conf.d/sugar-candy.conf > /dev/null << EOF
[Theme]
Current=sugar-candy
CursorTheme=Bibata-Modern-Classic
CursorSize=18
EOF
            # Write full theme config to the sugar-candy theme directory
            sudo tee /usr/share/sddm/themes/sugar-candy/theme.conf > /dev/null << EOF
[General]
Background="Backgrounds/Mountain.png"
DimBackgroundImage="0.0"
ScaleImageCropped="true"
ScreenWidth="1366"
ScreenHeight="768"
FullBlur="false"
PartialBlur="true"
BlurRadius="55"
HaveFormBackground="true"
FormPosition="center"
BackgroundImageHAlignment="center"
BackgroundImageVAlignment="center"
MainColor="white"
AccentColor="#fb884f"
BackgroundColor="#243900"
OverrideLoginButtonTextColor=""
InterfaceShadowSize="6"
InterfaceShadowOpacity="0.6"
RoundCorners="20"
ScreenPadding="0"
Font="Noto Sans"
FontSize=""
ForceRightToLeft="false"
ForceLastUser="true"
ForcePasswordFocus="true"
ForceHideCompletePassword="false"
ForceHideVirtualKeyboardButton="false"
ForceHideSystemButtons="false"
AllowEmptyPassword="false"
AllowBadUsernames="false"
Locale=""
HourFormat="HH:mm"
DateFormat="dddd, d of MMMM"
HeaderText="󰫣 󰫣 󰫣"
TranslatePlaceholderUsername=""
TranslatePlaceholderPassword=""
TranslateShowPassword=""
TranslateLogin=""
TranslateLoginFailedWarning=""
TranslateCapslockWarning=""
TranslateSession=""
TranslateSuspend=""
TranslateHibernate=""
TranslateReboot=""
TranslateShutdown=""
TranslateVirtualKeyboardButton=""
EOF
            # ── Patch sugar-candy Main.qml for AnimatedImage gif support (once) ──────────
            MAIN_QML="/usr/share/sddm/themes/sugar-candy/Main.qml"

            if [[ -f "$MAIN_QML" ]]; then
                if grep -q "^\s*Image {" "$MAIN_QML"; then
                    sudo sed -i 's/^\(\s*\)Image {/\1AnimatedImage {/' "$MAIN_QML"
                    sudo sed -i '/id: backgroundImage/a\            playing: true' "$MAIN_QML"
                    echo "🎬 Patched Main.qml with AnimatedImage support"
                else
                    echo "✅ Main.qml already patched"
                fi
            fi

            print_success "SDDM configured to use Sugar Candy theme with custom auto-updating background"
        else
            print_warning "Sugar Candy theme not found. SDDM will use default theme."
        fi
    fi
}

# Function to setup default "custom.conf" file
setup_custom_config() {
# Create the custom settings directory and files if it doesn't already exist
        if [ ! -d "$HOME/.config/hyprcustom" ]; then
            mkdir -p "$HOME/.config/hyprcustom" && touch "$HOME/.config/hypr/hyprviz.conf" && touch "$HOME/.config/hyprcustom/custom_lock.conf"
            echo "📁 Created the custom settings directory with 'custom.conf' and 'custom_lock.conf' files to keep your personal Hyprland and Hyprlock changes safe ..."
          if [ "$PANEL_CHOICE" = "waybar" ]; then
 # Add default content to the custom.conf file
            cat > "$HOME/.config/hypr/hyprviz.conf" << 'EOF'
#  ██████╗ █████╗ ███╗   ██╗██████╗ ██╗   ██╗
# ██╔════╝██╔══██╗████╗  ██║██╔══██╗╚██╗ ██╔╝
# ██║     ███████║██╔██╗ ██║██║  ██║ ╚████╔╝ 
# ██║     ██╔══██║██║╚██╗██║██║  ██║  ╚██╔╝  
# ╚██████╗██║  ██║██║ ╚████║██████╔╝   ██║   
#  ╚═════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝    ╚═╝   

#[IMPORTANT]#
# Add custom settings to "$HOME/.config/custom/custom.conf".
#[IMPORTANT]#

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                           Autostart                         ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

# Environment must be first — everything else depends on these
exec-once = systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE
exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=hyprland DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY

# Portals next — before any app or service that might need them
exec-once = bash ~/.config/hypr/scripts/xdg.sh

# Theme
exec-once = gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark'
exec-once = gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

# System Services
exec-once = systemctl --user start hyprpolkitagent
exec-once = systemctl --user start rofi-font-watcher
exec-once = systemctl --user start cursor-theme-watcher

# Daemons
#exec-once = ~/.config/waybar/scripts/manager.sh
exec-once = gjs ~/.hyprcandy/GJS/candy-daemon.js
exec-once = gjs ~/.hyprcandy/GJS/hyprcandydock/daemon.js
exec-once = bash ~/.config/hypr/scripts/wallpaper-restore.sh
exec-once = hypridle
exec-once = /usr/bin/pypr

# UI — after daemons are up
# Dock
exec-once = ~/.hyprcandy/GJS/hyprcandydock/autostart.sh
# Bar
exec-once = qs -c bar
# Overview
exec-once = qs -c overview

# Clipboard
exec-once = wl-paste --watch cliphist store

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                           Animations                        ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

source = ~/.config/hypr/conf/animations/LimeFrenzy.conf

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                        Hypraland-colors                     ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

source = ~/.config/hypr/colors.conf

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                         Env-variables                       ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

# Packages to have full env path access
env = PATH,$PATH:/usr/local/bin:/usr/bin:/bin:/home/$USERNAME/.cargo/bin

# After using nwg-look, also change the cursor settings here to maintain changes after every reboot
env = XCURSOR_THEME,Marci-Crystal
env = XCURSOR_SIZE,18
env = HYPRCURSOR_THEME,Marci-Crystal
env = HYPRCURSOR_SIZE,18
# GTK
env =  GTK_THEME,adw-gtk3-dark
# XDG Desktop Portal
env = XDG_CURRENT_DESKTOP,Hyprland
env = XDG_SESSION_TYPE,wayland
env = XDG_SESSION_DESKTOP,Hyprland
# QT
env = QT_QPA_PLATFORM,wayland
env = QT_QPA_PLATFORMTHEME,qt6ct
env = QT_WAYLAND_DISABLE_WINDOWDECORATION,0
env = QT_AUTO_SCREEN_SCALE_FACTOR,1
# GDK
env = GDK_DEBUG,portals
env = GDK_SCALE,1
# Toolkit Backend
env = GDK_BACKEND,wayland
env = CLUTTER_BACKEND,wayland
# Mozilla
env = MOZ_ENABLE_WAYLAND,1
# Ozone
env = OZONE_PLATFORM,wayland
env = ELECTRON_OZONE_PLATFORM_HINT,wayland
# Extra
env = WINIT_UNIX_BACKEND,wayland
# Virtual machine display scaling
env = QT_SCALE_FACTOR_ROUNDING_POLICY=PassThrough
# For better VM performance
env = QEMU_AUDIO_DRV=pa

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                           Keyboard                          ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

input {
    kb_layout = $LAYOUT
    kb_variant = 
    kb_model =
    kb_options =
    numlock_by_default = true
    mouse_refocus = false

    follow_mouse = 1
    touchpad {
        # for desktop
        natural_scroll = false

        # for laptop
        # natural_scroll = yes
        # middle_button_emulation = true
        # clickfinger_behavior = false
        scroll_factor = 1.0  # Touchpad scroll factor
    }
    sensitivity = 0 # Pointer speed: -1.0 - 1.0, 0 means no modification.
}

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                             Layout                          ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

general {
    gaps_in = 4
    gaps_out = 9	
    gaps_workspaces = 50    # Gaps between workspaces
    border_size = 3
    col.active_border = $inverse_primary
    col.inactive_border = $background
    layout = scrolling
    resize_on_border = true
    allow_tearing = false
}

group {
    col.border_active =  $source_color
    col.border_inactive = $background
    col.border_locked_active =  $primary_fixed_dim
    col.border_locked_inactive = $background
    
    groupbar {
        font_size = 14
        font_weight_active = heavy
        font_weight_inactive = heavy
        text_color = $surface_tint
        col.active =  $primary_fixed_dim
        col.inactive = $background
        col.locked_active =  $primary_fixed_dim
        col.locked_inactive = $background
        indicator_height = 4
        indicator_gap = 6
    
        # Additional styling options
        height = 10          # Height of the groupbar
        render_titles = true           # Show window titles
        scrolling = true              # Enable scrolling through titles
        
        # Gradients work too (like hyprbars)
        # col.active = $source_color $primary_fixed_dim 45deg
    }
}

dwindle {
    pseudotile = true
    preserve_split = true
}

master {
    new_status = slave
    new_on_active = after
    smart_resizing = true
    drop_at_cursor = true
}

scrolling {
    direction = right
    focus_fit_method = 0
    column_width = 0.5
}

gesture = 3, horizontal, workspace
gesture = 4, swipe, move,
gesture = 2, pinch, float
gestures {
    workspace_swipe_distance = 700
    workspace_swipe_cancel_ratio = 0.2
    workspace_swipe_min_speed_to_force = 5
    workspace_swipe_direction_lock = true
    workspace_swipe_direction_lock_threshold = 10
    workspace_swipe_create_new = true
}

binds {
  workspace_back_and_forth = true
  allow_workspace_cycles = true
  pass_mouse_when_bound = false
}

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                          Decorations                        ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

decoration {
    rounding = 15
    rounding_power = 2
    active_opacity = 0.85
    inactive_opacity = 0.85
    fullscreen_opacity = 1.0

    blur {
    enabled = true
    size = 2
    passes = 4
    new_optimizations = on
    ignore_opacity = true
        xray = false
        vibrancy = 0.24999999999999933
        noise = 0
    popups = true
    popups_ignorealpha = 0.8
        brightness = 1.0000000000000002
        contrast = 0.9999999999999997
        special = false
        vibrancy_darkness = 0.5000000000000002
    }

    shadow {
        enabled = true
        range = 12
        render_power = 4
        color = $scrim
    }
    dim_strength = 0.19999999999999973
    dim_inactive = false
}

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                          Decorations                        ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

decoration {
    rounding = 15
    rounding_power = 2
    active_opacity = 0.8499999999999999
    inactive_opacity = 0.8499999999999999
    fullscreen_opacity = 1.0

    blur {
    enabled = true
    size = 2
    passes = 4
    new_optimizations = on
    ignore_opacity = true
        xray = true
        vibrancy = 0.24999999999999933
        noise = 0
    popups = true
    popups_ignorealpha = 0.8
        brightness = 1.0000000000000002
        contrast = 0.9999999999999997
        special = false
        vibrancy_darkness = 0.5000000000000002
    }

    shadow {
        enabled = true
        range = 12
        render_power = 4
        color = $scrim
    }
    dim_strength = 0.19999999999999973
    dim_inactive = false
}

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                      Window & layer rules                   ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

windowrule = group barred, match:class .*
windowrule = pin on,border_size 0,match:class (com.candy.widgets|gjs|widgets)
windowrule = move ((monitor_w*0.5)-(window_w*0.5)) 45,match:title (candy.utils)#center
windowrule = move ((monitor_w*1)-((window_w*1)+10)) 45,match:title (candy.systemmonitor) #top right
windowrule = move ((monitor_w*0.5)-(window_w*0.5)) 45,match:title (candy.weather) #center
windowrule = move (monitor_w*0.01) 45,match:title (candy.media) #top left
windowrule = opacity 0.85 0.85,match:class ^(kitty|kitty-scratchpad|Alacritty|floating-installer|clock)$
windowrule = float on, center on,size 800 500,match:class (kitty-scratchpad)
windowrule = suppress_event maximize, match:class .* #nofocus,match:class ^$,match:title ^$,xwayland:1,floating:1,fullscreen:0,pinned:0
# Pavucontrol floating
windowrule = float on,match:class (.*org.pulseaudio.pavucontrol.*)
windowrule = size 700 600,match:class (.*org.pulseaudio.pavucontrol.*)
windowrule = center on,match:class (.*org.pulseaudio.pavucontrol.*)
#windowrule = pin on,match:class (.*org.pulseaudio.pavucontrol.*)
# Browser Picture in Picture
windowrule = float on, match:title ^(Picture-in-Picture)$
windowrule = pin on, match:title ^(Picture-in-Picture)$
windowrule = move 69.5% 4%, match:title ^(Picture-in-Picture)$
# Waypaper
windowrule = float on,match:class (.*waypaper.*)
windowrule = size 800 600,match:class (.*waypaper.*)
windowrule = center on,match:class (.*waypaper.*)
#windowrule = pin on,match:class (.*waypaper.*)
# Blueman Manager
windowrule = float on,match:class (blueman-manager)
windowrule = size 800 600,match:class (blueman-manager)
windowrule = center on,match:class (blueman-manager)
# Weather
windowrule = float on,match:class (org.gnome.Weather)
windowrule = size 700 600,match:class (org.gnome.Weather)
windowrule = center on,match:class (org.gnome.Weather)
#windowrule = pin on,match:class (org.gnome.Weather)
# Calendar
windowrule = float on,match:class (org.gnome.Calendar)
windowrule = size 820 600,match:class (org.gnome.Calendar)
windowrule = center on,match:class (org.gnome.Calendar)
#windowrule = pin on,match:class (org.gnome.Calendar)
# System Monitor
windowrule = float on,match:class (org.gnome.SystemMonitor)
windowrule = size 820 625,match:class (org.gnome.SystemMonitor)
windowrule = center on,match:class (org.gnome.SystemMonitor)
#windowrule = pin on,match:class (org.gnome.SystemMonitor)
# Files
windowrule = float on,match:title (Open Files)
windowrule = size 700 600,match:title (Open Files)
windowrule = center on,match:title (Open Files)
#windowrule = pin on,match:title (Open Files)

windowrule = float on,match:title (Select Copy Destination)
windowrule = size 700 600,match:title (Select Copy Destination)
windowrule = center on,match:title (Select Copy Destination)
#windowrule = pin on,match:title (Select Copy Destination)

windowrule = float on,match:title (Select Move Destination)
windowrule = size 700 600,match:title (Select Move Destination)
windowrule = center on,match:title (Select Move Destination)
#windowrule = pin on,match:title (Select Move Destination)

windowrule = float on,match:title (Save As)
windowrule = size 700 600,match:title (Save As)
windowrule = center on,match:title (Save As)
#windowrule = pin on,match:title (Save As)

windowrule = float on,match:title (Select files to send)
windowrule = size 700 600,match:title (Select files to send)
windowrule = center on,match:title (Select files to send)
#windowrule = pin on,match:title (Select files to send)

windowrule = float on,match:title (Bluetooth File Transfer)
#windowrule = pin on,match:title (Bluetooth File Transfer)
# nwg-look
windowrule = float on,match:class (nwg-look)
windowrule = size 700 600,match:class (nwg-look)
windowrule = center on,match:class (nwg-look)
#windowrule = pin on,match:class (nwg-look)
# CachyOS Hello
windowrule = float on,match:title (CachyOS Hello)
windowrule = size 700 600,match:title (CachyO SHello)
windowrule = center on,match:title (CachyOS Hello)
#windowrule = pin on,match:class (CachyOSHello)
# nwg-displays
windowrule = float on,match:class (nwg-displays)
windowrule = size 990 600,match:class (nwg-displays)
windowrule = center on,match:class (nwg-displays)
#windowrule = pin on,match:class (nwg-displays)
# System Mission Center
windowrule = float on, match:class (io.missioncenter.MissionCenter)
#windowrule = pin on, match:class (io.missioncenter.MissionCenter)
windowrule = center on, match:class (io.missioncenter.MissionCenter)
windowrule = size 900 600, match:class (io.missioncenter.MissionCenter)
# System Mission Center Preference Window
windowrule = float on, match:class (missioncenter), match:title ^(Preferences)$
#windowrule = pin on, match:class (missioncenter), match:title ^(Preferences)$
windowrule = center on, match:class (missioncenter), match:title ^(Preferences)$
# Gnome Calculator
windowrule = float on,match:class (org.gnome.Calculator)
windowrule = size 700 600,match:class (org.gnome.Calculator)
windowrule = center on,match:class (org.gnome.Calculator)
# Emoji Picker Smile
windowrule = float on,match:class (it.mijorus.smile)
#windowrule = pin on, match:class (it.mijorus.smile)
windowrule = move 100%-w-40 90,match:class (it.mijorus.smile)
# Hyprland Share Picker
windowrule = float on, match:class (hyprland-share-picker)
#windowrule = pin on, match:class (hyprland-share-picker)
windowrule = center on, match:title match:class (hyprland-share-picker)
windowrule = size 600 400,match:class (hyprland-share-picker)
# Hyprland Settings App
windowrule = float on,match:title (hyprviz)
windowrule = size 1000 625,match:title (hyprviz)
windowrule = center on,match:title (hyprviz)
# General floating
windowrule = float on,match:class (dotfiles-floating)
windowrule = size 1000 700,match:class (dotfiles-floating)
windowrule = center on,match:class (dotfiles-floating)
# Satty
windowrule = float on,match:title (satty)
windowrule = size 1000 565,match:title (satty)
windowrule = center on,match:title (satty)
# Float Necessary Windows
windowrule = float on, match:class ^(org.pulseaudio.pavucontrol)
windowrule = float on, match:class ^()$,match:title ^(Picture in picture)$
windowrule = float on, match:class ^()$,match:title ^(Save File)$
windowrule = float on, match:class ^()$,match:title ^(Open File)$
windowrule = float on, match:class ^(LibreWolf)$,match:title ^(Picture-in-Picture)$
##windowrule = float on, match:class ^(blueman-manager)$
windowrule = float on, match:class ^(xdg-desktop-portal-hyprland|xdg-desktop-portal-gtk|xdg-desktop-portal-kde)(.*)$
windowrule = float on, match:class ^(hyprpolkitagent|polkit-gnome-authentication-agent-1|org.org.kde.polkit-kde-authentication-agent-1)(.*)$
windowrule = float on, match:title ^(CachyOS Hello)$
windowrule = float on, match:class ^(zenity)$
windowrule = float on, match:class ^()$,match:title ^(Steam - Self Updater)$
# Increase the opacity
windowrule = opacity 1.0, match:class ^(zen)$
# # windowrule = opacity 1.0, match:class ^(discord|armcord|webcord)$
# # windowrule = opacity 1.0, match:title ^(QQ|Telegram)$
# # windowrule = opacity 1.0, match:title ^(NetEase Cloud Music Gtk4)$
# General window rules
windowrule = float on, match:title ^(Picture-in-Picture)$
windowrule = size 460 260, match:title ^(Picture-in-Picture)$
windowrule = move 65%- 10%-, match:title ^(Picture-in-Picture)$
windowrule = float on, match:title ^(imv|mpv|danmufloat|termfloat|nemo|ncmpcpp)$
windowrule = move 25%-, match:title ^(imv|mpv|danmufloat|termfloat|nemo|ncmpcpp)$
windowrule = size 960 540, match:title ^(imv|mpv|danmufloat|termfloat|nemo|ncmpcpp)$
#windowrule = pin on, match:title ^(danmufloat)$
windowrule = rounding 5, match:title ^(danmufloat|termfloat)$
windowrule = animation slide right, match:class ^(kitty|Alacritty)$
#windowrule = no_blur on, match:class ^(org.mozilla.firefox)$
# Decorations related to floating windows on workspaces 1 to 10
##windowrule = bordersize 2, floating:1, onworkspace:w[fv1-10]
workspace = w[fv1-10], border_color c $source_color, float on #$on_primary_fixed_variant 90deg
##windowrule = rounding 8, floating:1, onworkspace:w[fv1-10]
# Decorations related to tiling windows on workspaces 1 to 10
##windowrule = bordersize 3, floating:0, onworkspace:f[1-10]
##windowrule = rounding 4, floating:0, onworkspace:f[1-10]
#windowrule = tile, match:title ^(Microsoft-edge)$
vwindowrule = tile, match:title ^(Brave-browser)$
#windowrule = tile, match:title ^(Chromium)$
windowrule = float on, match:title ^(pavucontrol)$
windowrule = float on, match:title ^(blueman-manager)$
windowrule = float on, match:title ^(nm-connection-editor)$
windowrule = float on, match:title ^(qalculate-gtk)$
# idleinhibit
windowrule = idle_inhibit fullscreen,match:class ([window]) # Available modes: none, always, focus, fullscreen
### no blur for specific classes
##windowrule = noblur,match:class ^(?!(nautilus|nwg-look|nwg-displays|zen))
## Windows Rules End #

windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(nautilus)$
windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(zen)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(Brave-browser)$
windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(code-oss)$
windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^([Cc]ode)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(code-url-handler)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(code-insiders-url-handler)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(org.kde.dolphin)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(org.kde.ark)$
windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(nwg-look)$
windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(qt5ct)$
windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(qt6ct)$
windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(kvantummanager)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(org.pulseaudio.pavucontrol)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(blueman-manager)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(nm-applet)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(nm-connection-editor)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(org.kde.polkit-kde-authentication-agent-1)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(polkit-gnome-authentication-agent-1)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(org.freedesktop.impl.portal.desktop.gtk)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(org.freedesktop.impl.portal.desktop.hyprland)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^([Ss]team)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(steamwebhelper)$
windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^([Ss]potify)$
windowrule = opacity 1.0 $& 1.0 $& 1,match:title ^(Spotify Free)$
windowrule = opacity 1.0 $& 1.0 $& 1,match:title ^(Spotify Premium)$
# # 
# # windowrule = opacity 1.0 1.0,match:class ^(com.github.rafostar.Clapper)$ # Clapper-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(com.github.tchx84.Flatseal)$ # Flatseal-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(hu.kramo.Cartridges)$ # Cartridges-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(com.obsproject.Studio)$ # Obs-Qt
# # windowrule = opacity 1.0 1.0,match:class ^(gnome-boxes)$ # Boxes-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(vesktop)$ # Vesktop
# # windowrule = opacity 1.0 1.0,match:class ^(discord)$ # Discord-Electron
# # windowrule = opacity 1.0 1.0,match:class ^(WebCord)$ # WebCord-Electron
# # windowrule = opacity 1.0 1.0,match:class ^(ArmCord)$ # ArmCord-Electron
# # windowrule = opacity 1.0 1.0,match:class ^(app.drey.Warp)$ # Warp-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(net.davidotek.pupgui2)$ # ProtonUp-Qt
# # windowrule = opacity 1.0 1.0,match:class ^(yad)$ # Protontricks-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(Signal)$ # Signal-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(io.github.alainm23.planify)$ # planify-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(io.gitlab.theevilskeleton.Upscaler)$ # Upscaler-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(com.github.unrud.VideoDownloader)$ # VideoDownloader-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(io.gitlab.adhami3310.Impression)$ # Impression-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(io.missioncenter.MissionCenter)$ # MissionCenter-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(io.github.flattool.Warehouse)$ # Warehouse-Gtk
windowrule = float on,match:class ^(org.kde.dolphin)$,match:title ^(Progress Dialog — Dolphin)$
windowrule = float on,match:class ^(org.kde.dolphin)$,match:title ^(Copying — Dolphin)$
windowrule = float on,match:title ^(About Mozilla Firefox)$
windowrule = float on,match:class ^(firefox)$,match:title ^(Picture-in-Picture)$
windowrule = float on,match:class ^(firefox)$,match:title ^(Library)$
windowrule = float on,match:class ^(kitty)$,match:title ^(top)$
windowrule = float on,match:class ^(kitty)$,match:title ^(btop)$
windowrule = float on,match:class ^(kitty)$,match:title ^(htop)$
windowrule = float on,match:class ^(eww-main-window)$
windowrule = float on,match:class ^(eww-notifications)$
windowrule = float on,match:class ^(kvantummanager)$
windowrule = float on,match:class ^(qt5ct)$
windowrule = float on,match:class ^(qt6ct)$
windowrule = float on,match:class ^(nwg-look)$
windowrule = float on,match:class ^(org.kde.ark)$
windowrule = float on,match:class ^(org.pulseaudio.pavucontrol)$
windowrule = float on,match:class ^(blueman-manager)$
windowrule = float on,match:class ^(nm-applet)$
windowrule = float on,match:class ^(nm-connection-editor)$
windowrule = float on,match:class ^(org.kde.polkit-kde-authentication-agent-1)$

windowrule = float on,match:class ^(Signal)$ # Signal-Gtk
windowrule = float on,match:class ^(com.github.rafostar.Clapper)$ # Clapper-Gtk
windowrule = float on,match:class ^(app.drey.Warp)$ # Warp-Gtk
windowrule = float on,match:class ^(net.davidotek.pupgui2)$ # ProtonUp-Qt
windowrule = float on,match:class ^(yad)$ # Protontricks-Gtk
windowrule = float on,match:class ^(eog)$ # Imageviewer-Gtk
windowrule = float on,match:class ^(io.github.alainm23.planify)$ # planify-Gtk
windowrule = float on,match:class ^(io.gitlab.theevilskeleton.Upscaler)$ # Upscaler-Gtk
windowrule = float on,match:class ^(com.github.unrud.VideoDownloader)$ # VideoDownloader-Gkk
windowrule = float on,match:class ^(io.gitlab.adhami3310.Impression)$ # Impression-Gtk
windowrule = float on,match:class ^(io.missioncenter.MissionCenter)$ # MissionCenter-Gtk
windowrule = float on,match:class (clipse) # ensure you have a floating window class set if you want this behavior
windowrule = size 622 652,match:class (clipse) # set the size of the window as necessary
#windowrule = noborder, fullscreen:1

# common modals
#windowrule = float on,match:title ^(Open File)$
#windowrule = layer:top,match:class hyprpolkitagent
windowrule = float on,match:title ^(Choose Files)$
windowrule = float on,match:title ^(Save As)$
windowrule = float on,match:title ^(Confirm to replace files)$
windowrule = float on,match:title ^(File Operation Progress)$
windowrule = float on,match:class ^(xdg-desktop-portal-gtk)$

# installer
windowrule = float on, match:class (floating-installer)
windowrule = center on, match:class (floating-installer)

# clock
windowrule = float on, center on, size 400 200, match:class (clock)

# Extra workspace & window rules 
# Workspaces Rules https://wiki.hyprland.org/0.45.0/Configuring/Workspace-Rules/ #
# workspace = 1, default:true, monitor:$priMon
# workspace = 6, default:true, monitor:$secMon
# Workspace selectors https://wiki.hyprland.org/0.45.0/Configuring/Workspace-Rules/#workspace-selectors
# workspace = r[1-5], monitor:$priMon
# workspace = r[6-10], monitor:$secMon
# workspace = special:scratchpad, on-created-empty:$applauncher
# no_gaps_when_only deprecated instead workspaces rules with selectors can do the same
# Smart gaps from 0.45.0 https://wiki.hyprland.org/0.45.0/Configuring/Workspace-Rules/#smart-gaps
#workspace = w[t1], gapsout:0, gapsin:0
#workspace = w[tg1], gapsout:0, gapsin:0
workspace = f[1], gapsout:0, gapsin:0
#windowrule = bordersize 2, floating:0, onworkspace:w[t1]
#windowrule = rounding 10, floating:0, onworkspace:w[t1]
#windowrule = bordersize 2, floating:0, onworkspace:w[tg1]
#windowrule = rounding 10, floating:0, onworkspace:w[tg1]
#windowrule = bordersize 2, floating:0, onworkspace:f[1]
#windowrule = rounding 10, floating:0, onworkspace:f[1]
windowrule = rounding 0, fullscreen true, border_size 0
#workspace = w[tv1-10], gapsout:6, gapsin:2
#workspace = f[1], gapsout:6, gapsin:2

workspace = 1, layoutopt:orientation:left
workspace = 2, layoutopt:orientation:right
workspace = 3, layoutopt:orientation:left
workspace = 4, layoutopt:orientation:right
workspace = 5, layoutopt:orientation:left
workspace = 6, layoutopt:orientation:right
workspace = 7, layoutopt:orientation:left
workspace = 8, layoutopt:orientation:right
workspace = 9, layoutopt:orientation:left
workspace = 10, layoutopt:orientation:right
# Workspaces Rules End #

# Layers Rules #
layerrule = animation slide top, match:namespace logout_dialog
layerrule = blur on,xray on,no_anim on,match:namespace rofi
layerrule = ignore_alpha 0.01,match:namespace rofi
layerrule = blur on,match:namespace notifications
layerrule = ignore_alpha 0.01,match:namespace notifications
layerrule = blur on,match:namespace swaync-notification-window
layerrule = ignore_alpha 0.01,match:namespace swaync-notification-window
layerrule = blur on,xray on,no_anim on,match:namespace swaync-control-center
layerrule = ignore_alpha 0.01,match:namespace swaync-control-center
layerrule = blur on,xray on,no_anim on,match:namespace hyprcandy-dock
layerrule = ignore_alpha 0.01,match:namespace hyprcandy-dock
layerrule = blur on,xray on,no_anim on,match:namespace hyprcandy-launcher
layerrule = ignore_alpha 0.01,match:namespace hyprcandy-launcher
layerrule = blur on,match:namespace logout_dialog
layerrule = ignore_alpha 0.01,match:namespace logout_dialog
layerrule = blur on,match:namespace gtk-layer-shell
layerrule = ignore_alpha 0.01,match:namespace gtk-layer-shell
layerrule = blur on,no_anim on,match:namespace waybar
layerrule = ignore_alpha 0.01,match:namespace waybar
layerrule = blur on,match:namespace dashboardmenu
layerrule = ignore_alpha 0.01,match:namespace dashboardmenu
layerrule = blur on,no_anim on,match:namespace quickshell
layerrule = ignore_alpha 0.01,match:namespace quickshell
layerrule = blur on,xray on,no_anim on,match:namespace quickshell:overview
layerrule = ignore_alpha 0.01,match:namespace quickshell:overview
layerrule = blur on,xray on,no_anim on,match:namespace quickshell:weather-popup
layerrule = ignore_alpha 0.01,match:namespace quickshell:weather-popup
layerrule = blur on,xray on,no_anim on,match:namespace quickshell:sysmon-popup
layerrule = ignore_alpha 0.01,match:namespace quickshell:sysmon-popup
layerrule = blur on,xray on,no_anim on,match:namespace quickshell:wallpaper
layerrule = ignore_alpha 0.01,match:namespace quickshell:wallpaper
layerrule = blur on,xray on,no_anim on,match:namespace quickshell:startmenu
layerrule = ignore_alpha 0.01,match:namespace quickshell:startmenu
layerrule = blur on,xray on,no_anim on,match:namespace quickshell-controlcenter
layerrule = ignore_alpha 0.01,match:namespace quickshell-controlcenter
layerrule = blur on,xray on,no_anim on,match:namespace quickshell:notifications:toasts
layerrule = ignore_alpha 0.01,match:namespace quickshell:notifications:toasts
layerrule = blur on,xray on,no_anim on,match:namespace quickshell:notifications:history
layerrule = ignore_alpha 0.01,match:namespace quickshell:notifications:history
layerrule = blur on,match:namespace notificationsmenu
layerrule = ignore_alpha 0.01,match:namespace notificationsmenu
layerrule = blur on,match:namespace networkmenu
layerrule = ignore_alpha 0.01,match:namespace networkmenu
layerrule = blur on,match:namespace mediamenu
layerrule = ignore_alpha 0.01,match:namespace mediamenu
layerrule = blur on,match:namespace energymenu
layerrule = ignore_alpha 0.01,match:namespace energymenu
layerrule = blur on,match:namespace bluetoothmenu
layerrule = ignore_alpha 0.01,match:namespace bluetoothmenu
layerrule = blur on,match:namespace audiomenu
layerrule = ignore_alpha 0.01,match:namespace audiomenu
layerrule = blur on,match:namespace hyprmenu
layerrule = ignore_alpha 0.01,match:namespace hyprmenu
# layerrule = animation popin 50%, waybar
# Layers Rules End #

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                         Misc-settings                       ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

misc {
    disable_hyprland_logo = true
    disable_splash_rendering = false
    initial_workspace_tracking = 1
}

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                           Userprefs                         ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
# [NOTE!!] Add you personal settings from here and incase of an update copy them to the new file once this is changed to a backup

debug {
    suppress_errors = true
}

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                            Plugins                          ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

EOF

else  

            # Add default content to the custom.conf file
            cat > "$HOME/.config/hypr/hyprviz.conf" << 'EOF'
# ██████╗ █████╗ ███╗   ██╗██████╗ ██╗   ██╗
#██╔════╝██╔══██╗████╗  ██║██╔══██╗╚██╗ ██╔╝
#██║     ███████║██╔██╗ ██║██║  ██║ ╚████╔╝ 
#██║     ██╔══██║██║╚██╗██║██║  ██║  ╚██╔╝  
#╚██████╗██║  ██║██║ ╚████║██████╔╝   ██║   
# ╚═════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝    ╚═╝   

#[IMPORTANT]#
# Add custom settings at the very end of the file.
# This "hypr" folder is backed up on updates so you can copy you "userprefs" from the hyprviz.conf backup to the new file
#[IMPORTANT]#

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                           Autostart                         ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

# Environment must be first — everything else depends on these
exec-once = systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE
exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=hyprland DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY

# Portals next — before any app or service that might need them
exec-once = bash ~/.config/hypr/scripts/xdg.sh

# Theme
exec-once = gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark'
exec-once = gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

# System services
exec-once = systemctl --user start hyprpolkitagent
exec-once = systemctl --user start hyprpanel-idle-monitor
exec-once = systemctl --user start rofi-font-watcher
exec-once = systemctl --user start cursor-theme-watcher

# Daemons
exec-once = hypridle
exec-once = /usr/bin/pypr

# UI — after daemons are up
exec-once = systemctl --user start hyprpanel
exec-once = bash ~/.config/hyprcandy/hooks/startup_services.sh
exec-once = bash ~/.config/hyprcandy/scripts/toggle-dock.sh --login

# Wallpaper
exec-once = bash ~/.config/hypr/scripts/wallpaper-restore.sh
exec-once = systemctl --user start background-watcher

# Clipboard
exec-once = wl-paste --watch cliphist store

# Overview
env = QS_NO_RELOAD_POPUP,1
exec-once = qs -c overview

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                           Animations                        ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

source = ~/.config/hypr/conf/animations/LimeFrenzy.conf

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                        Hypraland-colors                     ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

source = ~/.config/hypr/colors.conf

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                         Env-variables                       ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

# Packages to have full env path access
env = PATH,$PATH:/usr/local/bin:/usr/bin:/bin:/home/$USERNAME/.cargo/bin

# After using nwg-look, also change the cursor settings here to maintain changes after every reboot
env = XCURSOR_THEME,Bibata-Modern-Classic
env = XCURSOR_SIZE,18
env = HYPRCURSOR_THEME,Bibata-Modern-Classic
env = HYPRCURSOR_SIZE,18

# XDG Desktop Portal
env = XDG_CURRENT_DESKTOP,Hyprland
env = XDG_SESSION_TYPE,wayland
env = XDG_SESSION_DESKTOP,Hyprland
# QT
env = QT_QPA_PLATFORM,wayland
env = QT_QPA_PLATFORMTHEME,qt6ct
env = QT_WAYLAND_DISABLE_WINDOWDECORATION,0
env = QT_AUTO_SCREEN_SCALE_FACTOR,1
# GDK
env = GDK_DEBUG,portals
env = GDK_SCALE,1
# Toolkit Backend
env = GDK_BACKEND,wayland
env = CLUTTER_BACKEND,wayland
# Mozilla
env = MOZ_ENABLE_WAYLAND,1
# Ozone
env = OZONE_PLATFORM,wayland
env = ELECTRON_OZONE_PLATFORM_HINT,wayland
# Extra
env = WINIT_UNIX_BACKEND,wayland
env = WLR_DRM_NO_ATOMIC,1
env = WLR_NO_HARDWARE_CURSORS,1
# Virtual machine display scaling
env = QT_SCALE_FACTOR_ROUNDING_POLICY=PassThrough
# For better VM performance
env = QEMU_AUDIO_DRV=pa

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                           Keyboard                          ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

input {
    kb_layout = $LAYOUT
    kb_variant = 
    kb_model =
    kb_options =
    numlock_by_default = true
    mouse_refocus = false

    follow_mouse = 1
    touchpad {
        # for desktop
        natural_scroll = false

        # for laptop
        # natural_scroll = yes
        # middle_button_emulation = true
        # clickfinger_behavior = false
        scroll_factor = 1.0  # Touchpad scroll factor
    }
    sensitivity = 0 # Pointer speed: -1.0 - 1.0, 0 means no modification.
}

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                             Layout                          ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

general {
    gaps_in = 6
    gaps_out = 8	
    gaps_workspaces = 50    # Gaps between workspaces
    border_size = 3
    col.active_border = $source_color
    col.inactive_border = $background
    layout = scrolling
    resize_on_border = true
    allow_tearing = true
}

group {
    col.border_active =  $source_color
    col.border_inactive = $background
    col.border_locked_active =  $primary_fixed_dim
    col.border_locked_inactive = $background
    
    groupbar {
        font_size = 14
        font_weight_active = heavy
        font_weight_inactive = heavy
        text_color = $surface_tint
        col.active =  $primary_fixed_dim
        col.inactive = $background
        col.locked_active =  $primary_fixed_dim
        col.locked_inactive = $background
        indicator_height = 4
        indicator_gap = 6
    
        # Additional styling options
        height = 10          # Height of the groupbar
        render_titles = true           # Show window titles
        scrolling = true              # Enable scrolling through titles
        
        # Gradients work too (like hyprbars)
        # col.active = $source_color $primary_fixed_dim 45deg
    }
}

dwindle {
    pseudotile = true
    preserve_split = true
}

master {
    new_status = slave
    new_on_active = after
    smart_resizing = true
    drop_at_cursor = true
}

scrolling {
    direction = right
    focus_fit_method = 0
    column_width = 0.5
}

gesture = 3, horizontal, workspace
gesture = 4, swipe, move,
gesture = 2, pinch, float
gestures {
    workspace_swipe_distance = 700
    workspace_swipe_cancel_ratio = 0.2
    workspace_swipe_min_speed_to_force = 5
    workspace_swipe_direction_lock = true
    workspace_swipe_direction_lock_threshold = 10
    workspace_swipe_create_new = true
}

binds {
  workspace_back_and_forth = true
  allow_workspace_cycles = true
  pass_mouse_when_bound = false
}

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                          Decorations                        ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

decoration {
    rounding = 15
    rounding_power = 2
    active_opacity = 0.85
    inactive_opacity = 0.85
    fullscreen_opacity = 1.0

    blur {
    enabled = true
    size = 2
    passes = 4
    new_optimizations = on
    ignore_opacity = true
        xray = false
        vibrancy = 0.24999999999999933
        noise = 0
    popups = true
    popups_ignorealpha = 0.8
        brightness = 1.0000000000000002
        contrast = 0.9999999999999997
        special = false
        vibrancy_darkness = 0.5000000000000002
    }

    shadow {
        enabled = true
        range = 12
        render_power = 4
        color = $scrim
    }
    dim_strength = 0.19999999999999973
    dim_inactive = false
}

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                          Decorations                        ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

decoration {
    rounding = 15
    rounding_power = 2
    active_opacity = 0.8499999999999999
    inactive_opacity = 0.8499999999999999
    fullscreen_opacity = 1.0

    blur {
    enabled = true
    size = 2
    passes = 4
    new_optimizations = on
    ignore_opacity = true
        xray = true
        vibrancy = 0.24999999999999933
        noise = 0
    popups = true
    popups_ignorealpha = 0.8
        brightness = 1.0000000000000002
        contrast = 0.9999999999999997
        special = false
        vibrancy_darkness = 0.5000000000000002
    }

    shadow {
        enabled = true
        range = 12
        render_power = 4
        color = $scrim
    }
    dim_strength = 0.19999999999999973
    dim_inactive = false
}

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                      Window & layer rules                   ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

windowrule = group barred, match:class .*
windowrule = pin on,border_size 0,match:class (com.candy.widgets|gjs|widgets)
windowrule = move ((monitor_w*0.5)-(window_w*0.5)) 45,match:title (candy.utils)#center
windowrule = move ((monitor_w*1)-((window_w*1)+10)) 45,match:title (candy.systemmonitor) #top right
windowrule = move ((monitor_w*0.5)-(window_w*0.5)) 45,match:title (candy.weather) #center
windowrule = move (monitor_w*0.01) 45,match:title (candy.media) #top left
windowrule = opacity 0.85 0.85,match:class ^(kitty|kitty-scratchpad|Alacritty|floating-installer|clock)$
windowrule = float on, center on,size 800 500,match:class (kitty-scratchpad)
windowrule = suppress_event maximize, match:class .* #nofocus,match:class ^$,match:title ^$,xwayland:1,floating:1,fullscreen:0,pinned:0
# Pavucontrol floating
windowrule = float on,match:class (.*org.pulseaudio.pavucontrol.*)
windowrule = size 700 600,match:class (.*org.pulseaudio.pavucontrol.*)
windowrule = center on,match:class (.*org.pulseaudio.pavucontrol.*)
#windowrule = pin on,match:class (.*org.pulseaudio.pavucontrol.*)
# Browser Picture in Picture
windowrule = float on, match:title ^(Picture-in-Picture)$
windowrule = pin on, match:title ^(Picture-in-Picture)$
windowrule = move 69.5% 4%, match:title ^(Picture-in-Picture)$
# Waypaper
windowrule = float on,match:class (.*waypaper.*)
windowrule = size 800 600,match:class (.*waypaper.*)
windowrule = center on,match:class (.*waypaper.*)
#windowrule = pin on,match:class (.*waypaper.*)
# Blueman Manager
windowrule = float on,match:class (blueman-manager)
windowrule = size 800 600,match:class (blueman-manager)
windowrule = center on,match:class (blueman-manager)
# Weather
windowrule = float on,match:class (org.gnome.Weather)
windowrule = size 700 600,match:class (org.gnome.Weather)
windowrule = center on,match:class (org.gnome.Weather)
#windowrule = pin on,match:class (org.gnome.Weather)
# Calendar
windowrule = float on,match:class (org.gnome.Calendar)
windowrule = size 820 600,match:class (org.gnome.Calendar)
windowrule = center on,match:class (org.gnome.Calendar)
#windowrule = pin on,match:class (org.gnome.Calendar)
# System Monitor
windowrule = float on,match:class (org.gnome.SystemMonitor)
windowrule = size 820 625,match:class (org.gnome.SystemMonitor)
windowrule = center on,match:class (org.gnome.SystemMonitor)
#windowrule = pin on,match:class (org.gnome.SystemMonitor)
# Files
windowrule = float on,match:title (Open Files)
windowrule = size 700 600,match:title (Open Files)
windowrule = center on,match:title (Open Files)
#windowrule = pin on,match:title (Open Files)

windowrule = float on,match:title (Select Copy Destination)
windowrule = size 700 600,match:title (Select Copy Destination)
windowrule = center on,match:title (Select Copy Destination)
#windowrule = pin on,match:title (Select Copy Destination)

windowrule = float on,match:title (Select Move Destination)
windowrule = size 700 600,match:title (Select Move Destination)
windowrule = center on,match:title (Select Move Destination)
#windowrule = pin on,match:title (Select Move Destination)

windowrule = float on,match:title (Save As)
windowrule = size 700 600,match:title (Save As)
windowrule = center on,match:title (Save As)
#windowrule = pin on,match:title (Save As)

windowrule = float on,match:title (Select files to send)
windowrule = size 700 600,match:title (Select files to send)
windowrule = center on,match:title (Select files to send)
#windowrule = pin on,match:title (Select files to send)

windowrule = float on,match:title (Bluetooth File Transfer)
#windowrule = pin on,match:title (Bluetooth File Transfer)
# nwg-look
windowrule = float on,match:class (nwg-look)
windowrule = size 700 600,match:class (nwg-look)
windowrule = center on,match:class (nwg-look)
#windowrule = pin on,match:class (nwg-look)
# CachyOS Hello
windowrule = float on,match:class (CachyOSHello)
windowrule = size 700 600,match:class (CachyOSHello)
windowrule = center on,match:class (CachyOSHello)
#windowrule = pin on,match:class (CachyOSHello)
# nwg-displays
windowrule = float on,match:class (nwg-displays)
windowrule = size 990 600,match:class (nwg-displays)
windowrule = center on,match:class (nwg-displays)
#windowrule = pin on,match:class (nwg-displays)
# System Mission Center
windowrule = float on, match:class (io.missioncenter.MissionCenter)
#windowrule = pin on, match:class (io.missioncenter.MissionCenter)
windowrule = center on, match:class (io.missioncenter.MissionCenter)
windowrule = size 900 600, match:class (io.missioncenter.MissionCenter)
# System Mission Center Preference Window
windowrule = float on, match:class (missioncenter), match:title ^(Preferences)$
#windowrule = pin on, match:class (missioncenter), match:title ^(Preferences)$
windowrule = center on, match:class (missioncenter), match:title ^(Preferences)$
# Gnome Calculator
windowrule = float on,match:class (org.gnome.Calculator)
windowrule = size 700 600,match:class (org.gnome.Calculator)
windowrule = center on,match:class (org.gnome.Calculator)
# Emoji Picker Smile
windowrule = float on,match:class (it.mijorus.smile)
#windowrule = pin on, match:class (it.mijorus.smile)
windowrule = move 100%-w-40 90,match:class (it.mijorus.smile)
# Hyprland Share Picker
windowrule = float on, match:class (hyprland-share-picker)
#windowrule = pin on, match:class (hyprland-share-picker)
windowrule = center on, match:title match:class (hyprland-share-picker)
windowrule = size 600 400,match:class (hyprland-share-picker)
# Hyprland Settings App
windowrule = float on,match:title (hyprviz)
windowrule = size 1000 625,match:title (hyprviz)
windowrule = center on,match:title (hyprviz)
# General floating
windowrule = float on,match:class (dotfiles-floating)
windowrule = size 1000 700,match:class (dotfiles-floating)
windowrule = center on,match:class (dotfiles-floating)
# Satty
windowrule = float on,match:title (satty)
windowrule = size 1000 565,match:title (satty)
windowrule = center on,match:title (satty)
# Float Necessary Windows
windowrule = float on, match:class ^(org.pulseaudio.pavucontrol)
windowrule = float on, match:class ^()$,match:title ^(Picture in picture)$
windowrule = float on, match:class ^()$,match:title ^(Save File)$
windowrule = float on, match:class ^()$,match:title ^(Open File)$
windowrule = float on, match:class ^(LibreWolf)$,match:title ^(Picture-in-Picture)$
##windowrule = float on, match:class ^(blueman-manager)$
windowrule = float on, match:class ^(xdg-desktop-portal-hyprland|xdg-desktop-portal-gtk|xdg-desktop-portal-kde)(.*)$
windowrule = float on, match:class ^(hyprpolkitagent|polkit-gnome-authentication-agent-1|org.org.kde.polkit-kde-authentication-agent-1)(.*)$
windowrule = float on, match:class ^(CachyOSHello)$
windowrule = float on, match:class ^(zenity)$
windowrule = float on, match:class ^()$,match:title ^(Steam - Self Updater)$
# Increase the opacity
windowrule = opacity 1.0, match:class ^(zen)$
# # windowrule = opacity 1.0, match:class ^(discord|armcord|webcord)$
# # windowrule = opacity 1.0, match:title ^(QQ|Telegram)$
# # windowrule = opacity 1.0, match:title ^(NetEase Cloud Music Gtk4)$
# General window rules
windowrule = float on, match:title ^(Picture-in-Picture)$
windowrule = size 460 260, match:title ^(Picture-in-Picture)$
windowrule = move 65%- 10%-, match:title ^(Picture-in-Picture)$
windowrule = float on, match:title ^(imv|mpv|danmufloat|termfloat|nemo|ncmpcpp)$
windowrule = move 25%-, match:title ^(imv|mpv|danmufloat|termfloat|nemo|ncmpcpp)$
windowrule = size 960 540, match:title ^(imv|mpv|danmufloat|termfloat|nemo|ncmpcpp)$
#windowrule = pin on, match:title ^(danmufloat)$
windowrule = rounding 5, match:title ^(danmufloat|termfloat)$
windowrule = animation slide right, match:class ^(kitty|Alacritty)$
#windowrule = no_blur on, match:class ^(org.mozilla.firefox)$
# Decorations related to floating windows on workspaces 1 to 10
##windowrule = bordersize 2, floating:1, onworkspace:w[fv1-10]
workspace = w[fv1-10], border_color c $source_color, float on #$on_primary_fixed_variant 90deg
##windowrule = rounding 8, floating:1, onworkspace:w[fv1-10]
# Decorations related to tiling windows on workspaces 1 to 10
##windowrule = bordersize 3, floating:0, onworkspace:f[1-10]
##windowrule = rounding 4, floating:0, onworkspace:f[1-10]
#windowrule = tile, match:title ^(Microsoft-edge)$
vwindowrule = tile, match:title ^(Brave-browser)$
#windowrule = tile, match:title ^(Chromium)$
windowrule = float on, match:title ^(pavucontrol)$
windowrule = float on, match:title ^(blueman-manager)$
windowrule = float on, match:title ^(nm-connection-editor)$
windowrule = float on, match:title ^(qalculate-gtk)$
# idleinhibit
windowrule = idle_inhibit fullscreen,match:class ([window]) # Available modes: none, always, focus, fullscreen
### no blur for specific classes
##windowrule = noblur,match:class ^(?!(nautilus|nwg-look|nwg-displays|zen))
## Windows Rules End #

windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(nautilus)$
windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(zen)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(Brave-browser)$
windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(code-oss)$
windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^([Cc]ode)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(code-url-handler)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(code-insiders-url-handler)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(org.kde.dolphin)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(org.kde.ark)$
windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(nwg-look)$
windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(qt5ct)$
windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(qt6ct)$
windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(kvantummanager)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(org.pulseaudio.pavucontrol)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(blueman-manager)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(nm-applet)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(nm-connection-editor)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(org.kde.polkit-kde-authentication-agent-1)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(polkit-gnome-authentication-agent-1)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(org.freedesktop.impl.portal.desktop.gtk)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(org.freedesktop.impl.portal.desktop.hyprland)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^([Ss]team)$
# # windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^(steamwebhelper)$
windowrule = opacity 1.0 $& 1.0 $& 1,match:class ^([Ss]potify)$
windowrule = opacity 1.0 $& 1.0 $& 1,match:title ^(Spotify Free)$
windowrule = opacity 1.0 $& 1.0 $& 1,match:title ^(Spotify Premium)$
# # 
# # windowrule = opacity 1.0 1.0,match:class ^(com.github.rafostar.Clapper)$ # Clapper-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(com.github.tchx84.Flatseal)$ # Flatseal-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(hu.kramo.Cartridges)$ # Cartridges-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(com.obsproject.Studio)$ # Obs-Qt
# # windowrule = opacity 1.0 1.0,match:class ^(gnome-boxes)$ # Boxes-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(vesktop)$ # Vesktop
# # windowrule = opacity 1.0 1.0,match:class ^(discord)$ # Discord-Electron
# # windowrule = opacity 1.0 1.0,match:class ^(WebCord)$ # WebCord-Electron
# # windowrule = opacity 1.0 1.0,match:class ^(ArmCord)$ # ArmCord-Electron
# # windowrule = opacity 1.0 1.0,match:class ^(app.drey.Warp)$ # Warp-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(net.davidotek.pupgui2)$ # ProtonUp-Qt
# # windowrule = opacity 1.0 1.0,match:class ^(yad)$ # Protontricks-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(Signal)$ # Signal-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(io.github.alainm23.planify)$ # planify-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(io.gitlab.theevilskeleton.Upscaler)$ # Upscaler-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(com.github.unrud.VideoDownloader)$ # VideoDownloader-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(io.gitlab.adhami3310.Impression)$ # Impression-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(io.missioncenter.MissionCenter)$ # MissionCenter-Gtk
# # windowrule = opacity 1.0 1.0,match:class ^(io.github.flattool.Warehouse)$ # Warehouse-Gtk
windowrule = float on,match:class ^(org.kde.dolphin)$,match:title ^(Progress Dialog — Dolphin)$
windowrule = float on,match:class ^(org.kde.dolphin)$,match:title ^(Copying — Dolphin)$
windowrule = float on,match:title ^(About Mozilla Firefox)$
windowrule = float on,match:class ^(firefox)$,match:title ^(Picture-in-Picture)$
windowrule = float on,match:class ^(firefox)$,match:title ^(Library)$
windowrule = float on,match:class ^(kitty)$,match:title ^(top)$
windowrule = float on,match:class ^(kitty)$,match:title ^(btop)$
windowrule = float on,match:class ^(kitty)$,match:title ^(htop)$
windowrule = float on,match:class ^(eww-main-window)$
windowrule = float on,match:class ^(eww-notifications)$
windowrule = float on,match:class ^(kvantummanager)$
windowrule = float on,match:class ^(qt5ct)$
windowrule = float on,match:class ^(qt6ct)$
windowrule = float on,match:class ^(nwg-look)$
windowrule = float on,match:class ^(org.kde.ark)$
windowrule = float on,match:class ^(org.pulseaudio.pavucontrol)$
windowrule = float on,match:class ^(blueman-manager)$
windowrule = float on,match:class ^(nm-applet)$
windowrule = float on,match:class ^(nm-connection-editor)$
windowrule = float on,match:class ^(org.kde.polkit-kde-authentication-agent-1)$

windowrule = float on,match:class ^(Signal)$ # Signal-Gtk
windowrule = float on,match:class ^(com.github.rafostar.Clapper)$ # Clapper-Gtk
windowrule = float on,match:class ^(app.drey.Warp)$ # Warp-Gtk
windowrule = float on,match:class ^(net.davidotek.pupgui2)$ # ProtonUp-Qt
windowrule = float on,match:class ^(yad)$ # Protontricks-Gtk
windowrule = float on,match:class ^(eog)$ # Imageviewer-Gtk
windowrule = float on,match:class ^(io.github.alainm23.planify)$ # planify-Gtk
windowrule = float on,match:class ^(io.gitlab.theevilskeleton.Upscaler)$ # Upscaler-Gtk
windowrule = float on,match:class ^(com.github.unrud.VideoDownloader)$ # VideoDownloader-Gkk
windowrule = float on,match:class ^(io.gitlab.adhami3310.Impression)$ # Impression-Gtk
windowrule = float on,match:class ^(io.missioncenter.MissionCenter)$ # MissionCenter-Gtk
windowrule = float on,match:class (clipse) # ensure you have a floating window class set if you want this behavior
windowrule = size 622 652,match:class (clipse) # set the size of the window as necessary
#windowrule = noborder, fullscreen:1

# common modals
#windowrule = float on,match:title ^(Open File)$
#windowrule = layer:top,match:class hyprpolkitagent
windowrule = float on,match:title ^(Choose Files)$
windowrule = float on,match:title ^(Save As)$
windowrule = float on,match:title ^(Confirm to replace files)$
windowrule = float on,match:title ^(File Operation Progress)$
windowrule = float on,match:class ^(xdg-desktop-portal-gtk)$

# installer
windowrule = float on, match:class (floating-installer)
windowrule = center on, match:class (floating-installer)

# clock
windowrule = float on, center on, size 400 200, match:class (clock)

# Extra workspace & window rules 
# Workspaces Rules https://wiki.hyprland.org/0.45.0/Configuring/Workspace-Rules/ #
# workspace = 1, default:true, monitor:$priMon
# workspace = 6, default:true, monitor:$secMon
# Workspace selectors https://wiki.hyprland.org/0.45.0/Configuring/Workspace-Rules/#workspace-selectors
# workspace = r[1-5], monitor:$priMon
# workspace = r[6-10], monitor:$secMon
# workspace = special:scratchpad, on-created-empty:$applauncher
# no_gaps_when_only deprecated instead workspaces rules with selectors can do the same
# Smart gaps from 0.45.0 https://wiki.hyprland.org/0.45.0/Configuring/Workspace-Rules/#smart-gaps
#workspace = w[t1], gapsout:0, gapsin:0
#workspace = w[tg1], gapsout:0, gapsin:0
workspace = f[1], gapsout:0, gapsin:0
#windowrule = bordersize 2, floating:0, onworkspace:w[t1]
#windowrule = rounding 10, floating:0, onworkspace:w[t1]
#windowrule = bordersize 2, floating:0, onworkspace:w[tg1]
#windowrule = rounding 10, floating:0, onworkspace:w[tg1]
#windowrule = bordersize 2, floating:0, onworkspace:f[1]
#windowrule = rounding 10, floating:0, onworkspace:f[1]
windowrule = rounding 0, fullscreen true, border_size 0
#workspace = w[tv1-10], gapsout:6, gapsin:2
#workspace = f[1], gapsout:6, gapsin:2

workspace = 1, layoutopt:orientation:left
workspace = 2, layoutopt:orientation:right
workspace = 3, layoutopt:orientation:left
workspace = 4, layoutopt:orientation:right
workspace = 5, layoutopt:orientation:left
workspace = 6, layoutopt:orientation:right
workspace = 7, layoutopt:orientation:left
workspace = 8, layoutopt:orientation:right
workspace = 9, layoutopt:orientation:left
workspace = 10, layoutopt:orientation:right
# Workspaces Rules End #

# Layers Rules #
layerrule = animation slide top, match:namespace logout_dialog
layerrule = blur on,xray on,match:namespace rofi
layerrule = ignore_alpha 0.01,match:namespace rofi
layerrule = blur on,match:namespace notifications
layerrule = ignore_alpha 0.01,match:namespace notifications
layerrule = blur on,match:namespace swaync-notification-window
layerrule = ignore_alpha 0.01,match:namespace swaync-notification-window
layerrule = blur on,xray on,no_anim on,match:namespace swaync-control-center
layerrule = ignore_alpha 0.01,match:namespace swaync-control-center
layerrule = blur on,no_anim on,match:namespace nwg-dock
layerrule = ignore_alpha 0.01,match:namespace nwg-dock
layerrule = blur on,match:namespace logout_dialog
layerrule = ignore_alpha 0.01,match:namespace logout_dialog
layerrule = blur on,match:namespace gtk-layer-shell
layerrule = ignore_alpha 0.01,match:namespace gtk-layer-shell
layerrule = blur on,no_anim on,match:namespace bar-0
layerrule = ignore_alpha 0.01,match:namespace bar-0
layerrule = blur on,match:namespace dashboardmenu
layerrule = ignore_alpha 0.01,match:namespace dashboardmenu
layerrule = blur on,match:namespace calendarmenu
layerrule = ignore_alpha 0.01,match:namespace calendarmenu
layerrule = blur on,match:namespace notificationsmenu
layerrule = ignore_alpha 0.01,match:namespace notificationsmenu
layerrule = blur on,match:namespace networkmenu
layerrule = ignore_alpha 0.01,match:namespace networkmenu
layerrule = blur on,match:namespace mediamenu
layerrule = ignore_alpha 0.01,match:namespace mediamenu
layerrule = blur on,match:namespace energymenu
layerrule = ignore_alpha 0.01,match:namespace energymenu
layerrule = blur on,match:namespace bluetoothmenu
layerrule = ignore_alpha 0.01,match:namespace bluetoothmenu
layerrule = blur on,match:namespace audiomenu
layerrule = ignore_alpha 0.01,match:namespace audiomenu
layerrule = blur on,match:namespace hyprmenu
layerrule = ignore_alpha 0.01,match:namespace hyprmenu
# layerrule = animation popin 50%, waybar
# Layers Rules End #

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                         Misc-settings                       ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

misc {
    disable_hyprland_logo = true
    disable_splash_rendering = false
    initial_workspace_tracking = 1
}

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                           Userprefs                         ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
# [NOTE!!] Add you personal settings from here and incase of an update copy them to the new file once this is changed to a backup

debug {
    suppress_errors = true
}

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                            Plugins                          ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

EOF
fi

            # Add default content to the custom_lock.conf file
            cat > "$HOME/.config/hyprcustom/custom_lock.conf" << 'EOF'
# ██╗  ██╗██╗   ██╗██████╗ ██████╗ ██╗      ██████╗  ██████╗██╗  ██╗
# ██║  ██║╚██╗ ██╔╝██╔══██╗██╔══██╗██║     ██╔═══██╗██╔════╝██║ ██╔╝
# ███████║ ╚████╔╝ ██████╔╝██████╔╝██║     ██║   ██║██║     █████╔╝ 
# ██╔══██║  ╚██╔╝  ██╔═══╝ ██╔══██╗██║     ██║   ██║██║     ██╔═██╗ 
# ██║  ██║   ██║   ██║     ██║  ██║███████╗╚██████╔╝╚██████╗██║  ██╗
# ╚═╝  ╚═╝   ╚═╝   ╚═╝     ╚═╝  ╚═╝╚══════╝ ╚═════╝  ╚═════╝╚═╝  ╚═╝

source = ~/.config/hypr/colors.conf

general {
    ignore_empty_input = true
    hide_cursor = true
}

auth {
    fingerprint {
        enabled = true
        ready_message = Scan fingerprint to unlock
        present_message = Scanning...
        retry_delay = 250 # in milliseconds
    }
}

background {
    monitor =
    path = ~/.config/background.png
    blur_passes = 4
    blur_sizes = 0
    vibrancy = 0.1696
    noise = 0.01
    contrast = 0.8916
}

input-field {
    monitor =
    size = 200, 50
    outline_thickness = 3
    dots_size = 0.25 # Scale of input-field height, 0.2 - 0.8
    dots_spacing = 0.2 # Scale of dots' absolute size, 0.0 - 1.0
    dots_center = true
    dots_rounding = -1 # -1 default circle, -2 follow input-field rounding
    outer_color = $primary_fixed_dim $on_secondary 90deg
    inner_color = $on_primary_fixed_variant
    font_color = $primary_fixed_dim
    font_family = C059 Bold Italic
    fade_on_empty = false
    fade_timeout = 1000 # Milliseconds before fade_on_empty is triggered.
    placeholder_text = <i><span>       $USER       </span></i># Text rendered in the input box when it's empty. # foreground="$inverse_primary ##ffffff99
    hide_input = false
    rounding = 20 # -1 means complete rounding (circle/oval)
    check_color = $rimary
    fail_color = $error # if authentication failed, changes outer_color and fail message color
    fail_text = <i>$FAIL <b>($ATTEMPTS)</b></i> # can be set to empty
    fail_transition = 300 # transition time in ms between normal outer_color and fail_color
    capslock_color = $primary_fixed_dim
    numlock_color = $primary_fixed_dim $on_secondary 90deg
    #bothlock_color = -1 # when both locks are active. -1 means don't change outer color (same for above)
    invert_numlock = false # change color if numlock is off
    swap_font_color = false # see below
    position = 0, 150
    halign = center
    valign = bottom
    shadow_passes = 10
    shadow_size = 20
    shadow_color = $shadow
    shadow_boost = 1.6
}

label {
    monitor =
    #date
    text = cmd[update:60000] date +"%A, %d %B %Y"
    color = $primary
    font_size = 20
    font_family = C059 Bold
    position = 0, -35
    halign = center
    valign = top
}

label {
    monitor =
    #clock
    text = cmd[update:1000] echo "$TIME"
    color = $on_primary_fixed_variant
    font_size = 55
    font_family = C059 Bold Italic
    position = 0, -150
    halign = center
    valign = top
    shadow_passes = 5
    shadow_size = 10
}

#label {
    monitor =
    #text = ✝      $USER    ✝ #  $USER
    color = $primary_fixed_dim
    font_size = 20
    font_family = C059 Bold
    position = 0, 100
    halign = center
    valign = bottom
    shadow_passes = 5
    shadow_size = 10
}

image {
    monitor =
    path = ~/.config/lock.png #.face.icon
    size = 160  lesser side if not 1:1 ratio
    rounding = -1 # negative values mean circle
    border_size = 4
    border_color = $primary_fixed_dim $on_secondary 90deg
    rotate = 0 # degrees, counter-clockwise
    reload_time = -1 # seconds between reloading, 0 to reload with SIGUSR2
#    reload_cmd =  # command to get new path. if empty, old path will be used. don't run "follow" commands like tail -F
    position = 0, 0
    halign = center
    valign = center
}
EOF

if [ "$PANEL_CHOICE" = "waybar" ]; then

            # Add default content to the custom_keybinds.conf file
            cat > "$HOME/.config/hyprcustom/custom_keybinds.conf" << 'EOF'
# ██╗  ██╗███████╗██╗   ██╗██████╗ ██╗███╗   ██╗██████╗ ███████╗
# ██║ ██╔╝██╔════╝╚██╗ ██╔╝██╔══██╗██║████╗  ██║██╔══██╗██╔════╝
# █████╔╝ █████╗   ╚████╔╝ ██████╔╝██║██╔██╗ ██║██║  ██║███████╗
# ██╔═██╗ ██╔══╝    ╚██╔╝  ██╔══██╗██║██║╚██╗██║██║  ██║╚════██║
# ██║  ██╗███████╗   ██║   ██████╔╝██║██║ ╚████║██████╔╝███████║
# ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚═════╝ ╚═╝╚═╝  ╚═══╝╚═════╝ ╚══════╝

#
$mainMod = SUPER
$HYPRSCRIPTS = ~/.config/hypr/scripts
$SCRIPTS = ~/.config/hyprcandy/scripts
$EDITOR = gedit # Change from the default editor to your prefered editor
$DISCORD = equibop
#

#### Kill active window ####

bind = $mainMod, Escape, killactive #Kill single active window
bind = $mainMod SHIFT, Escape, exec, hyprctl activewindow | grep pid | tr -d 'pid:' | xargs kill #Quit active window and all similar open instances

#### Rofi Menus ####

bind = $mainMod CTRL, R, exec, $HYPRSCRIPTS/rofi-menus.sh     #Launch utilities rofi-menu
bind = bind = $mainMod, A, exec, ~/.hyprcandy/GJS/hyprcandydock/toggle-app-launcher.sh     #Show/hide rofi application finder
bind = $mainMod, K, exec, $HYPRSCRIPTS/keybindings.sh     #Show keybindings
bind = $mainMod CTRL, A, exec, $HYPRSCRIPTS/animations.sh     #Select animations
bind = $mainMod CTRL, V, exec, $SCRIPTS/cliphist.sh     #Open clipboard manager
bind = $mainMod CTRL, E, exec, ~/.config/hyprcandy/settings/emojipicker.sh 		  #Open rofi emoji-picker
bind = $mainMod CTRL, G, exec, ~/.config/hyprcandy/settings/glyphpicker.sh 		  #Open rofi glyph-picker

#### Applications ####

bind = $mainMod, W, exec, $SCRIPTS/wallpaper.sh #Wallpaper picker
bind = ALT, W, exec, ~/.config/quickshell/wallpaper/wallpaper-cycle.sh -n #Alternate wallpapers forward
bind = ALT SHIFT, W, exec, ~/.config/quickshell/wallpaper/wallpaper-cycle.sh -p #Alternate wallpapers backward
bind = ALT SHIFT, R, exec, ~/.config/hyprcandy/hooks/wallpaper_integration.sh #Reload system colors
bind = $mainMod, S, exec, spotify-launcher #Spotify
bind = $mainMod, D, exec, $DISCORD #Discord
bind = $mainMod, C, exec, DRI_PRIME=1 $EDITOR #Editor
bind = $mainMod, B, exec, DRI_PRIME=1 xdg-open "http://" #Launch your default browser
bind = $mainMod, Q, exec, kitty #Launch normal kitty instances
bind = $mainMod, Return, exec, DRI_PRIME=1 pypr toggle term #Launch a kitty scratchpad through pyprland
bind = $mainMod, O, exec, DRI_PRIME=1 /usr/bin/octopi #Launch octopi application finder
bind = $mainMod, E, exec, DRI_PRIME=1 nautilus #Launch the filemanager 
bind = $mainMod CTRL, C, exec, DRI_PRIME=1 gnome-calculator #Launch the calculator

#### Bar/Panel ####

bind = ALT, 1, exec, ~/.config/hyprcandy/scripts/bar.sh #Hide/Show bar

#### Dock keybinds ####

bind = ALT, 2, exec, ~/.hyprcandy/GJS/hyprcandydock/toggle.sh #Hide/Show dock

#### Status display ####

bind = ALT, 3, exec, ~/.config/hyprcandy/hooks/hyprland_status_display.sh #Hyprland status display

#### Recorder ####

# Wf--recorder (simple recorder) + slurp (allows to select a specific region of the monitor)
# {to list audio devices run "pactl list sources | grep Name"}   
bind = $mainMod, R, exec, bash -c 'wf-recorder -g -a --audio=bluez_output.78_15_2D_0D_BD_B7.1.monitor -f "$HOME/Videos/Recordings/recording-$(date +%Y%m%d-%H%M%S).mp4" $(slurp)' # Start recording
bind = Alt, R, exec, pkill -x wf-recorder #Stop recording

#### Hyprsunset ####

bind = Shift, H, exec, hyprctl hyprsunset gamma +10 #Increase gamma by 10%
bind = Alt, H, exec, hyprctl hyprsunset gamma -10 #Reduce gamma by 10%


#### Actions ####

bind = ALT, G, exec, $HYPRSCRIPTS/gamemode.sh						  #Toggle game-mode
#bind = $mainMod, M, exec, ~/.config/hypr/scripts/power.sh exit 				  #Logout
#bind = $mainMod,SPACE, hyprexpo:expo, toggle						  #Hyprexpo-plus workspaces overview
bind = $mainMod SHIFT, R, exec, $HYPRSCRIPTS/loadconfig.sh                                 #Reload Hyprland configuration
bind = $mainMod SHIFT, A, exec, $HYPRSCRIPTS/toggle-animations.sh                         #Toggle animations
bind = $mainMod, PRINT, exec, $HYPRSCRIPTS/screenshot.sh                                  #Take a screenshot
bind = $mainMod, V, exec, cliphist wipe 						  #Clear cliphist database
bind = $mainMod CTRL, D, exec, $ cliphist list | dmenu | cliphist delete 		  #Delete an old item
bind = $mainMod ALT, D, exec, $ cliphist delete-query "secret item"  			  #Delete an old item quering manually
bind = $mainMod ALT, S, exec, $ cliphist list | dmenu | cliphist decode | wl-copy    	  #Select an old item
bind = $mainMod ALT, O, exec, $HYPRSCRIPTS/window-opacity.sh                              #Change opacity
bind = $mainMod, L, exec, ~/.config/hypr/scripts/power.sh lock 				  #Lock


#### Workspaces ####

bind = SHIFT, TAB, exec, $SCRIPTS/overview.sh #Workspace overview

bind = $mainMod, 1, workspace, 1  #Open workspace 1
bind = $mainMod, 2, workspace, 2  #Open workspace 2
bind = $mainMod, 3, workspace, 3  #Open workspace 3
bind = $mainMod, 4, workspace, 4  #Open workspace 4
bind = $mainMod, 5, workspace, 5  #Open workspace 5
bind = $mainMod, 6, workspace, 6  #Open workspace 6
bind = $mainMod, 7, workspace, 7  #Open workspace 7
bind = $mainMod, 8, workspace, 8  #Open workspace 8
bind = $mainMod, 9, workspace, 9  #Open workspace 9
bind = $mainMod, 0, workspace, 10 #Open workspace 10

bind = $mainMod SHIFT, 1, movetoworkspace, 1  #Move active window to workspace 1
bind = $mainMod SHIFT, 2, movetoworkspace, 2  #Move active window to workspace 2
bind = $mainMod SHIFT, 3, movetoworkspace, 3  #Move active window to workspace 3
bind = $mainMod SHIFT, 4, movetoworkspace, 4  #Move active window to workspace 4
bind = $mainMod SHIFT, 5, movetoworkspace, 5  #Move active window to workspace 5
bind = $mainMod SHIFT, 6, movetoworkspace, 6  #Move active window to workspace 6
bind = $mainMod SHIFT, 7, movetoworkspace, 7  #Move active window to workspace 7
bind = $mainMod SHIFT, 8, movetoworkspace, 8  #Move active window to workspace 8
bind = $mainMod SHIFT, 9, movetoworkspace, 9  #Move active window to workspace 9
bind = $mainMod SHIFT, 0, movetoworkspace, 10 #Move active window to workspace 10

bind = $mainMod, Tab, workspace, m+1       #Open next workspace
bind = $mainMod SHIFT, Tab, workspace, m-1 #Open previous workspace

bind = $mainMod CTRL, 1, exec, $HYPRSCRIPTS/moveTo.sh 1  #Move all windows to workspace 1
bind = $mainMod CTRL, 2, exec, $HYPRSCRIPTS/moveTo.sh 2  #Move all windows to workspace 2
bind = $mainMod CTRL, 3, exec, $HYPRSCRIPTS/moveTo.sh 3  #Move all windows to workspace 3
bind = $mainMod CTRL, 4, exec, $HYPRSCRIPTS/moveTo.sh 4  #Move all windows to workspace 4
bind = $mainMod CTRL, 5, exec, $HYPRSCRIPTS/moveTo.sh 5  #Move all windows to workspace 5
bind = $mainMod CTRL, 6, exec, $HYPRSCRIPTS/moveTo.sh 6  #Move all windows to workspace 6
bind = $mainMod CTRL, 7, exec, $HYPRSCRIPTS/moveTo.sh 7  #Move all windows to workspace 7
bind = $mainMod CTRL, 8, exec, $HYPRSCRIPTS/moveTo.sh 8  #Move all windows to workspace 8
bind = $mainMod CTRL, 9, exec, $HYPRSCRIPTS/moveTo.sh 9  #Move all windows to workspace 9
bind = $mainMod CTRL, 0, exec, $HYPRSCRIPTS/moveTo.sh 10  #Move all windows to workspace 10

bind = $mainMod, mouse_down, workspace, e+1  #Open next workspace
bind = $mainMod, mouse_up, workspace, e-1    #Open previous workspace
bind = $mainMod CTRL, down, workspace, empty #Open the next empty workspace

#### Minimize windows using special workspaces ####

bind = CTRL SHIFT, 1, togglespecialworkspace, magic #Togle window from special workspace
bind = CTRL SHIFT, 2, movetoworkspace, +0 #Move window to special workspace 2 (Can be toggled with "$mainMod,1")
bind = CTRL SHIFT, 3, togglespecialworkspace, magic #Togle window to and from special workspace
bind = CTRL SHIFT, 4, movetoworkspace, special:magic #Move window to special workspace 4 (Can be toggled with "$mainMod,1")
bind = CTRL SHIFT, 5, togglespecialworkspace, magic #Togle window to and from special workspace


#### Windows ####

bind = $mainMod ALT, 1, movetoworkspacesilent, 1  #Move active window to workspace 1 silently
bind = $mainMod ALT, 2, movetoworkspacesilent, 2  #Move active window to workspace 2 silently
bind = $mainMod ALT, 3, movetoworkspacesilent, 3  #Move active window to workspace 3 silently
bind = $mainMod ALT, 4, movetoworkspacesilent, 4  #Move active window to workspace 4 silently
bind = $mainMod ALT, 5, movetoworkspacesilent, 5  #Move active window to workspace 5 silently
bind = $mainMod ALT, 6, movetoworkspacesilent, 6  #Move active window to workspace 6 silently
bind = $mainMod ALT, 7, movetoworkspacesilent, 7  #Move active window to workspace 7 silently
bind = $mainMod ALT, 8, movetoworkspacesilent, 8  #Move active window to workspace 8 silently
bind = $mainMod ALT, 9, movetoworkspacesilent, 9  #Move active window to workspace 9 silently
bind = $mainMod ALT, 0, movetoworkspacesilent, 10  #Move active window to workspace 10 silently 

bindm = $mainMod, Z, movewindow #Hold to move selected window
bindm = $mainMod, X, resizewindow #Hold to resize selected window

bind = $mainMod, F, fullscreen, 0                                                           #Set active window to fullscreen
bind = $mainMod SHIFT, M, fullscreen, 1                                                           #Maximize Window
bind = $mainMod CTRL, F, togglefloating                                                     #Toggle active windows into floating mode
bind = $mainMod CTRL, T, exec, $HYPRSCRIPTS/toggleallfloat.sh                               #Toggle all windows into floating mode
bind = $mainMod, J, togglesplit                                                             #Toggle split
bind = $mainMod, left, movefocus, l                                                         #Move focus left
bind = $mainMod, right, movefocus, r                                                        #Move focus right
bind = $mainMod, up, movefocus, u                                                           #Move focus up
bind = $mainMod, down, movefocus, d                                                         #Move focus down
bindm = $mainMod, mouse:272, movewindow                                                     #Move window with the mouse
bindm = $mainMod, mouse:273, resizewindow                                                   #Resize window with the mouse
bind = $mainMod SHIFT, right, resizeactive, 100 0                                           #Increase window width with keyboard
bind = $mainMod SHIFT, left, resizeactive, -100 0                                           #Reduce window width with keyboard
bind = $mainMod SHIFT, down, resizeactive, 0 100                                            #Increase window height with keyboard
bind = $mainMod SHIFT, up, resizeactive, 0 -100                                             #Reduce window height with keyboard
bind = $mainMod, G, togglegroup                                                             #Toggle window group
bind = $mainMod CTRL, left, changegroupactive, prev				  	    #Switch to the previous window in the group
bind = $mainMod CTRL, right, changegroupactive, next					    #Switch to the next window in the group
bind = $mainMod CTRL, K, swapsplit                                                               #Swapsplit
bind = $mainMod ALT, left, swapwindow, l                                                    #Swap tiled window left
bind = $mainMod ALT, right, swapwindow, r                                                   #Swap tiled window right
bind = $mainMod ALT, up, swapwindow, u                                                      #Swap tiled window up
bind = $mainMod ALT, down, swapwindow, d                                                    #Swap tiled window down
binde = ALT,Tab,cyclenext                                                                   #Cycle between windows
binde = ALT,Tab,bringactivetotop                                                            #Bring active window to the top
bind = ALT, S, layoutmsg, swapwithmaster master 					    #Switch current focused window to master
bind = $mainMod SHIFT, L, exec, hyprctl keyword general:layout "$(hyprctl getoption general:layout | grep -q 'dwindle' && echo 'master' || echo 'dwindle')" #Toggle between dwindle and master layout


#### Fn keys ####

bind = , XF86MonBrightnessUp, exec, brightnessctl -q s +10% && notify-send "Screen Brightness" "$(brightnessctl | grep -o '[0-9]*%' | head -1)" -t 1000  #Increase brightness by 10% 
bind = , XF86MonBrightnessDown, exec, brightnessctl -q s 10%- && notify-send "Screen Brightness" "$(brightnessctl | grep -o '[0-9]*%' | head -1)" -t 1000 #Reduce brightness by 10%
bind = , XF86AudioRaiseVolume, exec, pactl set-sink-mute @DEFAULT_SINK@ 0 && pactl set-sink-volume @DEFAULT_SINK@ +5% && notify-send "Volume" "$(pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]*%' | head -1)" -t 1000
bind = , XF86AudioLowerVolume, exec, pactl set-sink-mute @DEFAULT_SINK@ 0 && pactl set-sink-volume @DEFAULT_SINK@ -5% && notify-send "Volume" "$(pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]*%' | head -1)" -t 1000
bind = , XF86AudioMute, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle && if pactl get-sink-mute @DEFAULT_SINK@ | grep -q 'yes'; then notify-send "Volume" "Muted" -t 1000; else notify-send "Volume" "$(pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]*%' | head -1)" -t 1000; fi
bind = , XF86AudioPlay, exec, playerctl play-pause #Audio play pause
bind = , XF86AudioPause, exec, playerctl pause #Audio pause
bind = , XF86AudioNext, exec, playerctl next #Audio next
bind = , XF86AudioPrev, exec, playerctl previous #Audio previous
bind = , XF86AudioMicMute, exec, pactl set-source-mute @DEFAULT_SOURCE@ toggle #Toggle microphone
bind = , XF86Calculator, exec, ~/.config/hyprcandy/settings/calculator.sh  #Open calculator
bind = , XF86Lock, exec, hyprlock #Open screenlock

# Keyboard backlight controls with notifications
bind = , code:236, exec, brightnessctl -d smc::kbd_backlight s +10 && notify-send "Keyboard Backlight" "$(brightnessctl -d smc::kbd_backlight | grep -o '[0-9]*%' | head -1)" -t 1000
bind = , code:237, exec, brightnessctl -d smc::kbd_backlight s 10- && notify-send "Keyboard Backlight" "$(brightnessctl -d smc::kbd_backlight | grep -o '[0-9]*%' | head -1)" -t 1000

# Screen brightness controls with notifications
bind = Shift, F2, exec, brightnessctl -q s +10% && notify-send "Screen Brightness" "$(brightnessctl | grep -o '[0-9]*%' | head -1)" -t 1000
bind = Shift, F1, exec, brightnessctl -q s 10%- && notify-send "Screen Brightness" "$(brightnessctl | grep -o '[0-9]*%' | head -1)" -t 1000

# Volume mute toggle with notification
bind = Shift, F9, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle && if pactl get-sink-mute @DEFAULT_SINK@ | grep -q 'yes'; then notify-send "Volume" "Muted" -t 1000; else notify-send "Volume" "$(pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]*%' | head -1)" -t 1000; fi

# Volume controls with notifications
bind = Shift, F8, exec, pactl set-sink-mute @DEFAULT_SINK@ 0 && pactl set-sink-volume @DEFAULT_SINK@ +5% && notify-send "Volume" "$(pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]*%' | head -1)" -t 1000
bind = Shift, F7, exec, pactl set-sink-mute @DEFAULT_SINK@ 0 && pactl set-sink-volume @DEFAULT_SINK@ -5% && notify-send "Volume" "$(pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]*%' | head -1)" -t 1000

bind = Shift, F4, exec, playerctl play-pause #Toggle play/pause
bind = Shift, F6, exec, playerctl next #Play next video/song
bind = Shift, F5, exec, playerctl previous #Play previous video/song
EOF

else

            # Add default content to the custom_keybinds.conf file
            cat > "$HOME/.config/hyprcustom/custom_keybinds.conf" << 'EOF'
# ██╗  ██╗███████╗██╗   ██╗██████╗ ██╗███╗   ██╗██████╗ ███████╗
# ██║ ██╔╝██╔════╝╚██╗ ██╔╝██╔══██╗██║████╗  ██║██╔══██╗██╔════╝
# █████╔╝ █████╗   ╚████╔╝ ██████╔╝██║██╔██╗ ██║██║  ██║███████╗
# ██╔═██╗ ██╔══╝    ╚██╔╝  ██╔══██╗██║██║╚██╗██║██║  ██║╚════██║
# ██║  ██╗███████╗   ██║   ██████╔╝██║██║ ╚████║██████╔╝███████║
# ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚═════╝ ╚═╝╚═╝  ╚═══╝╚═════╝ ╚══════╝

#
$mainMod = SUPER
$HYPRSCRIPTS = ~/.config/hypr/scripts
$SCRIPTS = ~/.config/hyprcandy/scripts
$EDITOR = gedit # Change from the default editor to your prefered editor
$DISCORD = equibop
#

#### Kill active window ####

bind = $mainMod, Escape, killactive #Kill single active window
bind = $mainMod SHIFT, Escape, exec, hyprctl activewindow | grep pid | tr -d 'pid:' | xargs kill #Quit active window and all similar open instances

#### Rofi Menus ####

bind = $mainMod CTRL, R, exec, $HYPRSCRIPTS/rofi-menus.sh     #Launch utilities rofi-menu
bind = $mainMod, A, exec, rofi -show drun || pkill rofi      #Launch or kill/hide rofi application finder
bind = $mainMod, K, exec, $HYPRSCRIPTS/keybindings.sh     #Show keybindings
bind = $mainMod CTRL, A, exec, $HYPRSCRIPTS/animations.sh     #Select animations
bind = $mainMod CTRL, V, exec, $SCRIPTS/cliphist.sh     #Open clipboard manager
bind = $mainMod CTRL, E, exec, ~/.config/hyprcandy/settings/emojipicker.sh 		  #Open rofi emoji-picker
bind = $mainMod CTRL, G, exec, ~/.config/hyprcandy/settings/glyphpicker.sh 		  #Open rofi glyph-picker

#### Applications ####

bind = $mainMod, W, exec, waypaper #Waypaper
bind = $mainMod, S, exec, spotify-launcher #Spotify
bind = $mainMod, D, exec, $DISCORD #Discord
bind = $mainMod, C, exec, DRI_PRIME=1 $EDITOR #Editor
bind = $mainMod, B, exec, DRI_PRIME=1 xdg-open "http://" #Launch your default browser
bind = $mainMod, Q, exec, kitty #Launch normal kitty instances
bind = $mainMod, Return, exec, DRI_PRIME=1 pypr toggle term #Launch a kitty scratchpad through pyprland
bind = $mainMod, O, exec, DRI_PRIME=1 /usr/bin/octopi #Launch octopi application finder
bind = $mainMod, E, exec, DRI_PRIME=1 nautilus #Launch the filemanager 
bind = $mainMod CTRL, C, exec, DRI_PRIME=1 gnome-calculator #Launch the calculator

#### Bar/Panel ####

bind = ALT, 1, exec, ~/.config/hyprcandy/hooks/kill_hyprpanel_safe.sh #Hide/kill hyprpanel and start automatic idle-inhibitor
bind = ALT, 2, exec, ~/.config/hyprcandy/hooks/restart_hyprpanel.sh #Restart or reload hyprpanel and stop automatic idle-inhibitor

#### Dock keybinds ####

bind = ALT, 3, exec, $SCRIPTS/toggle-dock.sh --restore #Hide/kill or launch dock
bind = ALT, 4, exec, ~/.config/hyprcandy/hooks/nwg_dock_status_display.sh #Dock status display

#### Status display ####

bind = ALT, 5, exec, ~/.config/hyprcandy/hooks/hyprland_status_display.sh #Hyprland status display

#### Recorder ####

# Wf--recorder (simple recorder) + slurp (allows to select a specific region of the monitor)
# {to list audio devices run "pactl list sources | grep Name"}   
bind = $mainMod, R, exec, bash -c 'wf-recorder -g -a --audio=bluez_output.78_15_2D_0D_BD_B7.1.monitor -f "$HOME/Videos/Recordings/recording-$(date +%Y%m%d-%H%M%S).mp4" $(slurp)' # Start recording
bind = Alt, R, exec, pkill -x wf-recorder #Stop recording

#### Hyprsunset ####

bind = Shift, H, exec, hyprctl hyprsunset gamma +10 #Increase gamma by 10%
bind = Alt, H, exec, hyprctl hyprsunset gamma -10 #Reduce gamma by 10%


#### Actions ####

bind = ALT, G, exec, $HYPRSCRIPTS/gamemode.sh						  #Toggle game-mode
#bind = $mainMod, M, exec, ~/.config/hypr/scripts/power.sh exit 				  #Logout
#bind = $mainMod,SPACE, hyprexpo:expo, toggle						  #Hyprexpo-plus workspaces overview
bind = $mainMod SHIFT, R, exec, $HYPRSCRIPTS/loadconfig.sh                                 #Reload Hyprland configuration
bind = $mainMod SHIFT, A, exec, $HYPRSCRIPTS/toggle-animations.sh                         #Toggle animations
bind = $mainMod, PRINT, exec, $HYPRSCRIPTS/screenshot.sh                                  #Take a screenshot
bind = $mainMod, V, exec, cliphist wipe 						  #Clear cliphist database
bind = $mainMod CTRL, D, exec, $ cliphist list | dmenu | cliphist delete 		  #Delete an old item
bind = $mainMod ALT, D, exec, $ cliphist delete-query "secret item"  			  #Delete an old item quering manually
bind = $mainMod ALT, S, exec, $ cliphist list | dmenu | cliphist decode | wl-copy    	  #Select an old item
bind = $mainMod ALT, O, exec, $HYPRSCRIPTS/window-opacity.sh                              #Change opacity
bind = $mainMod, L, exec, ~/.config/hypr/scripts/power.sh lock 				  #Lock


#### Workspaces ####

bind = SHIFT, TAB, exec, $SCRIPTS/overview.sh #Workspace overview

bind = $mainMod, 1, workspace, 1  #Open workspace 1
bind = $mainMod, 2, workspace, 2  #Open workspace 2
bind = $mainMod, 3, workspace, 3  #Open workspace 3
bind = $mainMod, 4, workspace, 4  #Open workspace 4
bind = $mainMod, 5, workspace, 5  #Open workspace 5
bind = $mainMod, 6, workspace, 6  #Open workspace 6
bind = $mainMod, 7, workspace, 7  #Open workspace 7
bind = $mainMod, 8, workspace, 8  #Open workspace 8
bind = $mainMod, 9, workspace, 9  #Open workspace 9
bind = $mainMod, 0, workspace, 10 #Open workspace 10

bind = $mainMod SHIFT, 1, movetoworkspace, 1  #Move active window to workspace 1
bind = $mainMod SHIFT, 2, movetoworkspace, 2  #Move active window to workspace 2
bind = $mainMod SHIFT, 3, movetoworkspace, 3  #Move active window to workspace 3
bind = $mainMod SHIFT, 4, movetoworkspace, 4  #Move active window to workspace 4
bind = $mainMod SHIFT, 5, movetoworkspace, 5  #Move active window to workspace 5
bind = $mainMod SHIFT, 6, movetoworkspace, 6  #Move active window to workspace 6
bind = $mainMod SHIFT, 7, movetoworkspace, 7  #Move active window to workspace 7
bind = $mainMod SHIFT, 8, movetoworkspace, 8  #Move active window to workspace 8
bind = $mainMod SHIFT, 9, movetoworkspace, 9  #Move active window to workspace 9
bind = $mainMod SHIFT, 0, movetoworkspace, 10 #Move active window to workspace 10

bind = $mainMod, Tab, workspace, m+1       #Open next workspace
bind = $mainMod SHIFT, Tab, workspace, m-1 #Open previous workspace

bind = $mainMod CTRL, 1, exec, $HYPRSCRIPTS/moveTo.sh 1  #Move all windows to workspace 1
bind = $mainMod CTRL, 2, exec, $HYPRSCRIPTS/moveTo.sh 2  #Move all windows to workspace 2
bind = $mainMod CTRL, 3, exec, $HYPRSCRIPTS/moveTo.sh 3  #Move all windows to workspace 3
bind = $mainMod CTRL, 4, exec, $HYPRSCRIPTS/moveTo.sh 4  #Move all windows to workspace 4
bind = $mainMod CTRL, 5, exec, $HYPRSCRIPTS/moveTo.sh 5  #Move all windows to workspace 5
bind = $mainMod CTRL, 6, exec, $HYPRSCRIPTS/moveTo.sh 6  #Move all windows to workspace 6
bind = $mainMod CTRL, 7, exec, $HYPRSCRIPTS/moveTo.sh 7  #Move all windows to workspace 7
bind = $mainMod CTRL, 8, exec, $HYPRSCRIPTS/moveTo.sh 8  #Move all windows to workspace 8
bind = $mainMod CTRL, 9, exec, $HYPRSCRIPTS/moveTo.sh 9  #Move all windows to workspace 9
bind = $mainMod CTRL, 0, exec, $HYPRSCRIPTS/moveTo.sh 10  #Move all windows to workspace 10

bind = $mainMod, mouse_down, workspace, e+1  #Open next workspace
bind = $mainMod, mouse_up, workspace, e-1    #Open previous workspace
bind = $mainMod CTRL, down, workspace, empty #Open the next empty workspace

#### Minimize windows using special workspaces ####

bind = CTRL SHIFT, 1, togglespecialworkspace, magic #Togle window from special workspace
bind = CTRL SHIFT, 2, movetoworkspace, +0 #Move window to special workspace 2 (Can be toggled with "$mainMod,1")
bind = CTRL SHIFT, 3, togglespecialworkspace, magic #Togle window to and from special workspace
bind = CTRL SHIFT, 4, movetoworkspace, special:magic #Move window to special workspace 4 (Can be toggled with "$mainMod,1")
bind = CTRL SHIFT, 5, togglespecialworkspace, magic #Togle window to and from special workspace


#### Windows ####

bind = $mainMod ALT, 1, movetoworkspacesilent, 1  #Move active window to workspace 1 silently
bind = $mainMod ALT, 2, movetoworkspacesilent, 2  #Move active window to workspace 2 silently
bind = $mainMod ALT, 3, movetoworkspacesilent, 3  #Move active window to workspace 3 silently
bind = $mainMod ALT, 4, movetoworkspacesilent, 4  #Move active window to workspace 4 silently
bind = $mainMod ALT, 5, movetoworkspacesilent, 5  #Move active window to workspace 5 silently
bind = $mainMod ALT, 6, movetoworkspacesilent, 6  #Move active window to workspace 6 silently
bind = $mainMod ALT, 7, movetoworkspacesilent, 7  #Move active window to workspace 7 silently
bind = $mainMod ALT, 8, movetoworkspacesilent, 8  #Move active window to workspace 8 silently
bind = $mainMod ALT, 9, movetoworkspacesilent, 9  #Move active window to workspace 9 silently
bind = $mainMod ALT, 0, movetoworkspacesilent, 10  #Move active window to workspace 10 silently 

bindm = $mainMod, Z, movewindow #Hold to move selected window
bindm = $mainMod, X, resizewindow #Hold to resize selected window

bind = $mainMod, F, fullscreen, 0                                                           #Set active window to fullscreen
bind = $mainMod SHIFT, M, fullscreen, 1                                                           #Maximize Window
bind = $mainMod CTRL, F, togglefloating                                                     #Toggle active windows into floating mode
bind = $mainMod CTRL, T, exec, $HYPRSCRIPTS/toggleallfloat.sh                               #Toggle all windows into floating mode
bind = $mainMod, J, togglesplit                                                             #Toggle split
bind = $mainMod, left, movefocus, l                                                         #Move focus left
bind = $mainMod, right, movefocus, r                                                        #Move focus right
bind = $mainMod, up, movefocus, u                                                           #Move focus up
bind = $mainMod, down, movefocus, d                                                         #Move focus down
bindm = $mainMod, mouse:272, movewindow                                                     #Move window with the mouse
bindm = $mainMod, mouse:273, resizewindow                                                   #Resize window with the mouse
bind = $mainMod SHIFT, right, resizeactive, 100 0                                           #Increase window width with keyboard
bind = $mainMod SHIFT, left, resizeactive, -100 0                                           #Reduce window width with keyboard
bind = $mainMod SHIFT, down, resizeactive, 0 100                                            #Increase window height with keyboard
bind = $mainMod SHIFT, up, resizeactive, 0 -100                                             #Reduce window height with keyboard
bind = $mainMod, G, togglegroup                                                             #Toggle window group
bind = $mainMod CTRL, left, changegroupactive, prev				  	    #Switch to the previous window in the group
bind = $mainMod CTRL, right, changegroupactive, next					    #Switch to the next window in the group
bind = $mainMod CTRL, K, swapsplit                                                               #Swapsplit
bind = $mainMod ALT, left, swapwindow, l                                                    #Swap tiled window left
bind = $mainMod ALT, right, swapwindow, r                                                   #Swap tiled window right
bind = $mainMod ALT, up, swapwindow, u                                                      #Swap tiled window up
bind = $mainMod ALT, down, swapwindow, d                                                    #Swap tiled window down
binde = ALT,Tab,cyclenext                                                                   #Cycle between windows
binde = ALT,Tab,bringactivetotop                                                            #Bring active window to the top
bind = ALT, S, layoutmsg, swapwithmaster master 					    #Switch current focused window to master
bind = $mainMod SHIFT, L, exec, hyprctl keyword general:layout "$(hyprctl getoption general:layout | grep -q 'dwindle' && echo 'master' || echo 'dwindle')" #Toggle between dwindle and master layout


#### Fn keys ####

bind = , XF86MonBrightnessUp, exec, brightnessctl -q s +10% && notify-send "Screen Brightness" "$(brightnessctl | grep -o '[0-9]*%' | head -1)" -t 1000  #Increase brightness by 10% 
bind = , XF86MonBrightnessDown, exec, brightnessctl -q s 10%- && notify-send "Screen Brightness" "$(brightnessctl | grep -o '[0-9]*%' | head -1)" -t 1000 #Reduce brightness by 10%
bind = , XF86AudioRaiseVolume, exec, pactl set-sink-mute @DEFAULT_SINK@ 0 && pactl set-sink-volume @DEFAULT_SINK@ +5% && notify-send "Volume" "$(pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]*%' | head -1)" -t 1000
bind = , XF86AudioLowerVolume, exec, pactl set-sink-mute @DEFAULT_SINK@ 0 && pactl set-sink-volume @DEFAULT_SINK@ -5% && notify-send "Volume" "$(pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]*%' | head -1)" -t 1000
bind = , XF86AudioMute, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle && if pactl get-sink-mute @DEFAULT_SINK@ | grep -q 'yes'; then notify-send "Volume" "Muted" -t 1000; else notify-send "Volume" "$(pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]*%' | head -1)" -t 1000; fi
bind = , XF86AudioPlay, exec, playerctl play-pause #Audio play pause
bind = , XF86AudioPause, exec, playerctl pause #Audio pause
bind = , XF86AudioNext, exec, playerctl next #Audio next
bind = , XF86AudioPrev, exec, playerctl previous #Audio previous
bind = , XF86AudioMicMute, exec, pactl set-source-mute @DEFAULT_SOURCE@ toggle #Toggle microphone
bind = , XF86Calculator, exec, ~/.config/hyprcandy/settings/calculator.sh  #Open calculator
bind = , XF86Lock, exec, hyprlock #Open screenlock

# Keyboard backlight controls with notifications
bind = , code:236, exec, brightnessctl -d smc::kbd_backlight s +10 && notify-send "Keyboard Backlight" "$(brightnessctl -d smc::kbd_backlight | grep -o '[0-9]*%' | head -1)" -t 1000
bind = , code:237, exec, brightnessctl -d smc::kbd_backlight s 10- && notify-send "Keyboard Backlight" "$(brightnessctl -d smc::kbd_backlight | grep -o '[0-9]*%' | head -1)" -t 1000

# Screen brightness controls with notifications
bind = Shift, F2, exec, brightnessctl -q s +10% && notify-send "Screen Brightness" "$(brightnessctl | grep -o '[0-9]*%' | head -1)" -t 1000
bind = Shift, F1, exec, brightnessctl -q s 10%- && notify-send "Screen Brightness" "$(brightnessctl | grep -o '[0-9]*%' | head -1)" -t 1000

# Volume mute toggle with notification
bind = Shift, F9, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle && if pactl get-sink-mute @DEFAULT_SINK@ | grep -q 'yes'; then notify-send "Volume" "Muted" -t 1000; else notify-send "Volume" "$(pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]*%' | head -1)" -t 1000; fi

# Volume controls with notifications
bind = Shift, F8, exec, pactl set-sink-mute @DEFAULT_SINK@ 0 && pactl set-sink-volume @DEFAULT_SINK@ +5% && notify-send "Volume" "$(pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]*%' | head -1)" -t 1000
bind = Shift, F7, exec, pactl set-sink-mute @DEFAULT_SINK@ 0 && pactl set-sink-volume @DEFAULT_SINK@ -5% && notify-send "Volume" "$(pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]*%' | head -1)" -t 1000

bind = Shift, F4, exec, playerctl play-pause #Toggle play/pause
bind = Shift, F6, exec, playerctl next #Play next video/song
bind = Shift, F5, exec, playerctl previous #Play previous video/song
EOF
fi

    # 🎨 Update Hyprland custom.conf with current username  
    USERNAME=$(whoami)      
    HYPRLAND_CUSTOM="$HOME/.config/hypr/hyprviz.conf"
    echo "🎨 Updating Hyprland custom.conf with current username..."		
    
    if [ -f "$HYPRLAND_CUSTOM" ]; then
        sed -i "s|\$USERNAME|$USERNAME|g" "$HYPRLAND_CUSTOM"
        echo "✅ Updated custom.conf PATH with username: $USERNAME"
    else
        echo "⚠️  File not found: $HYPRLAND_CUSTOM"
    fi
        fi
}

update_keybinds() {
    local CONFIG_FILE="$HOME/.config/hyprcustom/custom_keybinds.conf"
    
    # Check if config file exists
    if [ ! -f "$CONFIG_FILE" ]; then
        print_error "Config file not found: $CONFIG_FILE"
        return 1
    fi
    
    # Optional: Create backup (uncomment if needed)
    # cp "$CONFIG_FILE" "${CONFIG_FILE}.backup.$(date +%Y%m%d_%H%M%S)"
    # echo -e "${GREEN}Backup created${NC}"
    
    # Check current panel configuration to avoid unnecessary changes
    if grep -q "waybar" "$CONFIG_FILE" && [ "$PANEL_CHOICE" = "waybar" ]; then
        print_warning "Keybinds already set for waybar"
        return 0
    elif grep -q "hyprpanel" "$CONFIG_FILE" && [ "$PANEL_CHOICE" = "hyprpanel" ]; then
        print_warning "Keybinds already set for hyprpanel"
        return 0
    fi
    
    if [ "$PANEL_CHOICE" = "waybar" ]; then
        # Replace hyprpanel with waybar
        sed -i 's/hyprpanel/waybar/g' "$CONFIG_FILE"
        # Also update specific script paths that might reference hyprpanel
        sed -i 's/kill_hyprpanel_safe\.sh/kill_waybar_safe.sh/g' "$CONFIG_FILE"
        sed -i 's/restart_hyprpanel\.sh/restart_waybar.sh/g' "$CONFIG_FILE"
        echo -e "${GREEN}Updated keybinds for waybar${NC}"
    else
        # Replace waybar with hyprpanel
        sed -i 's/waybar/hyprpanel/g' "$CONFIG_FILE"
        # Also update specific script paths that might reference waybar
        sed -i 's/kill_waybar_safe\.sh/kill_hyprpanel_safe.sh/g' "$CONFIG_FILE"
        sed -i 's/restart_waybar\.sh/restart_hyprpanel.sh/g' "$CONFIG_FILE"
        echo -e "${GREEN}Updated keybinds for hyprpanel${NC}"
    fi
}

update_custom() {
    local CUSTOM_CONFIG_FILE="$HOME/.config/hypr/hyprviz.conf"
    
    # Check if custom config file exists
    if [ ! -f "$CUSTOM_CONFIG_FILE" ]; then
        print_error "Custom config file not found: $CUSTOM_CONFIG_FILE"
        return 1
    fi
    
    # Optional: Create backup (uncomment if needed)
    # cp "$CUSTOM_CONFIG_FILE" "${CUSTOM_CONFIG_FILE}.backup.$(date +%Y%m%d_%H%M%S)"
    # echo -e "${GREEN}Custom config backup created${NC}"
    
    if [ "$PANEL_CHOICE" = "waybar" ]; then
        # Replace bar-0 with waybar in layer rules
        sed -i '18s/exec-once = systemctl --user start hyprpanel/exec-once = waybar \&/g' "$CUSTOM_CONFIG_FILE"
        sed -i '22s/exec-once = systemctl --user start hyprpanel-idle-monitor/exec-once = systemctl --user start waybar-idle-monitor/g' "$CUSTOM_CONFIG_FILE"
        
        # Handle awww-daemon line - uncomment if commented
        if grep -q "^#.*exec-once = awww-daemon &" "$CUSTOM_CONFIG_FILE"; then
            # Line is commented, uncomment it
            sed -i 's/^#\+\s*exec-once = awww-daemon &/exec-once = awww-daemon \&/g' "$CUSTOM_CONFIG_FILE"
        elif ! grep -q "^exec-once = awww-daemon &" "$CUSTOM_CONFIG_FILE"; then
            # Line doesn't exist at all, add it (optional - you might want to handle this case)
            echo "exec-once = awww-daemon &" >> "$CUSTOM_CONFIG_FILE"
        fi
        sed -i 's/layerrule = blur,bar-0/layerrule = blur,waybar/g' "$CUSTOM_CONFIG_FILE"
        sed -i 's/layerrule = ignorezero,bar-0/layerrule = ignorezero,waybar/g' "$CUSTOM_CONFIG_FILE"
        echo -e "${GREEN}Updated custom config layer rules for waybar${NC}"
    else
        # Replace bar-0 with hyprpanel in layer rules
        sed -i '18s/exec-once = waybar \&/exec-once = systemctl --user start hyprpanel/g' "$CUSTOM_CONFIG_FILE"
        sed -i '22s/exec-once = systemctl --user start waybar-idle-monitor/exec-once = systemctl --user start hyprpanel-idle-monitor/g' "$CUSTOM_CONFIG_FILE"
        
        # Handle awww-daemon line - comment if uncommented
        if grep -q "^exec-once = awww-daemon &" "$CUSTOM_CONFIG_FILE"; then
            # Line is uncommented, comment it
            sed -i 's/^exec-once = awww-daemon &#exec-once = awww-daemon \&/g' "$CUSTOM_CONFIG_FILE"
        fi
        
        sed -i 's/exec-once = awww-daemon &/#exec-once = awww-daemon \&/g' "$CUSTOM_CONFIG_FILE"
        sed -i 's/layerrule = blur,waybar/layerrule = blur,bar-0/g' "$CUSTOM_CONFIG_FILE"
        sed -i 's/layerrule = ignorezero,waybar/layerrule = ignorezero,bar-0/g' "$CUSTOM_CONFIG_FILE"
        echo -e "${GREEN}Updated custom config layer rules for hyprpanel${NC}"
    fi
}

setup_gjs() {
# Create the GJS directory and files if they don't already exist
if [ ! -d "$HOME/.hyprcandy/GJS/src" ]; then
    mkdir -p "$HOME/.hyprcandy/GJS/src"
    echo "📁 Created the GJS directory"
fi

cd "$HOME/.hyprcandy/GJS"
rm -f toggle-control-center.sh toggle-media-player.sh toggle-system-monitor.sh toggle-weather-widget.sh
cd "$HOME"

cat > "$HOME/.hyprcandy/GJS/toggle-control-center.sh" << 'EOF'
#!/bin/bash

# Toggle Candy Utils - Fast launch (daemon stays running)
# No killing - daemon persists for instant widget launches

PID_FILE="$HOME/.cache/hyprcandy/pids/candy-daemon.pid"
DAEMON_SCRIPT="$HOME/.hyprcandy/GJS/candy-daemon.js"
TOGGLE_DIR="$HOME/.cache/hyprcandy/toggle"

mkdir -p "$TOGGLE_DIR"

# Start daemon if not running (0.3s sleep for faster launch)
if ! [ -f "$PID_FILE" ] || ! kill -0 "$(cat "$PID_FILE" 2>/dev/null)" 2>/dev/null; then
    gjs "$DAEMON_SCRIPT" &
    sleep 0.3
fi

# Toggle widget
touch "$TOGGLE_DIR/toggle-utils"
EOF
chmod +x "$HOME/.hyprcandy/GJS/toggle-control-center.sh"

cat > "$HOME/.hyprcandy/GJS/toggle-system-monitor.sh" << 'EOF'
#!/bin/bash

# Toggle System Monitor - Fast launch (daemon stays running)

PID_FILE="$HOME/.cache/hyprcandy/pids/candy-daemon.pid"
DAEMON_SCRIPT="$HOME/.hyprcandy/GJS/candy-daemon.js"
TOGGLE_DIR="$HOME/.cache/hyprcandy/toggle"

mkdir -p "$TOGGLE_DIR"

if ! [ -f "$PID_FILE" ] || ! kill -0 "$(cat "$PID_FILE" 2>/dev/null)" 2>/dev/null; then
    gjs "$DAEMON_SCRIPT" &
    sleep 0.3
fi

touch "$TOGGLE_DIR/toggle-system"
EOF
chmod +x "$HOME/.hyprcandy/GJS/toggle-system-monitor.sh"

cat > "$HOME/.hyprcandy/GJS/toggle-media-player.sh" << 'EOF'
#!/bin/bash

# Toggle Media Player - Fast launch (daemon stays running)

PID_FILE="$HOME/.cache/hyprcandy/pids/candy-daemon.pid"
DAEMON_SCRIPT="$HOME/.hyprcandy/GJS/candy-daemon.js"
TOGGLE_DIR="$HOME/.cache/hyprcandy/toggle"

mkdir -p "$TOGGLE_DIR"

if ! [ -f "$PID_FILE" ] || ! kill -0 "$(cat "$PID_FILE" 2>/dev/null)" 2>/dev/null; then
    gjs "$DAEMON_SCRIPT" &
    sleep 0.3
fi

touch "$TOGGLE_DIR/toggle-media"
EOF
chmod +x "$HOME/.hyprcandy/GJS/toggle-media-player.sh"

cat > "$HOME/.hyprcandy/GJS/toggle-weather-widget.sh" << 'EOF'
#!/bin/bash

# Toggle Weather Widget - Fast launch (daemon stays running)

PID_FILE="$HOME/.cache/hyprcandy/pids/candy-daemon.pid"
DAEMON_SCRIPT="$HOME/.hyprcandy/GJS/candy-daemon.js"
TOGGLE_DIR="$HOME/.cache/hyprcandy/toggle"

mkdir -p "$TOGGLE_DIR"

if ! [ -f "$PID_FILE" ] || ! kill -0 "$(cat "$PID_FILE" 2>/dev/null)" 2>/dev/null; then
    gjs "$DAEMON_SCRIPT" &
    sleep 0.3
fi

touch "$TOGGLE_DIR/toggle-weather"
EOF
chmod +x "$HOME/.hyprcandy/GJS/toggle-weather-widget.sh"

find "$HOME/.hyprcandy/GJS" -name "*.sh" -exec chmod +x {} \;
chmod +x "$HOME/.hyprcandy/GJS/candy-daemon.js"

echo "✅ Files and Apps setup complete"
}

# Function to setup keyboard layout
setup_keyboard_layout() {
    # Keyboard layout selection
    echo
    print_status "Keyboard Layout Configuration"
    echo "Select your keyboard layout (this will be applied to Hyprland):"
    echo "1) us - United States (default)"
    echo "2) gb - United Kingdom"
    echo "3) de - Germany"
    echo "4) fr - France"
    echo "5) es - Spain"
    echo "6) it - Italy"
    echo "7) cn - China"
    echo "8) ru - Russia"
    echo "9) jp - Japan"
    echo "10) kr - South Korea"
    echo "11) ar - Arabic"
    echo "12) il - Israel"
    echo "13) in - India"
    echo "14) tr - Turkey"
    echo "15) uz - Uzbekistan"
    echo "16) br - Brazil"
    echo "17) no - Norway"
    echo "18) pl - Poland"
    echo "19) nl - Netherlands"
    echo "20) se - Sweden"
    echo "21) fi - Finland"
    echo "22) custom - Enter your own layout code"
    echo
    echo -e "${CYAN}Note: For other countries not listed above, use option 22 (custom)${NC}"
    echo -e "${CYAN}Common examples: 'dvorak', 'colemak', 'ca' (Canada), 'au' (Australia), etc.${NC}"
    echo
    
    KEYBOARD_LAYOUT="us"  # Default layout
    
    while true; do
        echo -e "${YELLOW}Enter your choice (1-22, or press Enter for default 'us'):${NC}"
        read -r layout_choice
        
        # If empty input, use default
        if [ -z "$layout_choice" ]; then
            layout_choice=1
        fi
        
        case $layout_choice in
            1)
                KEYBOARD_LAYOUT="us"
                print_status "Selected: United States (us)"
                break
                ;;
            2)
                KEYBOARD_LAYOUT="gb"
                print_status "Selected: United Kingdom (gb)"
                break
                ;;
            3)
                KEYBOARD_LAYOUT="de"
                print_status "Selected: Germany (de)"
                break
                ;;
            4)
                KEYBOARD_LAYOUT="fr"
                print_status "Selected: France (fr)"
                break
                ;;
            5)
                KEYBOARD_LAYOUT="es"
                print_status "Selected: Spain (es)"
                break
                ;;
            6)
                KEYBOARD_LAYOUT="it"
                print_status "Selected: Italy (it)"
                break
                ;;
            7)
                KEYBOARD_LAYOUT="cn"
                print_status "Selected: China (cn)"
                break
                ;;
            8)
                KEYBOARD_LAYOUT="ru"
                print_status "Selected: Russia (ru)"
                break
                ;;
            9)
                KEYBOARD_LAYOUT="jp"
                print_status "Selected: Japan (jp)"
                break
                ;;
            10)
                KEYBOARD_LAYOUT="kr"
                print_status "Selected: South Korea (kr)"
                break
                ;;
            11)
                KEYBOARD_LAYOUT="ar"
                print_status "Selected: Arabic (ar)"
                break
                ;;
            12)
                KEYBOARD_LAYOUT="il"
                print_status "Selected: Israel (il)"
                break
                ;;
            13)
                KEYBOARD_LAYOUT="in"
                print_status "Selected: India (in)"
                break
                ;;
            14)
                KEYBOARD_LAYOUT="tr"
                print_status "Selected: Turkey (tr)"
                break
                ;;
            15)
                KEYBOARD_LAYOUT="uz"
                print_status "Selected: Uzbekistan (uz)"
                break
                ;;
            16)
                KEYBOARD_LAYOUT="br"
                print_status "Selected: Brazil (br)"
                break
                ;;
            17)
                KEYBOARD_LAYOUT="no"
                print_status "Selected: Norway (no)"
                break
                ;;
            18)
                KEYBOARD_LAYOUT="pl"
                print_status "Selected: Poland (pl)"
                break
                ;;
            19)
                KEYBOARD_LAYOUT="nl"
                print_status "Selected: Netherlands (nl)"
                break
                ;;
            20)
                KEYBOARD_LAYOUT="se"
                print_status "Selected: Sweden (se)"
                break
                ;;
            21)
                KEYBOARD_LAYOUT="fi"
                print_status "Selected: Finland (fi)"
                break
                ;;
            22)
                echo -e "${YELLOW}Enter your custom keyboard layout code (e.g., 'dvorak', 'colemak', 'ca', 'au'):${NC}"
                read -r custom_layout
                if [ -n "$custom_layout" ]; then
                    KEYBOARD_LAYOUT="$custom_layout"
                    print_status "Selected: Custom layout ($custom_layout)"
                    break
                else
                    print_error "Custom layout cannot be empty. Please try again."
                fi
                ;;
            *)
                print_error "Invalid choice. Please enter a number between 1-22."
                ;;
        esac
    done
    
        # Apply the keyboard layout to the custom.conf file
    CUSTOM_CONFIG_FILE="$HOME/.config/hypr/hyprviz.conf"
    
    if [ -f "$CUSTOM_CONFIG_FILE" ]; then
        sed -i "s/\$LAYOUT/$KEYBOARD_LAYOUT/g" "$CUSTOM_CONFIG_FILE"
        print_status "Keyboard layout '$KEYBOARD_LAYOUT' has been applied to custom.conf"
    else
        print_error "Custom config file not found at $CUSTOM_CONFIG_FILE"
        print_error "Please run setup_custom_config() first"
    fi

# WAYLAND_DISPLAY is inherited from the Hyprland session when called correctly.
# If somehow unset, derive it from the running compositor socket.
if [ -z "$WAYLAND_DISPLAY" ]; then
    export WAYLAND_DISPLAY=$(ls /run/user/$(id -u)/wayland-* 2>/dev/null | head -1 | xargs -I{} basename {})
fi
pgrep -x awww-daemon > /dev/null 2>&1 || awww-daemon &
sleep 1
# Wait for awww-daemon socket — it may still be starting up
RETRIES=10
until timeout 2 awww query &>/dev/null || [ $RETRIES -eq 0 ]; do
    sleep 1
    (( RETRIES-- ))
done

# Start the correct services

echo "🔄 Setting up services..."
systemctl --user daemon-reload

if [ "$PANEL_CHOICE" = "waybar" ]; then
    systemctl --user restart rofi-font-watcher.service cursor-theme-watcher.service &>/dev/null
else
    systemctl --user restart hyprpanel-idle-monitor.service background-watcher.service rofi-font-watcher.service cursor-theme-watcher.service &>/dev/null
fi
sudo systemctl enable switcheroo-control
sudo systemctl enable bluetooth
echo "✅ Services set..."

if timeout 2 awww query &>/dev/null; then
  	awww img "$(grep '^wallpaper' ~/.config/wallpaper/wallpaper.ini | cut -d= -f2 | sed "s|^ *||;s|^~|$HOME|")"
	sleep 1
    bash "$HOME/.config/hyprcandy/hooks/wallpaper_integration.sh" 2>&1 &
    echo "✅ Initial background set"
	sleep 0.5
	qs -c bar >/dev/null 2>&1 &
	gjs "$HOME/.hyprcandy/GJS/candy-daemon.js" 2>&1 &
	gjs "$HOME/.hyprcandy/GJS/hyprcandydock/daemon.js" 2>&1 &
	bash "$HOME/.hyprcandy/GJS/hyprcandydock/autostart.sh" 2>&1 &
else
    echo "Setting background..."
	awww-daemon
	sleep 1
	awww img "$(grep '^wallpaper' ~/.config/wallpaper/wallpaper.ini | cut -d= -f2 | sed "s|^ *||;s|^~|$HOME|")"
	sleep 1
	bash "$HOME/.config/hyprcandy/hooks/wallpaper_integration.sh" 2>&1 &
    echo "✅ Initial background set"
	sleep 0.5
	qs -c bar >/dev/null 2>&1 &
	gjs "$HOME/.hyprcandy/GJS/candy-daemon.js" 2>&1 &
	gjs "$HOME/.hyprcandy/GJS/hyprcandydock/daemon.js" 2>&1 &
	bash "$HOME/.hyprcandy/GJS/hyprcandydock/autostart.sh" 2>&1 &
fi

    # 🔄 Reload Hyprland
    echo
    echo "🔄 Reloading Hyprland with 'hyprctl reload'..."
    if command -v hyprctl > /dev/null 2>&1; then
        if pgrep -x "Hyprland" > /dev/null; then
            hyprctl reload && echo "✅ Hyprland reloaded successfully." || echo "❌ Failed to reload Hyprland."
        else
            echo "ℹ️  Hyprland is not currently running. Configuration will be applied on next start and Hyprland login."
        fi
    else
        echo "⚠️  'hyprctl' not found. Skipping Hyprland reload. Run 'hyprctl reload' on next start and Hyprland login."
    fi

# Only create sentinel if xray is actually on in the running config
#XRAY_STATE=$(hyprctl getoption decoration:blur:xray -j 2>/dev/null | jq -r '.int // .value // 0')
#if [ "$XRAY_STATE" = "1" ]; then
    #touch "$HOME/.config/hyprcandy/settings/xray-on"
#else
    #rm -f "$HOME/.config/hyprcandy/settings/xray-on"
#fi

    print_success "HyprCandy configuration setup completed!"  
}

# Function to prompt for reboot
prompt_reboot() {
    echo
    print_success "Installation and configuration completed!"
    print_status "All packages have been installed and Hyprcandy configurations have been deployed."
    print_status "The $DISPLAY_MANAGER display manager has been enabled."
    echo
    print_warning "Reboot is recommended on new installs to ensure all changes take effect properly."
    echo
    echo -e "${YELLOW}Would you like to reboot now? (n/Y)${NC}"
    read -r reboot_choice
    case "$reboot_choice" in
        [nN][oO]|[nN])
            echo "✅ Installation complete (reboot post install is advised)..."
            sleep 4
            nohup bash "$HOME/.config/hyprcandy/hooks/complete.sh" > /dev/null 2>&1 &
            return 0
            ;;
        *)
            print_status "Restarting system..."
            sleep 2
            bash -c "rm -rf ~/candyinstall"
			sleep 0.5
			systemctl reboot
            ;;
    esac
}

# Main execution
main() {
    # Show multicolored ASCII art
    show_ascii_art
    
    print_status "This installer will set up a complete Hyprland environment with:"
    echo "  • Hyprland window manager and ecosystem"
    echo "  • Essential applications and utilities"
    echo "  • Pre-configured HyprCandy dotfiles"
    echo "  • Dynamically colored Hyprland environment"
    echo "  • Your choice of display manager (SDDM or GDM)"
    echo "  • Your choice of shell (Fish or Zsh) with comprehensive configuration"
    echo
    
    # Choose shell
    choose_shell
    echo

    # Choose a browser
    choose_browser
    echo

    # Decide whether to install libroffice-fresh suite
    install_libreoffice
    echo
    
    # Check for AUR helper or install one
    check_or_install_aur_helper
    
    echo
    print_status "Using $AUR_HELPER as AUR helper"
    
    # Build package list based on display manager and shell choice
    build_package_list
    
    # Ask for confirmation
    echo -e "${YELLOW}This will install ${#packages[@]} packages and setup HyprCandy configuration. Continue? (n/Y)${NC}"
    read -r response
    case "$response" in
        [nN][oO]|[nN])
            print_status "Installation cancelled."
            exit 0
            ;;
        *)
            install_packages
            ;;
    esac
    
    echo
    print_status "Package installation completed!"

     # Setup shell configuration
    echo
    print_status "Setting up shell configuration..."
    if [ "$SHELL_CHOICE" = "fish" ]; then
        setup_fish
    elif [ "$SHELL_CHOICE" = "zsh" ]; then
        setup_zsh
    fi
    
    # Automatically setup HyprCandy configuration
    print_status "Proceeding with HyprCandy configuration setup..."
    setup_hyprcandy
    
    # Enable display manager
    enable_display_manager

    # Setup default "custom.conf" file
    setup_custom_config

    # Update keybinds based on choice
    update_keybinds
    
    # Update custom config based on choice
    update_custom

    # Setup GJS
    setup_gjs

    # Setup keyboard layout
    setup_keyboard_layout
    
    # Configuration management tips
    echo
    print_status "Configuration management tips:"
    print_status "• Your HyprCandy configs are in: ~/.hyprcandy/"
    print_status "• Minor updates: cd ~/.hyprcandy && git pull && stow */"
    print_status "• Major updates: rerun the install script for updated apps and configs"
    print_status "• To remove a config: cd ~/.hyprcandy && stow -D <config_name> -t $HOME"
    print_status "• To reinstall a config: cd ~/.hyprcandy && stow -R <config_name> -t $HOME"
    
    # Display and wallpaper configuration notes
    echo
    echo -e "${CYAN}════════════════════════════════════════════════════════════════════════════════════════════════════════════${NC}"
    echo -e "${WHITE}                              🖥️  Post-Installation Configuration  🖼️${NC}"
    echo -e "${CYAN}════════════════════════════════════════════════════════════════════════════════════════════════════════════${NC}"
    echo
    print_status "After rebooting, you may want to configure the following:"
    echo
    echo -e "${PURPLE}📱 Display Configuration:${NC}"
    print_status "• Use ${YELLOW}nwg-displays${NC} to configure monitor scaling, resolution, and positioning"
    print_status "• Launch it from the application menu or run: ${CYAN}nwg-displays${NC}"
    print_status "• Adjust scaling for HiDPI displays if needed"
    echo
    echo -e "${PURPLE}🐚 Zsh Configuration:${NC}"
    print_status "• IMPORTANT: If you chose Zsh-shell then use ${CYAN}SUPER + Q${NC} to toggle Kitty and go through the Zsh setup"
    print_status "• IMPORTANT: (Remember to type ${YELLOW}n${NC}o at the end when asked to Apply changes to .zshrc since HyprCandy already has them applied)"
    print_status "• To configure Zsh, in the ${CYAN}Home${NC} directory edit ${CYAN}.hyprcandy-zsh.zsh${NC} or ${CYAN}.zshrc${NC}"
    print_status "• You can also rerun the script to switch from either one or regenerate HyprCandy's default Zsh shell setup"
    print_status "• You can also rerun the script to install Fish shell"
    print_status "• When both are installed switch at anytime by running ${CYAN}chsh -s /usr/bin/<name of shell>${NC} then reboot"
    echo
    echo -e "${PURPLE}🖼️ Wallpaper Setup (Hyprpanel):${NC}"
    print_status "• Through Hyprpanel's configuration interface in the ${CYAN}Theming${NC} section do the following:"
    print_status "• Under ${YELLOW}General Settings${NC} choose a wallpaper to apply where it says None"
    print_status "• Find default wallpapers check the ${CYAN}~/Pictures/Candy${NC} or ${CYAN}Candy${NC} folder"
    print_status "• Under ${YELLOW}Matugen Settings${NC} toggle the button to enable matugen color application"
    print_status "• If the wallpaper doesn't apply through the configuration interface, then toggle the button to apply wallpapers"
    print_status "• Ths will quickly reset awww and apply the background"
    print_status "• Remember to reload the dock with ${CYAN}SHIFT + K${NC} to update its colors"
    echo
    echo -e "${PURPLE}🎨 Font, Icon And Cursor Theming:${NC}"
    print_status "• Open the application-finder with SUPER + A and search for ${YELLOW}GTK Settings${NC} application"
    print_status "• Prefered font to set through nwg-look is ${CYAN}JetBrainsMono Nerd Font Propo Regular${NC} at size ${CYAN}10${NC}"
    print_status "• Use ${YELLOW}nwg-look${NC} to configure the system-font, tela-icons and cursor themes"
    print_status "• Cursor themes take effect after loging out and back in"
    echo
    echo -e "${PURPLE}🐟 Fish Configuration:${NC}"
    print_status "• To configure Fish edit, in the ${YELLOW}~/.config/fish${NC} directory edit the ${YELLOW}config.fish${NC} file"
    print_status "• You can also rerun the script to switch from either one or regenerate HyprCandy's default Fish shell setup"
    print_status "• You can also rerun the script to install Zsh shell"
    print_status "• When both are installed switch by running ${CYAN}chsh -s /usr/bin/<name of shell>${NC} then reboot"
    echo
    echo -e "${PURPLE}🔎 Browser Color Theming:${NC}"
    print_status "• If you chose Brave, go to ${YELLOW}Appearance${NC} in Settings and set the 'Theme' to ${CYAN}GTK${NC} and Brave colors to Same as Linux"
    print_status "• If you chose Firefox, install the ${YELLOW}pywalfox${NC} extension and run ${YELLOW}pywalfox update${NC} in kitty"
    print_status "• If you chose Zen Browser, for slight additional theming install the ${YELLOW}pywalfox${NC} extension and run ${YELLOW}pywalfox update${NC}"
    print_status "• If you chose Librewolf, you know what you're doing"
    echo
    echo -e "${PURPLE}🏠 Clean Home Directory:${NC}"
    print_status "• You can delete any stowed symlinks made in the 'Home' directory"
    echo
    echo -e "${CYAN}════════════════════════════════════════════════════════════════════════════════════════════════════════════${NC}"
    
    # Prompt for reboot
    prompt_reboot
}

# Run main function
main "$@"
