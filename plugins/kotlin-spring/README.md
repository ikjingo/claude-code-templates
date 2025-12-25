# Kotlin + Spring Boot Plugin

Claude Code skills for Kotlin and Spring Boot backend development.

## Installation

Copy the contents of `.claude/skills/` to your project's `.claude/skills/` directory:

```bash
cp -r plugins/kotlin-spring/.claude/skills/* /path/to/your/project/.claude/skills/
```

Then add the skill rules to your `skill-rules.json`.

## Included Skills

### backend-dev-guidelines

Development guidelines for Kotlin + Spring Boot projects:
- Multi-module Gradle structure
- Controller → Service → Repository layer patterns
- DTO design and validation
- Error handling with ErrorCode enum
- API documentation with REST Docs

**Triggers:**
- Keywords: "backend development", "api implementation", "controller", "service"
- File patterns: `backend/**/*.kt` (excluding tests)

### backend-test-generator

Test code generation for JUnit5 + MockK:
- Unit tests for services
- Integration tests for controllers
- Mock setup patterns
- Test fixtures and factories

**Triggers:**
- Keywords: "backend test", "service test", "controller test", "junit", "mockk"
- File patterns: `backend/**/*Test.kt`

## Skill Rules

Add these rules to your `.claude/skills/skill-rules.json`:

```json
{
    "backend-test-generator": {
        "type": "domain",
        "enforcement": "suggest",
        "priority": "high",
        "description": "Kotlin/Spring Boot test code generation",
        "promptTriggers": {
            "keywords": ["backend test", "service test", "controller test", "junit", "mockk"],
            "intentPatterns": ["(test).*(write|create|add)"]
        },
        "fileTriggers": {
            "pathPatterns": ["backend/**/*Test.kt", "backend/**/*Tests.kt"]
        }
    },
    "backend-dev-guidelines": {
        "type": "guardrail",
        "enforcement": "suggest",
        "priority": "high",
        "description": "Kotlin/Spring Boot development guidelines",
        "promptTriggers": {
            "keywords": ["backend development", "api implementation", "controller", "service", "endpoint"],
            "intentPatterns": ["(backend|api).*(develop|implement|create)"]
        },
        "fileTriggers": {
            "pathPatterns": ["backend/**/*.kt"],
            "pathExclusions": ["**/*Test.kt", "**/*Tests.kt"]
        }
    }
}
```

## Requirements

- Kotlin 1.9+
- Spring Boot 3.x
- Gradle (Kotlin DSL)
- JUnit 5
- MockK
