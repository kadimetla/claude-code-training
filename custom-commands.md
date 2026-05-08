# Skills and Custom Commands

> **As of Claude Code 2.1, custom commands have been merged into skills.**
> A file at `.claude/commands/deploy.md` and a skill at `.claude/skills/deploy/SKILL.md` both create `/deploy` and behave the same way. Existing `.claude/commands/` files keep working — but **skills are the recommended path** for new work.

This document showcases reusable workflow automation for Claude Code. New material teaches **skills**; the older `.claude/commands/` form appears at the end as a backwards-compatibility reference.

---

## Why Skills (and not just commands)

Skills add capabilities that flat command files can't have:

- **Directory structure** — a skill is a folder (`SKILL.md` + supporting templates, scripts, examples) instead of a single file.
- **Frontmatter for control** — invocation rules (`disable-model-invocation`, `user-invocable`), per-skill tool permissions (`allowed-tools`), forked-subagent execution (`context: fork`), path-based triggering (`paths`).
- **Automatic loading** — Claude loads a skill when its `description` matches the conversation, even without an explicit `/skill-name` invocation.
- **Live change detection** — adding or editing a skill takes effect within the current session.
- **Argument substitution** — same `$ARGUMENTS`, `$0`, `$1` substitution as commands.

If a command and a skill share a name, **the skill wins**.

### Skill locations and precedence

`Enterprise > Personal > Project`. Plugin skills are namespaced separately.

| Scope       | Path                                          |
| ----------- | --------------------------------------------- |
| Enterprise  | managed settings                              |
| Personal    | `~/.claude/skills/<skill-name>/SKILL.md`      |
| Project     | `.claude/skills/<skill-name>/SKILL.md`        |
| Plugin      | `<plugin>/skills/<skill-name>/SKILL.md`       |

---

## Skill Anatomy

```
~/.claude/skills/my-skill/
├── SKILL.md          # Required: instructions with YAML frontmatter
├── templates/        # Optional: reusable templates
├── scripts/          # Optional: helper scripts
└── reference/        # Optional: docs, schemas, examples
```

Minimal `SKILL.md`:

```markdown
---
name: docs
description: Update README.md and CLAUDE.md to reflect the current state of the project.
---

Update both the README.md and CLAUDE.md files as appropriate.
If either file does not exist, create it. Generate the
CLAUDE.md file as though the user invoked the `/init` task.
```

### Useful frontmatter fields

| Field                       | What it does                                                                  |
| --------------------------- | ----------------------------------------------------------------------------- |
| `name`                      | Skill name (becomes the slash command if `user-invocable`)                    |
| `description`               | Used by Claude to decide when the skill is relevant — write this carefully    |
| `user-invocable`            | If `true`, exposes `/<name>` for explicit invocation                          |
| `disable-model-invocation`  | If `true`, the skill only runs when invoked explicitly (no auto-load)         |
| `allowed-tools`             | Whitelist of tools this skill can use (e.g., `Read, Edit, Bash`)              |
| `context: fork`             | Run in a forked subagent so the parent context isn't polluted                 |
| `paths`                     | Glob patterns that trigger the skill when matching files are discussed        |
| `model`                     | Force a specific model for this skill (e.g., `opus` for hard work)            |
| `effort`                    | `low | medium | high` — control reasoning depth                               |

---

## Showcase Skills

Each of these lives under `skills/<name>/SKILL.md` in this repo. Copy the directories you want into `~/.claude/skills/` (personal) or `.claude/skills/` (project) to use them.

### `/docs` — Documentation Generator
Updates README.md and CLAUDE.md to reflect current project state. Useful at the end of a feature branch.

### `/security-review` — Security Code Review
Walks the changed files (or the whole project) looking for SQL injection, XSS, auth/authz flaws, input validation gaps, sensitive data exposure, insecure cryptography. Path-triggered in this repo.

### `/onboard` — Codebase Onboarding Generator
Analyzes structure and writes `CODEBASE.md` + a Slidev `PRESENTATION.md` for new team members.

### `/modernize-java` — Java Modernization
Updates Java code to records, switch expressions, pattern matching, virtual threads, sealed classes, text blocks, and modern collection factories. Path-triggered on `*.java`.

### `/spring-controller <Entity>` — Spring REST Controller Scaffold
Generates a `<Entity>Controller` with CRUD endpoints, DTOs, validation, OpenAPI docs, and integration tests.

### `/spring-service <Entity>` — Spring Service Scaffold
Generates a `<Entity>Service` with constructor injection, logging, exception handling, and unit tests with `@MockitoBean` / `@MockitoSpyBean`.

---

## Quick setup

```bash
# Personal: skills available across all your projects
mkdir -p ~/.claude/skills
cp -r skills/* ~/.claude/skills/

# Project: skills shared with your team via the repo
mkdir -p .claude/skills
cp -r skills/* .claude/skills/
```

Skills hot-reload — edit a `SKILL.md` and the change takes effect in the current session.

---

## Best practices

1. **Write a careful `description`** — this is what Claude matches against to decide if the skill is relevant. Vague descriptions don't auto-load.
2. **Scope tools deliberately** — `allowed-tools` makes a skill safer to invoke and easier to reason about.
3. **Use `context: fork` for noisy work** — refactoring, large reviews, anything that would otherwise dump 5,000 lines into your conversation.
4. **Use `paths` for path-triggered relevance** — `paths: ["src/**/*.java"]` keeps a Java-modernization skill from activating on a Python file.
5. **Keep `SKILL.md` short** — Claude loads it when relevant. Put bulky reference material in `reference/` and link from `SKILL.md`.

---

## Backwards compatibility: `.claude/commands/`

The flat command form still works, with one caveat: it can't do anything skills can do beyond argument substitution. Use it for trivial one-liners or for compatibility with material written before 2026.

```markdown
# .claude/commands/fix.md
Fix issue #$ARGUMENTS — investigate, propose a plan, then implement.
```

Usage: `/fix 1234` (project) or `/user:fix 1234` (personal commands require the `user:` prefix).

This repo keeps **one** legacy command in `commands/` (`docs.md`) so students can see the old form alongside the new. Everything else has migrated to `skills/`.

---

## Integration with Course Labs

- **Lab 5**: Use the `/modernize-java` and `/security-review` skills against the legacy refactor target.
- **Lab 6**: Build a custom skill (with frontmatter that scopes tools and matches paths) and contrast it with a one-line `.claude/commands/` entry.
- **Java demos**: Use `/spring-controller` and `/spring-service` against the `certificate-service` exercise.
