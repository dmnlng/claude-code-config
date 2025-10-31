#!/bin/bash
# Boilerplate Code Generator
# Generates initial project files from templates
# Usage: ./.claude/scripts/generate-boilerplate.sh <project-type> <project-name>

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Arguments
PROJECT_TYPE="${1:-}"
PROJECT_NAME="${2:-}"

# Helper Functions
log_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

log_success() {
    echo -e "${GREEN}✓${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

log_error() {
    echo -e "${RED}✗${NC} $1"
}

generate_secret() {
    openssl rand -base64 32
}

# Validation
if [ -z "$PROJECT_TYPE" ]; then
    echo -e "${RED}Error: Project type required${NC}"
    echo ""
    echo "Usage: $0 <project-type> [project-name]"
    echo ""
    echo "Available project types:"
    echo "  nextjs-prisma    Next.js + PostgreSQL + Prisma + NextAuth"
    echo "  express-prisma   Express + PostgreSQL + Prisma"
    echo "  fastapi-postgres FastAPI + PostgreSQL"
    echo ""
    exit 1
fi

# Set project name from directory if not provided
if [ -z "$PROJECT_NAME" ]; then
    PROJECT_NAME=$(basename "$(pwd)")
    log_info "Using directory name as project name: $PROJECT_NAME"
fi

# Derive project name variants
PROJECT_NAME_SNAKE=$(echo "$PROJECT_NAME" | tr '[:upper:]' '[:lower:]' | tr '-' '_')
PROJECT_NAME_KEBAB=$(echo "$PROJECT_NAME" | tr '[:upper:]' '[:lower:]' | tr '_' '-')
PROJECT_NAME_CAMEL=$(echo "$PROJECT_NAME" | sed -r 's/(^|_)([a-z])/\U\2/g')

# Template directory
TEMPLATE_DIR=".claude/templates/boilerplate/${PROJECT_TYPE}"

if [ ! -d "$TEMPLATE_DIR" ]; then
    log_error "Project type '$PROJECT_TYPE' not found"
    echo ""
    echo "Available types:"
    ls -1 .claude/templates/boilerplate/ 2>/dev/null || echo "  (none - templates not installed)"
    exit 1
fi

# Header
echo -e "${BLUE}╔══════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Code Generation: $PROJECT_TYPE${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${CYAN}Project:${NC} $PROJECT_NAME"
echo -e "${CYAN}Type:${NC} $PROJECT_TYPE"
echo ""

# Check if files already exist
EXISTING_FILES=()
for template in "$TEMPLATE_DIR"/*.template; do
    filename=$(basename "$template" .template)

    # Handle special cases
    case "$filename" in
        "prisma-schema.prisma")
            target="prisma/schema.prisma"
            ;;
        *)
            target="$filename"
            ;;
    esac

    if [ -f "$target" ] || [ -d "$(dirname "$target")" ]; then
        EXISTING_FILES+=("$target")
    fi
done

if [ ${#EXISTING_FILES[@]} -gt 0 ]; then
    log_warning "Some files already exist:"
    for file in "${EXISTING_FILES[@]}"; do
        echo "  - $file"
    done
    echo ""
    read -p "Overwrite existing files? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Cancelled"
        exit 0
    fi
fi

# Generate files
echo -e "${CYAN}Generating files...${NC}"
echo ""

GENERATED_FILES=()

# Generate secret for NextAuth
NEXTAUTH_SECRET=$(generate_secret)

# Process each template
for template in "$TEMPLATE_DIR"/*.template; do
    filename=$(basename "$template" .template)

    # Determine target path
    case "$filename" in
        "prisma-schema.prisma")
            target="prisma/schema.prisma"
            mkdir -p prisma
            ;;
        *)
            target="$filename"
            ;;
    esac

    log_info "Generating $target..."

    # Read template and replace placeholders
    content=$(<"$template")

    # Replace placeholders
    content="${content//\{\{PROJECT_NAME\}\}/$PROJECT_NAME}"
    content="${content//\{\{PROJECT_NAME_SNAKE\}\}/$PROJECT_NAME_SNAKE}"
    content="${content//\{\{PROJECT_NAME_KEBAB\}\}/$PROJECT_NAME_KEBAB}"
    content="${content//\{\{PROJECT_NAME_CAMEL\}\}/$PROJECT_NAME_CAMEL}"
    content="${content//\{\{GENERATE_SECRET\}\}/$NEXTAUTH_SECRET}"

    # Write to target
    echo "$content" > "$target"

    log_success "Created $target"
    GENERATED_FILES+=("$target")
done

echo ""

# Create additional required directories
log_info "Creating project structure..."

DIRS=(
    "app"
    "lib"
    "components"
    "prisma/migrations"
    "__tests__/unit"
    "__tests__/integration"
    "public"
)

for dir in "${DIRS[@]}"; do
    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
        log_success "Created directory: $dir"
    fi
done

echo ""

# Create .gitignore if it doesn't exist
if [ ! -f ".gitignore" ]; then
    log_info "Creating .gitignore..."
    cat > .gitignore <<EOF
# Dependencies
node_modules/
.pnp
.pnp.js

# Testing
coverage/
.nyc_output

# Next.js
.next/
out/
build/

# Production
dist/

# Misc
.DS_Store
*.pem

# Debug
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Local env files
.env*.local
.env
!.env.example

# Vercel
.vercel

# TypeScript
*.tsbuildinfo
next-env.d.ts

# Prisma
prisma/*.db
prisma/*.db-journal

# IDE
.vscode/
.idea/
*.swp
*.swo

# Claude Code
.claude/logs/
EOF
    log_success "Created .gitignore"
fi

# Create initial app page if it doesn't exist
if [ ! -f "app/page.tsx" ] && [ "$PROJECT_TYPE" = "nextjs-prisma" ]; then
    log_info "Creating initial app/page.tsx..."
    mkdir -p app
    cat > app/page.tsx <<'EOF'
export default function Home() {
  return (
    <main className="flex min-h-screen flex-col items-center justify-center p-24">
      <div className="z-10 max-w-5xl w-full items-center justify-center font-mono text-sm">
        <h1 className="text-4xl font-bold mb-4">Welcome</h1>
        <p className="text-lg">
          Your Next.js + Prisma application is ready!
        </p>
      </div>
    </main>
  )
}
EOF
    log_success "Created app/page.tsx"

    # Create layout
    cat > app/layout.tsx <<'EOF'
import type { Metadata } from 'next'
import './globals.css'

export const metadata: Metadata = {
  title: '{{PROJECT_NAME}}',
  description: 'Generated by Claude Code',
}

export default function RootLayout({
  children,
}: {
  children: React.Node
}) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  )
}
EOF
    log_success "Created app/layout.tsx"

    # Create globals.css
    cat > app/globals.css <<'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;
EOF
    log_success "Created app/globals.css"
fi

# Create lib/prisma.ts if it doesn't exist
if [ ! -f "lib/prisma.ts" ] && [ "$PROJECT_TYPE" = "nextjs-prisma" ]; then
    log_info "Creating lib/prisma.ts..."
    mkdir -p lib
    cat > lib/prisma.ts <<'EOF'
import { PrismaClient } from '@prisma/client'

const globalForPrisma = globalThis as unknown as {
  prisma: PrismaClient | undefined
}

export const prisma = globalForPrisma.prisma ?? new PrismaClient()

if (process.env.NODE_ENV !== 'production') globalForPrisma.prisma = prisma
EOF
    log_success "Created lib/prisma.ts"
fi

echo ""

# Summary
echo -e "${CYAN}╔══════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║  Generation Complete!                            ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════╝${NC}"
echo ""

echo -e "${GREEN}✓${NC} Generated ${#GENERATED_FILES[@]} files:"
for file in "${GENERATED_FILES[@]}"; do
    echo "  • $file"
done

echo ""
echo -e "${BLUE}📋 Next Steps:${NC}"
echo ""
echo "1. Install dependencies:"
echo "   ${CYAN}npm install${NC}"
echo ""
echo "2. Copy environment variables:"
echo "   ${CYAN}cp .env.example .env.local${NC}"
echo ""
echo "3. Start Docker services:"
echo "   ${CYAN}docker-compose up -d${NC}"
echo ""
echo "4. Push database schema:"
echo "   ${CYAN}npx prisma db push${NC}"
echo ""
echo "5. Start development server:"
echo "   ${CYAN}npm run dev${NC}"
echo ""
echo -e "${BLUE}💡 Tip:${NC} Run ${CYAN}/feature verify 001-project-setup${NC} to validate setup"
echo ""
