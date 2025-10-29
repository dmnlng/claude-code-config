#!/bin/bash
# Token Usage Analyzer for Claude Code
# Identifies files and directories that consume excessive tokens

set -euo pipefail

# Colors for output
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Claude Code Token Usage Analyzer${NC}"
echo "=================================="
echo ""

# Check if .claude/ignore exists
if [ ! -f ".claude/ignore" ]; then
    echo -e "${RED}Warning: .claude/ignore not found${NC}"
    echo "Creating a basic .claude/ignore file..."
    mkdir -p .claude
    cat > .claude/ignore << 'EOF'
node_modules/
.git/objects/
dist/
build/
__pycache__/
EOF
    echo -e "${GREEN}Created .claude/ignore with basic patterns${NC}"
    echo ""
fi

# Function to estimate tokens (rough: 1 token ≈ 4 characters)
estimate_tokens() {
    local chars=$1
    echo $((chars / 4))
}

# Function to check if path matches ignore patterns
is_ignored() {
    local path=$1
    local ignore_file=".claude/ignore"

    if [ ! -f "$ignore_file" ]; then
        return 1
    fi

    # Read patterns from .claude/ignore (skip comments and empty lines)
    while IFS= read -r pattern; do
        # Skip comments and empty lines
        [[ "$pattern" =~ ^#.*$ ]] && continue
        [[ -z "$pattern" ]] && continue

        # Check if path matches pattern
        if [[ "$path" == *"$pattern"* ]]; then
            return 0
        fi
    done < "$ignore_file"

    return 1
}

echo -e "${YELLOW}Analyzing project structure...${NC}"
echo ""

# Find large files (> 1000 lines)
echo -e "${BLUE}Large Files (> 1000 lines):${NC}"
large_files=()
while IFS= read -r file; do
    if [ -f "$file" ]; then
        lines=$(wc -l < "$file" 2>/dev/null || echo 0)
        if [ "$lines" -gt 1000 ]; then
            chars=$(wc -c < "$file" 2>/dev/null || echo 0)
            tokens=$(estimate_tokens "$chars")

            if is_ignored "$file"; then
                status="${GREEN}[IGNORED]${NC}"
            else
                status="${RED}[EXPOSED]${NC}"
                large_files+=("$file:$tokens")
            fi

            printf "  %-60s %8d lines %10d tokens %b\n" "$file" "$lines" "$tokens" "$status"
        fi
    fi
done < <(find . -type f \( -name "*.js" -o -name "*.ts" -o -name "*.py" -o -name "*.rs" -o -name "*.go" -o -name "*.java" \) 2>/dev/null | head -100)

echo ""

# Find large directories
echo -e "${BLUE}Large Directories:${NC}"
declare -A dir_sizes
exposed_dirs=()

while IFS= read -r dir; do
    if [ -d "$dir" ]; then
        size=$(du -sh "$dir" 2>/dev/null | cut -f1)
        file_count=$(find "$dir" -type f 2>/dev/null | wc -l)

        # Estimate total characters in directory
        total_chars=$(find "$dir" -type f -exec wc -c {} + 2>/dev/null | tail -1 | awk '{print $1}')
        tokens=$(estimate_tokens "${total_chars:-0}")

        if is_ignored "$dir"; then
            status="${GREEN}[IGNORED]${NC}"
        else
            status="${RED}[EXPOSED]${NC}"
            exposed_dirs+=("$dir:$tokens")
        fi

        printf "  %-50s %8s %8d files %10d tokens %b\n" "$dir" "$size" "$file_count" "$tokens" "$status"
    fi
done < <(find . -maxdepth 3 -type d \( -name "node_modules" -o -name "dist" -o -name "build" -o -name ".git" -o -name "vendor" -o -name "target" -o -name "__pycache__" -o -name ".next" -o -name "coverage" \) 2>/dev/null)

echo ""

# Check for common problematic files
echo -e "${BLUE}Checking for common token-heavy patterns...${NC}"
problematic_found=false

# Check for lock files
for lockfile in package-lock.json yarn.lock Cargo.lock Pipfile.lock pnpm-lock.yaml; do
    if [ -f "$lockfile" ]; then
        chars=$(wc -c < "$lockfile" 2>/dev/null || echo 0)
        tokens=$(estimate_tokens "$chars")

        if is_ignored "$lockfile"; then
            status="${GREEN}[IGNORED]${NC}"
        else
            status="${RED}[EXPOSED]${NC}"
            problematic_found=true
        fi

        printf "  %-50s %10d tokens %b\n" "$lockfile" "$tokens" "$status"
    fi
done

# Check for generated files
for pattern in "*.generated.*" "*.gen.*" "*_pb2.py" "*.pb.go"; do
    while IFS= read -r file; do
        if [ -f "$file" ]; then
            chars=$(wc -c < "$file" 2>/dev/null || echo 0)
            tokens=$(estimate_tokens "$chars")

            if is_ignored "$file"; then
                status="${GREEN}[IGNORED]${NC}"
            else
                status="${RED}[EXPOSED]${NC}"
                problematic_found=true
            fi

            printf "  %-50s %10d tokens %b\n" "$file" "$tokens" "$status"
        fi
    done < <(find . -type f -name "$pattern" 2>/dev/null | head -10)
done

echo ""

# Generate recommendations
echo -e "${YELLOW}Recommendations:${NC}"
echo ""

if [ ${#exposed_dirs[@]} -gt 0 ] || [ ${#large_files[@]} -gt 0 ] || [ "$problematic_found" = true ]; then
    echo -e "${RED}Found token optimization opportunities!${NC}"
    echo ""

    if [ ${#exposed_dirs[@]} -gt 0 ]; then
        echo "Add these directories to .claude/ignore:"
        for entry in "${exposed_dirs[@]}"; do
            dir=$(echo "$entry" | cut -d: -f1)
            tokens=$(echo "$entry" | cut -d: -f2)
            echo "  $dir/  # Saves ~$tokens tokens"
        done
        echo ""
    fi

    if [ ${#large_files[@]} -gt 0 ]; then
        echo "Consider refactoring or ignoring these large files:"
        for entry in "${large_files[@]}"; do
            file=$(echo "$entry" | cut -d: -f1)
            tokens=$(echo "$entry" | cut -d: -f2)
            echo "  $file  # $tokens tokens"
        done
        echo ""
    fi

    # Calculate potential savings
    total_savings=0
    for entry in "${exposed_dirs[@]}"; do
        tokens=$(echo "$entry" | cut -d: -f2)
        total_savings=$((total_savings + tokens))
    done
    for entry in "${large_files[@]}"; do
        tokens=$(echo "$entry" | cut -d: -f2)
        total_savings=$((total_savings + tokens))
    done

    if [ $total_savings -gt 0 ]; then
        echo -e "${GREEN}Potential token savings: ~$total_savings tokens per session${NC}"
        percentage=$((total_savings * 100 / 100000))
        echo -e "${GREEN}That's approximately $percentage% of a typical 100k context window${NC}"
    fi
else
    echo -e "${GREEN}✓ No major token optimization opportunities found!${NC}"
    echo "Your .claude/ignore configuration looks good."
fi

echo ""
echo -e "${BLUE}Additional Tips:${NC}"
echo "1. Use scoped searches: 'grep pattern src/' instead of 'grep -r pattern .'"
echo "2. Run '/clear' between unrelated tasks to reset context"
echo "3. Use subagents for large exploration tasks"
echo "4. Keep CLAUDE.md files concise (they load on every request)"
echo ""
echo "For more information, see: .claude/workflows/ and README.md"
