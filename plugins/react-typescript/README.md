# React + TypeScript Plugin

Claude Code skills for React and TypeScript frontend development.

## Installation

Copy the contents of `.claude/skills/` to your project's `.claude/skills/` directory:

```bash
cp -r plugins/react-typescript/.claude/skills/* /path/to/your/project/.claude/skills/
```

Then add the skill rules to your `skill-rules.json`.

## Included Skills

### frontend-dev-guidelines

Development guidelines for React + TypeScript projects:
- Component patterns (functional components, hooks)
- State management (Zustand, TanStack Query)
- Form handling (React Hook Form + Zod)
- Styling (Tailwind CSS, shadcn/ui)
- Directory structure and naming conventions
- Performance optimization patterns

**Triggers:**
- Keywords: "frontend development", "react implementation", "component", "page"
- File patterns: `frontend/src/**/*.tsx`, `frontend/src/**/*.ts`

## Skill Rules

Add these rules to your `.claude/skills/skill-rules.json`:

```json
{
    "frontend-dev-guidelines": {
        "type": "guardrail",
        "enforcement": "suggest",
        "priority": "high",
        "description": "React/TypeScript/Tailwind frontend guidelines",
        "promptTriggers": {
            "keywords": ["frontend development", "react implementation", "component", "page", "ui implementation"],
            "intentPatterns": ["(frontend|react).*(develop|implement|create)", "(component|page).*(create|add)"]
        },
        "fileTriggers": {
            "pathPatterns": ["frontend/src/**/*.tsx", "frontend/src/**/*.ts"],
            "pathExclusions": ["**/*.test.tsx", "**/*.test.ts", "**/vite.config.ts"]
        }
    }
}
```

## Requirements

- React 18+
- TypeScript 5+
- Vite (recommended)
- Tailwind CSS
- shadcn/ui (optional but recommended)
- Zustand (for state management)
- TanStack Query (for server state)
- React Hook Form + Zod (for forms)
