# Creating Skills

This guide explains how to create new skills for Claude Code.

## What is a Skill?

A skill is a modular knowledge base that Claude loads when needed. Skills provide:
- Domain-specific guidelines
- Best practices and patterns
- Code examples
- Anti-patterns to avoid

## Skill Structure

```
.claude/skills/my-skill/
├── SKILL.md              # Main skill file (required)
└── resources/            # Optional additional resources
    ├── topic-1.md
    └── topic-2.md
```

## Creating a Basic Skill

### Step 1: Create the Directory

```bash
mkdir -p .claude/skills/my-skill
```

### Step 2: Create SKILL.md

```markdown
---
name: my-skill
description: Brief description shown in skill listings
---

# My Skill

## Purpose

Describe what this skill helps with and when it should be used.

## When to Use

- Scenario 1
- Scenario 2
- Scenario 3

## Quick Reference

### Pattern 1

```language
// Code example
```

### Pattern 2

```language
// Code example
```

## Guidelines

### Do

- ✅ Recommendation 1
- ✅ Recommendation 2

### Don't

- ❌ Anti-pattern 1
- ❌ Anti-pattern 2

## Examples

### Example 1: [Title]

[Detailed example with code]

### Example 2: [Title]

[Detailed example with code]
```

### Step 3: Add to skill-rules.json

```json
{
  "my-skill": {
    "type": "domain",
    "enforcement": "suggest",
    "priority": "medium",
    "description": "Brief description",
    "promptTriggers": {
      "keywords": ["keyword1", "keyword2"],
      "intentPatterns": ["pattern.*(action)"]
    }
  }
}
```

## Advanced: Multi-File Skills

For complex skills, split content into multiple files.

### Main SKILL.md

```markdown
---
name: complex-skill
description: Complex skill with multiple resources
---

# Complex Skill

## Purpose
[Overview]

## Resources

This skill includes detailed resources:
- [Topic 1](resources/topic-1.md) - Detailed topic 1 guide
- [Topic 2](resources/topic-2.md) - Detailed topic 2 guide

## Quick Reference
[Essential information here]
```

### Resources

`resources/topic-1.md`:
```markdown
# Topic 1 Detail

[Detailed content for topic 1]
```

## The 500-Line Rule

Large skills can hit context limits. Best practices:

1. **Main SKILL.md**: Under 500 lines
   - Overview and navigation
   - Quick reference
   - Essential patterns

2. **Resource files**: Each under 500 lines
   - Detailed explanations
   - Extended examples
   - Reference documentation

3. **Progressive loading**: Claude loads resources as needed

## Skill Types

### Domain Skills

Provide knowledge for specific domains:

```json
{
  "type": "domain",
  "enforcement": "suggest"
}
```

Examples: backend-dev-guidelines, frontend-dev-guidelines

### Guardrail Skills

Ensure standards are followed:

```json
{
  "type": "guardrail",
  "enforcement": "suggest"
}
```

Examples: security-guidelines, code-style-rules

## Trigger Configuration

### Prompt Triggers

```json
{
  "promptTriggers": {
    "keywords": [
      "exact match keyword",
      "another keyword"
    ],
    "intentPatterns": [
      "(pattern).*(matches)",
      "regex pattern"
    ]
  }
}
```

### File Triggers

```json
{
  "fileTriggers": {
    "pathPatterns": [
      "src/**/*.ts",
      "lib/**/*.py"
    ],
    "pathExclusions": [
      "**/*.test.ts",
      "**/__tests__/**"
    ]
  }
}
```

## Testing Your Skill

### Manual Testing

```
User: [Use a trigger keyword]
→ Skill should be suggested

User: "Use the my-skill skill to help me"
→ Skill should be loaded
```

### Verification Checklist

- [ ] SKILL.md is under 500 lines
- [ ] Frontmatter is valid (name, description)
- [ ] skill-rules.json entry is valid JSON
- [ ] Keywords trigger the skill
- [ ] Content is accurate and helpful

## Examples

### Example: Database Migration Skill

```markdown
---
name: db-migration
description: Database migration patterns and best practices
---

# Database Migration Skill

## Purpose

Guide database migrations to ensure data integrity and zero-downtime deployments.

## When to Use

- Creating new tables
- Modifying existing schemas
- Data migrations
- Rolling back changes

## Quick Reference

### Safe Migration Pattern

```sql
-- Always use transactions
BEGIN;
  ALTER TABLE users ADD COLUMN email VARCHAR(255);
COMMIT;
```

### Zero-Downtime Rename

```sql
-- Step 1: Add new column
ALTER TABLE users ADD COLUMN user_email VARCHAR(255);

-- Step 2: Copy data (in batches)
UPDATE users SET user_email = email WHERE user_email IS NULL LIMIT 1000;

-- Step 3: Switch reads to new column
-- Step 4: Remove old column
ALTER TABLE users DROP COLUMN email;
```

## Guidelines

### Do

- ✅ Use transactions for all DDL
- ✅ Test migrations on staging first
- ✅ Have rollback scripts ready
- ✅ Migrate data in batches

### Don't

- ❌ Drop columns without migration period
- ❌ Lock tables during peak hours
- ❌ Skip backup before migration
```
