# Git Workflow Plugin

Claude Code skills for Git workflow automation.

## Installation

Copy the contents of `.claude/skills/` to your project's `.claude/skills/` directory:

```bash
cp -r plugins/git-workflow/.claude/skills/* /path/to/your/project/.claude/skills/
```

Then add the skill rules to your `skill-rules.json`.

## Included Skills

### pr-workflow

Complete PR workflow automation:
- Commit message generation
- PR creation with proper formatting
- Code review request handling
- Branch merge automation

**Triggers:**
- Keywords: "create pr", "pull request", "merge", "code review"

## Skill Rules

Add these rules to your `.claude/skills/skill-rules.json`:

```json
{
    "pr-workflow": {
        "type": "domain",
        "enforcement": "suggest",
        "priority": "high",
        "description": "Commit, PR creation, code review, and merge automation",
        "promptTriggers": {
            "keywords": ["create pr", "pull request", "merge", "code review"],
            "intentPatterns": ["pr.*(create|make)", "(commit).*(and).*(pr|merge)"]
        }
    }
}
```

## Requirements

- Git
- GitHub CLI (`gh`) for PR operations
