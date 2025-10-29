#!/bin/bash
# Remote Template Installer for Claude Code Bootstrap
# Downloads template from GitHub to temporary directory
# Returns path to downloaded template on stdout

set -euo pipefail

# Configuration
GITHUB_REPO="${CLAUDE_TEMPLATE_REPO:-dmnlng/claude-code-config}"
GITHUB_BRANCH="${CLAUDE_TEMPLATE_BRANCH:-main}"
TMP_DIR="/tmp/claude-code-template-$$"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Cleanup on exit
cleanup() {
    # Don't cleanup - let caller use the downloaded template
    # It will be cleaned up by OS on reboot
    :
}
trap cleanup EXIT

# Helper to check command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Try to download template from GitHub
download_from_github() {
    echo -e "${BLUE}Downloading Claude Code template from GitHub...${NC}" >&2

    if command_exists git; then
        # Preferred: Use git for shallow clone
        if git clone --depth 1 --branch "$GITHUB_BRANCH" \
            "https://github.com/${GITHUB_REPO}.git" "$TMP_DIR" >/dev/null 2>&1; then
            echo -e "${GREEN}✓ Template downloaded via git${NC}" >&2
            echo "$TMP_DIR"
            return 0
        fi
    fi

    if command_exists curl; then
        # Fallback: Use curl to download zip
        mkdir -p "$TMP_DIR"
        DOWNLOAD_URL="https://github.com/${GITHUB_REPO}/archive/refs/heads/${GITHUB_BRANCH}.zip"

        if curl -sSL "$DOWNLOAD_URL" -o "$TMP_DIR/template.zip" 2>/dev/null; then
            if command_exists unzip; then
                cd "$TMP_DIR"
                if unzip -q template.zip 2>/dev/null; then
                    # Move contents from extracted dir to TMP_DIR
                    EXTRACTED_DIR=$(find . -maxdepth 1 -type d -name "claude-code-template-*" | head -n1)
                    if [ -n "$EXTRACTED_DIR" ]; then
                        mv "$EXTRACTED_DIR"/* .
                        mv "$EXTRACTED_DIR"/.* . 2>/dev/null || true
                        rm -rf "$EXTRACTED_DIR" template.zip
                        echo -e "${GREEN}✓ Template downloaded via curl+unzip${NC}" >&2
                        echo "$TMP_DIR"
                        return 0
                    fi
                fi
            fi
        fi
    fi

    if command_exists wget; then
        # Fallback: Use wget
        mkdir -p "$TMP_DIR"
        DOWNLOAD_URL="https://github.com/${GITHUB_REPO}/archive/refs/heads/${GITHUB_BRANCH}.tar.gz"

        if wget -q "$DOWNLOAD_URL" -O "$TMP_DIR/template.tar.gz" 2>/dev/null; then
            cd "$TMP_DIR"
            if tar -xzf template.tar.gz 2>/dev/null; then
                EXTRACTED_DIR=$(find . -maxdepth 1 -type d -name "claude-code-template-*" | head -n1)
                if [ -n "$EXTRACTED_DIR" ]; then
                    mv "$EXTRACTED_DIR"/* .
                    mv "$EXTRACTED_DIR"/.* . 2>/dev/null || true
                    rm -rf "$EXTRACTED_DIR" template.tar.gz
                    echo -e "${GREEN}✓ Template downloaded via wget+tar${NC}" >&2
                    echo "$TMP_DIR"
                    return 0
                fi
            fi
        fi
    fi

    return 1
}

# Try local fallback
try_local_fallback() {
    echo -e "${YELLOW}Trying local fallback...${NC}" >&2

    # Check common locations
    LOCAL_PATHS=(
        "$HOME/claude-code-template"
        "$HOME/.claude-code-template"
        "$HOME/.config/claude-code-template"
        "/usr/local/share/claude-code-template"
    )

    for path in "${LOCAL_PATHS[@]}"; do
        if [ -d "$path/.claude" ]; then
            echo -e "${GREEN}✓ Found local template at: $path${NC}" >&2
            echo "$path"
            return 0
        fi
    done

    return 1
}

# Main execution
main() {
    echo -e "${BLUE}╔══════════════════════════════════════════════════╗${NC}" >&2
    echo -e "${BLUE}║   Claude Code Template Installer                ║${NC}" >&2
    echo -e "${BLUE}╚══════════════════════════════════════════════════╝${NC}" >&2
    echo "" >&2

    # Try GitHub download first
    if download_from_github; then
        return 0
    fi

    echo -e "${YELLOW}⚠ GitHub download failed${NC}" >&2
    echo "" >&2

    # Try local fallback
    if try_local_fallback; then
        return 0
    fi

    # All methods failed
    echo -e "${RED}✗ Could not download or find template${NC}" >&2
    echo "" >&2
    echo -e "${YELLOW}Options:${NC}" >&2
    echo "" >&2
    echo -e "1. ${BLUE}Install template locally:${NC}" >&2
    echo -e "   git clone https://github.com/${GITHUB_REPO}.git ~/claude-code-template" >&2
    echo "" >&2
    echo -e "2. ${BLUE}Set custom repository:${NC}" >&2
    echo -e "   export CLAUDE_TEMPLATE_REPO=your-org/your-repo" >&2
    echo -e "   /bootstrap" >&2
    echo "" >&2
    echo -e "3. ${BLUE}Manual installation:${NC}" >&2
    echo -e "   See: https://github.com/${GITHUB_REPO}#manual-installation" >&2
    echo "" >&2

    return 1
}

# Run main
main
exit_code=$?

# Output path on success (already done by download_from_github or try_local_fallback)
# Error messages go to stderr, path goes to stdout

exit $exit_code
