# Fullstack Kotlin + React Example

This example shows a complete Claude Code configuration for a fullstack project with:
- **Backend**: Kotlin + Spring Boot
- **Frontend**: React + TypeScript

## Installation

```bash
# From the claude-code-templates root
./scripts/install.sh ./examples/fullstack-kotlin-react --plugins kotlin-spring,react-typescript,git-workflow
```

## Project Structure

```
fullstack-kotlin-react/
├── .claude/
│   ├── settings.json      # Customized permissions
│   ├── agents/            # All 11 agents
│   ├── commands/          # All 8 commands
│   ├── hooks/             # Build check hooks
│   └── skills/
│       ├── skill-rules.json              # Combined rules
│       ├── artifacts-builder/            # Core
│       ├── docx/                         # Core
│       ├── git-commit-helper/            # Core
│       ├── skill-creator/                # Core
│       ├── webapp-testing/               # Core
│       ├── backend-dev-guidelines/       # kotlin-spring plugin
│       ├── backend-test-generator/       # kotlin-spring plugin
│       ├── frontend-dev-guidelines/      # react-typescript plugin
│       └── pr-workflow/                  # git-workflow plugin
├── backend/               # Kotlin Spring Boot
└── frontend/              # React TypeScript
```

## Key Configuration

### settings.json

```json
{
  "permissions": {
    "allow": [
      "Bash(git add:*)",
      "Bash(git commit:*)",
      "Bash(./gradlew:*)",
      "Bash(npm run:*)",
      "Bash(docker compose:*)"
    ]
  }
}
```

### skill-rules.json

Includes rules for:
- Core skills (git-commit-helper, webapp-testing, etc.)
- Kotlin/Spring skills (backend-dev-guidelines, backend-test-generator)
- React/TypeScript skills (frontend-dev-guidelines)
- Git workflow skills (pr-workflow)

## Usage Examples

### Backend Development

```
User: "Create a new API endpoint for users"
→ backend-dev-guidelines skill activates
→ Claude follows Kotlin/Spring patterns
```

### Frontend Development

```
User: "Add a new page for user profile"
→ frontend-dev-guidelines skill activates
→ Claude follows React/TypeScript patterns
```

### Testing

```
User: "Write tests for the UserService"
→ backend-test-generator skill activates
→ Claude generates JUnit5/MockK tests
```

### PR Workflow

```
User: "Create a PR for my changes"
→ pr-workflow skill activates
→ Claude commits, creates PR, requests review
```
