# Glossary

Vocabulary for the Claude Code training course. Use this as a quick reference
during the labs, or as a reading list for the concepts that pay off across
sessions.

## The decision ladder

The spine of the vocabulary is the laddering question: *what kind of artifact
should this work become?*

> If the work happens once, a prompt is enough. If it happens repeatedly the
> same way, you have a skill. If the workflow needs to travel between people,
> projects, tools, and environments, you have a plugin. If the agent needs
> live access to another system, that is the job of an MCP server. If a step
> has to be deterministic and cannot be trusted to the model, that is a hook
> or a script.
>
> — adapted from Nate B. Jones, *Codex plugins matter because the bottleneck moved* (May 2026)

The ladder is the same for Codex and Claude Code; the file paths differ. This
glossary uses Claude Code paths throughout.

---

## A

### AGENTS.md
A cross-tool conventions file used by Codex and other agentic tools. **Claude
Code does not natively read it** ([issue #6235](https://github.com/anthropics/claude-code/issues/6235)).
The bridge pattern is to import it from `CLAUDE.md` with `@AGENTS.md` so a
single source of truth feeds both tools. *See: CLAUDE.md.*

### Agent Teams (research preview)
Multiple custom subagents running in parallel against a shared task list, with
lead-agent summaries. Enable with `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`; with
it set, every session has one implicit team and teammates are spawned directly
via the Agent tool's `name` parameter (the older `TeamCreate`/`TeamDelete` tools
were removed). Best for orthogonal concerns (e.g., review tests / review
security / update docs in one pass). *See: Subagent, Dynamic Workflows.*

### Dynamic Workflows
Script-driven orchestration of tens to hundreds of background agents from a
single request, using deterministic control flow (loops, conditionals, fan-out,
pipelines) rather than model-improvised coordination. Opt in with the keyword
`ultracode` (renamed from `workflow`) or by asking Claude to "use a workflow";
view runs with `/workflows`. Contrast with Agent Teams, where a lead agent
coordinates dynamically. *See: Agent Teams, Subagent.*

### Auto Mode
A permission mode that uses a background safety classifier to decide per-action
whether approval is required, instead of prompting on everything or skipping
everything. The modern recommended escape hatch. **Replaces**
`--dangerously-skip-permissions`, which still works but is now categorized as
legacy. *See: Plan Mode.*

## C

### CLAUDE.md
The canonical project-memory file. Loaded automatically into every session in
the project's working tree. Personal global instructions live in
`~/.claude/CLAUDE.md`. Use `@filepath` syntax to import other files (such as
`AGENTS.md`). *See: AGENTS.md.*

### Custom command *(legacy)*
The pre-2.1 form: a flat Markdown file at `.claude/commands/<name>.md` (or
`~/.claude/commands/<name>.md` for personal). **Merged into skills** as of
Claude Code 2.1. A file at `.claude/commands/deploy.md` and a skill at
`.claude/skills/deploy/SKILL.md` both create `/deploy` and behave the same
way. Existing command files keep working; **skills are the recommended path
for new work**. If a command and a skill share a name, the skill wins.
*See: Skill.*

## H

### Hook
A registered lifecycle handler that fires on a Claude Code event:
`PreToolUse`, `PostToolUse`, `PostToolUseFailure`, `SessionEnd`, `SessionStart`,
`SubagentStart`, `TaskCreated`, and others. Configured in
`.claude/settings.json` (project) or `~/.claude/settings.json` (personal), or
inside a plugin at `hooks/hooks.json`. Hook *types* include `command`, `http`,
`mcp_tool`, `prompt`, and `agent`. **Use a hook when a step must be
deterministic and cannot be trusted to the model.** *See: Script.*

## M

### Manifest *(plugin)*
The file that identifies a plugin: `<plugin-root>/.claude-plugin/plugin.json`.
**Required:** `name` (also becomes the skill namespace prefix). **Recommended:**
`description`, `version`, `author`. Component directories (`skills/`, `agents/`,
`hooks/`, `commands/`) are auto-discovered at the plugin root — they are *not*
listed in the manifest. *See: Plugin.*

### Marketplace *(plugin)*
A catalog that tells Claude Code where installable plugins live. Public
marketplaces (Anthropic's, community ones) plus private/team marketplaces are
both supported. For local development you don't need a marketplace at all —
use `claude --plugin-dir <path>` to load a plugin directly. *See: Plugin.*

### MCP server *(Model Context Protocol)*
A standalone process that gives the agent **live access to a third-party
system or tool** — Linear, Slack, Postgres, Playwright, GitHub, your internal
APIs. Configured in `.mcp.json` (project root), `.claude/settings.json`, or
`~/.claude/settings.json`. Managed interactively via `/mcp`. **Use an MCP
server when the agent needs to read or act on a system that isn't a local
file.** *See: Plugin (which can bundle an MCP config).*

## O

### Output style
A directive that shapes *how* Claude presents responses, without changing what
it can do. Built-in: **Default**, **Explanatory**, **Learning**. Custom styles
live at `~/.claude/output-styles/<name>.md` (user), `.claude/output-styles/`
(project), or inside a plugin's `output-styles/` directory. Switch via
`/config` → **Output style** (the older bare `/output-style` command is
gone), or edit the `outputStyle` field directly in `.claude/settings.local.json`.
**Changes take effect on the next session start** — the system prompt is fixed
at session start so prompt caching stays warm.

## P

### Plan Mode
A mode that separates *proposing* from *executing*. Claude produces a structured
plan; nothing runs until you accept or refine it. Activate with `/plan` or
`Shift+Tab` twice (one toggle is auto-accept; two is Plan Mode). **Use when
reading a plan would change what you do.** Skip for single-file edits you've
already thought through. *See: Auto Mode.*

### Plugin
A package that bundles one or more skills (and optionally agents, hooks, MCP
configs, LSP servers, monitors) for distribution. Plugins are **packaging** —
the skill still does the work. In practice, **most plugins bundle a coherent
suite from one author**: `document-skills` ships ~16 skills (xlsx, pdf, docx,
pptx, …); `autoresearch` ships ~10. Single-skill plugins exist, usually
because the distribution channel (an official marketplace) requires the
plugin wrapper. Plugin skills are **always namespaced**: a `hello` skill in a
plugin named `my-tools` is invoked as `/my-tools:hello`. Test locally with
`claude --plugin-dir <path>`; reload edits with `/reload-skills`. *See:
Manifest, Marketplace, Skill.*

### Prompt
The work happens once. A clear, specific request to the agent in plain English.
The right artifact when the workflow is one-off and not worth packaging.
*See: Skill (when the prompt becomes repetitive).*

## S

### Script
A runnable file (shell, Python, anything executable). A skill or hook can call
a script via Bash; a script by itself is **not** a Claude Code primitive — it
has no lifecycle integration. Reach for a script when you want to *implement*
a deterministic step; reach for a hook when you want that step to fire
automatically at a Claude Code event. *See: Hook.*

### Skill
A reusable operating procedure that teaches Claude how to do a specific job.
**Not a saved prompt** — a skill encodes judgment: what standards to apply,
which mistakes to avoid, what kind of output counts as finished. Lives at
`.claude/skills/<name>/SKILL.md` (project), `~/.claude/skills/<name>/SKILL.md`
(personal), or inside a plugin. The `description` in frontmatter is the
**trigger surface**: Claude auto-loads the skill when the description matches
the conversation. Other useful frontmatter: `allowed-tools`, `paths`,
`context: fork`, `disable-model-invocation`, `user-invocable`, `model`,
`effort`. **Most installable capabilities you'll use are single skills.**
Hot-reloads on edit. *See: Plugin (when a skill or several need to be shared).*

### Subagent
A separate Claude context spawned for a focused task, with its own tool
permissions and (optionally) its own model. Built-in types: **Explore**
(read-only search), **Plan** (used by Plan Mode), **general-purpose**.
Custom subagents live at `.claude/agents/<name>.md` (project) or
`~/.claude/agents/<name>.md` (personal). Useful for protecting the main
context window from noisy work. *See: Agent Teams.*

### Surface
A way of accessing Claude Code. As of 2026: **terminal CLI**, **desktop app
*Code* tab**, **web** (`claude.ai/code`), **VS Code extension**, **JetBrains
plugin** (beta), **iOS app**, **Slack**, **Chrome extension**, **GitHub
Actions**, **GitLab CI/CD**. Local surfaces share settings, `CLAUDE.md`, MCP
servers, skills, and hooks; web sessions only inherit repo-committed config.
Handoff commands: `/desktop` (terminal → desktop, macOS/Windows),
`/teleport` (web → terminal), `/remote-control` (terminal → web).

---

## Cross-reference: which artifact for which need

| Need | Artifact | Where it lives |
|---|---|---|
| One-off ask | Prompt | the conversation |
| Repeated procedure (yours) | Skill | `.claude/skills/<name>/SKILL.md` |
| Repeated procedure (team) | Skill in repo | `.claude/skills/` checked in |
| Coherent suite to ship | Plugin | `<plugin>/.claude-plugin/plugin.json` |
| Live access to a system | MCP server | `.mcp.json` (or inside a plugin) |
| Deterministic check on a Claude event | Hook | `settings.json` (or plugin `hooks/hooks.json`) |
| Reusable executable | Script | anywhere on `$PATH`; called by skill or hook |
| Multi-step proposal before action | Plan Mode | `/plan` or `Shift+Tab` × 2 |
| Fewer permission prompts safely | Auto Mode | `/auto` or settings |
| Project memory loaded every session | CLAUDE.md | project root |
| Cross-tool memory (Codex etc.) | AGENTS.md (imported from CLAUDE.md) | project root |

---

*Last updated: 2026-06-26. Re-verify against [Anthropic's official documentation](https://code.claude.com/docs/) for anything that may have shifted.*
