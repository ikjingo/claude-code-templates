# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-12-25

### Added

#### Core Templates
- 11 specialized sub-agents for various development tasks
  - code-reviewer, architect-reviewer, test-engineer, test-automator
  - frontend-developer, backend-architect, database-architect
  - ui-ux-designer, context-manager, task-decomposition-expert, prompt-engineer
- 8 slash commands
  - /dev-docs, /dev-docs-update, /code-review, /refactor-code
  - /build-and-fix, /generate-tests, /ultra-think, /create-architecture-documentation
- 5 core skills
  - artifacts-builder: HTML artifact generation with React/Tailwind/shadcn
  - docx: Word document creation and editing
  - git-commit-helper: Git diff based commit message generation
  - skill-creator: Guide for creating new skills
  - webapp-testing: Playwright-based testing and screenshots
- Hooks system
  - skill-activation: Auto-activate skills based on prompts
  - build-check: Verify code changes after Claude responses
  - post-tool-use-tracker: Track file modifications

#### Plugins
- kotlin-spring: Kotlin + Spring Boot development
  - backend-dev-guidelines
  - backend-test-generator
- react-typescript: React + TypeScript development
  - frontend-dev-guidelines
- git-workflow: Git workflow automation
  - pr-workflow

#### Installation
- install.sh: Interactive installation script with plugin support

#### Documentation
- getting-started.md: Quick start guide
- customization.md: Customization guide
- creating-skills.md: Skill creation guide
- creating-agents.md: Agent creation guide

#### Examples
- fullstack-kotlin-react: Fullstack project example
- simple-node-project: Minimal Node.js example

### Notes

This is the initial public release. The templates are extracted and generalized from a production project (zenless) and have been tested in real development workflows.
