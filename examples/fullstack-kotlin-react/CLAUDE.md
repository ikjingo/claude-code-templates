# CLAUDE.md

This file provides guidance to Claude Code when working with this project.

## Project Overview

Fullstack web application with:
- **Backend**: Kotlin + Spring Boot 3.x (Java 21)
- **Frontend**: React 18 + TypeScript + Vite
- **Database**: PostgreSQL 16

## Project Structure

```
.
├── backend/                # Kotlin Spring Boot API
│   ├── src/main/kotlin/
│   ├── src/test/kotlin/
│   ├── build.gradle.kts
│   └── gradlew
├── frontend/              # React TypeScript SPA
│   ├── src/
│   ├── package.json
│   └── vite.config.ts
└── docker-compose.yml     # Development environment
```

## Development Commands

### Docker

```bash
docker compose up -d        # Start all services
docker compose down         # Stop all services
```

### Backend

```bash
cd backend
./gradlew bootRun          # Run server (port 8080)
./gradlew test             # Run tests
./gradlew compileKotlin    # Compile check
```

### Frontend

```bash
cd frontend
npm run dev                # Run dev server
npm run build              # Production build
npm run lint               # ESLint check
```

## Tech Stack

### Backend
- Kotlin 1.9+
- Spring Boot 3.x
- Spring Data JPA
- PostgreSQL

### Frontend
- React 18
- TypeScript 5
- Vite
- Tailwind CSS
- shadcn/ui

## Conventions

### Git Commits
- Format: `[type] description`
- Types: `[feature]`, `[fix]`, `[docs]`, `[refactor]`, `[test]`, `[chore]`

### Code Style
- Backend: Kotlin official style guide
- Frontend: ESLint + Prettier

### Testing
- Backend: JUnit5 + MockK
- Frontend: Vitest + Testing Library
