# Legacy `.claude/commands/` (kept for contrast)

This directory used to hold the project's custom slash commands. As of Claude Code 2.1, **custom commands are merged into skills** — the modern, recommended form lives in `../skills/`.

We keep one entry here (`docs.md`) intentionally, so students can see the *old* form alongside the *new* form and confirm that legacy `.claude/commands/` files still work. The other commands have moved to skills:

| Old (`.claude/commands/`)      | New (`.claude/skills/<name>/SKILL.md`) |
| ------------------------------ | -------------------------------------- |
| `modernize-java.md`            | `skills/modernize-java/`               |
| `onboard.md`                   | `skills/onboard/`                      |
| `security-review.md`           | `skills/security-review/`              |
| `spring-controller.md`         | `skills/spring-controller/`            |
| `spring-service.md`            | `skills/spring-service/`               |

The new skill versions add capabilities the flat command form can't have — frontmatter for `paths` triggering, `allowed-tools` scoping, `context: fork` execution, `disable-model-invocation` for explicit-only skills, and `$ARGUMENTS` substitution that mirrors the old form.

If a command and a skill share a name, the skill wins.

See `../custom-commands.md` for the full skills walk-through.
