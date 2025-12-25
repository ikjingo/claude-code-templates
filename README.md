# Claude Code Templates

Reusable Claude Code configuration templates with modular skills, agents, commands, and hooks.

## Features

- **Modular Architecture**: Core templates + optional plugins
- **Auto-activation**: Skills automatically activate based on context
- **11 Agents**: Specialized sub-agents for various tasks
- **8 Commands**: Ready-to-use slash commands
- **5+ Skills**: Domain-specific knowledge bases
- **Hook System**: Automated workflows

## Quick Start

### Basic Installation

```bash
# Clone the repository
git clone https://github.com/ikjingo/claude-code-templates.git

# Copy core templates to your project
cp -r claude-code-templates/core/.claude your-project/
cd your-project/.claude/hooks && npm install
```

### With Plugins

```bash
# Copy core + specific plugins
cp -r claude-code-templates/core/.claude your-project/
cp -r claude-code-templates/plugins/kotlin-spring/.claude/skills/* your-project/.claude/skills/
```

## Structure

```
claude-code-templates/
├── core/                   # Essential templates (required)
│   └── .claude/
│       ├── settings.json   # Base configuration
│       ├── agents/         # 11 specialized agents
│       ├── commands/       # 8 slash commands
│       ├── skills/         # Core skills
│       └── hooks/          # Automation hooks
│
├── plugins/                # Optional extensions
│   ├── kotlin-spring/      # Kotlin + Spring Boot
│   ├── react-typescript/   # React + TypeScript
│   ├── git-workflow/       # Git operations
│   └── documentation/      # Documentation tools
│
├── examples/               # Usage examples
├── scripts/                # Installation scripts
└── docs/                   # Documentation
```

## Available Components

### Agents

| Agent | Description |
|-------|-------------|
| code-reviewer | Code quality, security review |
| architect-reviewer | Architecture consistency |
| test-engineer | Test strategy and automation |
| frontend-developer | React components, responsive design |
| backend-architect | API design, microservices |
| database-architect | Data modeling, scaling |
| ui-ux-designer | User research, design systems |
| context-manager | Multi-agent workflow coordination |
| task-decomposition-expert | Complex goal breakdown |
| prompt-engineer | LLM prompt optimization |
| test-automator | Test suite generation |

### Commands

| Command | Description |
|---------|-------------|
| /dev-docs | Generate development documentation |
| /dev-docs-update | Update existing documentation |
| /code-review | Perform code review |
| /generate-tests | Generate test code |
| /refactor-code | Refactor and improve code |
| /build-and-fix | Build and fix errors |
| /ultra-think | Deep analysis mode |
| /create-architecture-documentation | Generate architecture docs |

### Core Skills

| Skill | Description |
|-------|-------------|
| artifacts-builder | HTML artifact generation with React/Tailwind |
| docx | Word document processing |
| git-commit-helper | Commit message generation |
| skill-creator | Guide for creating new skills |
| webapp-testing | Playwright-based testing |

### Plugins

| Plugin | Skills Included |
|--------|-----------------|
| kotlin-spring | backend-dev-guidelines, backend-test-generator |
| react-typescript | frontend-dev-guidelines |
| git-workflow | pr-workflow, commit-helper |
| documentation | docs-sync |

## Customization

### Adding Custom Skills

1. Create skill directory in `.claude/skills/your-skill/`
2. Add `SKILL.md` with frontmatter
3. Register in `skill-rules.json`

See [Creating Skills](docs/creating-skills.md) for details.

### Adding Custom Agents

1. Create agent file in `.claude/agents/your-agent.md`
2. Add YAML frontmatter with name, description, tools
3. Write agent instructions

See [Creating Agents](docs/creating-agents.md) for details.

## Requirements

- Claude Code CLI
- Node.js 18+ (for hooks)

## License

MIT License - see [LICENSE](LICENSE)

## Contributing

Contributions welcome! Please read our contributing guidelines first.
