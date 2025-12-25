# Getting Started

This guide will help you install and configure Claude Code Templates for your project.

## Prerequisites

- [Claude Code CLI](https://docs.anthropic.com/en/docs/claude-code) installed
- Node.js 18+ (for hooks)
- Git

## Quick Installation

### 1. Clone the Repository

```bash
git clone https://github.com/ikjingo/claude-code-templates.git
cd claude-code-templates
```

### 2. Install to Your Project

```bash
# Basic installation (core only)
./scripts/install.sh /path/to/your/project

# With plugins
./scripts/install.sh /path/to/your/project --plugins kotlin-spring,react-typescript
```

### 3. Verify Installation

```bash
ls /path/to/your/project/.claude/
# Should show: agents/ commands/ hooks/ skills/ settings.json
```

## Manual Installation

If you prefer manual installation:

### Core Components

```bash
# Copy core .claude directory
cp -r core/.claude /path/to/your/project/

# Install hook dependencies
cd /path/to/your/project/.claude/hooks
npm install
```

### Plugins (Optional)

```bash
# Kotlin + Spring Boot
cp -r plugins/kotlin-spring/.claude/skills/* /path/to/your/project/.claude/skills/

# React + TypeScript
cp -r plugins/react-typescript/.claude/skills/* /path/to/your/project/.claude/skills/

# Git Workflow
cp -r plugins/git-workflow/.claude/skills/* /path/to/your/project/.claude/skills/
```

## Post-Installation Setup

### 1. Create CLAUDE.md

Create a `CLAUDE.md` file in your project root with project-specific instructions:

```markdown
# CLAUDE.md

## Project Overview
[Describe your project]

## Tech Stack
[List your technologies]

## Development Commands
[Add common commands]

## Conventions
[Document your conventions]
```

### 2. Configure Permissions

Edit `.claude/settings.json` to add project-specific permissions:

```json
{
  "permissions": {
    "allow": [
      "Bash(git add:*)",
      "Bash(git commit:*)",
      "Bash(npm run build:*)",
      "Bash(./gradlew:*)"
    ]
  }
}
```

### 3. Add Plugin Skill Rules

If you installed plugins, add their rules to `.claude/skills/skill-rules.json`.

See each plugin's README for the specific rules to add.

## Verification

Start Claude Code in your project:

```bash
cd /path/to/your/project
claude
```

Try these prompts to verify:
- "What agents are available?"
- "Take a screenshot of the current page" (tests webapp-testing skill)
- "Create a commit message" (tests git-commit-helper skill)

## Next Steps

- [Customization Guide](./customization.md) - Customize for your project
- [Creating Skills](./creating-skills.md) - Add your own skills
- [Creating Agents](./creating-agents.md) - Add specialized agents
