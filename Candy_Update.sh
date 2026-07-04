#!/bin/bash

# HyprCandy Installer Script
# This script installs Hyprland and related packages across multiple distributions

#set -e  # Exit on any error

# Colors for output
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
SHELL_CHOICE="skip"
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
    echo -e "${WHITE}                           HyprCandy Update!${NC}"
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
    echo "   • Highly customizable manually"
    echo "   • Waypaper integration: loads colors through waypaper backgrounds"
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

choose_browser() {
    echo -e "${CYAN}Choose your browser:${NC}"
        echo "1) Brave (Seamless integration with HyprCandy GTK and Qt theme, fast, secure and privacy-focused)"
        echo "2) Firefox (Themed through python-pywalfox by running 'pywalfox update', open-source and privacy-focused)"
        echo "3) Zen Browser (Themed through zen mods and python-pywalfox, open-source and privacy-focused)"
        echo "4) Librewolf (Open-source browser with a focus on privacy, highly customizable manually)"
        echo "5) Other (Install your own browser post-installation)"
        
        while true; do
            read -rp "Enter 1, 2, 3, 4 or 5: " browser_choice
            case $browser_choice in
                1) BROWSER_CHOICE="brave"; break ;;
                2) BROWSER_CHOICE="firefox"; break ;;
                3) BROWSER_CHOICE="zen-browser-bin"; break ;;
                4) BROWSER_CHOICE="librewolf"; break ;;
                5) BROWSER_CHOICE="other"; break ;;
                *) print_error "Invalid choice. Please enter 1, 2, 3, 4 or 5." ;;
            esac
        done
    
    echo -e "${GREEN}Browser selected: $BROWSER_CHOICE${NC}"
}

# Function to choose shell
choose_shell() {
    echo -e "${CYAN}Switch shell or${NC} ${GREEN}Skip${NC} ${CYAN}(This can also regenerate HyprCandy's default shell setup):${NC}"
    echo "1) Fish - A modern shell with builtin fzf search, intelligent autosuggestions and syntax highlighting (Fisher plugins + Starship prompt)"
    echo "2) Zsh - Powerful shell with extensive customization (Zsh plugins + Oh My Zsh + Starship prompt)"
	echo "3) Skip shell selection"
    echo
    
    while true; do
        echo -e "${YELLOW}Enter your choice (1 for Fish, 2 for Zsh, 3 Skip):${NC}"
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
	    3)
		SHELL_CHOICE="skip"
		print_status "Skipping shell selection..."
                break
                ;;
            *)
                print_error "Invalid choice. Please enter 1, 2 or 3."
                ;;
        esac
    done
}

# Function to install yay
install_yay() {
    print_status "Installing yay..."
    local temp_dir=$(mktemp -d)
    cd "$temp_dir"
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd /
    rm -rf "$temp_dir"
    print_success "yay installed successfully!"
}

# Function to install paru
install_paru() {
    print_status "Installing paru..."
    local temp_dir=$(mktemp -d)
    cd "$temp_dir"
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si --noconfirm
    cd /
    rm -rf "$temp_dir"
    print_success "paru installed successfully!"
}

# Function to check or install appropriate package manager
check_or_install_package_manager() {
    print_status "Setting up package manager"
            if command -v yay >/dev/null 2>&1; then
                AUR_HELPER="yay"
                print_success "yay is already installed"
            elif command -v paru >/dev/null 2>&1; then
                AUR_HELPER="paru"
                print_success "paru is already installed"
            else
                print_status "No AUR helper found. Choose one to install:"
                echo "1) paru (default, recommended)"
                echo "2) yay"
                
                while true; do
                    read -p "Enter your choice (1-2): " choice
                    case $choice in
                        1|"")
                            print_status "Ensuring base-devel and git are installed..."
                            sudo pacman -S --needed --noconfirm base-devel git
                            install_paru
                            AUR_HELPER="paru"
                            break
                            ;;
                        2)
                            print_status "Ensuring base-devel and git are installed..."
                            sudo pacman -S --needed --noconfirm base-devel git
                            install_yay
                            AUR_HELPER="yay"
                            break
                            ;;
                        *)
                            print_error "Invalid choice. Please enter 1 or 2."
                            ;;
                    esac
                done
            fi
}

# Function to build package list
build_package_list() {
    # Initialize the main package array
    packages=(
        # Hyprland ecosystem
        "hyprland"
        "hyprcursor"
        "hyprpaper"
        "hyprpicker"
        "xdg-desktop-portal-hyprland"
        "hypridle"
        "hyprlock"
        "hyprland-protocols"
        "hyprland-qt-support"
        "hyprland-qtutils"
        "hyprlang"
        "hyprpolkitagent"
        "hyprsunset"
        "hyprsysteminfo"
        "hyprutils"
        "hyprwayland-scanner"
        "hyprgraphics"
        "hyprviz-bin"
        
        # Packages
        "pacman-contrib"
        "octopi"
        
        # Dependacies
        "meson" 
        "cpio" 
        "cmake"
        
        # GNOME components
        #"mutter"
        #"gnome-session"
        #"gnome-control-center"
        "gnome-system-monitor"
        "gnome-calendar"
        #"gnome-tweaks"
        "gnome-weather"
        #"gnome-software"
        "gnome-calculator"
        #"gnome-terminal"
        #"extension-manager"
        "evince"
        "flatpak"
        
        # Terminals and file manager
        "kitty"
        "nautilus"
        
        # Qt and GTK theming
        "qt5ct-kde"
        "qt6ct-kde"
        "nwg-look"
        
        # System utilities
        "power-profiles-daemon"
        "bluez"
        "bluez-utils"
        "blueman"
        "nwg-displays"
        "uwsm"
        
        # Application launchers and menus
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
        "gnome-disk-utility"
        "brightnessctl"
        "playerctl"
        
        # System monitoring
        "btop"
        "nvtop"
        "htop"
        
        # Customization and theming
        "matugen-bin"
        
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
        "jq"
        
        # Fonts
        "ttf-dejavu-sans-code"
        "ttf-cascadia-code-nerd"
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
        
        # Theming
        "adw-gtk-theme"
        "tela-circle-icon-theme-all"
        "bibata-cursor-theme-bin"
        
        # System info
        "fastfetch"
        
        # GTK libraries
        "gtkmm-4.0"
        "gtksourceview3"
        "gtksourceview4"
        "gtksourceview5"
        
        # Fun stuff
        "cmatrix"
        "pipes.sh"
        "asciiquarium"
        "tty-clock"
        
        # Configuration management
        "stow"
        
        # Extra
        "spotify-launcher"
        "equibop-bin"
    )
    
    # Add display manager packages
    if [ "$DISPLAY_MANAGER" = "sddm" ]; then
        packages+=("sddm" "sddm-sugar-candy-git")
        print_status "Added SDDM to package list"
    elif [ "$DISPLAY_MANAGER" = "gdm" ]; then
        packages+=("gdm" "gdm-settings")
        print_status "Added GDM to package list"
    fi
    
    # Add shell packages
    if [ "$SHELL_CHOICE" = "fish" ]; then
        packages+=(
            "fish"
            "fisher"
            "starship"
        )
        print_status "Added Fish shell to package list"
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
        print_status "Added Zsh to package list"
    elif [ "$SHELL_CHOICE" = "skip" ]; then
        echo
    fi
    
    # Add panel packages (Waybar for all, Hyprpanel only for Arch)
    if [ "$PANEL_CHOICE" = "waybar" ]; then
        packages+=(
            "waybar"
        )
        print_status "Added Waybar to package list"
    else
        # Hyprpanel (Arch only)
        packages+=(
            "ags-hyprpanel-git"
            "mako"
        )
        print_status "Added Hyprpanel to package list"
    fi
    
    # Add browser packages
    if [ "$BROWSER_CHOICE" = "brave" ]; then
        packages+=("brave-bin")
        print_status "Added Brave to package list"
    elif [ "$BROWSER_CHOICE" = "firefox" ]; then
        packages+=("firefox" "python-pywalfox")
        print_status "Added Firefox to package list"
    elif [ "$BROWSER_CHOICE" = "zen-browser-bin" ]; then
        packages+=("zen-browser-bin" "python-pywalfox")
        print_status "Added Zen Browser to package list"
    elif [ "$BROWSER_CHOICE" = "librewolf" ]; then
        packages+=("librewolf" "python-pywalfox")
        print_status "Added Librewolf to package list"
    fi
    
    print_success "Package list built with ${#packages[@]} packages"
}

