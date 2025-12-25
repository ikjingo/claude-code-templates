# Claude Code Hooks

이 디렉토리는 Claude Code의 Hook 스크립트를 포함합니다.

## 설치

```bash
cd .claude/hooks
npm install
```

## Hook 종류

### 1. skill-activation-prompt.ts (UserPromptSubmit)

사용자 프롬프트 제출 시 실행되어 `skill-rules.json`의 규칙에 따라 관련 스킬을 자동으로 제안합니다.

**특징:**
- JSON 기반 설정 (`skill-rules.json`)
- 키워드 매칭 + 정규식 의도 패턴 매칭
- 우선순위 지원 (critical/high/medium/low)
- TypeScript 기반으로 안정성 향상

**트리거 예시:**
| 프롬프트 | 제안 스킬 |
|---------|----------|
| "백엔드 테스트 작성해줘" | backend-test-generator |
| "코드 리팩토링 해줘" | refactor-code |
| "PR 만들어줘" | pr-workflow |
| "서버 시작해줘" | start-project |
| "프론트엔드 컴포넌트 만들어줘" | frontend-dev-guidelines |

### 2. post-tool-use-tracker.sh (PostToolUse)

파일 편집 도구(Edit, MultiEdit, Write) 사용 후 실행되어 변경된 파일과 영향받는 모듈을 추적합니다.

**동작:**
1. 편집된 파일의 모듈(frontend/backend) 감지
2. 영향받는 모듈 목록을 캐시에 저장
3. 빌드/타입체크 명령 저장

**추적 위치:** `.claude/build-cache/{session_id}/`
- `affected-modules.txt` - 영향받은 모듈 목록
- `edited-files.log` - 편집된 파일 로그
- `commands.txt` - 실행할 빌드 명령

### 3. build-check.sh (Stop)

Claude 응답 완료 후 실행되어 변경된 파일에 대해 빌드를 검증합니다.

**훅 연동 흐름:**
```
PostToolUse → post-tool-use-tracker.sh → 캐시 저장
                                              ↓
Stop        → build-check.sh          → 캐시 읽기 → 빌드 체크 → 캐시 정리
```

**동작:**
1. `post-tool-use-tracker.sh`가 저장한 캐시에서 영향받은 모듈 확인
2. 캐시가 없으면 `git diff`로 폴백
3. `frontend/` 변경 시: Prettier 자동 포맷팅 + TypeScript 체크
4. `backend/` 변경 시: `./gradlew compileKotlin` 실행
5. 에러 발생 시 상위 5개 에러 표시
6. 완료 후 캐시 정리

## 스킬 규칙 설정

스킬 자동 활성화 규칙은 `.claude/skills/skill-rules.json`에서 설정합니다.

```json
{
  "skills": {
    "skill-name": {
      "type": "domain",
      "enforcement": "suggest",
      "priority": "high",
      "description": "스킬 설명",
      "promptTriggers": {
        "keywords": ["키워드1", "키워드2"],
        "intentPatterns": ["정규식 패턴"]
      },
      "fileTriggers": {
        "pathPatterns": ["backend/**/*.kt"],
        "pathExclusions": ["**/*Test.kt"]
      }
    }
  }
}
```

### 설정 옵션

| 옵션 | 값 | 설명 |
|-----|-----|------|
| type | `domain` / `guardrail` | 도메인 지식 vs 가드레일 |
| enforcement | `suggest` / `block` / `warn` | 제안 / 차단 / 경고 |
| priority | `critical` / `high` / `medium` / `low` | 우선순위 |

## settings.json 설정

```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "npx tsx $CLAUDE_PROJECT_DIR/.claude/hooks/skill-activation-prompt.ts"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Edit|MultiEdit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/post-tool-use-tracker.sh"
          }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/build-check.sh"
          }
        ]
      }
    ]
  }
}
```

## Hook 비활성화

특정 Hook을 비활성화하려면 settings.json에서 해당 Hook 설정을 제거하거나 주석 처리하세요.

## 새 Hook 추가

1. `.claude/hooks/` 디렉토리에 스크립트 생성
2. 실행 권한 부여: `chmod +x script-name.sh`
3. `settings.json`의 적절한 이벤트에 등록

## 이벤트 종류

| 이벤트 | 설명 |
|--------|------|
| UserPromptSubmit | 사용자가 프롬프트 제출 시 |
| PostToolUse | 도구 사용 후 (파일 수정 등) |
| Stop | Claude 응답 완료 후 |

## 트러블슈팅

### Hook이 실행되지 않는 경우
1. 스크립트 실행 권한 확인: `ls -la .claude/hooks/`
2. settings.json 문법 검증
3. 스크립트 수동 실행 테스트

### TypeScript 훅 테스트
```bash
cd .claude/hooks
npm run test:activation
```

### 빌드 체크가 너무 느린 경우
- `build-check.sh`에서 전체 빌드 대신 타입 체크만 실행하도록 설정됨
- 필요시 스크립트를 수정하여 검사 범위 조정
