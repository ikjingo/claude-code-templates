# Skills

Context-aware, production-tested skills that auto-activate when needed.

---

## What are Skills?

Skills are modular knowledge bases that Claude loads when needed. They provide:
- Domain-specific guidelines
- Best practices
- Code examples
- Anti-patterns to avoid

**Problem:** By default, skills don't auto-activate.

**Solution:** This project includes hooks + skill-rules.json configuration for auto-activation.

---

## Available Core Skills (5)

### Workflow Skills

| Skill | Description | Priority |
|-------|-------------|----------|
| **git-commit-helper** | Git diff analysis based commit message generation | MEDIUM |

### Tool Skills

| Skill | Description | Priority |
|-------|-------------|----------|
| **webapp-testing** | Playwright-based webapp testing and screenshots | HIGH |
| **artifacts-builder** | React/Tailwind/shadcn HTML artifact generation | MEDIUM |
| **docx** | Word document (.docx) creation and editing | MEDIUM |
| **skill-creator** | Guide for creating new Claude Code skills | LOW |

---

## How Auto-Activation Works

### skill-rules.json

Skill activation rules are defined in `.claude/skills/skill-rules.json`:

```json
{
    "skills": {
        "webapp-testing": {
            "type": "domain",
            "enforcement": "suggest",
            "priority": "high",
            "promptTriggers": {
                "keywords": ["playwright", "screenshot", "e2e test"],
                "intentPatterns": ["(browser|screen|page).*(test|check|capture)"]
            }
        }
    }
}
```

### Trigger Types

**promptTriggers** - Based on user prompt
- `keywords`: Exact keyword matching
- `intentPatterns`: Regex intent pattern matching

**fileTriggers** - Based on file context
- `pathPatterns`: File path patterns
- `pathExclusions`: Paths to exclude
- `contentPatterns`: File content patterns

### Configuration Options

| Option | Values | Description |
|--------|--------|-------------|
| type | `domain` / `guardrail` | Domain knowledge vs guardrail |
| enforcement | `suggest` / `block` / `warn` | Suggest / Block / Warn |
| priority | `critical` / `high` / `medium` / `low` | Priority level |

---

## Skill Usage Examples

### Prompt Activation

```
User: "Take a screenshot of the page"
→ webapp-testing skill suggested

User: "Create a word document"
→ docx skill suggested
```

### Manual Activation

You can also invoke skills directly:

```
User: "Use the artifacts-builder skill to create a preview"
```

---

## Skill Structure

Each skill follows this structure:

```
skill-name/
├── SKILL.md                # Main skill file (<500 lines)
└── resources/              # (Optional) Additional resources
    ├── topic-1.md
    └── topic-2.md
```

### The 500-Line Rule

Large skills hit context limits. Solution:
- Keep main SKILL.md under 500 lines (overview + navigation)
- Each resource file under 500 lines (detailed content)
- Claude loads progressively as needed

---

## Adding New Skills

### 1. Create Skill Directory

```bash
mkdir -p .claude/skills/my-skill
```

### 2. Write SKILL.md

```markdown
---
name: my-skill
description: What this skill does
---

# My Skill

## Purpose
[Skill purpose]

## When to Use
[Auto-activation scenarios]

## Quick Reference
[Key patterns and examples]
```

### 3. Add Rules to skill-rules.json

```json
{
    "my-skill": {
        "type": "domain",
        "enforcement": "suggest",
        "priority": "medium",
        "promptTriggers": {
            "keywords": ["keyword1", "keyword2"]
        }
    }
}
```

---

## Extending with Plugins

This is the **core** template. Additional skills are available as plugins:

| Plugin | Skills Included |
|--------|-----------------|
| **kotlin-spring** | backend-dev-guidelines, backend-test-generator |
| **react-typescript** | frontend-dev-guidelines |
| **git-workflow** | pr-workflow, commit-helper |
| **documentation** | docs-sync |

Install plugins using the installation script or copy manually from the `plugins/` directory.

---

## Troubleshooting

### Skill Not Activating

**Check:**
1. Skill directory exists in `.claude/skills/`
2. Skill is registered in `skill-rules.json`
3. Keywords/patterns match your prompt
4. Hooks are installed and executable

**Debug:**
```bash
# Check skill exists
ls -la .claude/skills/

# Validate skill-rules.json
cat .claude/skills/skill-rules.json | jq .

# Check hooks are executable
ls -la .claude/hooks/*.sh
```

### Skill Activating Too Often

Update `skill-rules.json`:
- Make keywords more specific
- Narrow `pathPatterns` scope
- Refine `intentPatterns`

---

## Next Steps

1. **Choose skills for your task** - See list above
2. **Test activation** - Prompt with relevant keywords
3. **Customize if needed** - Edit skill-rules.json
