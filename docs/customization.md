# Customization Guide

This guide explains how to customize Claude Code Templates for your specific project needs.

## Directory Structure

After installation, your `.claude/` directory looks like:

```
.claude/
├── settings.json          # Permissions and hooks configuration
├── agents/                # Sub-agents for specialized tasks
├── commands/              # Slash commands
├── skills/                # Domain-specific knowledge
│   ├── skill-rules.json   # Auto-activation rules
│   └── [skill-name]/      # Individual skills
└── hooks/                 # Automation scripts
```

## Customizing settings.json

### Adding Permissions

Add frequently-used commands to auto-approve:

```json
{
  "permissions": {
    "allow": [
      "Bash(git add:*)",
      "Bash(git commit:*)",
      "Bash(npm run:*)",
      "Bash(./gradlew:*)",
      "Bash(docker compose:*)"
    ],
    "deny": []
  }
}
```

### Modifying Hooks

Hooks are configured in the `hooks` section:

```json
{
  "hooks": {
    "UserPromptSubmit": [...],  // Runs before processing user input
    "PostToolUse": [...],       // Runs after tools are used
    "Stop": [...]               // Runs when Claude stops
  }
}
```

To disable a hook, remove or comment out its entry.

## Customizing Skills

### Modifying skill-rules.json

Add or modify auto-activation rules:

```json
{
  "skills": {
    "my-custom-skill": {
      "type": "domain",
      "enforcement": "suggest",
      "priority": "high",
      "promptTriggers": {
        "keywords": ["my keyword", "another keyword"],
        "intentPatterns": ["pattern.*(action)"]
      },
      "fileTriggers": {
        "pathPatterns": ["src/**/*.ts"]
      }
    }
  }
}
```

### Priority Levels

| Priority | When to Use |
|----------|-------------|
| `critical` | Must always trigger |
| `high` | Important, trigger on most matches |
| `medium` | Standard, clear matches only |
| `low` | Optional, explicit matches only |

### Enforcement Types

| Type | Behavior |
|------|----------|
| `suggest` | Suggests the skill, doesn't block |
| `warn` | Shows warning, allows proceeding |
| `block` | Requires skill use before proceeding |

## Customizing Agents

### Modifying Agent Behavior

Edit agent files in `.claude/agents/`:

```markdown
---
name: my-agent
description: What this agent does
tools: Read, Write, Edit, Bash
model: sonnet
---

# My Agent

[Custom instructions here]
```

### Model Selection

| Model | Use Case |
|-------|----------|
| `haiku` | Quick, simple tasks |
| `sonnet` | Most development tasks (default) |
| `opus` | Complex analysis, deep reviews |

## Customizing Hooks

### build-check.sh

Modify to match your project structure:

```bash
# Add your build commands
if [ "$BACKEND_CHANGED" = true ]; then
    cd "$PROJECT_DIR/my-backend"
    ./my-build-command
fi
```

### skill-activation-prompt.ts

Customize skill detection logic:

```typescript
// Add custom detection patterns
const customPatterns = {
  'my-skill': ['keyword1', 'keyword2']
};
```

## Creating Project-Specific Components

### Project-Specific Skill

1. Create directory: `.claude/skills/my-project-skill/`
2. Add `SKILL.md`:

```markdown
---
name: my-project-skill
description: Skills specific to my project
---

# My Project Skill

## Purpose
[Describe purpose]

## Guidelines
[Project-specific guidelines]
```

3. Add to `skill-rules.json`

### Project-Specific Command

1. Create `.claude/commands/my-command.md`:

```markdown
---
name: my-command
description: What this command does
---

# My Command

[Command instructions]
```

## Best Practices

### Keep Core Separate

Don't modify core template files directly. Instead:
- Add new skills in separate directories
- Extend `skill-rules.json` rather than replacing
- Create new agents instead of modifying existing ones

### Version Control

- Commit `.claude/` to your repository
- Exclude `.claude/settings.local.json`
- Document customizations in your CLAUDE.md

### Testing Changes

After customization:
1. Start Claude Code
2. Test affected skills/agents
3. Verify hooks execute correctly
