# Simple Node.js Example

This example shows a minimal Claude Code configuration for a Node.js/TypeScript project.

## Installation

```bash
# From the claude-code-templates root
./scripts/install.sh ./examples/simple-node-project
```

## Project Structure

```
simple-node-project/
├── .claude/
│   ├── settings.json      # Basic permissions
│   ├── agents/            # All 11 agents
│   ├── commands/          # All 8 commands
│   ├── hooks/             # Build check hooks
│   └── skills/
│       ├── skill-rules.json
│       ├── artifacts-builder/
│       ├── docx/
│       ├── git-commit-helper/
│       ├── skill-creator/
│       └── webapp-testing/
├── src/                   # Source code
├── package.json
└── tsconfig.json
```

## Key Configuration

### settings.json

```json
{
  "permissions": {
    "allow": [
      "Bash(git add:*)",
      "Bash(git commit:*)",
      "Bash(npm run:*)",
      "Bash(npx:*)"
    ]
  }
}
```

## Usage Examples

### Development

```
User: "Help me create a new utility function"
→ Claude creates and tests the function
```

### Commits

```
User: "Commit my changes"
→ git-commit-helper skill activates
→ Claude generates appropriate commit message
```

### Screenshots

```
User: "Take a screenshot of localhost:3000"
→ webapp-testing skill activates
→ Claude captures the page
```
