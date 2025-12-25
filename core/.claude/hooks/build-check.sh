#!/bin/bash
# build-check.sh - Stop Hook: Build check execution
#
# Generic build check hook for Claude Code projects.
# Runs after Claude completes a response to verify changed code.
#
# Supported project types:
# - backend/ (Gradle Kotlin) → ./gradlew compileKotlin
# - frontend/ (TypeScript/Vite) → npx tsc --noEmit
#
# Workflow:
# 1. Check cached change info from post-tool-use-tracker.sh
# 2. Fallback to git diff if no cache (*.kt, *.ts, *.tsx only)
# 3. Run Kotlin compile check if backend/ changed
# 4. Run Prettier formatting + TypeScript check if frontend/ changed
# 5. Notify Claude of any errors
# 6. Clean up cache on completion

set -e

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
cd "$PROJECT_DIR"

# Check cache directory (created by post-tool-use-tracker.sh)
CACHE_BASE="$PROJECT_DIR/.claude/build-cache"
BACKEND_CHANGED=false
FRONTEND_CHANGED=false

# Check affected modules from cache
if [ -d "$CACHE_BASE" ]; then
    for session_dir in "$CACHE_BASE"/*/; do
        if [ -f "${session_dir}affected-modules.txt" ]; then
            while IFS= read -r module; do
                case "$module" in
                    backend) BACKEND_CHANGED=true ;;
                    frontend) FRONTEND_CHANGED=true ;;
                esac
            done < "${session_dir}affected-modules.txt"
        fi
    done
fi

# Fallback to git diff if cache is empty
if [ "$BACKEND_CHANGED" = false ] && [ "$FRONTEND_CHANGED" = false ]; then
    CHANGED_FILES=$(git diff --name-only HEAD 2>/dev/null || git diff --name-only 2>/dev/null || echo "")

    if [ -z "$CHANGED_FILES" ]; then
        # Clean cache and exit
        rm -rf "$CACHE_BASE" 2>/dev/null || true
        exit 0
    fi

    while IFS= read -r file; do
        # backend/*.kt files for compilation
        if [[ "$file" == backend/*.kt ]] || [[ "$file" == backend/**/*.kt ]]; then
            BACKEND_CHANGED=true
        # frontend/*.ts, *.tsx files for type checking
        elif [[ "$file" == frontend/*.ts ]] || [[ "$file" == frontend/**/*.ts ]] || \
             [[ "$file" == frontend/*.tsx ]] || [[ "$file" == frontend/**/*.tsx ]]; then
            FRONTEND_CHANGED=true
        fi
    done <<< "$CHANGED_FILES"
fi

ERRORS=""

# Frontend Prettier formatting (run before build)
if [ "$FRONTEND_CHANGED" = true ]; then
    if [ -f "$PROJECT_DIR/frontend/package.json" ]; then
        # Run Prettier if installed
        if [ -f "$PROJECT_DIR/frontend/node_modules/.bin/prettier" ]; then
            echo "Formatting with Prettier..."
            cd "$PROJECT_DIR/frontend"
            npx prettier --write "src/**/*.{ts,tsx}" --log-level error 2>/dev/null || true
            cd "$PROJECT_DIR"
        fi
    fi
fi

# Backend build check (Kotlin/Gradle)
if [ "$BACKEND_CHANGED" = true ]; then
    if [ -f "$PROJECT_DIR/backend/gradlew" ]; then
        echo "Running backend compile check..."

        cd "$PROJECT_DIR/backend"
        BUILD_OUTPUT=$(./gradlew compileKotlin --quiet 2>&1) || {
            ERROR_COUNT=$(echo "$BUILD_OUTPUT" | grep -c "error:" || echo "0")
            if [ "$ERROR_COUNT" -gt 0 ]; then
                ERRORS="${ERRORS}\n\nBackend compilation errors (${ERROR_COUNT}):\n"
                # Show first 5 errors only
                ERRORS="${ERRORS}$(echo "$BUILD_OUTPUT" | grep -A 2 "error:" | head -20)"
            fi
        }
        cd "$PROJECT_DIR"
    fi
fi

# Frontend build check (TypeScript)
if [ "$FRONTEND_CHANGED" = true ]; then
    if [ -f "$PROJECT_DIR/frontend/package.json" ]; then
        echo "Running frontend type check..."

        cd "$PROJECT_DIR/frontend"

        # TypeScript type check only (faster than full build)
        TSC_OUTPUT=$(npx tsc --noEmit 2>&1) || {
            ERROR_COUNT=$(echo "$TSC_OUTPUT" | grep -c "error TS" || echo "0")
            if [ "$ERROR_COUNT" -gt 0 ]; then
                ERRORS="${ERRORS}\n\nFrontend type errors (${ERROR_COUNT}):\n"
                # Show first 5 errors only
                ERRORS="${ERRORS}$(echo "$TSC_OUTPUT" | grep "error TS" | head -5)"
            fi
        }
        cd "$PROJECT_DIR"
    fi
fi

# Output results
if [ -n "$ERRORS" ]; then
    echo ""
    echo "================================================================"
    echo "Build Check Result: Errors Found"
    echo "================================================================"
    echo -e "$ERRORS"
    echo ""
    echo "Please fix the errors above."
    echo "================================================================"
else
    if [ "$BACKEND_CHANGED" = true ] || [ "$FRONTEND_CHANGED" = true ]; then
        echo "Build check passed"
    fi
fi

# Clean cache: delete current session cache
rm -rf "$CACHE_BASE" 2>/dev/null || true

exit 0
