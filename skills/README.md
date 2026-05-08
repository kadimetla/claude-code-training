# `skills/` — this project's working skills

These skills were migrated from the older `.claude/commands/` form. They are the project's recommended ready-to-copy automations — install them under `~/.claude/skills/` (personal) or `.claude/skills/` (project) to use them.

## Skills in this directory

| Skill                | Demonstrates                                                |
| -------------------- | ----------------------------------------------------------- |
| `modernize-java/`    | `paths` triggering on `*.java`, `effort: medium`            |
| `onboard/`           | `context: fork` (clean parent context), `model: opus`       |
| `security-review/`   | `allowed-tools` (read-only), `disable-model-invocation`     |
| `spring-controller/` | `$ARGUMENTS` substitution + `paths` (Java + build files)    |
| `spring-service/`    | `$ARGUMENTS` substitution + `paths`                         |

Each `SKILL.md` was written to demonstrate **a different frontmatter capability** — the goal is that reading them in sequence gives you a tour of the skill system.

## Installation

```bash
# Personal (across all your projects)
mkdir -p ~/.claude/skills
cp -r skills/* ~/.claude/skills/

# Project (shared with team via this repo's settings)
mkdir -p .claude/skills
cp -r skills/* .claude/skills/
```

Skills hot-reload — edit a `SKILL.md` and the change takes effect in the current session.

## Related directories in this repo

- `commands/` — the **legacy** `.claude/commands/` form, kept as a single backcompat example (`docs.md`).
- `skills-and-plugins/` — a separate **teaching library** of example skills used during Lab 6 (api-documentation-skill, spring-boot-skill, security-review-skill, plus a plugin example).

See `../custom-commands.md` for the full walkthrough.
