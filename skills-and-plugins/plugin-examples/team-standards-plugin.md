# Team Standards Plugin (multi-component reference)

This document shows what a real team-distribution plugin looks like — one that
bundles **several skills** plus hooks, MCP servers, and a custom subagent into
a single installable package. It's the natural next step after the single-skill
osquery plugin from Lab 6 Part B.

> **Why a multi-component plugin?** This is the dominant real-world pattern.
> Anthropic's `document-skills` plugin ships ~16 skills under one namespace;
> `autoresearch` ships ~10. When a team has a coherent suite of automations to
> standardize, the right artifact is one plugin with several skills — not
> several separate plugins.

---

## Directory layout

```
acme-corp-standards/
├── .claude-plugin/
│   └── plugin.json                # Manifest (only required file)
├── skills/                        # Auto-discovered at plugin root
│   ├── spring-controller/
│   │   └── SKILL.md
│   ├── spring-service/
│   │   └── SKILL.md
│   └── acme-api-standards/
│       └── SKILL.md
├── agents/                        # Custom subagents (optional)
│   └── security-reviewer.md
├── hooks/
│   └── hooks.json                 # Event handlers (optional)
├── .mcp.json                      # MCP server config (optional)
├── settings.json                  # Default settings (optional)
└── README.md
```

**Two rules people get wrong:**

1. The manifest **must** live at `.claude-plugin/plugin.json` — *not* at the plugin root.
2. Component directories (`skills/`, `agents/`, `hooks/`, `commands/`) live at the **plugin root** — *not* inside `.claude-plugin/`.

Component directories are **auto-discovered**. You do not list them in the
manifest.

---

## The manifest: `.claude-plugin/plugin.json`

```json
{
  "name": "acme-corp-standards",
  "description": "Acme Corporation development standards: Spring scaffolding, API conventions, security review",
  "version": "1.0.0",
  "author": {
    "name": "Acme Engineering"
  },
  "homepage": "https://github.com/acme/claude-plugins",
  "license": "MIT"
}
```

Only `name` is required. The `name` field becomes the **skill namespace**: a
skill named `spring-controller` inside this plugin is invoked as
`/acme-corp-standards:spring-controller`. Plugin skills are *always* namespaced
to prevent collisions across plugins.

---

## Skills: the heart of the plugin

Each skill is a directory with `SKILL.md`. Example:

```markdown
---
name: acme-api-standards
description: Enforce Acme API conventions — URL versioning, response envelope, error codes, request IDs. Use when reviewing API code or generating new endpoints.
allowed-tools: Read, Edit, Grep
---

# Acme API Standards

## Versioning
All APIs use URL-based versioning: `/api/v1/resource`.

## Response envelope
```json
{ "data": {...}, "meta": {"timestamp": "...", "version": "v1"}, "errors": [] }
```

## Error codes
- `ACME-1001`: authentication failed
- `ACME-2001`: resource not found
- `ACME-3001`: validation failed

## Required headers
- `X-Acme-Request-Id` on every response
- Correlation ID propagated for distributed tracing
```

The `description` is the **trigger surface** — write it carefully. Claude
auto-loads the skill when the description matches the conversation.

---

## Hooks: `hooks/hooks.json`

Hooks are registered lifecycle handlers. Use them for steps that **must** be
deterministic — security checks, format enforcement, audit logging — that you
don't want to depend on the model remembering.

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "${CLAUDE_PLUGIN_ROOT}/hooks/security-check.sh"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "${CLAUDE_PLUGIN_ROOT}/hooks/audit-log.sh"
          }
        ]
      }
    ]
  }
}
```

Event types include `PreToolUse`, `PostToolUse`, `PostToolUseFailure`,
`SessionStart`, `SessionEnd`, `SubagentStart`, `TaskCreated`, `FileChanged`.
Hook types include `command`, `http`, `mcp_tool`, `prompt`, and `agent`.

The `${CLAUDE_PLUGIN_ROOT}` variable resolves to the installed plugin's
directory — use it instead of relative paths so hooks work regardless of where
the plugin is installed from.

---

## MCP servers: `.mcp.json`

If the plugin's skills need live access to external systems (an internal API,
a ticketing tool, a database), bundle the MCP server config:

```json
{
  "mcpServers": {
    "acme-internal": {
      "command": "npx",
      "args": ["-y", "@acme/internal-api-mcp"],
      "env": {
        "ACME_API_TOKEN": "${ACME_API_TOKEN}"
      }
    }
  }
}
```

Pass credentials via environment variables, not CLI args. For values the user
must supply at install time, use the `userConfig` field in `plugin.json` —
Claude Code will prompt for them on enable instead of requiring users to
hand-edit `settings.json`.

---

## Subagents: `agents/<name>.md`

Custom subagents ship as Markdown files with frontmatter. Useful for focused
tasks the team wants standardized — security review, code review, release
notes — that benefit from running in their own context with their own tool
restrictions.

```markdown
---
name: security-reviewer
description: Reviews code for OWASP Top 10 issues, secret leakage, and Acme-specific security policy violations.
model: opus
tools: Read, Grep, Glob, Bash
---