# Function to install packages
install_packages() {
    print_status "Installing packages using $AUR_HELPER..."
    
    local installed=0
    local failed=()
    local skipped=()
        
        # Try to install all packages at once
        if $AUR_HELPER -S --needed --noconfirm "${packages[@]}" 2>&1 | tee /tmp/install.log; then
            print_success "Package installation completed"
            installed=${#packages[@]}
        else
            print_warning "Some packages failed. Installing individually to identify issues..."
            
            # Install individually to identify failures
            for pkg in "${packages[@]}"; do
                print_status "Installing $pkg..."
                if $AUR_HELPER -S --needed --noconfirm "$pkg" 2>/dev/null; then
                    ((installed++))
                    print_success "$pkg installed"
                else
                    failed+=("$pkg")
                    print_error "Failed to install $pkg"
                fi
            done
        fi
        
        # Handle notification daemon conflicts for Arch only
        print_status "Checking for notification daemon conflicts..."
        if [ "$PANEL_CHOICE" = "waybar" ]; then
            if pacman -Qi mako >/dev/null 2>&1; then
                print_status "Removing mako (using SwayNC with Waybar)..."
                $AUR_HELPER -R --noconfirm mako 2>/dev/null || true 
            fi
        else
            if pacman -Qi swaync >/dev/null 2>&1; then
                print_status "Removing swaync (using mako with Hyprpanel)..."
                $AUR_HELPER -R --noconfirm swaync 2>/dev/null || true
            fi
        fi
    
    # Summary
    echo
    print_success "Installation completed!"
    print_status "Successfully installed: $installed packages"
    
    if [ ${#skipped[@]} -gt 0 ]; then
        print_warning "Skipped ${#skipped[@]} packages"
    fi
    
    if [ ${#failed[@]} -gt 0 ]; then
        print_warning "Failed to install ${#failed[@]} packages:"
        printf '  - %s\n' "${failed[@]}"
        echo
        print_status "You can try installing failed packages manually later"
    fi
}

# Function to setup Fish shell configuration
setup_fish() {
    print_status "Setting up Fish shell configuration..."
    
# Install Fish and Starship if not present
if ! command -v fish &> /dev/null; then
    print_status "Installing Fish and Starship..."
    $AUR_HELPER -S --noconfirm fish starship
    print_success "Fish and Starship installed"
else
    print_status "Fish already installed, skipping..."
fi

# Set fish as default shell
# Done after install to ensure fish is available regardless of prior state
FISH_PATH="$(command -v fish)"
if [[ -z "$FISH_PATH" ]]; then
    print_error "Fish not found after install, cannot set default shell"
    exit 1
fi

if ! grep -qF "$FISH_PATH" /etc/shells; then
    echo "$FISH_PATH" | tee -a /etc/shells
fi

chsh -s "$FISH_PATH"
print_success "Fish set as default shell"

# Fisher setup — install plugins fresh or just update if already configured
if ! fish -c "type fisher" &> /dev/null; then
    print_status "Installing Fisher and plugins..."
    mkdir -p ~/.config/fish/functions
    curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish \
        -o ~/.config/fish/functions/fisher.fish

    fish -c "
        fisher install jorgebucaran/fisher
        fisher install \
            jorgebucaran/nvm.fish \
            jorgebucaran/autopair.fish \
            jethrokuan/z \
            patrickf1/fzf.fish \
            franciscolourenco/done
        fisher update
    "
    print_success "Fisher and plugins installed"
else
    print_status "Fisher already installed, updating..."
    fish -c "fisher update"
    print_success "Fisher is up to date"
fi
    
    # Configure Starship prompt
    if command -v starship &> /dev/null; then
        print_status "Configuring Starship prompt for Fish..."
        
        # Add Starship to Fish config
        echo 'starship init fish | source' >> "$USER_HOME/.config/fish/config.fish"
        
        # Create Starship config (same as Fish setup)
        mkdir -p "$USER_HOME/.config"
        cat > "$USER_HOME/.config/starship.toml" << 'EOF'
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
style_user = "bold cyan"
style_root = "bold red"
format = "[󱞬](grey) [](red) [](cyan) [$user](grey) [](red) ($style)"
show_always = true

[directory]
style = "cyan"
read_only = " 🔒"
truncation_length = 4
truncate_to_repo = false

[character]
success_symbol = "[󱞪](grey) [](red)"
error_symbol = "[󱞪](grey) [x](red)"
vimcmd_symbol = "[󱞪](grey) [](green)"

[git_branch]
symbol = "[](red) 🌱 "
truncation_length = 4
truncation_symbol = ""
style = "cyan"

[git_status]
ahead = "⇡${count}"
diverged = "⇕⇡${ahead_count}⇣${behind_count}"
behind = "⇣${count}"
deleted = "x"

[nodejs]
symbol = "[](red) 💠 "
style = "bold grey"

[python]
symbol = "[](red) 🐍 "
style = "bold yellow"

[rust]
symbol = "[](red) ⚙️ "
style = "bold red"

[time]
format = '[](cyan) [\[ $time \]](grey) [](red)($style)'#🕙
time_format = "%T"
disabled = false
style = "bright-white"

[cmd_duration]
format = "[](red) ⏱️ [$duration]($style)"
style = "grey"

[jobs]
symbol = "[](red) ⚡ "
style = "bold cyan"
EOF
        
        print_success "Starship configured for Fish"
    fi
    
    # Add useful Fish functions and aliases
    cat > "$USER_HOME/.config/fish/config.fish" << 'EOF'
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
if ! command -v zsh &> /dev/null; then
    print_status "Zsh not found, installing..."
    $AUR_HELPER -S --noconfirm zsh zsh-completions zsh-autosuggestions \
        zsh-history-substring-search zsh-syntax-highlighting starship oh-my-zsh-git
else
    print_status "Zsh already installed, setting as default shell..."
fi

ZSH_PATH="$(command -v zsh)"
if [[ -z "$ZSH_PATH" ]]; then
    print_error "Zsh not found after install, cannot set default shell"
    exit 1
fi

# Ensure zsh is in /etc/shells before chsh
if ! grep -qF "$ZSH_PATH" /etc/shells; then
    echo "$ZSH_PATH" | tee -a /etc/shells
fi

chsh -s "$ZSH_PATH"
print_success "Zsh set as default shell"
    
    # Install Oh My Zsh if not already installed
    if [ ! -d "$USER_HOME/.oh-my-zsh" ]; then
        print_status "Installing Oh My Zsh..."
        RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        print_success "Oh My Zsh installed"
    fi
    
    # Configure Starship prompt
    if command -v starship &> /dev/null; then
        print_status "Configuring Starship prompt for Zsh..."
        
        # Create Starship config (same as Fish setup)
        mkdir -p "$USER_HOME/.config"
        cat > "$USER_HOME/.config/starship.toml" << 'EOF'
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
style_user = "bold cyan"
style_root = "bold red"
format = "[󱞬](grey) [](red) [](cyan) [$user](grey) [](red) ($style)"
show_always = true

[directory]
style = "cyan"
read_only = " 🔒"
truncation_length = 4
truncate_to_repo = false

[character]
success_symbol = "[󱞪](grey) [](red)"
error_symbol = "[󱞪](grey) [x](red)"
vimcmd_symbol = "[󱞪](grey) [](green)"

[git_branch]
symbol = "[](red) 🌱 "
truncation_length = 4
truncation_symbol = ""
style = "cyan"

[git_status]
ahead = "⇡${count}"
diverged = "⇕⇡${ahead_count}⇣${behind_count}"
behind = "⇣${count}"
deleted = "x"

[nodejs]
symbol = "[](red) 💠 "
style = "bold grey"

[python]
symbol = "[](red) 🐍 "
style = "bold yellow"

[rust]
symbol = "[](red) ⚙️ "
style = "bold red"

[time]
format = '[](cyan) [\[ $time \]](grey) [](red)($style)'#🕙
time_format = "%T"
disabled = false
style = "bright-white"

[cmd_duration]
format = "[](red) ⏱️ [$duration]($style)"
style = "grey"

[jobs]
symbol = "[](red) ⚡ "
style = "bold cyan"
EOF
        
        # Create .zshrc with Starship configuration
        cat > "$USER_HOME/.zshrc" << 'EOF'
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

#alias hyprcandy="cd .hyprcandy && git pull && stow --ignore='Candy' --ignore='Candy-Images' --ignore='Dock-SVGs' --ignore='Gifs' --ignore='Logo' --ignore='transparent.png' --ignore='GJS' --ignore='Candy.desktop' --ignore='HyprCandy.png' --ignore='candy-daemon.js' --ignore='candy-launcher.sh' --ignore='toggle-control-center.sh' --ignore='toggle-media-player.sh' --ignore='toggle-system-monitor.sh' --ignore='toggle-weather-widget.sh' --ignore='candy-system-monitor.js' --ignore='toggle-hyprland-settings.sh' --ignore='resources' --ignore='src' --ignore='meson.build' --ignore='README.md' --ignore='run.log' --ignore='test_layout.js' --ignore='test_media_menu.js' --ignore='toggle.js' --ignore='toggle-main.js' --ignore='~' --ignore='candy-main.js' --ignore='gjs-media-player.desktop' --ignore='gjs-toggle-controls.desktop' --ignore='main.js' --ignore='media-main.js' --ignore='SEEK_FEATURE.md' --ignore='setup-custom-icon.sh' --ignore='weather-main.js' */"
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
	# Legacy desktop entry will be replaced later with a new version
	rm -rf ~/.local/share/applications/Candy.desktop 

	cat > "$USER_HOME/.config/starship.toml" << 'EOF'
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
style_user = "bold cyan"
style_root = "bold red"
format = "[󱞬](grey) [](red) [](cyan) [$user](grey) [](red) ($style)"
show_always = true

[directory]
style = "cyan"
read_only = " 🔒"
truncation_length = 4
truncate_to_repo = false

[character]
success_symbol = "[󱞪](grey) [](red)"
error_symbol = "[󱞪](grey) [x](red)"
vimcmd_symbol = "[󱞪](grey) [](green)"

[git_branch]
symbol = "[](red) 🌱 "
truncation_length = 4
truncation_symbol = ""
style = "cyan"

[git_status]
ahead = "⇡${count}"
diverged = "⇕⇡${ahead_count}⇣${behind_count}"
behind = "⇣${count}"
deleted = "x"

[nodejs]
symbol = "[](red) 💠 "
style = "bold grey"

[python]
symbol = "[](red) 🐍 "
style = "bold yellow"

[rust]
symbol = "[](red) ⚙️ "
style = "bold red"

[time]
format = '[](cyan) [\[ $time \]](grey) [](red)($style)'#🕙
time_format = "%T"
disabled = false
style = "bright-white"

[cmd_duration]
format = "[](red) ⏱️ [$duration]($style)"
style = "grey"

[jobs]
symbol = "[](red) ⚡ "
style = "bold cyan"
EOF
    
    # Install display manager packages
    if [ "$DISPLAY_MANAGER" = "sddm" ]; then
        if pacman -Qi sddm &>/dev/null; then
            #$AUR_HELPER -R --noconfirm swww
			#$AUR_HELPER -R --noconfirm qt6ct-kde
			#$AUR_HELPER -R --noconfirm wlogout
			#$AUR_HELPER -R --noconfirm waybar
			#$AUR_HELPER -R --noconfirm waypaper
			$AUR_HELPER -S --noconfirm wallust
            $AUR_HELPER -S --noconfirm quickshell-git --rebuild
            print_status "Dependencies are up to date"
        else
            echo ""
        fi
    elif [ "$DISPLAY_MANAGER" = "gdm" ]; then
        if pacman -Qi gdm &>/dev/null; then
            $AUR_HELPER -R --noconfirm swww
			$AUR_HELPER -R --noconfirm wlogout
			$AUR_HELPER -R --noconfirm waypaper
			$AUR_HELPER -R --noconfirm waypaper-git
            $AUR_HELPER -S --noconfirm gdm gdm-settings
            print_status "Installed GDM packages"
        else
            echo ""
        fi
    fi

    print_status "Updating HyprCandy configuration..."

UPDATE_DIR="$USER_HOME/.HCUpdates"
HYPRCANDY_DIR="$USER_HOME/.hyprcandy"

if [ ! -d "$UPDATE_DIR" ]; then
	# Clone fresh copy into store dir
	echo "🌐 Cloning latest HyprCandy into temporary directory..."
	git clone --depth 1 https://github.com/AstralDesigns/HyprC-Plus.git "$UPDATE_DIR"
	echo "✅ Clone complete"
fi

# Folders with user-specific changes — never overwritten on update >
SKIP_DIRS=("background" "background.png" "fastfetch" "gtk-3.0" "gtk-4.0" "hypr" "hyprcandy" "qt5ct" "qt6ct" "hyprcandydock")

echo "📦 Merging update into ~/.hyprcandy (skipping: ${SKIP_DIRS[*]})..."

# Build rsync exclude args
EXCLUDES=()
for dir in "${SKIP_DIRS[@]}"; do
    EXCLUDES+=(--exclude="**/$dir/")
done

# rsync: copy everything from the update clone into the live dotfiles dir,
# skipping the protected folders. Stow symlinks already point here so the
# running environment picks up changes immediately — no re-stow needed.
rsync -a \
    "${EXCLUDES[@]}" \
    --exclude='.git/' \
    "$UPDATE_DIR/" "$HYPRCANDY_DIR/"

echo "✅ Update merged"

# Symlink new wallust folder
ln -sf "$USER_HOME/.hyprcandy/.config/wallust/" "$USER_HOME/.config"

### ✅ Setup mako config, hook scripts and needed services
echo "📁 Updating HyprCandyPlus scripts..."

# ═══════════════════════════════════════════════════════════════
#                    Updates Patch Notes
# ═══════════════════════════════════════════════════════════════

	cat > "$USER_HOME/.config/hypr/scripts/notify.sh" << 'EOF'
#!/bin/bash

notify-send " HC+ Update Complete" "Updates made:
 Patched the bar in 'bar' mode to remain visible when the calendar popup is visible + overall color palette improvements.
EOF

chmod +x "$USER_HOME/.config/hypr/scripts/notify.sh"

# ═══════════════════════════════════════════════════════════════
#                    	User Settings File
# ═══════════════════════════════════════════════════════════════

if [ ! -f "$USER_HOME/.config/custom/custom.lua" ]; then
    cat > "$USER_HOME/.config/custom/custom.lua" << 'EOF'
--  ██████╗ █████╗ ███╗   ██║██████╗ ██╗   ██╗
-- ██╔════╝██╔══██╗████╗  ██║██╔══██╗╚██╗ ██╔╝
-- ██║     ███████║██╔██╗ ██║██║  ██║ ╚████╔╝ 
-- ██║     ██╔══██║██║╚██╗██║██║  ██║  ╚██╔╝  
-- ╚██████╗██║  ██║██║ ╚████║██████╔╝   ██║   
--  ╚═════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝    ╚═╝   
-- ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
-- ┃                          User Settings                      ┃
-- ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
-- [NOTE!!] Your personal settings added here are sourced in hyprland.lua.

hl.bind("SUPER + S", hl.dsp.exec_cmd("spotify-launcher"), { description = "Launch Spotify" })
hl.bind("SUPER + D", hl.dsp.exec_cmd("equibop"), { description = "Launch the Discord app" })
hl.bind("SUPER + C", hl.dsp.exec_cmd("gedit"), { description = "Launch the editor" })
hl.bind("SUPER + Q", hl.dsp.exec_cmd("kitty"), { description = "Launch normal kitty instances" })
hl.bind("SUPER + Return", hl.dsp.exec_cmd("pypr toggle term"), { description = "Launch a kitty scratchpad through pyprland" })
hl.bind("SUPER + E", hl.dsp.exec_cmd("nautilus"), { description = "Launch the filemanager" })
hl.bind("SUPER + CTRL + C", hl.dsp.exec_cmd("gnome-calculator"), { description = "Launch the calculator" })

return true
EOF
fi

# ═══════════════════════════════════════════════════════════════
#                 Notification DBus Handoff Script
# ═══════════════════════════════════════════════════════════════

	cat > "$USER_HOME/.config/hyprcandy/scripts/candylock-notif-handoff.sh" << 'EOF'
#!/usr/bin/env bash
# Notification DBus handoff for candylock — bar must not restart the daemon while locked.
CANDYLOCK_NOTIF_LOCK="${CANDYLOCK_NOTIF_LOCK:-/tmp/candylock-notif.lock}"

candylock_notif_acquire() {
    touch "$CANDYLOCK_NOTIF_LOCK"
    pkill -f "notify-daemon.py" 2>/dev/null || true
    sleep 0.25
}

candylock_notif_release() {
    rm -f "$CANDYLOCK_NOTIF_LOCK"
}
EOF

chmod +x "$USER_HOME/.config/hyprcandy/scripts/candylock-notif-handoff.sh"

# ═══════════════════════════════════════════════════════════════
#                   		Update Checker
# ═══════════════════════════════════════════════════════════════

cat > "$USER_HOME/.config/hyprcandy/scripts/hc-update-check.sh" << 'EOF'
#!/usr/bin/env bash
# hc-update-check.sh
# Checks for HyprCandy Plus dotfile updates and maintains a persistent state
# file so update availability survives bar restarts and session restarts.
#
# State file: ~/.config/hyprcandy/hc-update-state
#   - Written (with tooltip text) only when updates are detected
#   - Never written when git pull says "Already up to date"
#   - Deleted only by the HC update process after a successful apply
#
# Outputs one JSON line:
#   {"hasUpdates": true|false, "tooltip": "...", "noStore": true|false}

HC_STORE="$HOME/.HCUpdates"
STATE_FILE="$HOME/.config/hyprcandy/hc-update-state"

emit() {
    local has="$1" tip="$2" nostore="${3:-false}"
    tip="${tip//\"/\\\"}"
    echo "{\"hasUpdates\":${has},\"tooltip\":\"${tip}\",\"noStore\":${nostore}}"
}

write_state() {
    # Write tooltip to state file so the update is remembered across restarts
    echo "$1" > "$STATE_FILE"
}

# ── If state file already exists, updates were previously detected and not
#    yet applied — honour that regardless of what git pull says this scan
# ─────────────────────────────────────────────────────────────────────────────
if [ -f "$STATE_FILE" ]; then
    saved_tip=$(cat "$STATE_FILE")
    emit "true" "${saved_tip}" "false"
    # Still run the git pull in background to keep the store current so the
    # apply step gets the latest changes, but don't let its output affect state
    if [ -d "$HC_STORE/.git" ]; then
        git -C "$HC_STORE" pull 2>&1 > /dev/null &
    fi
    notify-send " HC+ Update" "New updates available"
    exit 0
fi

# ── No state file — evaluate current situation fresh ─────────────────────────

# Store folder absent or not a git repo → needs setup
if [ ! -d "$HC_STORE" ] || [ ! -d "$HC_STORE/.git" ]; then
    tip="HC+ store not found — 󰇚 to set up and sync dotfiles."
    write_state "$tip"
    emit "true" "$tip" "true"
    exit 0
fi

# Store present and is a git repo — pull and check for changes
pull_out=$(git -C "$HC_STORE" pull 2>&1)
pull_exit=$?

if [ $pull_exit -ne 0 ]; then
    # Network/git failure — don't write state, don't claim updates
    emit "false" "HC+ check failed: ${pull_out}" "false"
    exit 0
fi

if echo "$pull_out" | grep -q "Already up to date"; then
    # Genuinely up to date and no prior state file — nothing to report
    emit "false" "HyprCandy Plus is up to date" "false"
else
    # New changes were pulled — write state so this survives restarts
    tip="HC+ files changed — 󰇚 to sync."
    write_state "$tip"
    emit "true" "$tip" "false"
    notify-send " HC+ Update" "New updates available"
fi
EOF

chmod +x "$USER_HOME/.config/hyprcandy/scripts/hc-update-check.sh"

# ═══════════════════════════════════════════════════════════════
#                    Gaps OUT Increase Script
# ═══════════════════════════════════════════════════════════════

cat > "$USER_HOME/.config/hyprcandy/hooks/hyprland_gaps_out_increase.sh" << 'EOF'
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

chmod +x "$USER_HOME/.config/hyprcandy/hooks/hyprland_gaps_out_increase.sh"

# ═══════════════════════════════════════════════════════════════
#                    Gaps OUT Decrease Script
# ═══════════════════════════════════════════════════════════════

cat > "$USER_HOME/.config/hyprcandy/hooks/hyprland_gaps_out_decrease.sh" << 'EOF'
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

cat > "$USER_HOME/.config/hyprcandy/hooks/hyprland_gaps_in_increase.sh" << 'EOF'
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

cat > "$USER_HOME/.config/hyprcandy/hooks/hyprland_gaps_in_decrease.sh" << 'EOF'
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

cat > "$USER_HOME/.config/hyprcandy/hooks/hyprland_border_increase.sh" << 'EOF'
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

cat > "$USER_HOME/.config/hyprcandy/hooks/hyprland_border_decrease.sh" << 'EOF'
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

cat > "$USER_HOME/.config/hyprcandy/hooks/hyprland_rounding_increase.sh" << 'EOF'
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

cat > "$USER_HOME/.config/hyprcandy/hooks/hyprland_rounding_decrease.sh" << 'EOF'
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

cat > "$USER_HOME/.config/hyprcandy/hooks/hyprland_gap_presets.sh" << 'EOF'
#!/bin/bash

CONFIG_FILE="$HOME/.config/hypr/hyprviz.lua"

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

# Apply all settings to hyprviz.lua
# Note: In Lua, these are inside hl.config({ general = { ... }, decoration = { ... } })
sed -i "s/\(gaps_out\s*=\s*\)[0-9]*/\1$GAPS_OUT/" "$CONFIG_FILE"
sed -i "s/\(gaps_in\s*=\s*\)[0-9]*/\1$GAPS_IN/" "$CONFIG_FILE"
sed -i "s/\(border_size\s*=\s*\)[0-9]*/\1$BORDER/" "$CONFIG_FILE"
sed -i "s/\(rounding\s*=\s*\)[0-9]*/\1$ROUNDING/" "$CONFIG_FILE"

# Apply immediately using new Lua dispatch syntax via hyprctl
hyprctl eval "hl.config({ general = { gaps_out = $GAPS_OUT, gaps_in = $GAPS_IN, border_size = $BORDER }, decoration = { rounding = $ROUNDING } })"

echo "🎨 Applied $1 preset: gaps_out=$GAPS_OUT, gaps_in=$GAPS_IN, border=$BORDER, rounding=$ROUNDING"
notify-send "Visual Preset Applied" "$1: OUT=$GAPS_OUT IN=$GAPS_IN BORDER=$BORDER ROUND=$ROUNDING" -t 3000
EOF

# ═══════════════════════════════════════════════════════════════
#                    Visual Status Display Script
# ═══════════════════════════════════════════════════════════════

cat > "$USER_HOME/.config/hyprcandy/hooks/hyprland_status_display.sh" << 'EOF'
#!/bin/bash

CONFIG_FILE="$HOME/.config/hypr/hyprviz.lua"

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

chmod +x "$USER_HOME/.config/hyprcandy/hooks/hyprland_gaps_out_increase.sh"
chmod +x "$USER_HOME/.config/hyprcandy/hooks/hyprland_gaps_out_decrease.sh"
chmod +x "$USER_HOME/.config/hyprcandy/hooks/hyprland_gaps_in_increase.sh"
chmod +x "$USER_HOME/.config/hyprcandy/hooks/hyprland_gaps_in_decrease.sh"
chmod +x "$USER_HOME/.config/hyprcandy/hooks/hyprland_border_increase.sh"
chmod +x "$USER_HOME/.config/hyprcandy/hooks/hyprland_border_decrease.sh"
chmod +x "$USER_HOME/.config/hyprcandy/hooks/hyprland_rounding_increase.sh"
chmod +x "$USER_HOME/.config/hyprcandy/hooks/hyprland_rounding_decrease.sh"
chmod +x "$USER_HOME/.config/hyprcandy/hooks/hyprland_gap_presets.sh"
chmod +x "$USER_HOME/.config/hyprcandy/hooks/hyprland_status_display.sh"

echo "✅ Hyprland adjustment scripts created and made executable!"

# ═══════════════════════════════════════════════════════════════
#             SERVICES & SCRIPTS BASED ON CHOSEN BAR
# ═══════════════════════════════════════════════════════════════

if [ "$PANEL_CHOICE" = "waybar" ]; then

# ═══════════════════════════════════════════════════════════════
#                      XDG Script & Config
# ═══════════════════════════════════════════════════════════════

cat > "$USER_HOME/.config/xdg-desktop-portal/hyprland-portals.conf" << 'EOF'
[preferred]
default=hyprland;gtk
org.freedesktop.impl.portal.FileChooser=gtk
EOF

cat > "$USER_HOME/.config/hypr/scripts/xdg.sh" << 'EOF'
#!/bin/bash
# __  ______   ____
# \ \/ /  _ \ / ___|
#  \  /| | | | |  _
#  /  \| |_| | |_| |
# /_/\_\____/ \____|

killall -e xdg-desktop-portal          2>/dev/null

sleep 1

# Stop all managed services cleanly
systemctl --user stop \
    xdg-desktop-portal \

sleep 1

# Start portals in the correct order:

systemctl --user start xdg-desktop-portal
EOF

chmod +x "$USER_HOME/.config/hypr/scripts/xdg.sh"

else

# ═══════════════════════════════════════════════════════════════
#                      Hyprpanel XDG Script
# ═══════════════════════════════════════════════════════════════

cat > "$USER_HOME/.config/hypr/scripts/xdg.sh" << 'EOF'
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

chmod +x "$USER_HOME/.config/hypr/scripts/xdg.sh"
fi

if [ "$PANEL_CHOICE" = "waybar" ]; then

# ═══════════════════════════════════════════════════════════════
#                      Startup with Waybar
# ═══════════════════════════════════════════════════════════════

cat > "$USER_HOME/.config/hyprcandy/hooks/startup_services.sh" << 'EOF'
#!/bin/bash

# MAIN EXECUTION
echo "🎯 All services started successfully"
EOF

else

# ═══════════════════════════════════════════════════════════════
#                      Startup with Hyprpanel
# ═══════════════════════════════════════════════════════════════

cat > "$USER_HOME/.config/hyprcandy/hooks/startup_services.sh" << 'EOF'
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

chmod +x "$USER_HOME/.config/hyprcandy/hooks/startup_services.sh"
fi

# ═══════════════════════════════════════════════════════════════
#                      Cursor Update Script
# ═══════════════════════════════════════════════════════════════

cat > "$USER_HOME/.config/hyprcandy/hooks/watch_cursor_theme.sh" << 'EOF'
#!/bin/bash

GTK3_FILE="$HOME/.config/gtk-3.0/settings.ini"
GTK4_FILE="$HOME/.config/gtk-4.0/settings.ini"
HYPRLUA="$HOME/.config/hypr/hyprviz.lua"

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

    # Replace each hl.env line in hyprviz.lua
    sed -i "s|hl.env(\"XCURSOR_THEME\", \".*\")|hl.env(\"XCURSOR_THEME\", \"$theme\")|" "$HYPRLUA"
    sed -i "s|hl.env(\"XCURSOR_SIZE\", \".*\")|hl.env(\"XCURSOR_SIZE\", \"$size\")|" "$HYPRLUA"
    sed -i "s|hl.env(\"HYPRCURSOR_THEME\", \".*\")|hl.env(\"HYPRCURSOR_THEME\", \"$theme\")|" "$HYPRLUA"
    sed -i "s|hl.env(\"HYPRCURSOR_SIZE\", \".*\")|hl.env(\"HYPRCURSOR_SIZE\", \"$size\")|" "$HYPRLUA"
    
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

chmod +x "$USER_HOME/.config/hyprcandy/hooks/watch_cursor_theme.sh"

# ═══════════════════════════════════════════════════════════════
#                    Cursor Update Service
# ═══════════════════════════════════════════════════════════════

cat > "$USER_HOME/.config/systemd/user/cursor-theme-watcher.service" << 'EOF'
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

cat > "$USER_HOME/.config/pypr/config.toml" << 'EOF'
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

cat > "$USER_HOME/.config/systemd/user/waybar.service" << 'EOF'
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

cat > "$USER_HOME/.config/hyprcandy/hooks/clear_awww.sh" << 'EOF'
#!/bin/bash
CACHE_DIR="$HOME/.cache/awww"
[ -d "$CACHE_DIR" ] && rm -rf "$CACHE_DIR"
EOF
chmod +x "$USER_HOME/.config/hyprcandy/hooks/clear_awww.sh"
fi

if [ "$PANEL_CHOICE" = "waybar" ]; then
# ═══════════════════════════════════════════════════════════════
#                  Background Update Script
# ═══════════════════════════════════════════════════════════════

cat > "$USER_HOME/.config/hyprcandy/hooks/update_background.sh" << 'EOF'
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

    # ── AccentColor from surface_tint in colors.css ───────────────────
    if [[ -f "$COLORS_CSS" ]]; then
        FULL_HEX=$(grep -E '@define-color\s+surface_tint\s+#' "$COLORS_CSS" \
            | head -n1 \
            | grep -oP '(?<=#)[0-9a-fA-F]{6}')

        if [[ -n "$FULL_HEX" ]]; then
            sudo sed -i "s|^AccentColor=.*|AccentColor=\"#$FULL_HEX\"|" "$SDDM_CONF"
            #echo "🎨 SDDM AccentColor updated → #$FULL_HEX (from surface_tint)"
            pkill -f magick
        else
            echo "⚠️  Could not parse surface_tint from $COLORS_CSS"
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

cat > "$USER_HOME/.config/hyprcandy/hooks/update_background.sh" << 'EOF'
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

chmod +x "$USER_HOME/.config/hyprcandy/hooks/update_background.sh"

# ═══════════════════════════════════════════════════════════════
#                             Overview
# ═══════════════════════════════════════════════════════════════

cat > "$USER_HOME/.config/hyprcandy/scripts/overview.sh" << 'EOF'
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

chmod +x "$USER_HOME/.config/hyprcandy/scripts/overview.sh"

# ═══════════════════════════════════════════════════════════════
#              Background File & Matugen Watcher
# ═══════════════════════════════════════════════════════════════

cat > "$USER_HOME/.config/hyprcandy/hooks/watch_background.sh" << 'EOF'
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

chmod +x "$USER_HOME/.config/hyprcandy/hooks/watch_background.sh"

# ═══════════════════════════════════════════════════════════════
#            Systemd Service: Background Watcher
# ═══════════════════════════════════════════════════════════════

cat > "$USER_HOME/.config/systemd/user/background-watcher.service" << 'EOF'
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

cat > "$USER_HOME/.config/hypr/scripts/lock-watcher.sh" << 'EOF'
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
chmod +x "$USER_HOME/.config/hypr/scripts/lock-watcher.sh"

# ═══════════════════════════════════════════════════════════════
#            			   Hyprlock Service
# ═══════════════════════════════════════════════════════════════

cat > "$USER_HOME/.config/systemd/user/lock-watcher.service" << 'EOF'
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

cat > "$USER_HOME/.config/hyprcandy/hooks/waybar_idle_monitor.sh" << 'EOF'
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

chmod +x "$USER_HOME/.config/hyprcandy/hooks/waybar_idle_monitor.sh"

# ═══════════════════════════════════════════════════════════════
#        Systemd Service: waybar Idle Inhibitor Monitor
# ═══════════════════════════════════════════════════════════════

cat > "$USER_HOME/.config/systemd/user/waybar-idle-monitor.service" << 'EOF'
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
#               Wallpaper Integration Scripts
# ═══════════════════════════════════════════════════════════════

    cat > "$USER_HOME/.config/hyprcandy/hooks/wallpaper_integration.sh" << 'EOF'
#!/bin/bash

CONFIG_BG="$HOME/.config/background"
WP_CONFIG="$HOME/.config/wallpaper/wallpaper.ini"
WAYPAPER_CONFIG="$HOME/.config/waypaper/config.ini"
MATUGEN_CONFIG="$HOME/.config/matugen/config.toml"
RELOAD_SO="/usr/local/lib/gtk3-reload.so"
RELOAD_SRC="/usr/local/share/gtk3-reload/gtk3-reload.c"
HOOKS_DIR="$HOME/.config/hyprcandy/hooks"

get_waypaper_background() {
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
        pkill -f magick
        echo "🎨 Triggering color generation..."
wal -s -t -i "$bg_path" -n --cols16 darken --backend wal --contrast 1.5 --saturate 0.25 2>/dev/null
matugen image "$bg_path" --type scheme-fidelity -m dark -r nearest --base16-backend wal --lightness-dark -0.1 --source-color-index 0 --contrast 0.15 2>/dev/null
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
    echo "🎯 Waypaper integration triggered"
    current_bg=$(get_waypaper_background)
    if [ $? -eq 0 ]; then
        echo "📸 Current Waypaper background: $current_bg"
        if update_config_background "$current_bg"; then
           echo "✅ Color generation processes complete"
        fi
    else
        echo "⚠️  Could not determine current Waypaper background"
    fi
}

main
EOF
    chmod +x "$USER_HOME/.config/hyprcandy/hooks/wallpaper_integration.sh"
else

# ═══════════════════════════════════════════════════════════════
#         hyprpanel_idle_monitor.sh — Auto Toggle Inhibitor
# ═══════════════════════════════════════════════════════════════

cat > "$USER_HOME/.config/hyprcandy/hooks/hyprpanel_idle_monitor.sh" << 'EOF'
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

chmod +x "$USER_HOME/.config/hyprcandy/hooks/hyprpanel_idle_monitor.sh"

# ═══════════════════════════════════════════════════════════════
#        Systemd Service: hyprpanel Idle Inhibitor Monitor
# ═══════════════════════════════════════════════════════════════

cat > "$USER_HOME/.config/systemd/user/hyprpanel-idle-monitor.service" << 'EOF'
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

cat > "$USER_HOME/.config/hyprcandy/hooks/kill_hyprpanel_safe.sh" << 'EOF'
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

chmod +x "$USER_HOME/.config/hyprcandy/hooks/kill_hyprpanel_safe.sh"

# ═══════════════════════════════════════════════════════════════
#             Hyprpanel Restart Script (via systemd)
# ═══════════════════════════════════════════════════════════════

cat > "$USER_HOME/.config/hyprcandy/hooks/restart_hyprpanel.sh" << 'EOF'
#!/bin/bash

echo "🔄 Restarting hyprpanel via systemd..."

systemctl --user stop hyprpanel.service
sleep 0.5
systemctl --user start hyprpanel.service

echo "✅ Hyprpanel restarted"
EOF

chmod +x "$USER_HOME/.config/hyprcandy/hooks/restart_hyprpanel.sh"

# ═══════════════════════════════════════════════════════════════
#             Systemd Service: Hyprpanel Launcher
# ═══════════════════════════════════════════════════════════════

cat > "$USER_HOME/.config/systemd/user/hyprpanel.service" << 'EOF'
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

cat > "$USER_HOME/.config/hyprcandy/hooks/update_rofi_font.sh" << 'EOF'
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

chmod +x "$USER_HOME/.config/hyprcandy/hooks/update_rofi_font.sh"

# ═══════════════════════════════════════════════════════════════
#                Sync GTK, QT and ROFI Icon Themes
# ═══════════════════════════════════════════════════════════════

cat > "$USER_HOME/.config/hyprcandy/hooks/update_icon_theme.sh" << 'EOF'
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

chmod +x "$USER_HOME/.config/hyprcandy/hooks/update_icon_theme.sh"

# ═══════════════════════════════════════════════════════════════
#      Watcher: React to GTK Font Changes via nwg-look
# ═══════════════════════════════════════════════════════════════

cat > "$USER_HOME/.config/hyprcandy/hooks/watch_gtk_font.sh" << 'EOF'
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

chmod +x "$USER_HOME/.config/hyprcandy/hooks/watch_gtk_font.sh"

# ═══════════════════════════════════════════════════════════════
#      Systemd Service: GTK Font → Rofi Font Syncer
# ═══════════════════════════════════════════════════════════════

cat > "$USER_HOME/.config/systemd/user/rofi-font-watcher.service" << 'EOF'
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
org.gnome.gedit
org.gnome.DiskUtility
nwg-displays
nwg-look
hyprviz
com.shellyorg.shelly
EOF

else
	echo ""
fi

# ═══════════════════════════════════════════════════════════════
#               	  Desktop Pinned Apps File 
# ═══════════════════════════════════════════════════════════════
DESKTOP_FILE="$HOME/.config/desktop-pinned"
if [ ! -f "$DESKTOP_FILE" ]; then
	cat > "$DESKTOP_FILE" << 'EOF'
EOF

else
	echo ""
fi

# ═══════════════════════════════════════════════════════════════
#               		 POST SETUP CLEANUP
# ═══════════════════════════════════════════════════════════════
	cat > "$USER_HOME/.config/hyprcandy/hooks/complete.sh" << 'EOF'
#!/bin/bash

bash -c "rm -rf ~/candyinstall ~/.hyprcandy/candyinstall"
EOF

chmod +x "$USER_HOME/.config/hyprcandy/hooks/complete.sh"

find "$USER_HOME/.config/hyprcandy/hooks/" -name "*.sh" -exec chmod +x {} \;
find "$USER_HOME/.config/hyprcandy/scripts/" -name "*.sh" -exec chmod +x {} \;
find "$USER_HOME/.config/quickshell/bar/" -maxdepth 1 -name "*.sh" -exec chmod +x {} \;
find "$USER_HOME/.config/quickshell/bar/scripts/" -name "*.sh" -exec chmod +x {} \;
find "$USER_HOME/.config/waybar/scripts/" -name "*.sh" -exec chmod +x {} \;
find "$USER_HOME/.hyprcandy/GJS/hyprcandydock/" -name "*.sh" -exec chmod +x {} \;
chmod +x "$USER_HOME/.config/quickshell/candylock/auth.sh"
chmod +x "$USER_HOME/.config/quickshell/wallpaper/wallpaper-apply.sh"
chmod +x "$USER_HOME/.config/quickshell/wallpaper/wallpaper-cycle.sh"
#mkdir -p "$USER_HOME/.cache/quickshell/overview"
#mkdir -p "$USER_HOME/.cache/quickshell/wallpaper"

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
	
# Add custom cursors
echo "🔄 Adding custom cursors..."
cp -r "$USER_HOME"/.icons/* /usr/share/icons/
echo "✅ Cursors updated."

# Enabled SSD/NVME scheduled optimization
systemctl enable --now fstrim.timer > /dev/null 2>&1
echo
}

# Function to enable display manager and prompt for reboot
enable_display_manager() {
    print_status "Setting up $DISPLAY_MANAGER display manager..."

	# 🔐 Add sudoers entry for background script
    echo "🔄 Adding sddm background auto-update settings..."
	
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
	"$USERNAME ALL=(ALL) NOPASSWD: /usr/bin/chvt"
)

# Add all entries to sudoers safely using visudo
printf '%s\n' "${SUDOERS_ENTRIES[@]}" | EDITOR='tee -a' visudo -f /etc/sudoers.d/hyprcandy-background > /dev/null 2>&1

# Set proper permissions on the sudoers file
chmod 440 /etc/sudoers.d/hyprcandy-background > /dev/null 2>&1

    echo "✅ Added sddm background auto-update settings successfully"
    
    # Additional SDDM configuration if selected
    if [ "$DISPLAY_MANAGER" = "sddm" ]; then
        print_status "Configuring SDDM with Sugar Candy theme..."
        
        #rm -rf /etc/sddm.conf.d/
        #sleep 1
        # Create SDDM config directory if it doesn't exist
        mkdir -p /etc/sddm.conf.d/
        
        # Configure SDDM to use Sugar Candy theme
        if [ -d "/usr/share/sddm/themes/sugar-candy" ]; then
#            tee /etc/sddm.conf.d/sugar-candy.conf > /dev/null << EOF
#[Theme]
#Current=sugar-candy
#CursorTheme=Bibata-Modern-Classic
#CursorSize=18
#EOF
            # Write full theme config to the sugar-candy theme directory
            tee /usr/share/sddm/themes/sugar-candy/theme.conf > /dev/null << EOF
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
HeaderText="󰫣 󰫢 󰫣"
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
                    sed -i 's/^\(\s*\)Image {/\1AnimatedImage {/' "$MAIN_QML"
                    sed -i '/id: backgroundImage/a\            playing: true' "$MAIN_QML"
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

setup_custom_config() {
# Create the custom settings directory and files if it doesn't already exist
        if [ -d "$USER_HOME/.config/hypr" ]; then
            touch "$USER_HOME/.config/hypr/hyprviz.lua"

 # Add default content to the hyprland.lua file
		cat > "$USER_HOME/.config/hypr/hyprland.lua" << 'EOF'
-- ██╗  ██╗██╗   ██╗██████╗ ██████╗ ██╗      █████╗ ███╗   ██╗██████╗ 
-- ██║  ██║╚██╗ ██╔╝██╔══██╗██╔══██╗██║     ██╔══██╗████╗  ██║██╔══██╗
-- ███████║ ╚████╔╝ ██████╔╝██████╔╝██║     ███████║██╔██╗ ██║██║  ██║
-- ██╔══██║  ╚██╔╝  ██╔═══╝ ██╔══██╗██║     ██╔══██║██║╚██╗██║██║  ██║
-- ██║  ██║   ██║   ██║     ██║  ██║███████╗██║  ██║██║ ╚████║██████╔╝
-- ╚═╝  ╚═╝   ╚═╝   ╚═╝     ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝ 

-- HyprCandyPlus Hyprland Lua entry point.
-- Hyprland 0.55+ loads hyprland.lua directly. Keep hyprland.conf only as a
-- compatibility fallback while Lua adoption settles.

local home = os.getenv("HOME") or ""

local function optional_dofile(path, label)
    local ok, result = pcall(dofile, path)
    if not ok then
        -- Missing generated files should not prevent Hyprland from starting.
        -- Syntax/runtime errors are intentionally reported through Hyprland's Lua error UI.
        if not tostring(result):match("No such file") and not tostring(result):match("cannot open") then
            error((label or path) .. ": " .. tostring(result))
        end
    end
    return result
end

-- Generated color bridges. Matugen keeps the existing ~/.config/hypr/colors.conf
-- output for Quickshell reads and also writes ~/.config/hypr/colors.lua.
-- Pywal keeps legacy cache outputs and additionally writes ~/.cache/wal/hyprland-colors.lua.
optional_dofile(home .. "/.config/hypr/colors.lua", "matugen Hyprland Lua colors")
optional_dofile(home .. "/.cache/wal/hyprland-colors.lua", "pywal Hyprland Lua colors")

-- Static HyprCandyPlus visual configuration migrated from hyprviz.conf.
dofile(home .. "/.config/hypr/hyprviz.lua")

-- Mutable overrides written by Quickshell Control Center sliders/buttons.
optional_dofile(home .. "/.config/hypr/hyprviz-state.lua", "HyprCandyPlus mutable Hyprland state")

-- Custom settings file for user-preferences.
optional_dofile(home .. "/.config/custom/custom.lua", "HyprCandyPlus custom user-preferences file")

-- Animation preset selected by ~/.config/hypr/scripts/animations.sh.
optional_dofile(home .. "/.config/hypr/animations.lua", "HyprCandyPlus animation preset")

-- Future nwg-displays or conversion output. Current nwg-displays still writes
-- Hyprlang monitors.conf, so this is only an optional future-safe hook.
optional_dofile(home .. "/.config/hypr/monitors.lua", "Hyprland Lua monitor output")

return true
EOF

 # Add default content to the hyprviz.lua file
		cat > "$USER_HOME/.config/hypr/hyprviz.lua" << 'EOF'
--  ██████╗ █████╗ ███╗   ██╗██████╗ ██╗   ██╗
-- ██╔════╝██╔══██╗████╗  ██║██╔══██╗╚██╗ ██╔╝
-- ██║     ███████║██╔██╗ ██║██║  ██║ ╚████╔╝ 
-- ██║     ██╔══██║██║╚██╗██║██║  ██║  ╚██╔╝  
-- ╚██████╗██║  ██║██║ ╚████║██████╔╝   ██║   
--  ╚═════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝    ╚═╝

-- HyprCandyPlus visual configuration migrated from hyprviz.conf
-- Generated from the complete original file; comments below preserve original section context where useful.
-- Runtime-generated overrides should live in ~/.config/hypr/hyprviz-state.lua, loaded after this file.

local mainMod = "SUPER"
local HYPRSCRIPTS = os.getenv("HOME") .. "/.config/hypr/scripts"
local SCRIPTS = os.getenv("HOME") .. "/.config/hyprcandy/scripts"
local function home(path) return (os.getenv("HOME") or "") .. path end

-- Autostart
hl.on("hyprland.start", function()
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE")
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=hyprland DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY")
    hl.exec_cmd("bash ~/.config/hypr/scripts/xdg.sh")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark'")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("systemctl --user start rofi-font-watcher")
    hl.exec_cmd("systemctl --user start cursor-theme-watcher")
    hl.exec_cmd("gjs ~/.hyprcandy/GJS/candy-daemon.js")
    hl.exec_cmd("gjs ~/.hyprcandy/GJS/hyprcandydock/daemon.js")
    hl.exec_cmd("bash ~/.config/hypr/scripts/wallpaper-restore.sh")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("/usr/bin/pypr")
    hl.exec_cmd("~/.hyprcandy/GJS/hyprcandydock/autostart.sh")
    hl.exec_cmd("qs -c bar")
    hl.exec_cmd("wl-paste --watch cliphist store")
end)

-- Environment variables
hl.env("XCURSOR_THEME", "Marci-Crystal")
hl.env("XCURSOR_SIZE", "18")
hl.env("HYPRCURSOR_THEME", "Marci-Crystal")
hl.env("HYPRCURSOR_SIZE", "18")
hl.env("GTK_THEME", "adw-gtk3-dark")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "0")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("GDK_DEBUG", "portals")
hl.env("GDK_SCALE", "1")
hl.env("GDK_BACKEND", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("OZONE_PLATFORM", "wayland")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")
hl.env("WINIT_UNIX_BACKEND", "wayland")
hl.env("QT_SCALE_FACTOR_ROUNDING_POLICY", "PassThrough")
hl.env("QEMU_AUDIO_DRV", "pa")

-- Core Hyprland config blocks
hl.config({
    input = {
        kb_layout = "us",
        kb_variant = "",
        kb_model = "",
        kb_options = "",
        numlock_by_default = true,
        mouse_refocus = false,
        follow_mouse = 1,
        touchpad = {
            natural_scroll = false,
            scroll_factor = 1.0,
        },
        sensitivity = 0,
    },
    general = {
        gaps_in = 4,
        gaps_out = 8,
        gaps_workspaces = 50,
        border_size = 3,
        col = {
            active_border = inverse_primary,
            inactive_border = background,
        },
        layout = "scrolling",
        resize_on_border = true,
        allow_tearing = false,
    },
    group = {
        col = {
            border_active = source_color,
            border_inactive = background,
            border_locked_active = primary_fixed_dim,
            border_locked_inactive = background,
        },
        groupbar = {
            font_size = 14,
            font_weight_active = "heavy",
            font_weight_inactive = "heavy",
            text_color = surface_tint,
            col = {
                active = primary_fixed_dim,
                inactive = background,
                locked_active = primary_fixed_dim,
                locked_inactive = background,
            },
            indicator_height = 4,
            indicator_gap = 6,
            height = 10,
            render_titles = true,
            scrolling = true,
        },
    },
    dwindle = {
        pseudotile = true,
        preserve_split = true,
    },
    master = {
        new_status = "slave",
        new_on_active = "after",
        smart_resizing = true,
        drop_at_cursor = true,
    },
    scrolling = {
        direction = "right",
        focus_fit_method = 0,
        column_width = 0.5,
    },
    gestures = {
        workspace_swipe_distance = 700,
        workspace_swipe_cancel_ratio = 0.2,
        workspace_swipe_min_speed_to_force = 5,
        workspace_swipe_direction_lock = true,
        workspace_swipe_direction_lock_threshold = 10,
        workspace_swipe_create_new = true,
    },
    binds = {
        workspace_back_and_forth = true,
        allow_workspace_cycles = true,
        pass_mouse_when_bound = false,
    },
    decoration = {
        rounding = 20,
        rounding_power = 2,
        active_opacity = 0.85,
        inactive_opacity = 0.85,
        fullscreen_opacity = 1.0,
        blur = {
            enabled = true,
            size = 2,
            passes = 5,
            new_optimizations = true,
            ignore_opacity = true,
            xray = true,
            vibrancy = 0.24999999999999933,
            noise = 0,
            popups = true,
            popups_ignorealpha = 0.8,
            brightness = 1.0000000000000002,
            contrast = 0.9999999999999997,
            special = false,
            vibrancy_darkness = 0.5000000000000002,
        },
        shadow = {
            enabled = true,
            range = 12,
            render_power = 4,
            color = scrim,
        },
        dim_strength = 0.19999999999999973,
        dim_inactive = false,
    },
    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = false,
        initial_workspace_tracking = 1,
    },
    debug = {
        suppress_errors = true,
    },
})

-- Gestures
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 4, direction = "swipe", action = "move," })
hl.gesture({ fingers = 2, direction = "pinch", action = "float" })

-- Window rules
hl.window_rule({
    name = "windowrule-1",
    match = {
        class = ".*",
    },
    group = "barred",
})
hl.window_rule({
    name = "windowrule-2",
    match = {
        class = "(com.candy.widgets|gjs|widgets)",
    },
    pin = true,
    border_size = 3,
})
hl.window_rule({
    name = "windowrule-3",
    match = {
        title = "(candy.utils)",
    },
    move = "((monitor_w*0.5)-(window_w*0.5)) 45",
})
hl.window_rule({
    name = "windowrule-4",
    match = {
        title = "(candy.systemmonitor)",
    },
    move = "((monitor_w*1)-((window_w*1)+10)) 45",
})
hl.window_rule({
    name = "windowrule-5",
    match = {
        title = "(candy.weather)",
    },
    move = "((monitor_w*0.5)-(window_w*0.5)) 45",
})
hl.window_rule({
    name = "windowrule-6",
    match = {
        title = "(candy.media)",
    },
    move = "(monitor_w*0.01) 50",
})
hl.window_rule({
    name = "windowrule-7",
    match = {
        class = "^(kitty|kitty-scratchpad|Alacritty|floating-installer|clock)$",
    },
    opacity = "1.0 1.0",
})
hl.window_rule({
    name = "windowrule-8",
    match = {
        class = "(kitty-scratchpad)",
    },
    float = true,
    center = true,
    size = "800 500",
})
hl.window_rule({
    name = "windowrule-9",
    match = {
        class = "^$",
        title = "^$",
        xwayland = "True",
        float = "True",
        fullscreen = "False",
        pinned = "False",
    },
    suppress_event = "maximize",
})
hl.window_rule({
    name = "windowrule-10",
    match = {
        class = "(.*org.pulseaudio.pavucontrol.*)",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-11",
    match = {
        class = "(.*org.pulseaudio.pavucontrol.*)",
    },
    size = "700 600",
})
hl.window_rule({
    name = "windowrule-12",
    match = {
        class = "(.*org.pulseaudio.pavucontrol.*)",
    },
    center = true,
})
hl.window_rule({
    name = "windowrule-13",
    match = {
        class = "(.*waypaper.*)",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-14",
    match = {
        class = "(.*waypaper.*)",
    },
    size = "800 600",
})
hl.window_rule({
    name = "windowrule-15",
    match = {
        class = "(.*waypaper.*)",
    },
    center = true,
})
hl.window_rule({
    name = "windowrule-16",
    match = {
        class = "(blueman-manager)",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-17",
    match = {
        class = "(blueman-manager)",
    },
    size = "800 600",
})
hl.window_rule({
    name = "windowrule-18",
    match = {
        class = "(blueman-manager)",
    },
    center = true,
})
hl.window_rule({
    name = "windowrule-19",
    match = {
        class = "(org.gnome.Weather)",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-20",
    match = {
        class = "(org.gnome.Weather)",
    },
    size = "700 600",
})
hl.window_rule({
    name = "windowrule-21",
    match = {
        class = "(org.gnome.Weather)",
    },
    center = true,
})
hl.window_rule({
    name = "windowrule-22",
    match = {
        class = "(org.gnome.Calendar)",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-23",
    match = {
        class = "(org.gnome.Calendar)",
    },
    size = "820 600",
})
hl.window_rule({
    name = "windowrule-24",
    match = {
        class = "(org.gnome.Calendar)",
    },
    center = true,
})
hl.window_rule({
    name = "windowrule-25",
    match = {
        class = "(org.gnome.SystemMonitor)",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-26",
    match = {
        class = "(org.gnome.SystemMonitor)",
    },
    size = "820 625",
})
hl.window_rule({
    name = "windowrule-27",
    match = {
        class = "(org.gnome.SystemMonitor)",
    },
    center = true,
})
hl.window_rule({
    name = "windowrule-28",
    match = {
        title = "(Open Files)",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-29",
    match = {
        title = "(Open Files)",
    },
    size = "700 600",
})
hl.window_rule({
    name = "windowrule-30",
    match = {
        title = "(Open Files)",
    },
    center = true,
})
hl.window_rule({
    name = "windowrule-31",
    match = {
        title = "(Select Copy Destination)",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-32",
    match = {
        title = "(Select Copy Destination)",
    },
    size = "700 600",
})
hl.window_rule({
    name = "windowrule-33",
    match = {
        title = "(Select Copy Destination)",
    },
    center = true,
})
hl.window_rule({
    name = "windowrule-34",
    match = {
        title = "(Select Move Destination)",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-35",
    match = {
        title = "(Select Move Destination)",
    },
    size = "700 600",
})
hl.window_rule({
    name = "windowrule-36",
    match = {
        title = "(Select Move Destination)",
    },
    center = true,
})
hl.window_rule({
    name = "windowrule-37",
    match = {
        title = "(Save As)",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-38",
    match = {
        title = "(Save As)",
    },
    size = "700 600",
})
hl.window_rule({
    name = "windowrule-39",
    match = {
        title = "(Save As)",
    },
    center = true,
})
hl.window_rule({
    name = "windowrule-40",
    match = {
        title = "(Select files to send)",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-41",
    match = {
        title = "(Select files to send)",
    },
    size = "700 600",
})
hl.window_rule({
    name = "windowrule-42",
    match = {
        title = "(Select files to send)",
    },
    center = true,
})
hl.window_rule({
    name = "windowrule-43",
    match = {
        title = "(Bluetooth File Transfer)",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-44",
    match = {
        class = "(nwg-look)",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-45",
    match = {
        class = "(nwg-look)",
    },
    size = "700 600",
})
hl.window_rule({
    name = "windowrule-46",
    match = {
        class = "(nwg-look)",
    },
    center = true,
})
hl.window_rule({
    name = "windowrule-47",
    match = {
        title = "(CachyOS Hello)",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-48",
    match = {
        title = "(CachyOS Hello)",
    },
    size = "700 600",
})
hl.window_rule({
    name = "windowrule-49",
    match = {
        title = "(CachyOS Hello)",
    },
    center = true,
})
hl.window_rule({
    name = "windowrule-50",
    match = {
        class = "(nwg-displays)",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-51",
    match = {
        class = "(nwg-displays)",
    },
    size = "990 600",
})
hl.window_rule({
    name = "windowrule-52",
    match = {
        class = "(nwg-displays)",
    },
    center = true,
})
hl.window_rule({
    name = "windowrule-53",
    match = {
        class = "(io.missioncenter.MissionCenter)",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-54",
    match = {
        class = "(io.missioncenter.MissionCenter)",
    },
    center = true,
})
hl.window_rule({
    name = "windowrule-55",
    match = {
        class = "(io.missioncenter.MissionCenter)",
    },
    size = "900 600",
})
hl.window_rule({
    name = "windowrule-56",
    match = {
        class = "(missioncenter)",
        title = "^(Preferences)$",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-57",
    match = {
        class = "(missioncenter)",
        title = "^(Preferences)$",
    },
    center = true,
})
hl.window_rule({
    name = "windowrule-58",
    match = {
        class = "(org.gnome.Calculator)",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-59",
    match = {
        class = "(org.gnome.Calculator)",
    },
    size = "700 600",
})
hl.window_rule({
    name = "windowrule-60",
    match = {
        class = "(org.gnome.Calculator)",
    },
    center = true,
})
hl.window_rule({
    name = "windowrule-61",
    match = {
        class = "(it.mijorus.smile)",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-62",
    match = {
        class = "(it.mijorus.smile)",
    },
    move = "100%-w-40 90",
})
hl.window_rule({
    name = "windowrule-63",
    match = {
        class = "(hyprland-share-picker)",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-64",
    match = {
        title = "match:class (hyprland-share-picker)",
    },
    center = true,
})
hl.window_rule({
    name = "windowrule-65",
    match = {
        class = "(hyprland-share-picker)",
    },
    size = "600 400",
})
hl.window_rule({
    name = "windowrule-66",
    match = {
        title = "(hyprviz)",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-67",
    match = {
        title = "(hyprviz)",
    },
    size = "1000 625",
})
hl.window_rule({
    name = "windowrule-68",
    match = {
        title = "(hyprviz)",
    },
    center = true,
})
hl.window_rule({
    name = "windowrule-69",
    match = {
        class = "(dotfiles-floating)",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-70",
    match = {
        class = "(dotfiles-floating)",
    },
    size = "1000 700",
})
hl.window_rule({
    name = "windowrule-71",
    match = {
        class = "(dotfiles-floating)",
    },
    center = true,
})
hl.window_rule({
    name = "windowrule-72",
    match = {
        title = "(satty)",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-73",
    match = {
        title = "(satty)",
    },
    size = "1000 565",
})
hl.window_rule({
    name = "windowrule-74",
    match = {
        title = "(satty)",
    },
    center = true,
})
hl.window_rule({
    name = "windowrule-75",
    match = {
        class = "^(org.pulseaudio.pavucontrol)",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-76",
    match = {
        class = "^()$",
        title = "^(Picture in picture)$",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-77",
    match = {
        class = "^()$",
        title = "^(Save File)$",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-78",
    match = {
        class = "^()$",
        title = "^(Open File)$",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-79",
    match = {
        class = "^(LibreWolf)$",
        title = "^(Picture-in-Picture)$",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-80",
    match = {
        class = "^(xdg-desktop-portal-hyprland|xdg-desktop-portal-gtk|xdg-desktop-portal-kde)(.*)$",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-81",
    match = {
        class = "^(hyprpolkitagent|polkit-gnome-authentication-agent-1|org.org.kde.polkit-kde-authentication-agent-1)(.*)$",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-82",
    match = {
        title = "^(CachyOSHello)$",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-83",
    match = {
        class = "^(zenity)$",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-84",
    match = {
        class = "^()$",
        title = "^(Steam - Self Updater)$",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-85",
    match = {
        class = "^(zen)$",
    },
    opacity = "1.0",
})
hl.window_rule({
    name = "windowrule-86",
    match = {
        title = "^(Picture-in-Picture)$",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-87",
    match = {
        title = "^(Picture-in-Picture)$",
    },
    pin = true,
})
hl.window_rule({
    name = "windowrule-88",
    match = {
        title = "^(Picture-in-Picture)$",
    },
    size = "360 200",
})
hl.window_rule({
    name = "windowrule-89",
    match = {
        title = "^(Picture-in-Picture)$",
    },
    move = "((monitor_w*0.5)-(window_w*0.5)) 50",
})
hl.window_rule({
    name = "windowrule-90",
    match = {
        title = "^(imv|mpv|danmufloat|termfloat|nemo|ncmpcpp)$",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-91",
    match = {
        title = "^(imv|mpv|danmufloat|termfloat|nemo|ncmpcpp)$",
    },
    move = "25%-",
})
hl.window_rule({
    name = "windowrule-92",
    match = {
        title = "^(imv|mpv|danmufloat|termfloat|nemo|ncmpcpp)$",
    },
    size = "960 540",
})
hl.window_rule({
    name = "windowrule-93",
    match = {
        title = "^(danmufloat|termfloat)$",
    },
    rounding = 10,
})
hl.window_rule({
    name = "windowrule-94",
    match = {
        class = "^(kitty|Alacritty)$",
    },
    animation = "slide right",
})
hl.window_rule({
    name = "vwindowrule-95",
    match = {
        title = "^(Brave-browser)$",
    },
    float = false,
})
hl.window_rule({
    name = "windowrule-96",
    match = {
        title = "^(pavucontrol)$",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-97",
    match = {
        title = "^(blueman-manager)$",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-98",
    match = {
        title = "^(nm-connection-editor)$",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-99",
    match = {
        title = "^(qalculate-gtk)$",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-100",
    match = {
        class = "([window])",
    },
    idle_inhibit = "fullscreen",
    -- TODO verify direct Lua equivalent for legacy effect: always
    -- TODO verify direct Lua equivalent for legacy effect: focus
    -- TODO verify direct Lua equivalent for legacy effect: fullscreen
})
hl.window_rule({
    name = "windowrule-101",
    match = {
        class = "^(nautilus)$",
    },
    opacity = "1.0 $& 1.0 $& 1",
})
hl.window_rule({
    name = "windowrule-102",
    match = {
        class = "^(zen)$",
    },
    opacity = "1.0 $& 1.0 $& 1",
})
hl.window_rule({
    name = "windowrule-103",
    match = {
        class = "^(code-oss)$",
    },
    opacity = "1.0 $& 1.0 $& 1",
})
hl.window_rule({
    name = "windowrule-104",
    match = {
        class = "^([Cc]ode)$",
    },
    opacity = "1.0 $& 1.0 $& 1",
})
hl.window_rule({
    name = "windowrule-105",
    match = {
        class = "^(nwg-look)$",
    },
    opacity = "1.0 $& 1.0 $& 1",
})
hl.window_rule({
    name = "windowrule-106",
    match = {
        class = "^(qt5ct)$",
    },
    opacity = "1.0 $& 1.0 $& 1",
})
hl.window_rule({
    name = "windowrule-107",
    match = {
        class = "^(qt6ct)$",
    },
    opacity = "1.0 $& 1.0 $& 1",
})
hl.window_rule({
    name = "windowrule-108",
    match = {
        class = "^(kvantummanager)$",
    },
    opacity = "1.0 $& 1.0 $& 1",
})
hl.window_rule({
    name = "windowrule-109",
    match = {
        class = "^([Ss]potify)$",
    },
    opacity = "1.0 $& 1.0 $& 1",
})
hl.window_rule({
    name = "windowrule-110",
    match = {
        title = "^(Spotify Free)$",
    },
    opacity = "1.0 $& 1.0 $& 1",
})
hl.window_rule({
    name = "windowrule-111",
    match = {
        title = "^(Spotify Premium)$",
    },
    opacity = "1.0 $& 1.0 $& 1",
})
hl.window_rule({
    name = "windowrule-112",
    match = {
        class = "^(org.kde.dolphin)$",
        title = "^(Progress Dialog — Dolphin)$",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-113",
    match = {
        class = "^(org.kde.dolphin)$",
        title = "^(Copying — Dolphin)$",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-114",
    match = {
        title = "^(About Mozilla Firefox)$",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-115",
    match = {
        class = "^(firefox)$",
        title = "^(Picture-in-Picture)$",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-116",
    match = {
        class = "^(firefox)$",
        title = "^(Library)$",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-117",
    match = {
        class = "^(kitty)$",
        title = "^(top)$",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-118",
    match = {
        class = "^(kitty)$",
        title = "^(btop)$",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-119",
    match = {
        class = "^(kitty)$",
        title = "^(htop)$",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-120",
    match = {
        class = "^(eww-main-window)$",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-121",
    match = {
        class = "^(eww-notifications)$",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-122",
    match = {
        class = "^(kvantummanager)$",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-123",
    match = {
        class = "^(qt5ct)$",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-124",
    match = {
        class = "^(qt6ct)$",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-125",
    match = {
        class = "^(nwg-look)$",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-126",
    match = {
        class = "^(org.kde.ark)$",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-127",
    match = {
        class = "^(org.pulseaudio.pavucontrol)$",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-128",
    match = {
        class = "^(blueman-manager)$",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-129",
    match = {
        class = "^(nm-applet)$",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-130",
    match = {
        class = "^(nm-connection-editor)$",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-131",
    match = {
        class = "^(org.kde.polkit-kde-authentication-agent-1)$",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-132",
    match = {
        class = "^(Signal)$",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-133",
    match = {
        class = "^(com.github.rafostar.Clapper)$",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-134",
    match = {
        class = "^(app.drey.Warp)$",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-135",
    match = {
        class = "^(net.davidotek.pupgui2)$",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-136",
    match = {
        class = "^(yad)$",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-137",
    match = {
        class = "^(eog)$",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-138",
    match = {
        class = "^(io.github.alainm23.planify)$",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-139",
    match = {
        class = "^(io.gitlab.theevilskeleton.Upscaler)$",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-140",
    match = {
        class = "^(com.github.unrud.VideoDownloader)$",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-141",
    match = {
        class = "^(io.gitlab.adhami3310.Impression)$",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-142",
    match = {
        class = "^(io.missioncenter.MissionCenter)$",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-143",
    match = {
        class = "(clipse)",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-144",
    match = {
        class = "(clipse)",
    },
    size = "622 652",
})
hl.window_rule({
    name = "windowrule-145",
    match = {
        title = "^(Choose Files)$",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-146",
    match = {
        title = "^(Save As)$",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-147",
    match = {
        title = "^(Confirm to replace files)$",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-148",
    match = {
        title = "^(File Operation Progress)$",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-149",
    match = {
        class = "^(xdg-desktop-portal-gtk)$",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-150",
    match = {
        class = "(floating-installer)",
    },
    float = true,
})
hl.window_rule({
    name = "windowrule-151",
    match = {
        class = "(floating-installer)",
    },
    center = true,
})
hl.window_rule({
    name = "windowrule-152",
    match = {
        class = "(clock)",
    },
    float = true,
    center = true,
    size = "400 200",
})
hl.window_rule({
    name = "windowrule-153",
    rounding = 10,
    -- TODO verify direct Lua equivalent for legacy effect: fullscreen true
    border_size = 3,
})

-- Workspace rules
hl.workspace_rule({
    workspace = "hidden",
})
hl.workspace_rule({
    workspace = "w[fv1-10]",
    -- TODO verify direct Lua equivalent for legacy workspace option: border_color c $source_color
    -- TODO verify direct Lua equivalent for legacy workspace option: float on #$on_primary_fixed_variant 90deg
})
hl.workspace_rule({
    workspace = "f[1]",
    gaps_out = 6,
    gaps_in = 4,
})
hl.workspace_rule({
    workspace = "1",
    layoutopt = "orientation:left",
})
hl.workspace_rule({
    workspace = "2",
    layoutopt = "orientation:right",
})
hl.workspace_rule({
    workspace = "3",
    layoutopt = "orientation:left",
})
hl.workspace_rule({
    workspace = "4",
    layoutopt = "orientation:right",
})
hl.workspace_rule({
    workspace = "5",
    layoutopt = "orientation:left",
})
hl.workspace_rule({
    workspace = "6",
    layoutopt = "orientation:right",
})
hl.workspace_rule({
    workspace = "7",
    layoutopt = "orientation:left",
})
hl.workspace_rule({
    workspace = "8",
    layoutopt = "orientation:right",
})
hl.workspace_rule({
    workspace = "9",
    layoutopt = "orientation:left",
})
hl.workspace_rule({
    workspace = "10",
    layoutopt = "orientation:right",
})

-- Layer rules
hl.layer_rule({
    name = "layer-rule-1",
    match = {
        namespace = "logout_dialog",
    },
    animation = "slide top",
})
hl.layer_rule({
    name = "layer-rule-2",
    match = {
        namespace = "rofi",
    },
    blur = true,
    xray = true,
    no_anim = true,
})
hl.layer_rule({
    name = "layer-rule-3",
    match = {
        namespace = "rofi",
    },
    ignore_alpha = 0.01,
})
hl.layer_rule({
    name = "layer-rule-4",
    match = {
        namespace = "notifications",
    },
    blur = true,
})
hl.layer_rule({
    name = "layer-rule-5",
    match = {
        namespace = "notifications",
    },
    ignore_alpha = 0.01,
})
hl.layer_rule({
    name = "layer-rule-6",
    match = {
        namespace = "swaync-notification-window",
    },
    blur = true,
})
hl.layer_rule({
    name = "layer-rule-7",
    match = {
        namespace = "swaync-notification-window",
    },
    ignore_alpha = 0.01,
})
hl.layer_rule({
    name = "layer-rule-8",
    match = {
        namespace = "swaync-control-center",
    },
    blur = true,
    xray = true,
    no_anim = true,
})
hl.layer_rule({
    name = "layer-rule-9",
    match = {
        namespace = "swaync-control-center",
    },
    ignore_alpha = 0.01,
})
hl.layer_rule({
    name = "layer-rule-10",
    match = {
        namespace = "hyprcandy-dock",
    },
    blur = true,
    xray = true,
    no_anim = true,
})
hl.layer_rule({
    name = "layer-rule-11",
    match = {
        namespace = "hyprcandy-dock",
    },
    ignore_alpha = 0.01,
})
hl.layer_rule({
    name = "layer-rule-12",
    match = {
        namespace = "hyprcandy-launcher",
    },
    blur = true,
    xray = true,
    no_anim = true,
})
hl.layer_rule({
    name = "layer-rule-13",
    match = {
        namespace = "hyprcandy-launcher",
    },
    ignore_alpha = 0.01,
})
hl.layer_rule({
    name = "layer-rule-14",
    match = {
        namespace = "logout_dialog",
    },
    blur = true,
})
hl.layer_rule({
    name = "layer-rule-15",
    match = {
        namespace = "logout_dialog",
    },
    ignore_alpha = 0.01,
})
hl.layer_rule({
    name = "layer-rule-16",
    match = {
        namespace = "gtk-layer-shell",
    },
    blur = true,
})
hl.layer_rule({
    name = "layer-rule-17",
    match = {
        namespace = "gtk-layer-shell",
    },
    ignore_alpha = 0.01,
})
hl.layer_rule({
    name = "layer-rule-18",
    match = {
        namespace = "waybar",
    },
    blur = true,
    no_anim = true,
})
hl.layer_rule({
    name = "layer-rule-19",
    match = {
        namespace = "waybar",
    },
    ignore_alpha = 0.01,
})
hl.layer_rule({
    name = "layer-rule-20",
    match = {
        namespace = "dashboardmenu",
    },
    blur = true,
})
hl.layer_rule({
    name = "layer-rule-21",
    match = {
        namespace = "dashboardmenu",
    },
    ignore_alpha = 0.01,
})
hl.layer_rule({
    name = "layer-rule-22",
    match = {
        namespace = "quickshell",
    },
    blur = true,
    xray = true,
    no_anim = true,
})
hl.layer_rule({
    name = "layer-rule-23",
    match = {
        namespace = "quickshell",
    },
    ignore_alpha = 0.01,
})
hl.layer_rule({
    name = "layer-rule-24",
    match = {
        namespace = "quickshell:overview",
    },
    blur = true,
    xray = true,
    no_anim = true,
})
hl.layer_rule({
    name = "layer-rule-25",
    match = {
        namespace = "quickshell:overview",
    },
    ignore_alpha = 0.01,
})
hl.layer_rule({
    name = "layer-rule-26",
    match = {
        namespace = "quickshell:weather-popup",
    },
    blur = true,
    xray = true,
    no_anim = true,
})
hl.layer_rule({
    name = "layer-rule-27",
    match = {
        namespace = "quickshell:weather-popup",
    },
    ignore_alpha = 0.01,
})
hl.layer_rule({
    name = "layer-rule-28",
    match = {
        namespace = "quickshell:sysmon-popup",
    },
    blur = true,
    xray = true,
    no_anim = true,
})
hl.layer_rule({
    name = "layer-rule-29",
    match = {
        namespace = "quickshell:sysmon-popup",
    },
    ignore_alpha = 0.01,
})
hl.layer_rule({
    name = "layer-rule-30",
    match = {
        namespace = "quickshell:clock-popup",
    },
    blur = true,
    xray = true,
    no_anim = true,
})
hl.layer_rule({
    name = "layer-rule-31",
    match = {
        namespace = "quickshell:clock-popup",
    },
    ignore_alpha = 0.01,
})
hl.layer_rule({
    name = "layer-rule-32",
    match = {
        namespace = "quickshell:calendar-popup",
    },
    blur = true,
    xray = true,
    no_anim = true,
})
hl.layer_rule({
    name = "layer-rule-33",
    match = {
        namespace = "quickshell:calendar-popup",
    },
    ignore_alpha = 0.01,
})
hl.layer_rule({
    name = "layer-rule-34",
    match = {
        namespace = "quickshell:systraypopup",
    },
    blur = true,
    xray = true,
    no_anim = true,
})
hl.layer_rule({
    name = "layer-rule-35",
    match = {
        namespace = "quickshell:systraypopup",
    },
    ignore_alpha = 0.01,
})
hl.layer_rule({
    name = "layer-rule-36",
    match = {
        namespace = "quickshell:desktop",
    },
    blur = true,
    no_anim = true,
})
hl.layer_rule({
    name = "layer-rule-37",
    match = {
        namespace = "quickshell:desktop",
    },
    ignore_alpha = 0.01,
})
hl.layer_rule({
    name = "layer-rule-38",
    match = {
        namespace = "quickshell:wallpaper",
    },
    blur = true,
    xray = true,
    no_anim = true,
})
hl.layer_rule({
    name = "layer-rule-39",
    match = {
        namespace = "quickshell:wallpaper",
    },
    ignore_alpha = 0.01,
})
hl.layer_rule({
    name = "layer-rule-40",
    match = {
        namespace = "quickshell:startmenu",
    },
    blur = true,
    xray = true,
    no_anim = true,
})
hl.layer_rule({
    name = "layer-rule-41",
    match = {
        namespace = "quickshell:startmenu",
    },
    ignore_alpha = 0.01,
})
hl.layer_rule({
    name = "layer-rule-42",
    match = {
        namespace = "quickshell-controlcenter",
    },
    blur = true,
    xray = true,
    no_anim = true,
})
hl.layer_rule({
    name = "layer-rule-43",
    match = {
        namespace = "quickshell-controlcenter",
    },
    ignore_alpha = 0.01,
})
hl.layer_rule({
    name = "layer-rule-44",
    match = {
        namespace = "quickshell:notifications:toasts",
    },
    blur = true,
    xray = true,
    no_anim = true,
})
hl.layer_rule({
    name = "layer-rule-45",
    match = {
        namespace = "quickshell:notifications:toasts",
    },
    ignore_alpha = 0.01,
})
hl.layer_rule({
    name = "layer-rule-46",
    match = {
        namespace = "quickshell:notifications:history",
    },
    blur = true,
    xray = true,
    no_anim = true,
})
hl.layer_rule({
    name = "layer-rule-47",
    match = {
        namespace = "quickshell:notifications:history",
    },
    ignore_alpha = 0.01,
})
hl.layer_rule({
    name = "layer-rule-48",
    match = {
        namespace = "notificationsmenu",
    },
    blur = true,
})
hl.layer_rule({
    name = "layer-rule-49",
    match = {
        namespace = "notificationsmenu",
    },
    ignore_alpha = 0.01,
})
hl.layer_rule({
    name = "layer-rule-50",
    match = {
        namespace = "networkmenu",
    },
    blur = true,
})
hl.layer_rule({
    name = "layer-rule-51",
    match = {
        namespace = "networkmenu",
    },
    ignore_alpha = 0.01,
})
hl.layer_rule({
    name = "layer-rule-52",
    match = {
        namespace = "mediamenu",
    },
    blur = true,
})
hl.layer_rule({
    name = "layer-rule-53",
    match = {
        namespace = "mediamenu",
    },
    ignore_alpha = 0.01,
})
hl.layer_rule({
    name = "layer-rule-54",
    match = {
        namespace = "energymenu",
    },
    blur = true,
})
hl.layer_rule({
    name = "layer-rule-55",
    match = {
        namespace = "energymenu",
    },
    ignore_alpha = 0.01,
})
hl.layer_rule({
    name = "layer-rule-56",
    match = {
        namespace = "bluetoothmenu",
    },
    blur = true,
})
hl.layer_rule({
    name = "layer-rule-57",
    match = {
        namespace = "bluetoothmenu",
    },
    ignore_alpha = 0.01,
})
hl.layer_rule({
    name = "layer-rule-58",
    match = {
        namespace = "audiomenu",
    },
    blur = true,
})
hl.layer_rule({
    name = "layer-rule-59",
    match = {
        namespace = "audiomenu",
    },
    ignore_alpha = 0.01,
})
hl.layer_rule({
    name = "layer-rule-60",
    match = {
        namespace = "hyprmenu",
    },
    blur = true,
})
hl.layer_rule({
    name = "layer-rule-61",
    match = {
        namespace = "hyprmenu",
    },
    ignore_alpha = 0.01,
})
hl.layer_rule({
    name = "layer-rule-62",
    match = {
        namespace = "hyprcandy-trash-dialog",
    },
    blur = true,
    xray = true,
    no_anim = true,
})
hl.layer_rule({
    name = "layer-rule-63",
    match = {
        namespace = "hyprcandy-trash-dialog",
    },
    ignore_alpha = 0.01,
})
hl.layer_rule({
    name = "layer-rule-64",
    match = {
        namespace = "quickshell:clock-widget",
    },
    blur = true,
    xray = true,
    no_anim = true,
})
hl.layer_rule({
    name = "layer-rule-65",
    match = {
        namespace = "quickshell:clock-widget",
    },
    ignore_alpha = 0.01,
})
hl.layer_rule({
    name = "layer-rule-66",
    match = {
        namespace = "quickshell:weather-widget",
    },
    blur = true,
    xray = true,
    no_anim = true,
})
hl.layer_rule({
    name = "layer-rule-67",
    match = {
        namespace = "quickshell:weather-widget",
    },
    ignore_alpha = 0.01,
})
hl.layer_rule({
    name = "layer-rule-68",
    match = {
        namespace = "quickshell:sysmon-widget",
    },
    blur = true,
    xray = true,
    no_anim = true,
})
hl.layer_rule({
    name = "layer-rule-69",
    match = {
        namespace = "quickshell:sysmon-widget",
    },
    ignore_alpha = 0.01,
})

-- Keybindings
-- Legacy variables retained as Lua locals for scripts used by keybinds.
local function expand_vars(cmd)
    cmd = cmd:gsub("%$HYPRSCRIPTS", HYPRSCRIPTS):gsub("%$SCRIPTS", SCRIPTS):gsub("%$mainMod", mainMod)
    return cmd
end
hl.bind("SUPER + Escape",hl.dsp.window.close(), { description = "Kill active window" })
hl.bind("SUPER + CTRL + R", hl.dsp.exec_cmd("~/.config/hypr/scripts/rofi-menus.sh"), { description = "Launch utilities rofi-menu" })
hl.bind("SUPER + A", hl.dsp.exec_cmd("~/.hyprcandy/GJS/hyprcandydock/toggle-app-launcher.sh"), { description = "Show/hide rofi application finder" })
hl.bind("SUPER + CTRL + A", hl.dsp.exec_cmd("~/.config/hypr/scripts/animations.sh"), { description = "Select animations" })
hl.bind("SUPER + CTRL + V", hl.dsp.exec_cmd("~/.config/hyprcandy/scripts/cliphist.sh"), { description = "Open clipboard manager" })
hl.bind("SUPER + CTRL + E", hl.dsp.exec_cmd("~/.config/hyprcandy/settings/emojipicker.sh"), { description = "Open rofi emoji-picker" })
hl.bind("SUPER + CTRL + G", hl.dsp.exec_cmd("~/.config/hyprcandy/settings/glyphpicker.sh"), { description = "Open rofi glyph-picker" })
hl.bind("SUPER + W", hl.dsp.exec_cmd("~/.config/hyprcandy/scripts/wallpaper.sh"), { description = "Wallpaper picker" })
hl.bind("ALT + W", hl.dsp.exec_cmd("~/.config/quickshell/wallpaper/wallpaper-cycle.sh -n"), { description = "Alternate wallpapers forward" })
hl.bind("ALT + SHIFT + W", hl.dsp.exec_cmd("~/.config/quickshell/wallpaper/wallpaper-cycle.sh -p"), { description = "Alternate wallpapers backward" })
hl.bind("ALT + SHIFT + R", hl.dsp.exec_cmd("~/.config/hyprcandy/hooks/wallpaper_integration.sh"), { description = "Reload system colors" })
hl.bind("SUPER + B", hl.dsp.exec_cmd("xdg-open \"http://\""), { description = "Launch your default browser" })
hl.bind("ALT + 1", hl.dsp.exec_cmd("~/.config/hyprcandy/scripts/bar.sh"), { description = "Hide/Show bar" })
hl.bind("ALT + 2", hl.dsp.exec_cmd("~/.hyprcandy/GJS/hyprcandydock/toggle.sh"), { description = "Hide/Show dock" })
hl.bind("SUPER + R", hl.dsp.exec_cmd("bash -c 'wf-recorder -g -a --audio=bluez_output.78_15_2D_0D_BD_B7.1.monitor -f \"$HOME/Videos/Recordings/recording-$(date +%Y%m%d-%H%M%S).mp4\" $(slurp)'"), { description = "Start recording" })
hl.bind("Alt + R", hl.dsp.exec_cmd("pkill -x wf-recorder"), { description = "Stop recording" })
hl.bind("Shift + H", hl.dsp.exec_cmd("hyprctl hyprsunset gamma +10"), { description = "Increase gamma by 10%" })
hl.bind("Alt + H", hl.dsp.exec_cmd("hyprctl hyprsunset gamma -10"), { description = "Reduce gamma by 10%" })
hl.bind("ALT + G", hl.dsp.exec_cmd("~/.config/hypr/scripts/gamemode.sh"), { description = "Toggle game-mode" })
hl.bind("SUPER + SHIFT + R", hl.dsp.exec_cmd("~/.config/hypr/scripts/loadconfig.sh"), { description = "Reload Hyprland configuration" })
hl.bind("SUPER + PRINT", hl.dsp.exec_cmd("qs -p ~/.config/quickshell/bar ipc call bar toggleScreenshot"), { description = "Take a screenshot" })
hl.bind("SUPER + V", hl.dsp.exec_cmd("cliphist wipe"), { description = "Clear cliphist database" })
hl.bind("SUPER + CTRL + D", hl.dsp.exec_cmd("$ cliphist list | dmenu | cliphist delete"), { description = "Delete an old item" })
hl.bind("SUPER + ALT + D", hl.dsp.exec_cmd("$ cliphist delete-query \"secret item\""), { description = "Delete an old item quering manually" })
hl.bind("SUPER + ALT + S", hl.dsp.exec_cmd("$ cliphist list | dmenu | cliphist decode | wl-copy"), { description = "Select an old item" })
hl.bind("SUPER + L", hl.dsp.exec_cmd("~/.config/hypr/scripts/power.sh lock"), { description = "Lock" })
hl.bind("SHIFT + TAB", hl.dsp.exec_cmd("~/.config/hyprcandy/scripts/overview.sh"), { description = "Workspace overview" })
hl.bind("SUPER + 1", hl.dsp.focus({ workspace = "1" }), { description = "Open workspace 1" })
hl.bind("SUPER + 2", hl.dsp.focus({ workspace = "2" }), { description = "Open workspace 2" })
hl.bind("SUPER + 3", hl.dsp.focus({ workspace = "3" }), { description = "Open workspace 3" })
hl.bind("SUPER + 4", hl.dsp.focus({ workspace = "4" }), { description = "Open workspace 4" })
hl.bind("SUPER + 5", hl.dsp.focus({ workspace = "5" }), { description = "Open workspace 5" })
hl.bind("SUPER + 6", hl.dsp.focus({ workspace = "6" }), { description = "Open workspace 6" })
hl.bind("SUPER + 7", hl.dsp.focus({ workspace = "7" }), { description = "Open workspace 7" })
hl.bind("SUPER + 8", hl.dsp.focus({ workspace = "8" }), { description = "Open workspace 8" })
hl.bind("SUPER + 9", hl.dsp.focus({ workspace = "9" }), { description = "Open workspace 9" })
hl.bind("SUPER + 0", hl.dsp.focus({ workspace = "10" }), { description = "Open workspace 10" })
hl.bind("SUPER + SHIFT + 1", hl.dsp.window.move({ workspace = "1", follow = true }), { description = "Move active window to workspace 1" })
hl.bind("SUPER + SHIFT + 2", hl.dsp.window.move({ workspace = "2", follow = true }), { description = "Move active window to workspace 2" })
hl.bind("SUPER + SHIFT + 3", hl.dsp.window.move({ workspace = "3", follow = true }), { description = "Move active window to workspace 3" })
hl.bind("SUPER + SHIFT + 4", hl.dsp.window.move({ workspace = "4", follow = true }), { description = "Move active window to workspace 4" })
hl.bind("SUPER + SHIFT + 5", hl.dsp.window.move({ workspace = "5", follow = true }), { description = "Move active window to workspace 5" })
hl.bind("SUPER + SHIFT + 6", hl.dsp.window.move({ workspace = "6", follow = true }), { description = "Move active window to workspace 6" })
hl.bind("SUPER + SHIFT + 7", hl.dsp.window.move({ workspace = "7", follow = true }), { description = "Move active window to workspace 7" })
hl.bind("SUPER + SHIFT + 8", hl.dsp.window.move({ workspace = "8", follow = true }), { description = "Move active window to workspace 8" })
hl.bind("SUPER + SHIFT + 9", hl.dsp.window.move({ workspace = "9", follow = true }), { description = "Move active window to workspace 9" })
hl.bind("SUPER + SHIFT + 0", hl.dsp.window.move({ workspace = "10", follow = true }), { description = "Move active window to workspace 10" })
hl.bind("SUPER + Tab", hl.dsp.focus({ workspace = "m+1" }), { description = "Open next workspace" })
hl.bind("SUPER + SHIFT + Tab", hl.dsp.focus({ workspace = "m-1" }), { description = "Open previous workspace" })
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e+1" }), { description = "Open next workspace" })
hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "e-1" }), { description = "Open previous workspace" })
hl.bind("SUPER + CTRL + down", hl.dsp.focus({ workspace = "empty" }), { description = "Open the next empty workspace" })
hl.bind("CTRL + SHIFT + 1", hl.dsp.workspace.toggle_special("magic"), { description = "Toggle scratchpad/special workspace" })
hl.bind("CTRL + SHIFT + 2", hl.dsp.window.move({ workspace = "special:magic", follow = true }), { description = "Move window to special workspace 4 (Can be toggled with \"SUPER,1\")" })
hl.bind("SUPER + ALT + 1", hl.dsp.window.move({ workspace = "1", follow = false }), { description = "Move active window to workspace 1 silently" })
hl.bind("SUPER + ALT + 2", hl.dsp.window.move({ workspace = "2", follow = false }), { description = "Move active window to workspace 2 silently" })
hl.bind("SUPER + ALT + 3", hl.dsp.window.move({ workspace = "3", follow = false }), { description = "Move active window to workspace 3 silently" })
hl.bind("SUPER + ALT + 4", hl.dsp.window.move({ workspace = "4", follow = false }), { description = "Move active window to workspace 4 silently" })
hl.bind("SUPER + ALT + 5", hl.dsp.window.move({ workspace = "5", follow = false }), { description = "Move active window to workspace 5 silently" })
hl.bind("SUPER + ALT + 6", hl.dsp.window.move({ workspace = "6", follow = false }), { description = "Move active window to workspace 6 silently" })
hl.bind("SUPER + ALT + 7", hl.dsp.window.move({ workspace = "7", follow = false }), { description = "Move active window to workspace 7 silently" })
hl.bind("SUPER + ALT + 8", hl.dsp.window.move({ workspace = "8", follow = false }), { description = "Move active window to workspace 8 silently" })
hl.bind("SUPER + ALT + 9", hl.dsp.window.move({ workspace = "9", follow = false }), { description = "Move active window to workspace 9 silently" })
hl.bind("SUPER + ALT + 0", hl.dsp.window.move({ workspace = "10", follow = false }), { description = "Move active window to workspace 10 silently" })
hl.bind("SUPER + Z", hl.dsp.window.drag(), { mouse = true, description = "Hold to move selected window" })
hl.bind("SUPER + X", hl.dsp.window.resize(), { mouse = true, description = "Hold to resize selected window" })
hl.bind("SUPER + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }), { description = "Set active window to fullscreen" })
hl.bind("SUPER + CTRL + F", hl.dsp.window.float({ action = "toggle" }), { description = "Toggle active windows into floating mode" })
hl.bind("SUPER + CTRL + T", hl.dsp.exec_cmd("~/.config/hypr/scripts/toggleallfloat.sh"), { description = "Toggle all windows into floating mode" })
hl.bind("SUPER + J", hl.dsp.exec_cmd("hyprctl dispatch togglesplit"), { description = "Toggle split" })
hl.bind("SUPER + left", hl.dsp.focus({ direction = "l" }), { description = "Move focus left" })
hl.bind("SUPER + right", hl.dsp.focus({ direction = "r" }), { description = "Move focus right" })
hl.bind("SUPER + up", hl.dsp.focus({ direction = "u" }), { description = "Move focus up" })
hl.bind("SUPER + down", hl.dsp.focus({ direction = "d" }), { description = "Move focus down" })
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true, description = "Move window with the mouse" })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "Resize window with the mouse" })
hl.bind("SUPER + SHIFT + right", hl.dsp.window.resize({ x = 100, y = 0, relative = true }), { description = "Increase window width with keyboard" })
hl.bind("SUPER + SHIFT + left", hl.dsp.window.resize({ x = -100, y = 0, relative = true }), { description = "Reduce window width with keyboard" })
hl.bind("SUPER + SHIFT + down", hl.dsp.window.resize({ x = 0, y = 100, relative = true }), { description = "Increase window height with keyboard" })
hl.bind("SUPER + SHIFT + up", hl.dsp.window.resize({ x = 0, y = -100, relative = true }), { description = "Reduce window height with keyboard" })
hl.bind("SUPER + G", hl.dsp.group.toggle(), { description = "Toggle window group" })
hl.bind("SUPER + CTRL + left", hl.dsp.group.prev(), { description = "Switch to the previous window in the group" })
hl.bind("SUPER + CTRL + right", hl.dsp.group.next(), { description = "Switch to the next window in the group" })
hl.bind("SUPER + ALT + left", hl.dsp.window.swap({ direction = "l" }), { description = "Swap tiled window left" })
hl.bind("SUPER + ALT + right", hl.dsp.window.swap({ direction = "r" }), { description = "Swap tiled window right" })
hl.bind("SUPER + ALT + up", hl.dsp.window.swap({ direction = "u" }), { description = "Swap tiled window up" })
hl.bind("SUPER + ALT + down", hl.dsp.window.swap({ direction = "d" }), { description = "Swap tiled window down" })
hl.bind("ALT + Tab", hl.dsp.window.cycle_next({ next = true }), { repeating = true, description = "Cycle between windows" })
hl.bind("ALT + Tab", hl.dsp.window.alter_zorder({ mode = "top" }), { repeating = true, description = "Bring active floating window to the top" })
hl.bind("SUPER + CTRL + K", hl.dsp.layout("swapsplit"), { description = "Dwindle Layout- swap current focused window's halves" })
hl.bind("ALT + S", hl.dsp.layout("swapwithmaster master"), { description = "Master Layout - switch current focused window to master" })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -q s +10% && notify-send \"Screen Brightness\" \"$(brightnessctl | grep -o '[0-9]*%' | head -1)\" -t 1000"), { description = "Increase brightness by 10%" })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -q s 10%- && notify-send \"Screen Brightness\" \"$(brightnessctl | grep -o '[0-9]*%' | head -1)\" -t 1000"), { description = "Reduce brightness by 10%" })
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ 0 && pactl set-sink-volume @DEFAULT_SINK@ +5% && notify-send \"Volume\" \"$(pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]*%' | head -1)\" -t 1000"), { description = "Volume up" })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ 0 && pactl set-sink-volume @DEFAULT_SINK@ -5% && notify-send \"Volume\" \"$(pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]*%' | head -1)\" -t 1000"), { description = "Volume down" })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ toggle && if pactl get-sink-mute @DEFAULT_SINK@ | grep -q 'yes'; then notify-send \"Volume\" \"Muted\" -t 1000; else notify-send \"Volume\" \"$(pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]*%' | head -1)\" -t 1000; fi"), { description = "Mute Volume" })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { description = "Audio play pause" })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl pause"), { description = "Audio pause" })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { description = "Audio next" })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { description = "Audio previous" })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("pactl set-source-mute @DEFAULT_SOURCE@ toggle"), { description = "Toggle microphone" })
hl.bind("XF86Calculator", hl.dsp.exec_cmd("~/.config/hyprcandy/settings/calculator.sh"), { description = "Open calculator" })
hl.bind("XF86Lock", hl.dsp.exec_cmd("hyprlock"), { description = "Open screenlock" })
hl.bind("code:236", hl.dsp.exec_cmd("brightnessctl -d smc::kbd_backlight s +10 && notify-send \"Keyboard Backlight\" \"$(brightnessctl -d smc::kbd_backlight | grep -o '[0-9]*%' | head -1)\" -t 1000"), { description = "Keyboard brghtness up" })
hl.bind("code:237", hl.dsp.exec_cmd("brightnessctl -d smc::kbd_backlight s 10- && notify-send \"Keyboard Backlight\" \"$(brightnessctl -d smc::kbd_backlight | grep -o '[0-9]*%' | head -1)\" -t 1000"), { description = "Keyboard brghtness down" })

return true
EOF
fi
}

setup_gjs() {
# Create the GJS directory and files if they don't already exist
if [ ! -d "$USER_HOME/.hyprcandy/GJS/src" ]; then
    mkdir -p "$USER_HOME/.hyprcandy/GJS/src"
    echo "📁 Created the GJS directory"
fi

cd "$USER_HOME/.hyprcandy/GJS"
rm -f toggle-control-center.sh toggle-media-player.sh toggle-system-monitor.sh toggle-weather-widget.sh
cd "$USER_HOME"

cat > "$USER_HOME/.hyprcandy/GJS/toggle-control-center.sh" << 'EOF'
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
chmod +x "$USER_HOME/.hyprcandy/GJS/toggle-control-center.sh"

cat > "$USER_HOME/.hyprcandy/GJS/toggle-system-monitor.sh" << 'EOF'
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
chmod +x "$USER_HOME/.hyprcandy/GJS/toggle-system-monitor.sh"

cat > "$USER_HOME/.hyprcandy/GJS/toggle-media-player.sh" << 'EOF'
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
chmod +x "$USER_HOME/.hyprcandy/GJS/toggle-media-player.sh"

cat > "$USER_HOME/.hyprcandy/GJS/toggle-weather-widget.sh" << 'EOF'
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
chmod +x "$USER_HOME/.hyprcandy/GJS/toggle-weather-widget.sh"

find "$USER_HOME/.hyprcandy/GJS" -name "*.sh" -exec chmod +x {} \;
chmod +x "$USER_HOME/.hyprcandy/GJS/candy-daemon.js"

cat > "$USER_HOME/.hyprcandy/GJS/hyprcandydock/dock-main.js" << 'EOF'
#!/usr/bin/env gjs

// HyprCandy Dock - GTK4/GJS 2026 Implementation
// Modern replacement for nwg-dock-hyprland with HyprCandy theming
// Features: Drag-drop rearrange, async pin update, side popovers, proper indicators

imports.gi.versions.Gtk = '4.0';
imports.gi.versions.Gdk = '4.0';

const { Gtk, Gdk, Gio, GLib, GObject } = imports.gi;
const GLibUnix = imports.gi.GLibUnix;
const Gtk4LayerShell = imports.gi.Gtk4LayerShell;

// Import daemon + config
// Use the script's own directory — '.' is the working directory which breaks
// when the dock is launched from outside its own folder (e.g. exec-once in hyprland.conf).
const _dockDir = GLib.path_get_dirname(imports.system.programInvocationName);
imports.searchPath.unshift(_dockDir);
const Daemon     = imports.daemon.Daemon;
const DockConfig = imports.config.DockConfig;

// --- Parse position flag from ARGV ------------------------------------
// Usage: gjs dock-main.js [-b|-t|-l|-r]
(function parsePositionFlag() {
    const args = ARGV || [];
    if      (args.includes('-t')) DockConfig.position = 'top';
    else if (args.includes('-l')) DockConfig.position = 'left';
    else if (args.includes('-r')) DockConfig.position = 'right';
    else                          DockConfig.position = 'bottom'; // default
})();

// Apply position-specific config overrides
(function applyPositionOverrides() {
    const pos = DockConfig.position;
    const overrides = DockConfig.positionOverrides?.[pos];
    if (overrides) {
        Object.assign(DockConfig, overrides);
        log('[dock] Applied position overrides for: ' + pos);
    }
})();

const IS_VERTICAL = (DockConfig.position === 'left' || DockConfig.position === 'right');
function _spawnCleanCmd(cmdStr) {
    try {
        const [, argv] = GLib.shell_parse_argv(cmdStr);
        let envp = GLib.get_environ();
        envp = GLib.environ_unsetenv(envp, 'LD_PRELOAD');
        GLib.spawn_async(GLib.get_home_dir(), argv, envp,
            GLib.SpawnFlags.SEARCH_PATH | GLib.SpawnFlags.DO_NOT_REAP_CHILD,
            null);
    } catch (e) { console.error('_spawnCleanCmd failed:', e.message); }
}


// --- Configuration (live from DockConfig) -----------------------------
// Three independent size axes: app icons, glyph icons, indicators
const APP_ICON_SIZE   = DockConfig.appIconSize;
const GLYPH_ICON_SIZE = DockConfig.glyphIconSize !== null
    ? DockConfig.glyphIconSize
    : Math.round(APP_ICON_SIZE * (DockConfig.glyphIconSizeFraction || 1.1));
const INDICATOR_SIZE  = DockConfig.indicatorSize !== null
    ? DockConfig.indicatorSize
    : Math.max(6, Math.round(APP_ICON_SIZE * DockConfig.indicatorSizeFraction));
const INDICATOR_SPACING = DockConfig.indicatorSpacing;
// Legacy alias used throughout
const ICON_SIZE = APP_ICON_SIZE;

// Glyph icons — Nerd Font Unicode codepoints (NF font required)
const GLYPH_START      = '󱗼';   //  Linux / start
const GLYPH_INDICATOR  = '\u{F09DF}';  //  active-window dot "\u{F09DF}"
const GLYPH_TRASH_EMPTY = '󰩺';   //  nf-md-trash_can_outline — no files in trash
const GLYPH_TRASH_FULL  = '󰩹';   //  nf-md-trash_can         — files present (replaces delete_empty)
const GLYPH_TRASH_HEAVY = '󰆴';   //  nf-md-delete            — heavily loaded (>20 items)
// Hyprland logo glyph (nf-linux-hyprland, NerdFonts >= 3.2)
const GLYPH_FALLBACK  = '󱙝';   //  shown when app has no icon

// --- CSS Management ---------------------------------------------------
const HOME = GLib.get_home_dir();
const GTK3_COLORS_PATH      = GLib.build_filenamev([HOME, '.config', 'gtk-3.0', 'colors.css']);
const GTK4_COLORS_PATH      = GLib.build_filenamev([HOME, '.config', 'gtk-4.0', 'colors.css']);
const DOCK_STYLE_PATH       = GLib.build_filenamev([HOME, '.hyprcandy', 'GJS', 'hyprcandydock', 'style.css']);
const DOCK_CONFIG_PATH      = GLib.build_filenamev([HOME, '.hyprcandy', 'GJS', 'hyprcandydock', 'config.js']);
// Absolute path so the toggle script is found regardless of working-directory
// (exec-once in hyprland.conf sets cwd to '/', not the dock folder).
const LAUNCHER_TOGGLE_PATH  = GLib.build_filenamev([HOME, '.hyprcandy', 'GJS', 'hyprcandydock', 'toggle-app-launcher.sh']);
const LAUNCHER_STATE_PATH   = GLib.build_filenamev([HOME, '.cache', 'hyprcandy', 'launcher.state']);
const HYPRCANDY_CONF_PATH   = GLib.build_filenamev([HOME, '.config', 'hyprcandy', 'hyprcandy-bar.conf']);

let cssProviders = [];          // Static providers cleared/re-added on theme change
let dynamicConfigProvider = null; // Persistent provider for config-driven values — never cleared
let dockWindow = null;

let _colorMonitor     = null;  // Gio.FileMonitor for gtk-4.0/colors.css
let _styleMonitor     = null;  // Gio.FileMonitor for hyprcandydock/style.css
let _colorReloadTimer = 0;     // GLib timeout source ID (debounce)
let _styleReloadTimer = 0;
let _launcherMonitor  = null; // Gio.FileMonitor for launcher.state
let _launcherOpen     = false; // true while launcher window is visible

function loadCSS() {
    const display = Gdk.Display.get_default();
    
    // Remove old providers
    for (const provider of cssProviders) {
        try {
            Gtk.StyleContext.remove_provider_for_display(display, provider);
        } catch (e) { /* ignore */ }
    }
    cssProviders = [];

    // Load GTK3 colors (matugen named colors)
    if (GLib.file_test(GTK3_COLORS_PATH, GLib.FileTest.EXISTS)) {
        const gtk3Provider = new Gtk.CssProvider();
        try {
            gtk3Provider.load_from_path(GTK3_COLORS_PATH);
            Gtk.StyleContext.add_provider_for_display(display, gtk3Provider, Gtk.STYLE_PROVIDER_PRIORITY_USER);
            cssProviders.push(gtk3Provider);
        } catch (e) {
            log('[dock] Failed to load GTK3 colors: ' + e.message);
        }
    }

    // Load GTK4 colors
    if (GLib.file_test(GTK4_COLORS_PATH, GLib.FileTest.EXISTS)) {
        const gtk4Provider = new Gtk.CssProvider();
        try {
            gtk4Provider.load_from_path(GTK4_COLORS_PATH);
            Gtk.StyleContext.add_provider_for_display(display, gtk4Provider, Gtk.STYLE_PROVIDER_PRIORITY_USER);
            cssProviders.push(gtk4Provider);
        } catch (e) {
            log('[dock] Failed to load GTK4 colors: ' + e.message);
        }
    }

    // Load dock style
    if (GLib.file_test(DOCK_STYLE_PATH, GLib.FileTest.EXISTS)) {
        const styleProvider = new Gtk.CssProvider();
        try {
            styleProvider.load_from_path(DOCK_STYLE_PATH);
            Gtk.StyleContext.add_provider_for_display(display, styleProvider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);
            cssProviders.push(styleProvider);
        } catch (e) {
            log('[dock] Failed to load dock style: ' + e.message);
        }
    }

    // Inject computed glyph sizes from config so ICON_SIZE drives all unicode labels.
    // This runs after style.css so it overrides the static fallback font-sizes.
    _injectGlyphSizeCSS(display);
}

// Remap canonical (bottom-dock) corner radii → widget-local CSS corners.
//   top*    = desktop-facing edge  |  bottom* = screen-attached edge
// Read a string @HCD value directly from config.js on disk (source of truth on hot-reload).
function _readHcdString(key) {
    try {
        const [ok, contents] = GLib.file_get_contents(DOCK_CONFIG_PATH);
        if (!ok) return null;
        const text = new TextDecoder().decode(contents);
        const re = new RegExp('\\b' + key + ":\\s*'([^']*)'");
        const m = text.match(re);
        return m ? m[1] : null;
    } catch (e) {
        return null;
    }
}

// Border colour lives in style.css (GTK @name) — not in the dynamic injector.
function _readBorderColorFromStyle() {
    try {
        const [ok, contents] = GLib.file_get_contents(DOCK_STYLE_PATH);
        if (!ok) return null;
        const text = new TextDecoder().decode(contents);
        const m = text.match(/border-color:\s*@([a-zA-Z0-9_]+)/);
        return m ? m[1] : null;
    } catch (e) {
        return null;
    }
}

function _mapCornersForPosition(edge, storedTL, storedTR, storedBL, storedBR) {
    switch (edge) {
    case 'top':
        return { tl: storedBL, tr: storedBR, bl: storedTL, br: storedTR };
    case 'left':
        return { tl: storedBL, tr: storedTL, bl: storedBR, br: storedTR };
    case 'right':
        return { tl: storedTR, tr: storedBR, bl: storedTL, br: storedBL };
    default: // bottom
        return { tl: storedTL, tr: storedTR, bl: storedBL, br: storedBR };
    }
}

function _injectGlyphSizeCSS(display) {
    // Read live from DockConfig so hot-reload (SIGUSR2) picks up new values.
    // Do NOT use the baked consts (APP_ICON_SIZE etc.) here — they are frozen
    // at process start and won't reflect config edits.
    const appPx       = DockConfig.appIconSize;
    const glyphPx     = DockConfig.glyphIconSize !== null
        ? DockConfig.glyphIconSize
        : Math.round((appPx - 2) * (DockConfig.glyphIconSizeFraction || 1.1));
    const indicatorPx = DockConfig.indicatorSize !== null
        ? DockConfig.indicatorSize
        : Math.max(6, Math.round(appPx * DockConfig.indicatorSizeFraction));
    const btnSize  = appPx ;
    const borderW  = DockConfig.borderWidth;
    const fallbackR = DockConfig.borderRadius;
    const storedTL = DockConfig.borderTopLeftRadius     ?? fallbackR;
    const storedTR = DockConfig.borderTopRightRadius    ?? fallbackR;
    const storedBL = DockConfig.borderBottomLeftRadius  ?? fallbackR;
    const storedBR = DockConfig.borderBottomRightRadius ?? fallbackR;
    const mapped = _mapCornersForPosition(
        DockConfig.position || 'bottom', storedTL, storedTR, storedBL, storedBR);
    const borderTL = mapped.tl;
    const borderTR = mapped.tr;
    const borderBL = mapped.bl;
    const borderBR = mapped.br;
    const padPx    = DockConfig.innerPadding;

    // Gradient style mirrors the Bar / Tri rect gradient: inversePrimary → scrim.
    // GTK4 CSS @-variable references work in background-image just like in color.
    //
    // Direction is position-aware so the 3D depth illusion works on all four edges:
    //   bottom dock → light from top    → to bottom  (inverse_primary top, scrim bottom)
    //   top dock    → light from bottom → to top     (inverse_primary bottom, scrim top)
    //   right dock  → light from right  → to right   (scrim left, inverse_primary right)
    //   left dock   → light from left   → to left    (scrim right, inverse_primary left)
    // For left/right the stop order is reversed so inverse_primary always sits at the
    // screen-edge side and scrim faces the interior of the desktop.
    let bgStyle;
    if (DockConfig.rectBgStyle === 'gradient') {
        const pos = DockConfig.position;
        let gradientRule;
        if (pos === 'right') {
            // inverse_primary on the right (screen edge), scrim on the left (desktop side)
            gradientRule = 'linear-gradient(to right, @scrim, @inverse_primary)';
        } else if (pos === 'left') {
            // inverse_primary on the left (screen edge), scrim on the right (desktop side)
            gradientRule = 'linear-gradient(to left, @scrim, @inverse_primary)';
        } else if (pos === 'top') {
            // inverse_primary on the bottom (desktop-facing), scrim on the top (screen edge)
            gradientRule = 'linear-gradient(to bottom, @inverse_primary, @scrim)';
        } else {
            // bottom (default): inverse_primary on top, scrim on bottom — original behaviour
            gradientRule = 'linear-gradient(to bottom, @inverse_primary, @scrim)';
        }
        bgStyle = `background-image: ${gradientRule}; background-color: transparent;`;
    } else {
        bgStyle = 'background-image: none; background-color: @blur_background;';
    }

    // Circular badge gradient for start / trash icons.
    // Direction mirrors the dock surface gradient so the badge looks
    // depth-consistent with the fill regardless of dock position:
    //   bottom → light from top    → inverse_primary top,  scrim bottom
    //   top    → light from bottom → inverse_primary bottom, scrim top
    //   left   → light from left   → inverse_primary left,  scrim right
    //   right  → light from right  → inverse_primary right, scrim left
    const _badgePos = DockConfig.position || 'bottom';
    let glyphBadgeGradient;
    if (_badgePos === 'top') {
        glyphBadgeGradient = 'linear-gradient(to top, @surface, @on_primary_fixed_variant)';
    } else if (_badgePos === 'left') {
        glyphBadgeGradient = 'linear-gradient(to left, @surface, @on_primary_fixed_variant)';
    } else if (_badgePos === 'right') {
        glyphBadgeGradient = 'linear-gradient(to right, @surface, @on_primary_fixed_variant)';
    } else {
        // bottom (default)
        glyphBadgeGradient = 'linear-gradient(to bottom, @on_primary_fixed_variant, @surface)';
    }

    const css = `
        /* Config-driven values — updated in-place on SIGUSR2 hot-reload */
        window.background {
            border-width: ${borderW}px;
            border-style: solid;
            border-radius: ${borderTL}px ${borderTR}px ${borderBR}px ${borderBL}px;
            ${bgStyle}
        }
        #box {
            padding: ${padPx}px;
        }
        /* ── Circular badge for start / trash glyphs ──────────────────────
           min-width = min-height = glyphPx ensures the label is always a
           perfect square before border-radius: 50% rounds it into a circle.
           The gradient direction is flipped to match the dock edge so the
           badge depth-illusion is consistent with the dock surface fill. */
        #start-icon, #trash-icon {
            font-size: calc(${glyphPx}px - 1px);
            min-width:  calc(${glyphPx}px + 4px);
            min-height: ${padPx}px;
            border-radius: 50%;
            background-image: ${glyphBadgeGradient};
        }
        .fallback-icon {
            font-size: ${glyphPx}px;
        }
        #active-indicator {
            font-size: ${indicatorPx}px;
            padding-left: 2px;
        }
        /* Separator length matches icon size (not button container) */
        separator.dock-sep-v {
            min-height: ${appPx}px;
            max-height: ${appPx}px;
        }
        separator.dock-sep-h {
            min-width: ${appPx}px;
            max-width: ${appPx}px;
        }
        button.app-button, button.dock-button {
            min-width: ${btnSize}px;
            max-width: ${btnSize}px;
            min-height: ${btnSize}px;
            max-height: ${btnSize}px;
            overflow: hidden;
            padding-top: 4px;
            padding-bottom: 4px;
            padding-left: 5px;
            padding-right: 4px;
        }
        button.app-button image, button.dock-button image {
            min-width: ${appPx}px;
            max-width: ${appPx}px;
            min-height: ${appPx}px;
            max-height: ${appPx}px;
        }
    `;

    // Reuse the same provider object — just update its CSS in-place.
    // This provider lives outside cssProviders so loadCSS() never removes it.
    // It is registered once with the display at APPLICATION+1 priority
    // (higher than style.css at APPLICATION) so it always wins.
    if (!dynamicConfigProvider) {
        dynamicConfigProvider = new Gtk.CssProvider();
        Gtk.StyleContext.add_provider_for_display(
            display, dynamicConfigProvider,
            Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION + 1);
    }
    try {
        dynamicConfigProvider.load_from_data(css, -1);
    } catch (e) {
        log('[dock] Failed to inject config CSS: ' + e.message);
    }
}

// --- Hot-reload (SIGUSR2) ---------------------------------------------

// Read all @HCD-tagged values from config.js and write them into DockConfig.
// Returns true on success.
function reloadConfigFromFile() {
    try {
        const [ok, contents] = GLib.file_get_contents(DOCK_CONFIG_PATH);
        if (!ok) { log('[dock] hot-reload: cannot read config.js'); return false; }
        const text = new TextDecoder().decode(contents);
        // Match lines like:  appIconSize: 24,    // @HCD:appIconSize
        // Captures: key (group 1), numeric value (group 2)
        // Numeric @HCD values
        const numRe = /\b(\w+):[ \t]*([0-9]+(?:\.[0-9]+)?),[ \t]*\/\/ @HCD:\1\b/g;
        let match;
        while ((match = numRe.exec(text)) !== null) {
            const key = match[1];
            const val = Number(match[2]);
            if (!isNaN(val)) {
                DockConfig[key] = val;
                log('[dock] hot-reload: ' + key + ' = ' + val);
            }
        }
        // String @HCD values  (e.g.  startIcon: '',   // @HCD:startIcon)
        const strRe = /\b(\w+):[ \t]*'([^']*)',[ \t]*\/\/ @HCD:\1/g;
        while ((match = strRe.exec(text)) !== null) {
            const key = match[1];
            DockConfig[key] = match[2];
            log('[dock] hot-reload: ' + key + ' = \'' + match[2] + '\'');
        }
        // Re-parse and apply positionOverrides for the current position
        // so margin edits inside positionOverrides take effect on hot-reload.
        try {
            const ovMatch = text.match(/positionOverrides\s*:\s*\{([\s\S]*?)\n    \}/);
            if (ovMatch) {
                const pos = DockConfig.position;
                const posBlk = ovMatch[1].match(new RegExp(pos + '\\s*:\\s*\\{([^}]*?)\\}'));
                if (posBlk) {
                    const kvRe = /(\w+)\s*:\s*([0-9]+(?:\.[0-9]+)?)/g;
                    let kv;
                    while ((kv = kvRe.exec(posBlk[1])) !== null) {
                        DockConfig[kv[1]] = Number(kv[2]);
                        log('[dock] hot-reload override: ' + kv[1] + ' = ' + kv[2]);
                    }
                }
            }
        } catch (e) {
            log('[dock] hot-reload positionOverrides parse error: ' + e.message);
        }
        return true;
    } catch (e) {
        log('[dock] hot-reload error reading config: ' + e.message);
        return false;
    }
}

// Re-apply all four layer-shell margins from the (possibly updated) DockConfig.
function applyMarginsToLayerShell(win) {
    if (!win) return;
    const cfg = DockConfig;
    Gtk4LayerShell.set_margin(win, Gtk4LayerShell.Edge.BOTTOM, cfg.marginBottom);
    Gtk4LayerShell.set_margin(win, Gtk4LayerShell.Edge.TOP,    cfg.marginTop);
    Gtk4LayerShell.set_margin(win, Gtk4LayerShell.Edge.LEFT,   cfg.marginLeft);
    Gtk4LayerShell.set_margin(win, Gtk4LayerShell.Edge.RIGHT,  cfg.marginRight);
}


// --- Read hyprcandy-bar.conf [dock] section ---------------------------
// Returns { autoHide, autoHideDelay (ms), layer, marginFromEdge, licenseActive } with safe defaults.
function readHyprCandyConf() {
    const defaults = { autoHide: false, autoHideDelay: 5000, layer: 'top', marginFromEdge: null, licenseActive: false };
    try {
        const [ok, bytes] = GLib.file_get_contents(HYPRCANDY_CONF_PATH);
        if (!ok) return defaults;
        const txt = new TextDecoder().decode(bytes);

        // Extract licenseStatus from [cc-license-v1] section (written by Qt Settings / QuickShell bar).
        // Parsed first — independently of [dock] — so a missing [dock] section never blocks the check.
        // Value is 'active' on a valid HyprCandy+ subscription; empty / 'invalid' / anything else = false.
        const licMatch = txt.match(/\[cc-license-v1\]([\s\S]*?)(?=\n\[|$)/i);
        const licSection = licMatch ? licMatch[1] : '';
        const licStatusMatch = licSection.match(/^\s*licenseStatus\s*=\s*(\S+)/im);
        const licenseActive = licStatusMatch ? licStatusMatch[1].toLowerCase() === 'active' : false;

        // Extract [dock] section (up to the next [section] or end of file)
        const dockMatch = txt.match(/\[dock\]([\s\S]*?)(?=\n\[|$)/i);
        if (!dockMatch) return { ...defaults, licenseActive };
        const section = dockMatch[1];
        const ahMatch     = section.match(/^\s*autohide\s*=\s*(true|false)/im);
        const delayMatch  = section.match(/^\s*autohide_delay\s*=\s*(\d+)/im);
        const layerMatch  = section.match(/^\s*layer\s*=\s*(top|overlay)/im);
        const marginMatch = section.match(/^\s*margin_from_edge\s*=\s*(\d+)/im);
        return {
            autoHide:       ahMatch     ? ahMatch[1].toLowerCase() === 'true' : false,
            autoHideDelay:  delayMatch  ? parseInt(delayMatch[1]) * 1000       : 5000,
            layer:          layerMatch  ? layerMatch[1].toLowerCase()          : 'top',
            marginFromEdge: marginMatch ? parseInt(marginMatch[1])             : null,
            licenseActive,
        };
    } catch (e) {
        log('[dock] conf read error: ' + e.message);
        return defaults;
    }
}

// Full hot-reload: config values → CSS + layer-shell + exclusive zone.
// Triggered by SIGUSR2 (kill -12 <pid>) — sent by candy-utils after editing config.js.
//
// What each @HCD variable hot-reloads to:
//   appIconSize   → button min/max size + image pixel_size CSS (CSS side; button
//                   widget size_request needs a dock restart for structural rebuild)
//   innerPadding  → #box { padding }          (CSS re-inject)
//   borderWidth   → window.background border-width  (CSS re-inject)
//   borderColorVar → style.css border-color: @<gtk_name> (loadCSS reload)
//   borderRadius / border*Radius → window.background radius  (CSS re-inject)
//   rectBgStyle   → window.background fill (glass vs gradient)
//   marginBottom/Top/Left/Right → Gtk4LayerShell.set_margin (live)
function hotReload() {
    log('[dock] SIGUSR2 received — hot-reloading config');
    if (!reloadConfigFromFile()) return;
    const display = Gdk.Display.get_default();
    if (display) {
        loadCSS();
        const borderGtk = _readBorderColorFromStyle();
        log('[dock] hot-reload: border-color = @' + (borderGtk || 'on_secondary'));
        if (dockWindow) dockWindow.queue_draw();
    }

    // Apply layer (top/overlay) and margin_from_edge from hyprcandy-bar.conf
    {
        const conf = readHyprCandyConf();
        const newLayer = conf.layer === 'overlay'
            ? Gtk4LayerShell.Layer.OVERLAY
            : Gtk4LayerShell.Layer.TOP;
        Gtk4LayerShell.set_layer(dockWindow, newLayer);
        log('[dock] hot-reload: layer = ' + conf.layer);

        // Apply margin_from_edge → the anchored-edge margin for the current position.
        // This overrides the positionOverride value that reloadConfigFromFile() applied.
        if (conf.marginFromEdge !== null) {
            const pos = DockConfig.position;
            if      (pos === 'bottom') DockConfig.marginBottom = conf.marginFromEdge;
            else if (pos === 'top')    DockConfig.marginTop    = conf.marginFromEdge;
            else if (pos === 'left')   DockConfig.marginLeft   = conf.marginFromEdge;
            else if (pos === 'right')  DockConfig.marginRight  = conf.marginFromEdge;
            log('[dock] hot-reload: margin_from_edge = ' + conf.marginFromEdge + ' (position: ' + pos + ')');
        }

        // Update auto-hide settings; the EventControllerMotion on dockWindow
        // reads these module-level vars each time leave fires.
        _ahEnabled  = conf.autoHide;
        _ahDelaySec = conf.autoHideDelay;
        if (!_ahEnabled) {
            _ahCancelTimer();
            if (dockWindow) { dockWindow.set_visible(true); if (_ahHotspot) _ahHotspot.set_visible(false); }
        } else {
            // Autohide enabled — start timer immediately; pointer may already be away
            _ahStartTimer();
        }
        log('[dock] hot-reload: autohide=' + _ahEnabled + ' delay=' + _ahDelaySec + 'ms');
    }

    // Apply all four margins to the layer shell after DockConfig has been
    // updated by both reloadConfigFromFile() and margin_from_edge above.
    applyMarginsToLayerShell(dockWindow);

    if (dockWindow) {
        // Update start icon glyph if it changed
        if (dockWindow._startIconLabel) {
            dockWindow._startIconLabel.set_text(
                DockConfig.startIcon !== null ? DockConfig.startIcon : GLYPH_START
            );
        }
        // Update button spacing
        if (dockWindow.mainBox)
            dockWindow.mainBox.set_spacing(DockConfig.buttonSpacing);
        dockWindow._scheduleExclusiveZoneUpdate();

        // Reload pinned apps from disk so external writes (e.g. from the
        // App Launcher's "Pin to Dock" action) are reflected immediately.
        if (dockWindow.daemon) {
            dockWindow.daemon.clearAppInfoCache();
            dockWindow.daemon.pinnedApps.clear();
            dockWindow.daemon.loadPinnedApps();
            // Reload desktop-pinned apps synchronously so QML unpin/reorder
            // changes are visible immediately — the Gio.FileMonitor fires
            // asynchronously and can lose the race against context-menu open.
            dockWindow.daemon.desktopPinnedApps.clear();
            dockWindow.daemon.loadDesktopPinnedApps();
            const clientData = dockWindow.daemon.getClientData();
            dockWindow._updateFromDaemon(clientData);
            log('[dock] hot-reload: pinned apps refreshed from disk');
        }
    }
    // Refresh hotspot anchors in case dock position changed.
    // Also re-apply hotspot color: re-asserts background-image:none so the
    // display-level gradient rule (injected by _injectGlyphSizeCSS above)
    // cannot bleed onto the hotspot surface.
    if (_ahHotspot) {
        _ahHotspot._refreshAnchors();
        _ahHotspot._applyHotspotColor();
    }
    log('[dock] hot-reload complete');
}

// --- Colour hot-reload (matugen) --------------------------------------
// GTK4 does NOT auto-reload custom CssProviders on disk change — only its
// own theme CSS responds to GtkSettings signals.  We therefore watch
// gtk-4.0/colors.css with a single Gio.FileMonitor.  matugen regenerates
// both gtk-3.0 and gtk-4.0 colours together, so watching the gtk-4.0 file
// is sufficient; the gtk-3.0 provider is reloaded in the same loadCSS() call.
//
// Leak-prevention:
//   • Only CHANGES_DONE_HINT / CREATED events trigger a reload (avoids
//     duplicate firings from editors that do atomic write + rename).
//   • A single debounce timer (300 ms) is tracked and cancelled before being
//     re-queued, so rapid successive writes never stack up.
//   • teardownColorMonitor() cancels both the monitor and any pending timer;
//     it is called from vfunc_close_request so nothing outlives the process.

function _scheduleCssReload(timerRef) {
    if (timerRef === 'style') {
        if (_styleReloadTimer) {
            GLib.source_remove(_styleReloadTimer);
            _styleReloadTimer = 0;
        }
        _styleReloadTimer = GLib.timeout_add(GLib.PRIORITY_DEFAULT_IDLE, 300, () => {
            _styleReloadTimer = 0;
            loadCSS();
            if (dockWindow) dockWindow.queue_draw();
            return GLib.SOURCE_REMOVE;
        });
        return;
    }
    if (_colorReloadTimer) {
        GLib.source_remove(_colorReloadTimer);
        _colorReloadTimer = 0;
    }
    _colorReloadTimer = GLib.timeout_add(GLib.PRIORITY_DEFAULT_IDLE, 300, () => {
        _colorReloadTimer = 0;
        loadCSS();
        if (dockWindow) dockWindow.queue_draw();
        return GLib.SOURCE_REMOVE;
    });
}

function setupColorMonitor() {
    const file = Gio.File.new_for_path(GTK4_COLORS_PATH);
    try {
        _colorMonitor = file.monitor_file(Gio.FileMonitorFlags.NONE, null);
        _colorMonitor.connect('changed', (_mon, _f, _other, eventType) => {
            if (eventType !== Gio.FileMonitorEvent.CHANGES_DONE_HINT &&
                eventType !== Gio.FileMonitorEvent.CREATED) return;
            _scheduleCssReload('color');
        });
    } catch (e) {
        log('[dock] Color monitor setup failed: ' + e.message);
    }
}

function setupStyleMonitor() {
    const file = Gio.File.new_for_path(DOCK_STYLE_PATH);
    try {
        _styleMonitor = file.monitor_file(Gio.FileMonitorFlags.NONE, null);
        _styleMonitor.connect('changed', (_mon, _f, _other, eventType) => {
            if (eventType !== Gio.FileMonitorEvent.CHANGES_DONE_HINT &&
                eventType !== Gio.FileMonitorEvent.CREATED) return;
            _scheduleCssReload('style');
        });
        log('[dock] style.css monitor active: ' + DOCK_STYLE_PATH);
    } catch (e) {
        log('[dock] Style monitor setup failed: ' + e.message);
    }
}

function teardownColorMonitor() {
    if (_colorReloadTimer) {
        GLib.source_remove(_colorReloadTimer);
        _colorReloadTimer = 0;
    }
    if (_styleReloadTimer) {
        GLib.source_remove(_styleReloadTimer);
        _styleReloadTimer = 0;
    }
    if (_colorMonitor) {
        _colorMonitor.cancel();
        _colorMonitor = null;
    }
    if (_styleMonitor) {
        _styleMonitor.cancel();
        _styleMonitor = null;
    }
    teardownLauncherMonitor();
}

// --- Drag and Drop Manager --------------------------------------------
//
// Same-process DnD: we never need to serialise data across a process boundary
// so we skip the GTK4 content type system entirely.  The dragged className is
// stored as an instance variable; the DropTarget fires 'drop' purely as a
// positional signal and we read this.draggedClassName directly.
//
// The provider still needs to offer *something* so GTK starts the drag — we
// use a plain empty string GVariant.  DropTarget accepts the same mime type
// ('text/plain;charset=utf-8' which is what TYPE_STRING maps to in GTK4).
//
// Drag icon: we snapshot the button widget into a Gtk.DragIcon paintable so
// the user sees the actual app icon while dragging.
var DragDropManager = class {
    // Pattern from working GTK4 reorder example (GNOME Discourse #8422):
    //  - Payload = plain integer (source index). set_gtypes([TYPE_INT]) matches exactly.
    //  - DragSource on the Gtk.Button (events reach it before the overlay).
    //  - DropTarget on each Gtk.Overlay (drop fires on the specific slot released over).
    //  - No container-level drop target needed.
    //  - isDragging blocks _updateFromDaemon from reverting order mid-drag.
    constructor(dock) {
        this.dock         = dock;
        this.isDragging   = false;
        this.draggedClass = null;
    }

    _appEntries() {
        return Array.from(this.dock.clientWidgets.entries());
    }

    _applyReorder(draggedClass, afterClass) {
        const entries = this._appEntries();
        const from    = entries.findIndex(([c]) => c === draggedClass);
        if (from === -1) return;
        const [entry] = entries.splice(from, 1);
        const toIdx   = afterClass ? entries.findIndex(([c]) => c === afterClass) : -1;
        entries.splice(toIdx === -1 ? 0 : toIdx + 1, 0, entry);

        // Rebuild Map + reorder visual children.
        // Anchor from _startSeparator so apps never land before the start button.
        this.dock.clientWidgets.clear();
        for (const [c, w] of entries) this.dock.clientWidgets.set(c, w);
        let prev = this.dock._startSeparator || null;
        for (const [, w] of entries) {
            this.dock.mainBox.reorder_child_after(w, prev);
            prev = w;
        }
    }

    setupDragSource(btn, overlay, className) {
        // ── DragSource on the button ──────────────────────────────────────
        const dragSource = new Gtk.DragSource({ actions: Gdk.DragAction.MOVE });

        dragSource.connect('prepare', () => {
            const idx = this._appEntries().findIndex(([c]) => c === className);
            return Gdk.ContentProvider.new_for_value(idx >= 0 ? idx : 0);
        });

        dragSource.connect('drag-begin', (source) => {
            this.isDragging   = true;
            this.draggedClass = className;
            overlay.set_opacity(0.4);
            try { source.set_icon(Gtk.WidgetPaintable.new(btn), 0, 0); } catch (_) {}
        });

        dragSource.connect('drag-end', () => {
            overlay.set_opacity(1.0);
            // Always clear — successful drop (deleteData=true) must also unlock updates
            this.isDragging   = false;
            this.draggedClass = null;
        });

        btn.add_controller(dragSource);

        // ── DropTarget on the overlay ─────────────────────────────────────
        const dropTarget = new Gtk.DropTarget({ actions: Gdk.DragAction.MOVE });
        dropTarget.set_gtypes([GObject.TYPE_INT]);

        dropTarget.connect('motion', () => {
            overlay.add_css_class('drag-target-hover');
            return Gdk.DragAction.MOVE;
        });
        dropTarget.connect('leave', () => {
            overlay.remove_css_class('drag-target-hover');
        });

        dropTarget.connect('drop', (_t, srcIdx, x, y) => {
            overlay.remove_css_class('drag-target-hover');
            const entries = this._appEntries();
            if (srcIdx < 0 || srcIdx >= entries.length) return false;

            const draggedClass = entries[srcIdx][0];
            if (draggedClass === className) return false;

            // Decide insert position from pointer location within this slot
            const isVert = IS_VERTICAL;
            const alloc  = overlay.get_allocation();
            const half   = isVert ? alloc.height / 2 : alloc.width / 2;
            const pos    = isVert ? y : x;

            let afterClass;
            if (pos >= half) {
                // Drop in second half → insert after this slot
                afterClass = className;
            } else {
                // Drop in first half → insert before this slot
                const myIdx = entries.findIndex(([c]) => c === className);
                afterClass  = myIdx > 0 ? entries[myIdx - 1][0] : null;
            }

            this._applyReorder(draggedClass, afterClass);
            this.dock.daemon.reorderPinned(draggedClass, afterClass);

            this.isDragging   = false;
            this.draggedClass = null;
            return true;
        });

        overlay.add_controller(dropTarget);
    }
};

// --- Dock Window ------------------------------------------------------
const HyprCandyDock = GObject.registerClass({
    GTypeName: 'HyprCandyDock',
}, class HyprCandyDock extends Gtk.ApplicationWindow {
    _init(application) {
        super._init({
            application: application,
            title: 'HyprCandy Dock',
            decorated: false,
            resizable: false,
        });

        this.daemon = new Daemon(this);
        this.clientWidgets = new Map();
        
        // Track separators
        this._startSeparator = null;
        this._endSeparator = null;
        this._trashButton = null;

        dockWindow = this;

        this._setupLayerShell();
        this._createDock();
        
        // Initialize drag-drop manager after mainBox is created
        this.dragDropManager = new DragDropManager(this);
        
        this._initializeDock();
    }

    _setupLayerShell() {
        const cfg = DockConfig;
        const pos = cfg.position; // 'bottom' | 'top' | 'left' | 'right'

        Gtk4LayerShell.init_for_window(this);
        Gtk4LayerShell.set_namespace(this, 'hyprcandy-dock');
        // TOP layer: exclusive zones are respected by normal windows.
        // OVERLAY would render above everything but exclusive zone is ignored.
        Gtk4LayerShell.set_layer(this, Gtk4LayerShell.Layer.TOP);

        // Anchor the correct edge; clear the opposing three
        Gtk4LayerShell.set_anchor(this, Gtk4LayerShell.Edge.BOTTOM, pos === 'bottom');
        Gtk4LayerShell.set_anchor(this, Gtk4LayerShell.Edge.TOP,    pos === 'top');
        Gtk4LayerShell.set_anchor(this, Gtk4LayerShell.Edge.LEFT,   pos === 'left');
        Gtk4LayerShell.set_anchor(this, Gtk4LayerShell.Edge.RIGHT,  pos === 'right');

        // Margins from config
        Gtk4LayerShell.set_margin(this, Gtk4LayerShell.Edge.BOTTOM, cfg.marginBottom);
        Gtk4LayerShell.set_margin(this, Gtk4LayerShell.Edge.TOP,    cfg.marginTop);
        Gtk4LayerShell.set_margin(this, Gtk4LayerShell.Edge.LEFT,   cfg.marginLeft);
        Gtk4LayerShell.set_margin(this, Gtk4LayerShell.Edge.RIGHT,  cfg.marginRight);

        // Exclusive zone is set after the first layout pass via
        // _scheduleExclusiveZoneUpdate() — at this point the surface hasn't
        // been sized yet, so get_allocated_height() would return 0.

        log('[dock] Layer shell configured for position: ' + pos);
    }

    // Exclusive zone — reserves screen real-estate so tiled/maximised windows
    // never overlap the dock.
    //
    // GTK4 layer-shell: get_allocated_height() is unreliable (compositor
    // manages allocation externally).  Instead we query mainBox.measure()
    // for the NATURAL content height and add borderWidth*2 for the CSS
    // border the compositor draws around the content.
    //
    // The compositor automatically adds the anchored-edge margin (e.g.
    // marginBottom for a bottom dock) on top of the exclusive zone value.
    // Hyprland also applies its own gaps_out + border_size between windows
    // and the reserved boundary.  So zone = surfaceSize is sufficient.
    updateExclusiveZone() {
        const cfg = DockConfig;
        if (cfg.exclusiveZoneOverride !== null && cfg.exclusiveZoneOverride !== undefined) {
            Gtk4LayerShell.set_exclusive_zone(this, cfg.exclusiveZoneOverride);
            return;
        }
        const axis = IS_VERTICAL ? Gtk.Orientation.HORIZONTAL : Gtk.Orientation.VERTICAL;
        const contentSize = this.mainBox
            ? this.mainBox.measure(axis, -1)[1]   // [1] = natural size
            : (cfg.appIconSize + cfg.innerPadding * 2);  // fallback before mainBox exists
        const zone = contentSize + cfg.borderWidth * 2;
        Gtk4LayerShell.set_exclusive_zone(this, zone);
        log('[dock] exclusiveZone = ' + zone + ' (content=' + contentSize + ' + border=' + (cfg.borderWidth * 2) + ')');
    }

    // Called after layout changes. Short timeout ensures GTK has committed
    // the allocation before we query get_allocated_height().
    _scheduleExclusiveZoneUpdate() {
        if (this._ezUpdateId) return; // debounce
        this._ezUpdateId = GLib.timeout_add(GLib.PRIORITY_DEFAULT, 200, () => {
            this._ezUpdateId = 0;
            this.updateExclusiveZone();
            return GLib.SOURCE_REMOVE;
        });
    }

    _createDock() {
        // Orientation: horizontal for bottom/top, vertical for left/right
        const orientation = IS_VERTICAL
            ? Gtk.Orientation.VERTICAL
            : Gtk.Orientation.HORIZONTAL;

        this.mainBox = Gtk.Box.new(orientation, DockConfig.buttonSpacing);
        this.mainBox.set_name('box');
        this.mainBox.set_halign(Gtk.Align.CENTER);
        this.mainBox.set_valign(Gtk.Align.CENTER); // centres icons — fixes 1px top-heavy offset

        this.set_child(this.mainBox);
        // Horizontal docks: 100 is a minimum along-edge width while buttons load.
        // Vertical docks: 100 would force 100 px thickness — use natural size instead.
        if (IS_VERTICAL) {
            this.set_default_size(-1, -1);
        } else {
            this.set_default_size(100, -1);
        }

        log('[dock] Dock UI created (' + (IS_VERTICAL ? 'vertical' : 'horizontal') + ')');
    }

    async _initializeDock() {
        // Add start button first (leftmost)
        this._addStartButton();
        this._addSeparator('start');

        // Load initial clients
        await this.daemon.loadInitialClients();

        // Start event monitoring
        this.daemon.startEventMonitoring();

        // Separator before trash, then trash button last (rightmost)
        this._addSeparator('end');
        this._addTrashButton();

        this.show();

        // Keep the window object alive when hidden (set_visible(false))
        // so auto-hide can present() it again without rebuilding the dock.
        this.set_hide_on_close(true);

        // Auto-hide: attach EventControllerMotion so GTK4 notifies us when
        // the pointer enters or leaves the dock surface (no polling needed).
        {
            const motion = new Gtk.EventControllerMotion();
            motion.connect('enter', () => {
                if (!_ahEnabled) return;
                // Pointer entered — cancel any pending hide
                _ahCancelTimer();
                // Re-show if we were hidden (shouldn't happen often, but safe)
                if (!this.get_visible()) {
                    this.set_visible(true);
                    if (_ahHotspot) _ahHotspot.set_visible(false);
                }
            });
            motion.connect('leave', () => {
                if (!_ahEnabled) return;
                _ahStartTimer();
            });
            this.add_controller(motion);
        }

        // Schedule exclusive zone update after the first GTK layout pass.
        // At this point get_allocated_height() returns the real surface size.
        this._scheduleExclusiveZoneUpdate();
        log('[dock] Dock initialized');
    }

    _addSeparator(tag) {
        const sep = Gtk.Separator.new(
            IS_VERTICAL ? Gtk.Orientation.HORIZONTAL : Gtk.Orientation.VERTICAL
        );
        sep.set_name('separator-' + tag);
        sep.add_css_class(IS_VERTICAL ? 'dock-sep-h' : 'dock-sep-v');
        this.mainBox.append(sep);
        if (tag === 'start') this._startSeparator = sep;
        if (tag === 'end') this._endSeparator = sep;
    }

    _addStartButton() {
        // Start button has no indicator — it is a launcher, not a tracked app.
        // No dotsPlaceholder, no container wrapper, no overlay.  Plain button only.
        const btn = Gtk.Button.new();
        btn.add_css_class('app-button');
        btn.add_css_class('dock-button');
        btn.set_size_request(ICON_SIZE + 8, ICON_SIZE + 8);
        btn.set_halign(Gtk.Align.CENTER);
        btn.set_valign(Gtk.Align.CENTER);

        const label = Gtk.Label.new(
            DockConfig.startIcon !== null ? DockConfig.startIcon : GLYPH_START
        );
        label.set_name('start-icon');
        label.set_halign(Gtk.Align.CENTER);
        label.set_valign(Gtk.Align.CENTER);
        btn.set_child(label);
        btn.set_tooltip_text('Applications');
        this._installDockButtonHover(btn);

        // Left click — toggle the HyprCandy App Launcher (HyprCandy+ only)
        // Reads licenseStatus from [cc-license-v1] in hyprcandy-bar.conf each
        // click so de/reactivation takes effect immediately without a dock restart.
        btn.connect('clicked', () => {
            const conf = readHyprCandyConf();
            if (!conf.licenseActive) {
                log('[dock] app-launcher blocked — HyprCandy+ licence not active');
                return;
            }
            _spawnCleanCmd(`bash "${LAUNCHER_TOGGLE_PATH}"`);
        });

        // Right click - show settings menu
        const gesture = new Gtk.GestureClick();
        gesture.set_button(3); // Right click
        gesture.connect('released', () => {
            this._showStartMenu(btn);
        });
        btn.add_controller(gesture);

        this.mainBox.append(btn);
        this._startButton = btn;
        this._startIconLabel = label;
    }

    _addTrashButton() {
        const btn = Gtk.Button.new();
        btn.add_css_class('app-button');
        btn.add_css_class('dock-button');
        btn.set_size_request(ICON_SIZE + 8, ICON_SIZE + 8);
        btn.set_halign(Gtk.Align.CENTER);
        btn.set_valign(Gtk.Align.CENTER);

        const label = Gtk.Label.new(GLYPH_TRASH_EMPTY);
        label.set_name('trash-icon');
        label.set_halign(Gtk.Align.CENTER);
        label.set_valign(Gtk.Align.CENTER);
        btn.set_child(label);
        btn.set_tooltip_text('Trash (empty)');
        this._installDockButtonHover(btn);

        // ── Part 2: count-aware monitoring via trash:/// ──────────────────────
        // Query trash::item-count on trash:/// exactly as Nautilus does — this
        // covers ALL trash locations (home + mounted external drives), not just
        // ~/.local/share/Trash/files.  Nautilus itself only distinguishes two
        // visual states (empty / non-empty); we add a third glyph for >20 items
        // since no percentage-based trash icons exist in the FDO spec or any
        // standard icon theme.
        let _trashCount = 0;

        const _updateTrashIcon = () => {
            try {
                const trashUri = Gio.File.new_for_uri('trash:///');
                trashUri.query_info_async(
                    'trash::item-count',
                    Gio.FileQueryInfoFlags.NONE,
                    GLib.PRIORITY_DEFAULT,
                    null,
                    (_, res) => {
                        try {
                            const info  = trashUri.query_info_finish(res);
                            const count = info.get_attribute_uint32('trash::item-count');
                            _trashCount = count;
                            if (count === 0) {
                                label.set_text(GLYPH_TRASH_EMPTY);
                                btn.set_tooltip_text('Trash (empty)');
                            } else if (count <= 20) {
                                label.set_text(GLYPH_TRASH_FULL);
                                btn.set_tooltip_text(`Trash (${count} item${count === 1 ? '' : 's'})`);
                            } else {
                                label.set_text(GLYPH_TRASH_HEAVY);
                                btn.set_tooltip_text(`Trash (${count} items)`);
                            }
                        } catch (_) {}
                    }
                );
            } catch (_) {}
        };

        _updateTrashIcon();

        // The local Trash/files dir is the zero-latency change trigger.
        // Any change re-queries trash:/// so the count stays accurate across
        // all trash locations.
        const TRASH_FILES_DIR = GLib.build_filenamev(
            [GLib.get_home_dir(), '.local', 'share', 'Trash', 'files']
        );
        try { GLib.mkdir_with_parents(TRASH_FILES_DIR, 0o755); } catch (_) {}
        try {
            const trashDir = Gio.File.new_for_path(TRASH_FILES_DIR);
            this._trashMonitor = trashDir.monitor_directory(
                Gio.FileMonitorFlags.WATCH_MOVES, null
            );
            this._trashMonitor.connect('changed', () => _updateTrashIcon());
            log('[dock] Trash monitor active on: ' + TRASH_FILES_DIR);
        } catch (e) {
            log('[dock] Trash monitor setup failed: ' + e.message);
        }

        // ── Part 1: no-op when trash is empty ────────────────────────────────
        btn.connect('clicked', () => {
            if (_trashCount === 0) return;

            // ── Layer shell confirmation dialog ───────────────────────────────
            // Single OVERLAY surface — no backdrop needed. Focus loss (clicking
            // outside) is detected via notify::is-active and closes the dialog.
            const itemWord = _trashCount === 1 ? 'item' : 'items';

            // Dialog surface
            const dlg = new Gtk.Window({ decorated: false, resizable: false });
            dlg.add_css_class('hc-trash-dialog');
            Gtk4LayerShell.init_for_window(dlg);
            Gtk4LayerShell.set_layer(dlg, Gtk4LayerShell.Layer.OVERLAY);
            Gtk4LayerShell.set_keyboard_mode(dlg, Gtk4LayerShell.KeyboardMode.ON_DEMAND);

            const closeBoth = () => dlg.close();
            Gtk4LayerShell.set_exclusive_zone(dlg, -1);
            Gtk4LayerShell.set_namespace(dlg, 'hyprcandy-trash-dialog');
            // No anchors → compositor centers the surface on screen
            dlg.set_default_size(340, -1);

            // CSS — matches existing popover palette
            const dlgCss = new Gtk.CssProvider();
            dlgCss.load_from_data(`
                window.hc-trash-dialog {
                    background-color: alpha(@on_secondary, 0.60);
                    border-radius: 20px;
                    border: 1px solid alpha(@primary, 0.15);
                    box-shadow: none;
                }
                .dlg-title {
                    font-size: 13px;
                    font-weight: bold;
                    color: @primary;
                }
                .dlg-body {
                    font-size: 12px;
                    color: alpha(@primary, 0.75);
                }
                .dlg-btn {
                    border-radius: 8px;
                    padding: 6px 18px;
                    font-size: 12px;
                    min-width: 80px;
                }
                .dlg-btn-cancel {
                    background-color: alpha(@on_secondary, 0.65);
                    color: @primary;
                }
                .dlg-btn-cancel:hover { background-color: alpha(@on-secondary, 0.85); }
                .dlg-btn-confirm {
                    background-color: @error;
                    color: @on_error;
                }
                .dlg-btn-confirm:hover { background-color: alpha(@error, 0.80); }
            `, -1);
            dlg.get_style_context().add_provider(
                dlgCss, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION + 2);

            // Layout
            const root = new Gtk.Box({
                orientation: Gtk.Orientation.VERTICAL,
                spacing: 16,
                margin_top: 22, margin_bottom: 18,
                margin_start: 24, margin_end: 24,
            });

            const title = new Gtk.Label({ label: '󰩹  Empty Trash?' });
            title.add_css_class('dlg-title');
            title.set_halign(Gtk.Align.START);

            const body = new Gtk.Label({
                label: `Permanently delete ${_trashCount} ${itemWord}?\nThis action cannot be undone.`,
                wrap: true,
            });
            body.add_css_class('dlg-body');
            body.set_halign(Gtk.Align.START);

            const btnRow = new Gtk.Box({
                orientation: Gtk.Orientation.HORIZONTAL,
                spacing: 10,
                halign: Gtk.Align.END,
            });

            const cancelBtn = new Gtk.Button({ label: 'Cancel' });
            cancelBtn.add_css_class('dlg-btn');
            cancelBtn.add_css_class('dlg-btn-cancel');
            cancelBtn.connect('clicked', () => closeBoth());

            const confirmBtn = new Gtk.Button({ label: 'Empty Trash' });
            confirmBtn.add_css_class('dlg-btn');
            confirmBtn.add_css_class('dlg-btn-confirm');
            confirmBtn.connect('clicked', () => {
                closeBoth();
                try {
                    Gio.DBus.session.call(
                        'org.gnome.Nautilus',
                        '/org/gnome/Nautilus/FileOperations2',
                        'org.gnome.Nautilus.FileOperations2',
                        'EmptyTrash',
                        new GLib.Variant('(ba{sv})', [false, {}]),
                        null,
                        Gio.DBusCallFlags.NONE,
                        -1,
                        null,
                        (conn, res) => {
                            try { conn.call_finish(res); }
                            catch (e) { console.error('[dock] EmptyTrash failed:', e.message); }
                        }
                    );
                } catch (e) { console.error('[dock] EmptyTrash error:', e.message); }
            });

            // Escape to cancel
            const escCtrl = new Gtk.EventControllerKey();
            escCtrl.connect('key-pressed', (_c, keyval) => {
                if (keyval === 65307) { closeBoth(); return true; }
                return false;
            });
            dlg.add_controller(escCtrl);

            btnRow.append(cancelBtn);
            btnRow.append(confirmBtn);
            root.append(title);
            root.append(body);
            root.append(btnRow);
            dlg.set_child(root);

            // Close on focus loss (click outside)
            dlg.connect('notify::is-active', () => {
                if (!dlg.is_active()) dlg.close();
            });

            dlg.present();
        });

        this.mainBox.append(btn);
        this._trashButton = btn;
        this._trashLabel  = label;
    }

    _updateFromDaemon(clientData) {
        // Don't touch widget order while a drag is in flight
        if (this.dragDropManager && this.dragDropManager.isDragging) return;

        const orderKey = clientData.map(d => d.className).join('\0');
        const stateKey = clientData.map(d =>
            d.className + '\x01' + (d.instances ? d.instances.length : 0) +
            '\x01' + (d.active ? 1 : 0)
        ).join('\0');
        const fullKey = orderKey + '\x02' + stateKey;
        if (fullKey === this._lastDaemonKey) return;
        const prevOrderKey = this._lastOrderKey || '';
        this._lastDaemonKey = fullKey;
        this._lastOrderKey = orderKey;

        const currentClasses = new Set(this.clientWidgets.keys());
        const newClasses = new Set(clientData.map(d => d.className));
        let added = 0, removed = 0;

        // Remove deleted apps
        for (const className of currentClasses) {
            if (!newClasses.has(className)) {
                const widget = this.clientWidgets.get(className);
                if (widget) {
                    this.mainBox.remove(widget);
                    this.clientWidgets.delete(className);
                    removed++;
                    log('[dock] Removed: ' + className);
                }
            }
        }

        // Add or update apps
        for (const data of clientData) {
            if (!this.clientWidgets.has(data.className)) {
                this._addClientButton(data);
                added++;
            } else {
                this._updateClientButton(data);
            }
        }

        // Sync visual order to clientData order (= pinnedApps order after a drag).
        // Anchor from _startSeparator so apps never land before the start button.
        // `prev` ends up pointing at the last app widget in clientData order —
        // use it directly for sep/trash placement instead of _getLastAppWidget(),
        // which iterates the Map in *insertion* order (diverges from clientData
        // order whenever a new app is added mid-sequence, causing apps to appear
        // after the trash icon).
        let structuralChange = added > 0 || removed > 0;
        if (orderKey !== prevOrderKey || structuralChange) {
            let prev = this._startSeparator || null;
            for (const data of clientData) {
                const w = this.clientWidgets.get(data.className);
                if (w) { this.mainBox.reorder_child_after(w, prev); prev = w; }
            }
            if (this._endSeparator)
                this.mainBox.reorder_child_after(this._endSeparator, prev);
            if (this._trashButton)
                this.mainBox.reorder_child_after(
                    this._trashButton, this._endSeparator || prev);
            this._scheduleExclusiveZoneUpdate();
        }
    }

    _getLastAppWidget() {
        let last = null;
        for (const [, widget] of this.clientWidgets) {
            last = widget;
        }
        return last;
    }

    // CSS :hover opacity can stick after a right-click popover closes because
    // GTK's grab sequence skips the normal leave event. Manage opacity in JS.
    _installDockButtonHover(btn) {
        if (btn._dockHoverInstalled) return;
        btn._dockHoverInstalled = true;
        btn._suppressDockHover = false;
        const motion = new Gtk.EventControllerMotion();
        motion.connect('enter', () => {
            if (!btn._suppressDockHover)
                btn.set_opacity(0.45);
        });
        motion.connect('leave', () => {
            btn._suppressDockHover = false;
            btn.set_opacity(1.0);
        });
        btn.add_controller(motion);
    }

    _resetDockButtonHover(btn) {
        if (!btn) return;
        btn._suppressDockHover = true;
        btn.set_opacity(1.0);
    }

    _addClientButton(data) {
        // Each app button is a Gtk.Overlay so the indicator dots can be
        // overlaid directly on the button face at the screen-facing edge —
        // no sibling dotsBox means no extra layout height/width for any button.
        //
        // Screen-facing edge per dock position:
        //   bottom → dots at BOTTOM  (halign CENTER, valign END)
        //   top    → dots at TOP     (halign CENTER, valign START)
        //   left   → dots at LEFT    (halign START,  valign CENTER)
        //   right  → dots at RIGHT   (halign END,    valign CENTER)
        const pos = DockConfig.position;
        let dotsHalign, dotsValign;
        if (pos === 'top') {
            dotsHalign = Gtk.Align.CENTER; dotsValign = Gtk.Align.START;
        } else if (pos === 'left') {
            dotsHalign = Gtk.Align.START;  dotsValign = Gtk.Align.CENTER;
        } else if (pos === 'right') {
            dotsHalign = Gtk.Align.END;    dotsValign = Gtk.Align.CENTER;
        } else {
            // bottom (default)
            dotsHalign = Gtk.Align.CENTER; dotsValign = Gtk.Align.END;
        }

        // Icon button — fixed footprint
        const btn = Gtk.Button.new();
        btn.add_css_class('app-button');
        btn.add_css_class('dock-button');
        btn.set_name('app-' + data.className);
        btn.set_size_request(ICON_SIZE + 8, ICON_SIZE + 8);

        const iconName = this.daemon.getIcon(data.iconClass || data.className);
        let iconWidget;
        if (iconName === 'application-x-executable' || !iconName) {
            const fallbackLabel = Gtk.Label.new(GLYPH_FALLBACK);
            fallbackLabel.add_css_class('fallback-icon');
            btn.set_size_request(ICON_SIZE + 8, ICON_SIZE + 8);
            fallbackLabel.set_halign(Gtk.Align.CENTER);
            fallbackLabel.set_valign(Gtk.Align.CENTER);
            iconWidget = fallbackLabel;
        } else if (iconName.startsWith('/') || iconName.startsWith('~')) {
            iconWidget = Gtk.Image.new_from_file(iconName);
            iconWidget.set_pixel_size(ICON_SIZE);
            iconWidget.set_halign(Gtk.Align.CENTER);
            iconWidget.set_valign(Gtk.Align.CENTER);
        } else {
            iconWidget = Gtk.Image.new_from_icon_name(iconName);
            iconWidget.set_pixel_size(ICON_SIZE);
            iconWidget.set_halign(Gtk.Align.CENTER);
            iconWidget.set_valign(Gtk.Align.CENTER);
        }
        btn.set_child(iconWidget);
        this._installDockButtonHover(btn);

        const tooltipText = data.instances.length > 1
            ? (data.displayName || data.className) + ' (' + data.instances.length + ')'
            : (data.displayName || data.className);
        btn.set_tooltip_text(tooltipText);

        btn.connect('clicked', () => {
            const freshClientData = this.daemon.getClientData();
            const freshData = freshClientData.find(d => d.className === data.className);
            const instances = freshData ? freshData.instances : data.instances;
            if (instances.length === 0) {
                // Pinned but not running — launch via desktop entry
                const lookupClass = (freshData || data).iconClass || data.className;
                this.daemon.launchApp(lookupClass);
            } else if (instances.length === 1) {
                // Single instance — restore if minimized, focus if visible
                const inst = instances[0];
                const isMinimized = inst.workspace &&
                    String(inst.workspace.name) === 'hidden';
                if (isMinimized) {
                    this.daemon.restoreWindow(inst.address);
                } else {
                    this.daemon.focusWindow(inst.address);
                }
            } else {
                // Multiple instances — show a compact picker popover so the
                // user can choose which specific window to raise or restore.
                this._showInstancePicker(freshData || data, btn);
            }
        });

        const gesture = new Gtk.GestureClick();
        gesture.set_button(3);
        gesture.connect('released', () => {
            const freshClientData = this.daemon.getClientData();
            const freshData = freshClientData.find(d => d.className === data.className) || data;
            this._showContextMenu(freshData, btn);
        });
        btn.add_controller(gesture);

        // Dots overlay — lives on top of the button, zero layout cost.
        // Orientation: horizontal for bottom/top, vertical for left/right.
        const dotsBox = Gtk.Box.new(
            IS_VERTICAL ? Gtk.Orientation.VERTICAL : Gtk.Orientation.HORIZONTAL, 0);
        dotsBox.set_halign(dotsHalign);
        dotsBox.set_valign(dotsValign);
        dotsBox.set_name('indicator-dots');
        dotsBox._dotCount = data.instances ? data.instances.length : 0;
        this._populateDots(dotsBox, data);

        // Wrap button + dots in an overlay — no size penalty vs a plain button
        const overlay = new Gtk.Overlay();
        overlay.set_halign(Gtk.Align.CENTER);
        overlay.set_valign(Gtk.Align.CENTER);
        overlay.set_child(btn);
        overlay.add_overlay(dotsBox);
        // Prevent the dots from influencing the overlay's own size request
        overlay.set_measure_overlay(dotsBox, false);
        // Allow input events to pass through the transparent dots area to the button
        overlay.set_clip_overlay(dotsBox, true);

        this.dragDropManager.setupDragSource(btn, overlay, data.className);

        // Insert position: immediately before the end separator if it already
        // exists (correct at all times), otherwise after the last known app
        // widget or the start separator (during initial load before sep-end exists).
        // The full reorder in _updateFromDaemon corrects any transient position,
        // but inserting here correctly avoids a visible flash after trash.
        if (this._endSeparator) {
            const beforeSep = this._endSeparator.get_prev_sibling();
            this.mainBox.insert_child_after(overlay, beforeSep);
        } else {
            const anchor = this._getLastAppWidget() || this._startSeparator;
            if (anchor) {
                this.mainBox.insert_child_after(overlay, anchor);
            } else {
                this.mainBox.append(overlay);
            }
        }

        this.clientWidgets.set(data.className, overlay);
    }

    _updateClientButton(data) {
        // clientWidgets now stores the Gtk.Overlay directly.
        // Structure: overlay { child=btn, overlay=dotsBox }
        const overlay = this.clientWidgets.get(data.className);
        if (!overlay) return;

        const btn = overlay.get_child();
        if (btn) {
            const tooltipText = data.instances.length > 1
                ? (data.displayName || data.className) + ' (' + data.instances.length + ')'
                : (data.displayName || data.className);
            btn.set_tooltip_text(tooltipText);
        }

        // Only rebuild dots when the instance count actually changed —
        // avoids allocating/destroying Gtk.Label widgets on every poll tick.
        const dotsBox = this._findDotsBox(overlay);
        if (dotsBox) {
            const newCount = data.instances ? data.instances.length : 0;
            if (dotsBox._dotCount !== newCount) {
                dotsBox._dotCount = newCount;
                while (dotsBox.get_first_child()) {
                    dotsBox.remove(dotsBox.get_first_child());
                }
                this._populateDots(dotsBox, data);
            }
        }
    }

    // Walk the overlay's children to find the named dotsBox widget.
    // Gtk.Overlay keeps its overlay children as siblings AFTER the main child
    // in the internal child list, so we skip the first child (the button).
    _findDotsBox(overlay) {
        let child = overlay.get_first_child();
        while (child) {
            if (child.get_name() === 'indicator-dots') return child;
            child = child.get_next_sibling();
        }
        return null;
    }

    // Shared helper — fills a dotsBox with indicator glyphs
    _populateDots(dotsBox, data) {
        const instanceCount = data.instances ? data.instances.length : 0;
        if (instanceCount > 0) {
            if (instanceCount > 1) {
                const first = Gtk.Label.new(GLYPH_INDICATOR);
                first.set_name('active-indicator');
                dotsBox.append(first);
                const second = Gtk.Label.new(GLYPH_INDICATOR);
                second.set_name('active-indicator');
                if (IS_VERTICAL) second.set_margin_top(INDICATOR_SPACING);
                else              second.set_margin_start(INDICATOR_SPACING);
                dotsBox.append(second);
            } else {
                const dot = Gtk.Label.new(GLYPH_INDICATOR);
                dot.set_name('active-indicator');
                dotsBox.append(dot);
            }
        }
    }

    // --- Instance Picker Popover (left-click on multi-instance app icons) ---
    // Shows a compact stacked list of all open windows for the app.
    // Clicking a row restores the window if it is minimized on special:*,
    // or focuses it directly if it is on a normal workspace.
    _showInstancePicker(data, parentButton) {
        // Reuse the same directional logic as _showContextMenu
        const _pos = DockConfig.position;
        const _gap = DockConfig.popoverGapDock || 12;
        let popPos, offX, offY;
        if (_pos === 'top') {
            popPos = Gtk.PositionType.BOTTOM; offX = 0;    offY = _gap;
        } else if (_pos === 'left') {
            popPos = Gtk.PositionType.RIGHT;  offX = _gap; offY = 0;
        } else if (_pos === 'right') {
            popPos = Gtk.PositionType.LEFT;   offX = -_gap; offY = 0;
        } else {
            popPos = Gtk.PositionType.TOP;    offX = 0;    offY = -_gap;
        }

        const picker = new Gtk.Popover();
        picker.set_parent(parentButton);
        picker.set_has_arrow(false);
        picker.set_position(popPos);
        picker.add_css_class('dock-popover');
        picker.set_offset(offX, offY);
        picker.connect('closed', () => {
            _ahPopoverClosed();
            this._resetDockButtonHover(parentButton);
            GLib.idle_add(GLib.PRIORITY_LOW, () => {
                try { picker.unparent(); } catch (_) {}
                return GLib.SOURCE_REMOVE;
            });
        });

        const styleCtx = picker.get_style_context();
        styleCtx.add_provider(this._getPopoverCSSProvider(), Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);

        const box = Gtk.Box.new(Gtk.Orientation.VERTICAL, 0);
        box.set_margin_start(6);
        box.set_margin_end(6);
        box.set_margin_top(6);
        box.set_margin_bottom(6);

        data.instances.forEach((instance, idx) => {
            const isMinimized = instance.workspace &&
                String(instance.workspace.name) === 'hidden';

            // Row: small icon + title + workspace hint + restore/focus glyph
            const rowBox = Gtk.Box.new(Gtk.Orientation.HORIZONTAL, 8);

            const iconName = this.daemon.getIcon(data.iconClass || data.className);
            const icon = (iconName.startsWith('/') || iconName.startsWith('~'))
                ? Gtk.Image.new_from_file(iconName)
                : Gtk.Image.new_from_icon_name(iconName);
            icon.set_pixel_size(16);
            rowBox.append(icon);

            const title = instance.title.length > 28
                ? instance.title.substring(0, 28) + '…'
                : instance.title;
            const wsName = instance.workspace
                ? (instance.workspace.name || instance.workspace.id || '?')
                : '?';
            const wsDisplay = isMinimized ? '🗕' : ('WS ' + wsName);
            const labelText = title + '  ' + wsDisplay;

            const label = Gtk.Label.new(labelText);
            label.set_halign(Gtk.Align.START);
            label.set_hexpand(true);
            rowBox.append(label);

            // Small state glyph on the right — ↩ for restore,  for focus
            const stateLabel = Gtk.Label.new(isMinimized ? '' : '');
            stateLabel.set_halign(Gtk.Align.END);
            stateLabel.set_margin_start(6);
            rowBox.append(stateLabel);

            const rowBtn = Gtk.Button.new();
            rowBtn.set_child(rowBox);
            rowBtn.add_css_class('popover-item');
            rowBtn.set_halign(Gtk.Align.FILL);
            rowBtn.connect('clicked', () => {
                if (isMinimized) {
                    this.daemon.restoreWindow(instance.address);
                } else {
                    this.daemon.focusWindow(instance.address);
                }
                picker.popdown();
            });
            box.append(rowBtn);

            // Separator between rows
            if (idx < data.instances.length - 1) {
                const sep = Gtk.Separator.new(Gtk.Orientation.HORIZONTAL);
                sep.set_margin_top(3);
                sep.set_margin_bottom(3);
                box.append(sep);
            }
        });

        picker.set_child(box);
        _ahPopoverOpened();
        picker.popup();
    }

    // --- Context Menu (GTK4 Popover with nwg-style side menu) ---------
    _showContextMenu(data, parentButton) {
        // Compute popover directions so the menu always opens away from the
        // screen edge regardless of which edge the dock is anchored to.
        const _pos = DockConfig.position;
        const _gapD = DockConfig.popoverGapDock || 12;
        const _gapS = DockConfig.popoverGapSide || 12;
        let mainPopPos, mainOffX, mainOffY, sidePopPos, sideOffX, sideOffY;
        if (_pos === 'top') {
            mainPopPos = Gtk.PositionType.BOTTOM; mainOffX = 0;      mainOffY = _gapD;
            sidePopPos = Gtk.PositionType.BOTTOM; sideOffX = 0;      sideOffY = _gapS;
        } else if (_pos === 'left') {
            mainPopPos = Gtk.PositionType.RIGHT;  mainOffX = _gapD;  mainOffY = 0;
            sidePopPos = Gtk.PositionType.RIGHT;  sideOffX = _gapS;  sideOffY = 0;
        } else if (_pos === 'right') {
            mainPopPos = Gtk.PositionType.LEFT;   mainOffX = -_gapD; mainOffY = 0;
            sidePopPos = Gtk.PositionType.LEFT;   sideOffX = -_gapS; sideOffY = 0;
        } else {
            mainPopPos = Gtk.PositionType.TOP;    mainOffX = 0;      mainOffY = -_gapD;
            sidePopPos = Gtk.PositionType.RIGHT;  sideOffX = _gapS;  sideOffY = 0;
        }

        // Main popover
        const mainPopover = new Gtk.Popover();
        mainPopover.set_parent(parentButton);
        mainPopover.set_has_arrow(false);
        mainPopover.set_position(mainPopPos);
        mainPopover.add_css_class('dock-popover');
        mainPopover.set_offset(mainOffX, mainOffY);
        // Defer unparent via idle_add — calling unparent() synchronously inside
        // 'closed' interrupts GTK4's Wayland grab-release sequence, corrupting
        // event routing so all future right-clicks route to the first button that
        // ever showed a popover.  idle_add lets GTK finish cleanup first.
        mainPopover.connect('closed', () => {
            _ahPopoverClosed();
            this._resetDockButtonHover(parentButton);
            GLib.idle_add(GLib.PRIORITY_LOW, () => {
                try { mainPopover.unparent(); } catch(_) {}
                return GLib.SOURCE_REMOVE;
            });
        });
        
        // Apply inline styling for transparency fix
        const mainStyleContext = mainPopover.get_style_context();
        mainStyleContext.add_provider(this._getPopoverCSSProvider(), Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);

        const menuBox = Gtk.Box.new(Gtk.Orientation.VERTICAL, 0);
        menuBox.set_margin_start(6);
        menuBox.set_margin_end(6);
        menuBox.set_margin_top(6);
        menuBox.set_margin_bottom(6);

        // Track whichever side popover is currently open so we can close it
        // before opening another one — Wayland only allows one grab chain at a time.
        let openSidePopover = null;

        // Show instances only when app is running
        if (data.instances.length > 0) {
            // Per-instance entries with side popover on hover
            data.instances.forEach((instance, idx) => {
                // Instance header row
                const headerBox = Gtk.Box.new(Gtk.Orientation.HORIZONTAL, 6);

                const _instanceIconName = this.daemon.getIcon(data.iconClass || data.className);
                const instanceIcon = (_instanceIconName.startsWith('/') || _instanceIconName.startsWith('~'))
                    ? Gtk.Image.new_from_file(_instanceIconName)
                    : Gtk.Image.new_from_icon_name(_instanceIconName);
                instanceIcon.set_pixel_size(16);
                headerBox.append(instanceIcon);

                const title = instance.title.length > 30
                    ? instance.title.substring(0, 30) + '...'
                    : instance.title;
                const wsName = instance.workspace
                    ? (instance.workspace.name || instance.workspace.id || '?')
                    : '?';
                // Show a visible hint when the window is on a special (minimized) workspace
                const _instMinimized = wsName === 'hidden';
                const wsDisplay = _instMinimized ? '🗕 minimized' : wsName;
                const headerLabel = Gtk.Label.new(title + ' (' + wsDisplay + ')');
                headerLabel.set_halign(Gtk.Align.START);
                headerLabel.set_hexpand(true);
                headerBox.append(headerLabel);

                const chevronLabel = Gtk.Label.new('›');
                chevronLabel.set_halign(Gtk.Align.END);
                chevronLabel.set_valign(Gtk.Align.CENTER);
                chevronLabel.set_margin_start(8);
                headerBox.append(chevronLabel);

                // Detect minimized state for this specific instance
                const _isMinimized = instance.workspace &&
                    String(instance.workspace.name) === 'hidden';

                // Focus button — restores if minimized, focuses if visible
                const focusBtn = Gtk.Button.new();
                focusBtn.set_child(headerBox);
                focusBtn.add_css_class('popover-item');
                focusBtn.set_halign(Gtk.Align.FILL);
                focusBtn.connect('clicked', () => {
                    if (_isMinimized) {
                        this.daemon.restoreWindow(instance.address);
                    } else {
                        this.daemon.focusWindow(instance.address);
                    }
                    mainPopover.popdown();
                });

                // Side popover for actions (opens on hover)
                const sidePopover = new Gtk.Popover();
                sidePopover.set_parent(focusBtn);
                sidePopover.set_has_arrow(false);
                sidePopover.set_position(sidePopPos);
                sidePopover.add_css_class('dock-popover');
                sidePopover.set_offset(sideOffX, sideOffY);
                // NOTE: no 'closed' → unparent() here.
                // sidePopover is parented to focusBtn which lives inside
                // mainPopover's content tree. Calling unparent() on it after
                // it closes causes a crash when the mouse re-enters focusBtn:
                // hoverCtrl 'enter' calls sidePopover.popup() on the now-
                // parentless widget, triggering a GTK assertion.
                // mainPopover.unparent() (deferred via idle_add on its own
                // 'closed' signal) cleans up the entire tree including all
                // side popovers when the main menu is dismissed.
                
                // Apply inline styling for transparency fix
                const sideStyleContext = sidePopover.get_style_context();
                sideStyleContext.add_provider(this._getPopoverCSSProvider(), Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);

                const actionsBox = Gtk.Box.new(Gtk.Orientation.VERTICAL, 0);
                actionsBox.set_margin_start(6);
                actionsBox.set_margin_end(6);
                actionsBox.set_margin_top(6);
                actionsBox.set_margin_bottom(6);

                // Window actions — Minimize/Restore first, then the rest
                const windowActions = [
                    _isMinimized
                        ? { label: 'Restore', fn: () => this.daemon.restoreWindow(instance.address) }
                        : { label: 'Minimize', fn: () => this.daemon.minimizeWindow(instance.address) },
                    { label: 'Close Window', fn: () => this.daemon.closeWindow(instance.address) },
                    { label: 'Toggle Floating', fn: () => GLib.spawn_command_line_async(`hyprctl dispatch "hl.dsp.window.float({ window = 'address:${instance.address}', action = 'toggle' })"`) },
                    { label: 'Fullscreen', fn: () => GLib.spawn_command_line_async(`hyprctl dispatch "hl.dsp.window.fullscreen({ window = 'address:${instance.address}', action = 'toggle' })"`) },
                ];

                for (const wa of windowActions) {
                    const actionBtn = Gtk.Button.new_with_label(wa.label);
                    actionBtn.add_css_class('popover-item');
                    actionBtn.add_css_class('popover-action');
                    actionBtn.set_halign(Gtk.Align.FILL);
                    actionBtn.connect('clicked', () => {
                        wa.fn();
                        sidePopover.popdown();
                        mainPopover.popdown();
                    });
                    actionsBox.append(actionBtn);
                }

                // Move to workspace — separator, header in @inverse_primary, separator, then WS buttons
                const wsSepTop = Gtk.Separator.new(Gtk.Orientation.HORIZONTAL);
                wsSepTop.set_margin_top(4);
                wsSepTop.set_margin_bottom(4);
                actionsBox.append(wsSepTop);

                const wsMenuLabel = Gtk.Label.new('Move to Workspace');
                wsMenuLabel.set_halign(Gtk.Align.CENTER);
                wsMenuLabel.add_css_class('popover-section-header');
                actionsBox.append(wsMenuLabel);

                const wsSepBottom = Gtk.Separator.new(Gtk.Orientation.HORIZONTAL);
                wsSepBottom.set_margin_top(4);
                wsSepBottom.set_margin_bottom(4);
                actionsBox.append(wsSepBottom);

                for (let i = 1; i <= 10; i++) {
                    const wsBtn = Gtk.Button.new_with_label('→ WS ' + i);
                    wsBtn.add_css_class('popover-item');
                    wsBtn.add_css_class('popover-action');
                    wsBtn.set_halign(Gtk.Align.FILL);
wsBtn.connect('clicked', () => {
	                        GLib.spawn_command_line_async(`hyprctl dispatch "hl.dsp.window.move({ window = 'address:${instance.address}', workspace = ${i} })"`);
	                        sidePopover.popdown();
	                        mainPopover.popdown();
	                    });
                    actionsBox.append(wsBtn);
                }

                sidePopover.set_child(actionsBox);

                // Hover to open side popover.
                // Close any previously open side popover first so Wayland's
                // single-grab-chain constraint is never violated.
                const hoverCtrl = new Gtk.EventControllerMotion();
                // Track open/closed for autohide suppression.
                // Use a per-instance flag so rapid hover in/out doesn't
                // double-increment if popup() is called while already open.
                let _sideOpen = false;
                sidePopover.connect('closed', () => {
                    if (_sideOpen) { _sideOpen = false; _ahPopoverClosed(); }
                });
                hoverCtrl.connect('enter', () => {
                    if (openSidePopover && openSidePopover !== sidePopover) {
                        openSidePopover.popdown();
                    }
                    openSidePopover = sidePopover;
                    if (!_sideOpen) { _sideOpen = true; _ahPopoverOpened(); }
                    sidePopover.popup();
                });
                focusBtn.add_controller(hoverCtrl);

                // Close when mouse leaves the actions box; clear the shared ref.
                const actionsHoverCtrl = new Gtk.EventControllerMotion();
                actionsHoverCtrl.connect('leave', () => {
                    sidePopover.popdown();
                    if (openSidePopover === sidePopover) openSidePopover = null;
                });
                actionsBox.add_controller(actionsHoverCtrl);

                menuBox.append(focusBtn);

                // Separator between instances
                if (idx < data.instances.length - 1) {
                    const sep = Gtk.Separator.new(Gtk.Orientation.HORIZONTAL);
                    sep.set_margin_top(4);
                    sep.set_margin_bottom(4);
                    menuBox.append(sep);
                }
            });
        }

        // --- "New Window" always shown; dGPU options appended if switcheroo reports any ---
        // getAvailableGPUs() returns [{name, envVars}] for non-default GPUs via
        // switcheroo-control, or [] if unavailable / single GPU.
        const gpus = this.daemon.getAvailableGPUs();

        // Helper: build and attach a workspace sub-popover to a launch button.
        // On hover the sub-popover appears showing WS 1-10; clicking a WS launches
        // on that workspace.  Clicking the button itself (without hovering into the
        // sub-popover) launches on the current workspace.
        const _attachWsSubPopover = (launchBtn, launchFn) => {
            const wsSubPop = new Gtk.Popover();
            wsSubPop.set_parent(launchBtn);
            wsSubPop.set_has_arrow(false);
            wsSubPop.set_position(sidePopPos);
            wsSubPop.set_offset(sideOffX, sideOffY);
            wsSubPop.add_css_class('dock-popover');
            const wsSubStyleCtx = wsSubPop.get_style_context();
            wsSubStyleCtx.add_provider(this._getPopoverCSSProvider(), Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);

            const wsBox = Gtk.Box.new(Gtk.Orientation.VERTICAL, 0);
            wsBox.set_margin_start(6);
            wsBox.set_margin_end(6);
            wsBox.set_margin_top(6);
            wsBox.set_margin_bottom(6);

            const wsHdr = Gtk.Label.new('Open on Workspace');
            wsHdr.set_halign(Gtk.Align.CENTER);
            wsHdr.add_css_class('popover-section-header');
            wsBox.append(wsHdr);

            const wsHdrSep = Gtk.Separator.new(Gtk.Orientation.HORIZONTAL);
            wsHdrSep.set_margin_top(4);
            wsHdrSep.set_margin_bottom(4);
            wsBox.append(wsHdrSep);

            for (let i = 1; i <= 10; i++) {
                const wsBtn = Gtk.Button.new_with_label('→ WS ' + i);
                wsBtn.add_css_class('popover-item');
                wsBtn.add_css_class('popover-action');
                wsBtn.set_halign(Gtk.Align.FILL);
wsBtn.connect('clicked', () => {
	                    // Combine workspace focus with exec_cmd rule to fix race conditions for apps like Nautilus
	                    const raw = this.daemon._resolveExec(data.iconClass || data.className);
	                    if (raw) {
	                        // Focus workspace first, then launch with rule
	                        GLib.spawn_command_line_async(`hyprctl dispatch "hl.dsp.focus({ workspace = ${i} })"`);
	                        GLib.timeout_add(GLib.PRIORITY_DEFAULT, 50, () => {
	                            GLib.spawn_command_line_async(`hyprctl dispatch "hl.dsp.exec_cmd('${raw}', { workspace = ${i} })"`);
	                            return GLib.SOURCE_REMOVE;
	                        });
	                    } else {
	                        // Fallback: focus workspace then launch
	                        GLib.spawn_command_line_async(`hyprctl dispatch "hl.dsp.focus({ workspace = ${i} })"`);
	                        launchFn();
	                    }
	                    wsSubPop.popdown();
	                    mainPopover.popdown();
	                });
                wsBox.append(wsBtn);
            }
            wsSubPop.set_child(wsBox);

            // Track open state for autohide suppression
            let _wsSubOpen = false;
            wsSubPop.connect('closed', () => {
                if (_wsSubOpen) { _wsSubOpen = false; _ahPopoverClosed(); }
            });

            const hoverCtrl = new Gtk.EventControllerMotion();
            hoverCtrl.connect('enter', () => {
                if (openSidePopover && openSidePopover !== wsSubPop)
                    openSidePopover.popdown();
                openSidePopover = wsSubPop;
                if (!_wsSubOpen) { _wsSubOpen = true; _ahPopoverOpened(); }
                wsSubPop.popup();
            });
            launchBtn.add_controller(hoverCtrl);

            const wsBoxHover = new Gtk.EventControllerMotion();
            wsBoxHover.connect('leave', () => {
                wsSubPop.popdown();
                if (openSidePopover === wsSubPop) openSidePopover = null;
            });
            wsBox.add_controller(wsBoxHover);
        };

        // Always: separator + "New Window" (plain launch on default GPU)
        if (data.instances.length > 0 || gpus.length > 0) {
            const newWinSepTop = Gtk.Separator.new(Gtk.Orientation.HORIZONTAL);
            newWinSepTop.set_margin_top(4);
            newWinSepTop.set_margin_bottom(4);
            menuBox.append(newWinSepTop);
        }

        // "New Window" row — label + chevron to hint at sub-popover
        const newWinBox = Gtk.Box.new(Gtk.Orientation.HORIZONTAL, 6);
        const newWinLabel = Gtk.Label.new('New Window');
        newWinLabel.set_halign(Gtk.Align.START);
        newWinLabel.set_hexpand(true);
        newWinBox.append(newWinLabel);
        const newWinChev = Gtk.Label.new('›');
        newWinChev.set_halign(Gtk.Align.END);
        newWinChev.set_valign(Gtk.Align.CENTER);
        newWinChev.set_margin_start(8);
        newWinBox.append(newWinChev);

        const newWinBtn = Gtk.Button.new();
        newWinBtn.set_child(newWinBox);
        newWinBtn.add_css_class('popover-item');
        newWinBtn.set_halign(Gtk.Align.FILL);
        const _newWinLaunch = () => {
            const execCmd = this.daemon.getExecFromDesktop(data.iconClass || data.className);
            _spawnCleanCmd(execCmd || (data.iconClass || data.className).toLowerCase());
        };
        newWinBtn.connect('clicked', () => {
            _newWinLaunch();
            mainPopover.popdown();
        });
        _attachWsSubPopover(newWinBtn, _newWinLaunch);
        menuBox.append(newWinBtn);

        // dGPU options — only if switcheroo-control reports non-default GPUs
        if (gpus.length > 0) {
            const gpuSepTop = Gtk.Separator.new(Gtk.Orientation.HORIZONTAL);
            gpuSepTop.set_margin_top(4);
            gpuSepTop.set_margin_bottom(4);
            menuBox.append(gpuSepTop);

            const gpuHeader = Gtk.Label.new('Launch on GPU');
            gpuHeader.set_halign(Gtk.Align.CENTER);
            gpuHeader.add_css_class('popover-section-header');
            menuBox.append(gpuHeader);

            const gpuSepBottom = Gtk.Separator.new(Gtk.Orientation.HORIZONTAL);
            gpuSepBottom.set_margin_top(4);
            gpuSepBottom.set_margin_bottom(4);
            menuBox.append(gpuSepBottom);

            for (const gpu of gpus) {
                const _abbrev = imports.daemon.abbreviateGpuName
                    ? imports.daemon.abbreviateGpuName(gpu.name) : gpu.name;

                // dGPU row — label + chevron
                const gpuRowBox = Gtk.Box.new(Gtk.Orientation.HORIZONTAL, 6);
                const gpuRowLabel = Gtk.Label.new(_abbrev);
                gpuRowLabel.set_halign(Gtk.Align.START);
                gpuRowLabel.set_hexpand(true);
                gpuRowBox.append(gpuRowLabel);
                const gpuChev = Gtk.Label.new('›');
                gpuChev.set_halign(Gtk.Align.END);
                gpuChev.set_valign(Gtk.Align.CENTER);
                gpuChev.set_margin_start(8);
                gpuRowBox.append(gpuChev);

                const gpuBtn = Gtk.Button.new();
                gpuBtn.set_child(gpuRowBox);
                gpuBtn.add_css_class('popover-item');
                gpuBtn.add_css_class('popover-action');
                gpuBtn.set_halign(Gtk.Align.FILL);
                const _gpuLaunch = ((_gpu) => () => {
                    this.daemon.launchWithGPU(data.iconClass || data.className, _gpu);
                })(gpu);
                gpuBtn.connect('clicked', () => {
                    _gpuLaunch();
                    mainPopover.popdown();
                });
                _attachWsSubPopover(gpuBtn, _gpuLaunch);
                menuBox.append(gpuBtn);
            }
        }

        const afterLaunchSep = Gtk.Separator.new(Gtk.Orientation.HORIZONTAL);
        afterLaunchSep.set_margin_top(4);
        afterLaunchSep.set_margin_bottom(4);
        menuBox.append(afterLaunchSep);
        // Close all windows (only when multiple instances running)
        if (data.instances.length > 1) {
            const closeAllBtn = Gtk.Button.new_with_label('Close All Windows');
            closeAllBtn.add_css_class('popover-item');
            closeAllBtn.set_halign(Gtk.Align.FILL);
            closeAllBtn.connect('clicked', () => {
                for (const instance of data.instances) {
                    this.daemon.closeWindow(instance.address);
                }
                mainPopover.popdown();
            });
            menuBox.append(closeAllBtn);
        }

        // Pin / Unpin - always show at bottom
        const pinBtn = Gtk.Button.new_with_label(data.pinned ? 'Unpin' : 'Pin');
        pinBtn.add_css_class('popover-item');
        pinBtn.set_halign(Gtk.Align.FILL);
        pinBtn.connect('clicked', () => {
            this.daemon.togglePin(data.iconClass || data.className);
            mainPopover.popdown();
            // Async refresh after pin state changes
            GLib.timeout_add(GLib.PRIORITY_DEFAULT_IDLE, 150, () => {
                this._updateFromDaemon(this.daemon.getClientData());
                return false;
            });
        });
        menuBox.append(pinBtn);

        // Pin to Desktop / Unpin from Desktop
        const cls = data.iconClass || data.className;
        const isDesktopPinned = this.daemon.isDesktopPinned(cls);
        const desktopPinBtn = Gtk.Button.new_with_label(isDesktopPinned ? 'Unpin from Desktop' : 'Pin to Desktop');
        desktopPinBtn.add_css_class('popover-item');
        desktopPinBtn.set_halign(Gtk.Align.FILL);
        desktopPinBtn.connect('clicked', () => {
            this.daemon.toggleDesktopPin(cls);
            mainPopover.popdown();
        });
        menuBox.append(desktopPinBtn);

        mainPopover.set_child(menuBox);
        _ahPopoverOpened();
        mainPopover.popup();
    }

    _showStartMenu(parentButton) {
        // Calculate popover position based on dock position
        let mainPopPos, mainOffX, mainOffY;
        const _gap = 8;
        
        if (IS_VERTICAL) {
            mainPopPos = (DockConfig.position === 'left') ? Gtk.PositionType.RIGHT : Gtk.PositionType.LEFT;
            mainOffX = _gap;
            mainOffY = 0;
        } else {
            mainPopPos = (DockConfig.position === 'bottom') ? Gtk.PositionType.TOP : Gtk.PositionType.BOTTOM;
            mainOffX = 0;
            mainOffY = -_gap;
        }

        // Create popover
        const popover = new Gtk.Popover();
        popover.set_parent(parentButton);
        popover.set_has_arrow(false);
        popover.set_position(mainPopPos);
        popover.add_css_class('dock-popover');
        popover.set_offset(mainOffX, mainOffY);
        popover.connect('closed', () => {
            _ahPopoverClosed();
            this._resetDockButtonHover(parentButton);
            GLib.idle_add(GLib.PRIORITY_LOW, () => {
                try { popover.unparent(); } catch(_) {}
                return GLib.SOURCE_REMOVE;
            });
        });
        
        // Apply styling
        const styleContext = popover.get_style_context();
        styleContext.add_provider(this._getPopoverCSSProvider(), Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);

        // Create menu content
        const menuBox = Gtk.Box.new(Gtk.Orientation.VERTICAL, 0);
        menuBox.set_margin_top(4);
        menuBox.set_margin_bottom(4);
        menuBox.set_size_request(40, 6);

        // Settings button
        const settingsBtn = Gtk.Button.new_with_label('Toggle Hyprland Settings');
        settingsBtn.add_css_class('popover-item');
        settingsBtn.set_halign(Gtk.Align.FILL);
        settingsBtn.connect('clicked', () => {
            try {
                // pgrep -x matches exact process name; exclude zombies (state Z)
                const [, out] = GLib.spawn_command_line_sync('pgrep -x hyprviz');
                const pids = out ? new TextDecoder().decode(out).trim().split('\n').filter(Boolean) : [];
                const alive = pids.some(pid => {
                    try {
                        const [, stat] = GLib.spawn_command_line_sync(`cat /proc/${pid.trim()}/status`);
                        const text = new TextDecoder().decode(stat);
                        const stateMatch = text.match(/^State:\s+(\S)/m);
                        return stateMatch && stateMatch[1] !== 'Z';
                    } catch (_) { return false; }
                });
                if (alive) {
                    GLib.spawn_command_line_sync('pkill -x hyprviz');
                } else {
                    // Spawn without DO_NOT_REAP_CHILD so GLib auto-reaps the child
                    const [, argv] = GLib.shell_parse_argv('hyprviz');
                    let envp = GLib.get_environ();
                    envp = GLib.environ_unsetenv(envp, 'LD_PRELOAD');
                    GLib.spawn_async(GLib.get_home_dir(), argv, envp,
                        GLib.SpawnFlags.SEARCH_PATH, null);
                }
            } catch (e) { console.error('hyprviz toggle failed:', e.message); }
            popover.popdown();
        });
        menuBox.append(settingsBtn);

        popover.set_child(menuBox);
        _ahPopoverOpened();
        popover.popup();
    }

    _getPopoverCSSProvider() {
        if (!this._popoverCSSProvider) {
            this._popoverCSSProvider = new Gtk.CssProvider();
            // GTK4 popovers have a 'contents' node that needs explicit background.
            // We must NOT @import gtk.css as it resets our rules.
            const popoverCSS = `
                popover.dock-popover {
                    background-color: transparent;
                    border: none;
                    border-radius: 12px;
                    color: @primary;
                }
                popover.dock-popover > contents {
                    background-color: @on_secondary;
                    border-radius: 12px;
                    border: 1px solid alpha(@secondary, 0.5);
                    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.4);
                    color: @primary;
                }
                popover.dock-popover > arrow {
                    background-color: @on_secondary;
                }
                popover.dock-popover > contents separator {
                    background-color: @secondary;
                    min-height: 1px;
                }
                popover.dock-popover .popover-item {
                    background: transparent;
                    background-color: transparent;
                    color: @primary;
                    padding: 6px 12px;
                    border-radius: 6px;
                    border: none;
                    box-shadow: none;
                }
                popover.dock-popover .popover-item:hover {
                    background-color: alpha(@primary, 0.12);
                }
                popover.dock-popover .popover-action {
                    font-size: 12px;
                    padding: 4px 10px;
                }
                popover.dock-popover .popover-sublabel {
                    font-size: 11px;
                    font-weight: bold;
                    color: @primary;
                    padding: 4px 12px 2px 12px;
                }
                popover.dock-popover .popover-section-header {
                    font-size: 11px;
                    font-weight: bold;
                    color: @inverse_primary;
                    padding: 4px 12px 2px 12px;
                    margin-top: 2px;
                }
            `;
            this._popoverCSSProvider.load_from_data(popoverCSS, -1);
        }
        return this._popoverCSSProvider;
    }

    vfunc_close_request() {
        if (this._trashMonitor) {
            this._trashMonitor.cancel();
            this._trashMonitor = null;
        }
        teardownColorMonitor();
        this.daemon.shutdown();
        return false;
    }
});

// --- Auto-hide state -------------------------------------------------
// Set by readHyprCandyConf() on startup and on every SIGUSR2 hot-reload.
let _ahEnabled      = false;
let _ahDelaySec     = 5000;     // ms
let _ahTimerId      = 0;        // GLib timeout source id, 0 = not running
let _ahPopoverCount = 0;        // number of popovers currently open; dock stays
                                // visible while this is > 0 (pointer-leave from
                                // dock into a popover must not trigger hide)

function _ahCancelTimer() {
    if (_ahTimerId) {
        GLib.source_remove(_ahTimerId);
        _ahTimerId = 0;
    }
}

// Call when a dock popover opens so autohide is suppressed.
function _ahPopoverOpened() {
    _ahPopoverCount++;
    _ahCancelTimer();
}

// Call when a dock popover closes.  When the last one closes, restart the
// hide timer so autohide resumes naturally after the user is done.
function _ahPopoverClosed() {
    _ahPopoverCount = Math.max(0, _ahPopoverCount - 1);
    if (_ahPopoverCount === 0 && _ahEnabled) {
        _ahStartTimer();
    }
}

function _ahStartTimer() {
    // Don't start a hide timer while any popover is open — the pointer-leave
    // event fires when the cursor moves from the dock surface into the popover
    // (popovers are separate toplevels in GTK4), but the dock must stay visible.
    if (_ahPopoverCount > 0) return;
    _ahCancelTimer();
    _ahTimerId = GLib.timeout_add(GLib.PRIORITY_DEFAULT, _ahDelaySec, () => {
        _ahTimerId = 0;
        if (!_ahEnabled || !dockWindow) return GLib.SOURCE_REMOVE;
        // Popover guard — a popover may have opened between timer start and fire
        if (_ahPopoverCount > 0) return GLib.SOURCE_REMOVE;
        // Fullscreen guard — skip hide if hyprctl reports an active fullscreen window
        try {
            const [, out] = GLib.spawn_command_line_sync('hyprctl -j activewindow');
            const json = new TextDecoder().decode(out);
            if (/"fullscreen"\s*:\s*true/.test(json)) return GLib.SOURCE_REMOVE;
        } catch (_) {}
        dockWindow.set_visible(false);
        if (_ahHotspot) {
            _ahHotspot._applySize();
            _ahHotspot.set_visible(true);
        }
        return GLib.SOURCE_REMOVE;
    });
}

// --- Launcher state-file monitor --------------------------------------
// app-launcher.js writes "open\n" / "closed\n" to LAUNCHER_STATE_PATH
// on every visibility change.  We watch that file with Gio.FileMonitor
// and hook into the same _ahPopoverOpened / _ahPopoverClosed mechanism
// used by right-click popovers so autohide is suppressed while the
// launcher is on screen.
function setupLauncherMonitor() {
    if (_launcherMonitor) return;
    try {
        const f = Gio.File.new_for_path(LAUNCHER_STATE_PATH);
        _launcherMonitor = f.monitor_file(Gio.FileMonitorFlags.NONE, null);
        _launcherMonitor.connect('changed', (_mon, _file, _other, ev) => {
            if (ev !== Gio.FileMonitorEvent.CHANGES_DONE_HINT &&
                ev !== Gio.FileMonitorEvent.CREATED &&
                ev !== Gio.FileMonitorEvent.CHANGED) return;
            try {
                const [ok, bytes] = GLib.file_get_contents(LAUNCHER_STATE_PATH);
                if (!ok) return;
                const state = new TextDecoder().decode(bytes).trim();
                const nowOpen = state === 'open';
                if (nowOpen && !_launcherOpen) {
                    _launcherOpen = true;
                    _ahPopoverOpened();
                } else if (!nowOpen && _launcherOpen) {
                    _launcherOpen = false;
                    _ahPopoverClosed();
                }
            } catch (_) {}
        });
    } catch (e) {
        log('[dock] launcher monitor setup failed: ' + e.message);
    }
}

function teardownLauncherMonitor() {
    if (_launcherMonitor) {
        _launcherMonitor.cancel();
        _launcherMonitor = null;
    }
    if (_launcherOpen) {
        _launcherOpen = false;
        _ahPopoverClosed();
    }
}

let _ahHotspot = null;   // HotspotWindow instance, created after dockWindow

// --- Hotspot Window (auto-hide re-show strip) -------------------------
// A 2 px tall/wide layer surface anchored to the same edge as the dock.
// It is visible only while the dock is hidden and auto-hide is active.
// EventControllerMotion.enter re-shows the dock and hides the hotspot.
const HotspotWindow = GObject.registerClass({
    GTypeName: 'HyprCandyDockHotspot',
}, class HotspotWindow extends Gtk.ApplicationWindow {
    _init(application) {
        super._init({
            application: application,
            title:       'HyprCandy Dock Hotspot',
            decorated:   false,
            resizable:   false,
        });

        Gtk4LayerShell.init_for_window(this);
        Gtk4LayerShell.set_namespace(this, 'hyprcandy-dock-hotspot');
        this._hotspotCss = new Gtk.CssProvider();
        this._applyHotspotColor();
        this.get_style_context().add_provider(this._hotspotCss,
            Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION + 10);
        Gtk4LayerShell.set_layer(this, Gtk4LayerShell.Layer.TOP);
        Gtk4LayerShell.set_exclusive_zone(this, 0);

        // Size the hotspot surface by querying the monitor geometry directly
        // rather than relying on GTK anchor-stretch, which is unreliable inside
        // Gtk.ApplicationWindow's internal frame hierarchy.  _refreshAnchors()
        // calls _applySize() which sets an explicit size_request matching the
        // monitor's along-edge dimension so pointer events cover the full strip.
        const fill = new Gtk.DrawingArea();
        fill.set_hexpand(true);
        fill.set_vexpand(true);
        this.set_child(fill);

        // Anchor same edge as the dock (read from DockConfig at creation time;
        // _refreshAnchors() is also called by hotReload() to track position changes)
        this._refreshAnchors();

        // Re-show dock when pointer enters the hotspot strip
        const motion = new Gtk.EventControllerMotion();
        motion.connect('enter', () => {
            if (!_ahEnabled || !dockWindow) return;
            dockWindow.set_visible(true);
            dockWindow.present();
            this.set_visible(false);
        });
        this.add_controller(motion);

        // Start hidden; shown by _ahStartTimer() when the dock hides
        this.set_visible(false);
    }

    // Update hotspot background to match the current rectBgStyle.
    // The CC Bar:Background fill toggle controls the dock surface — the hotspot
    // always stays @blur so it remains invisible regardless of dock style.
    // Called at construction and by hotReload() so live changes take effect.
    _applyHotspotColor() {
        // background-image: none is required here — without it the display-level
        // dynamicConfigProvider (APP+1) bleeds its gradient rule onto this window
        // when rectBgStyle=gradient.  The hotspot always stays @blur regardless
        // of dock fill style; the explicit none at widget-level (APP+10) wins.
        this._hotspotCss.load_from_data(
            'window.background { background-color: @blur; background-image: none; border: none; box-shadow: none; }', -1);
    }

    _refreshAnchors() {
        const pos = DockConfig.position;
        Gtk4LayerShell.set_anchor(this, Gtk4LayerShell.Edge.BOTTOM, pos === 'bottom');
        Gtk4LayerShell.set_anchor(this, Gtk4LayerShell.Edge.TOP,    pos === 'top');
        Gtk4LayerShell.set_anchor(this, Gtk4LayerShell.Edge.LEFT,   pos === 'left'  || pos === 'bottom' || pos === 'top');
        Gtk4LayerShell.set_anchor(this, Gtk4LayerShell.Edge.RIGHT,  pos === 'right' || pos === 'bottom' || pos === 'top');

        // Always zero all four margins so a previous position's values don't bleed in.
        Gtk4LayerShell.set_margin(this, Gtk4LayerShell.Edge.BOTTOM, 0);
        Gtk4LayerShell.set_margin(this, Gtk4LayerShell.Edge.TOP,    0);
        Gtk4LayerShell.set_margin(this, Gtk4LayerShell.Edge.LEFT,   0);
        Gtk4LayerShell.set_margin(this, Gtk4LayerShell.Edge.RIGHT,  0);

        // Use an explicit size_request derived from the monitor geometry so
        // pointer events cover the entire edge.  GTK4 anchor-stretching inside
        // Gtk.ApplicationWindow is unreliable (the internal frame widget does
        // not propagate expands to the Wayland surface commit), causing the
        // hotspot to only respond near the left/top corner.  Querying the
        // monitor and calling set_size_request bypasses that entirely.
        this._applySize();
    }

    _applySize() {
        const pos = DockConfig.position;
        const isHoriz = (pos === 'bottom' || pos === 'top');

        // Thickness: fill the screen-edge gap so the cursor triggers re-show
        // without having to travel to the raw pixel edge.
        const thickness = isHoriz
            ? Math.max(4, pos === 'bottom' ? DockConfig.marginBottom : DockConfig.marginTop)
            : Math.max(4, pos === 'left'   ? DockConfig.marginLeft   : DockConfig.marginRight);

        // Along-edge dimension: query the monitor so we set an exact pixel size.
        // Fall back to a large sentinel (4096) if the display isn't ready yet;
        // _applySize() is called again after show() in _ahStartTimer so it will
        // correct itself once the surface is mapped.
        let along = isHoriz ? 4096 : 4096;
        try {
            const display = Gdk.Display.get_default();
            if (display) {
                // get_monitors() returns a Gio.ListModel in GTK4
                const monitors = display.get_monitors();
                const n = monitors.get_n_items();
                if (n > 0) {
                    // Use the first monitor; for multi-monitor setups this matches
                    // the monitor the dock is on (layer-shell assigns to primary by default)
                    const mon = monitors.get_item(0);
                    const geo = mon.get_geometry();
                    along = isHoriz ? geo.width : geo.height;
                }
            }
        } catch (e) {
            log('[dock] hotspot _applySize: monitor query failed: ' + e.message);
        }

        if (isHoriz) {
            this.set_size_request(along, thickness);
            this.set_default_size(along, thickness);
        } else {
            this.set_size_request(thickness, along);
            this.set_default_size(thickness, along);
        }
    }
});

// --- Application ------------------------------------------------------
const DockApplication = GObject.registerClass({
    GTypeName: 'HyprCandyDockApplication',
}, class DockApplication extends Gtk.Application {
    vfunc_activate() {
        // Load CSS (static providers: GTK3/4 colours + style.css)
        loadCSS();

        // Watch gtk-4.0/colors.css + style.css for matugen / CC hot-reload
        setupColorMonitor();
        setupStyleMonitor();

        // Create dock
        dockWindow = new HyprCandyDock(this);
        this.add_window(dockWindow);

        // Initialise auto-hide conf values (hotReload() will update them later)
        {
            const conf = readHyprCandyConf();
            _ahEnabled  = conf.autoHide;
            _ahDelaySec = conf.autoHideDelay;
            // Apply initial layer from conf
            Gtk4LayerShell.set_layer(dockWindow, conf.layer === 'overlay'
                ? Gtk4LayerShell.Layer.OVERLAY : Gtk4LayerShell.Layer.TOP);
            log('[dock] startup: autohide=' + _ahEnabled + ' layer=' + conf.layer);

            // Apply margin_from_edge to the anchored-edge margin so the saved
            // CC slider value takes effect immediately on launch.
            if (conf.marginFromEdge !== null) {
                const pos = DockConfig.position;
                if      (pos === 'bottom') DockConfig.marginBottom = conf.marginFromEdge;
                else if (pos === 'top')    DockConfig.marginTop    = conf.marginFromEdge;
                else if (pos === 'left')   DockConfig.marginLeft   = conf.marginFromEdge;
                else if (pos === 'right')  DockConfig.marginRight  = conf.marginFromEdge;
                applyMarginsToLayerShell(dockWindow);
                log('[dock] startup: margin_from_edge = ' + conf.marginFromEdge + ' (position: ' + pos + ')');
            }
        }

        // Hotspot window — strip at the same edge as the dock, Layer.TOP,
        // exclusiveZone=0.  Shown only when dock is hidden.  Its own
        // EventControllerMotion re-shows the dock when the pointer enters.
        _ahHotspot = new HotspotWindow(this);
        this.add_window(_ahHotspot);

        // If autohide was enabled in the saved conf, start the hide timer
        // immediately so the dock behaves correctly on a fresh session
        // without requiring a SIGUSR2 hot-reload to activate it.
        if (_ahEnabled) {
            log('[dock] startup: autohide active — starting hide timer');
            _ahStartTimer();
        }

        // Always start the launcher state-file monitor so autohide is
        // suppressed whenever the app-launcher window is visible, regardless
        // of whether autohide was enabled at startup (it can be toggled live).
        setupLauncherMonitor();
    }
});

// --- Signal handler (module scope) -----------------------------------
// Registered HERE — before app.run() — so there is zero race window
// between process start and the handler being active.
//
// SIGUSR2 (12) is the hot-reload signal.  SIGUSR1 (10) is reserved by GJS
// for internal heap-dump / profiling when --profile is active.
// candy-utils reloads the dock with:
//   pkill -12 -f 'gjs dock-main.js'
GLibUnix.signal_add_full(GLib.PRIORITY_DEFAULT, 12, () => {
    hotReload();
    return GLib.SOURCE_CONTINUE;
});
log('[dock] SIGUSR2 (12) handler registered — send with: pkill -12 -f \'gjs dock-main.js\'');

// --- Launch -----------------------------------------------------------
const app = new DockApplication({
    application_id: 'com.hyprcandy.dock',
    flags: Gio.ApplicationFlags.NON_UNIQUE,
});
app.run(ARGV);
EOF

echo "✅ Files and Apps setup complete"
}

# Function to cleanup post update
cleanup() {
	echo
    REAL_USER=$(getent passwd $PKEXEC_UID | cut -d: -f1)

	su - "$REAL_USER" -c "USER_HOME=$USER_HOME bash '$USER_HOME/.config/hypr/scripts/notify.sh'"
    su - "$REAL_USER" -c "USER_HOME=$USER_HOME bash '$USER_HOME/.config/hyprcandy/hooks/complete.sh'"
    return 0
}

    # Main execution
main() {
    USER_HOME=$(getent passwd $PKEXEC_UID | cut -d: -f6)
    cd "$USER_HOME"
	
	# Show multicolored ASCII art
    show_ascii_art 
    echo
    
    # Choose display manager first
    #choose_display_manager
    #echo

    #detect distro
    #detect_distro
    #echo

    # Choose a panel
    #choose_panel
    #echo
    
    # Choose shell
    #choose_shell
    #echo

    # Check for AUR helper or install one
    check_or_install_package_manager
    echo
    
    if [ "$SHELL_CHOICE" = "fish" ]; then
        setup_fish
    elif [ "$SHELL_CHOICE" = "zsh" ]; then
        setup_zsh
    elif [ "$SHELL_CHOICE" = "skip" ]; then
        echo
    fi
    
    # Automatically setup HyprCandy configuration
    setup_hyprcandy
    echo

    # Enable display manager
    #enable_display_manager

    # Setup default custom config file
    #setup_custom_config
    #echo
    
    # Update keybinds based on choice
    #update_keybinds
    
    # Update custom config based on choice
    #update_custom

    # Setup GJS
    setup_gjs
    echo
    
    # Function to cleanup post update
    cleanup
}

# Run main function
main "$@"
