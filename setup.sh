#!/bin/bash

# --- Color codes ---
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}========================================="
echo -e " ThreatMail Simulator - Global Setup"
echo -e "=========================================${NC}"

echo -e "${BLUE}[*] Checking Python and pip...${NC}"
if command -v python3 >/dev/null 2>&1; then
    PYTHON=python3
elif command -v python >/dev/null 2>&1; then
    PYTHON=python
else
    echo -e "${RED}[!] Python not found. Please install Python 3."
    exit 1
fi
if command -v pip3 >/dev/null 2>&1; then
    PIP=pip3
elif command -v pip >/dev/null 2>&1; then
    PIP=pip
else
    echo -e "${RED}[!] pip for Python not found. Please install pip for Python 3."
    exit 1
fi

echo -e "${BLUE}[*] Installing dependencies (flask, werkzeug)...${NC}"
$PIP install --upgrade flask werkzeug > /dev/null 2>&1

echo -e "${BLUE}[*] Ensuring 'mails/' and 'scripts/' directories exist...${NC}"
mkdir -p mails
mkdir -p scripts

if [ ! -f "email" ]; then
    echo -e "${RED}[!] 'email' launcher script not found in this directory.${NC}"
    exit 1
fi

echo -e "${BLUE}[*] Setting executable permissions on 'email'...${NC}"
chmod +x email

DEST=""
IS_TERMUX=false
IS_WINDOWS=false

if grep -qiE 'microsoft|windows' <<<"$(uname -a 2>/dev/null)"; then
    IS_WINDOWS=true
fi

if [ "$IS_WINDOWS" = true ]; then
    echo -e "${YELLOW}[!] Detected Windows environment."
    echo -e "    Please copy the 'email' script to a directory in your PATH (e.g. C:\\Windows or add your own),"
    echo -e "    or use Git Bash/MSYS2 and add ~/bin to your PATH."
    echo -e "${GREEN}You can run the tool with:${NC} ${YELLOW}bash email${NC} (from your project directory or global location)."
    exit 0
elif [ "$PREFIX" ] && [ -d "$PREFIX/bin" ]; then
    DEST="$PREFIX/bin"
    IS_TERMUX=true
elif [ -w /usr/local/bin ]; then
    DEST="/usr/local/bin"
elif [ -d "$HOME/bin" ]; then
    DEST="$HOME/bin"
else
    mkdir -p "$HOME/bin"
    DEST="$HOME/bin"
fi

echo -e "${BLUE}[*] Installing 'email' launcher to: ${YELLOW}$DEST${NC}"
cp email "$DEST/email"

echo -e "${BLUE}[*] Ensuring global 'email' command is executable...${NC}"
chmod +x "$DEST/email"

if [[ ":$PATH:" != *":$DEST:"* ]]; then
    echo -e "${YELLOW}[!] $DEST is not in your PATH."
    echo -e "    Add the following line to your shell profile (e.g. ~/.bashrc, ~/.zshrc):"
    echo -e "    ${CYAN}export PATH=\"\$PATH:$DEST\"${NC}"
    echo -e "    Then restart your terminal or run: ${CYAN}source ~/.profile${NC}"
fi

echo ""
echo -e "${GREEN}========================================="
echo -e "✅  Setup complete!"
echo -e "=========================================${NC}"
echo -e "${CYAN}You can now run the tool globally from anywhere using:${NC} ${YELLOW}email${NC}"
echo -e "${CYAN}For example:${NC} ${YELLOW}email${NC}"
echo ""
echo -e "${GREEN}Happy phishing simulations and testing (authorized use only)!${NC}"
echo ""