# Acme Security Reviewer

When reviewing code, check for:
1. SQL injection, XSS, CSRF
2. Hardcoded secrets or credentials (never commit)
3. Insecure cryptography (no MD5, SHA-1 for security purposes)
4. Missing input validation
5. Acme policy: PII fields must be encrypted at rest, audit-logged on access
...
```

For security reasons, plugin-shipped agents do **not** support `hooks`,
`mcpServers`, or `permissionMode` in their frontmatter.

---

## Default settings: `settings.json`

The plugin can ship default settings that apply when it's enabled. **Only two
keys are currently supported**: `agent` (activates one of the plugin's custom
agents as the main thread) and `subagentStatusLine`.

```json
{
  "agent": "security-reviewer"
}
```

Unknown keys are silently ignored. If you want output style or status line
customization, ship those as separate skills or instruct users to configure
them in their own settings.

---

## Distribution: the marketplace

To share the plugin with the team, add a `marketplace.json` to a separate
catalog repo (or the same repo, in a different directory):

```json
{
  "name": "acme-internal",
  "owner": {
    "name": "Acme Engineering",
    "url": "https://acme.corp/engineering"
  },
  "plugins": [
    {
      "name": "acme-corp-standards",
      "source": {
        "type": "git",
        "url": "https://github.com/acme/claude-plugins.git",
        "path": "./acme-corp-standards"
      }
    }
  ]
}
```

The marketplace file lives at `.claude-plugin/marketplace.json` in the catalog
repo's root.

### Team installation

```bash
# Add the marketplace once per machine
/plugin marketplace add acme-corp/claude-plugins

# Install the plugin
/plugin install acme-corp-standards@acme-internal

# Or pin to project scope (writes to .claude/settings.json so the team gets it)
claude plugin install acme-corp-standards@acme-internal --scope project
```

To make the marketplace appear automatically without users running
`marketplace add`, ship `extraKnownMarketplaces` in managed enterprise
settings:

```json
{
  "extraKnownMarketplaces": {
    "acme-internal": {
      "source": {
        "type": "git",
        "url": "https://github.com/acme/claude-plugins.git"
      }
    }
  }
}
```

### Plugin management

```bash
/plugin list                              # List installed plugins
/plugin enable acme-corp-standards
/plugin disable acme-corp-standards
/plugin marketplace update                # Refresh catalog
/plugin validate                          # Validate plugin structure
```

---

## Local development loop

Don't push to a marketplace until the plugin works. Develop locally:

```bash
claude --plugin-dir ./acme-corp-standards
```

Edit any file, then run `/reload-plugins` in the session to pick up changes
without restarting.

---

## When this pattern fits

Use a multi-component plugin when **all** of these apply:

- The team has 2+ related skills that should travel together
- At least one skill needs deterministic enforcement (→ hooks) or live system access (→ MCP)
- The configuration should live in version control, not in each developer's `~/.claude/`

If you only have one skill and no hooks/MCP, **a single-skill plugin is fine**
(see `skills-and-plugins/osquery-plugin/`). If you don't need to share across
projects yet, **a plain `.claude/skills/` directory is fine** — don't add
plugin scaffolding before it's earning its keep.

---

## See also

- `skills-and-plugins/osquery-plugin/` — the simplest possible plugin (one skill, no extras)
- `glossary.md` — the decision ladder and definitions for every term used here
- [Claude Code plugins docs](https://code.claude.com/docs/en/plugins)
- [Plugin marketplaces docs](https://code.claude.com/docs/en/plugin-marketplaces)
- [Plugins reference](https://code.claude.com/docs/en/plugins-reference)
