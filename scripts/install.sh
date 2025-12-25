#!/bin/bash
# install.sh - Claude Code Templates Installer
#
# Usage:
#   ./scripts/install.sh /path/to/project [--plugins plugin1,plugin2]
#
# Examples:
#   ./scripts/install.sh ~/my-project
#   ./scripts/install.sh ~/my-project --plugins kotlin-spring,react-typescript

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$(dirname "$SCRIPT_DIR")"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_info() {
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

show_help() {
    echo "Claude Code Templates Installer"
    echo ""
    echo "Usage:"
    echo "  ./scripts/install.sh <target-project-path> [options]"
    echo ""
    echo "Options:"
    echo "  --plugins <list>    Comma-separated list of plugins to install"
    echo "                      Available: kotlin-spring, react-typescript, git-workflow"
    echo "  --force             Overwrite existing files without prompting"
    echo "  --help              Show this help message"
    echo ""
    echo "Examples:"
    echo "  ./scripts/install.sh ~/my-project"
    echo "  ./scripts/install.sh ~/my-project --plugins kotlin-spring"
    echo "  ./scripts/install.sh ~/my-project --plugins kotlin-spring,react-typescript --force"
}

# Parse arguments
TARGET_DIR=""
PLUGINS=""
FORCE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --plugins)
            PLUGINS="$2"
            shift 2
            ;;
        --force)
            FORCE=true
            shift
            ;;
        --help)
            show_help
            exit 0
            ;;
        -*)
            print_error "Unknown option: $1"
            show_help
            exit 1
            ;;
        *)
            if [ -z "$TARGET_DIR" ]; then
                TARGET_DIR="$1"
            else
                print_error "Unexpected argument: $1"
                show_help
                exit 1
            fi
            shift
            ;;
    esac
done

# Validate target directory
if [ -z "$TARGET_DIR" ]; then
    print_error "Target project path is required"
    show_help
    exit 1
fi

if [ ! -d "$TARGET_DIR" ]; then
    print_error "Target directory does not exist: $TARGET_DIR"
    exit 1
fi

TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"

print_info "Installing Claude Code Templates to: $TARGET_DIR"

# Create .claude directory if it doesn't exist
CLAUDE_DIR="$TARGET_DIR/.claude"
if [ ! -d "$CLAUDE_DIR" ]; then
    mkdir -p "$CLAUDE_DIR"
    print_info "Created .claude directory"
fi

# Backup existing files if not forcing
backup_if_exists() {
    local file=$1
    if [ -e "$file" ] && [ "$FORCE" = false ]; then
        local backup="${file}.backup.$(date +%Y%m%d%H%M%S)"
        cp -r "$file" "$backup"
        print_warning "Backed up existing: $file -> $backup"
    fi
}

# Copy core templates
print_info "Installing core templates..."

# Copy settings.json
if [ -f "$CLAUDE_DIR/settings.json" ] && [ "$FORCE" = false ]; then
    print_warning "settings.json already exists, skipping (use --force to overwrite)"
else
    cp "$TEMPLATE_DIR/core/.claude/settings.json" "$CLAUDE_DIR/"
    print_success "Installed settings.json"
fi

# Copy agents
backup_if_exists "$CLAUDE_DIR/agents"
cp -r "$TEMPLATE_DIR/core/.claude/agents" "$CLAUDE_DIR/"
print_success "Installed agents (11 files)"

# Copy commands
backup_if_exists "$CLAUDE_DIR/commands"
cp -r "$TEMPLATE_DIR/core/.claude/commands" "$CLAUDE_DIR/"
print_success "Installed commands (8 files)"

# Copy hooks
backup_if_exists "$CLAUDE_DIR/hooks"
cp -r "$TEMPLATE_DIR/core/.claude/hooks" "$CLAUDE_DIR/"
chmod +x "$CLAUDE_DIR/hooks/"*.sh 2>/dev/null || true
print_success "Installed hooks"

# Copy skills
if [ ! -d "$CLAUDE_DIR/skills" ]; then
    mkdir -p "$CLAUDE_DIR/skills"
fi
cp -r "$TEMPLATE_DIR/core/.claude/skills/"* "$CLAUDE_DIR/skills/"
print_success "Installed core skills (5 skills)"

# Install hooks dependencies
print_info "Installing hooks dependencies..."
if [ -f "$CLAUDE_DIR/hooks/package.json" ]; then
    cd "$CLAUDE_DIR/hooks"
    npm install --silent 2>/dev/null || print_warning "npm install failed, you may need to run it manually"
    cd - > /dev/null
    print_success "Installed hooks dependencies"
fi

# Install plugins if specified
if [ -n "$PLUGINS" ]; then
    print_info "Installing plugins..."
    IFS=',' read -ra PLUGIN_ARRAY <<< "$PLUGINS"
    for plugin in "${PLUGIN_ARRAY[@]}"; do
        plugin=$(echo "$plugin" | xargs) # Trim whitespace
        PLUGIN_DIR="$TEMPLATE_DIR/plugins/$plugin"

        if [ -d "$PLUGIN_DIR" ]; then
            # Copy plugin skills
            if [ -d "$PLUGIN_DIR/.claude/skills" ]; then
                cp -r "$PLUGIN_DIR/.claude/skills/"* "$CLAUDE_DIR/skills/"
                print_success "Installed plugin: $plugin"
            else
                print_warning "Plugin $plugin has no skills to install"
            fi
        else
            print_error "Plugin not found: $plugin"
            echo "  Available plugins: kotlin-spring, react-typescript, git-workflow"
        fi
    done

    print_info ""
    print_warning "Remember to add plugin skill rules to your skill-rules.json"
    print_info "See plugin README.md files for the skill rules to add"
fi

echo ""
print_success "Installation complete!"
echo ""
print_info "Next steps:"
echo "  1. Review and customize settings.json"
echo "  2. Add skill rules for installed plugins to skill-rules.json"
echo "  3. Create your CLAUDE.md file with project-specific instructions"
echo ""
print_info "Repository: https://github.com/ikjingo/claude-code-templates"
