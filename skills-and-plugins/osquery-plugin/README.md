# osquery-plugin (reference)

Reference implementation for **Lab 6 Part B** of the Claude Code training.
Students build this themselves during the lab; this directory exists so they
can compare against a working version if they get stuck.

## What it is

A minimal Claude Code plugin that wraps the `osqueryi` CLI tool with a single
skill. The user asks a diagnostic question in plain English ("what's hammering
my CPU?"), the skill translates to SQL against osquery's system tables, runs
the query, and explains the result.

## Layout

```
osquery-plugin/
├── .claude-plugin/
│   └── plugin.json          # Manifest (the only required file)
├── skills/
│   └── osquery/
│       └── SKILL.md         # The skill itself
└── README.md                # This file
```

The two rules people get wrong:

1. The manifest **must** live at `.claude-plugin/plugin.json` — not the plugin root.
2. The `skills/` directory lives at the **plugin root** — *not* inside `.claude-plugin/`.

## Try it

Prerequisite: `osqueryi` installed (`brew install --cask osquery` on macOS).

From this directory, or anywhere:

```bash
claude --plugin-dir ./skills-and-plugins/osquery-plugin
```

Then in the new session:

```
What's hammering my CPU right now?
```

The skill should activate based on its description and run a query against the
`processes` table. List your skills with `/help` — you'll see it as
`/osquery-tools:osquery` (plugin skills are always namespaced as
`<plugin-name>:<skill-name>`).

## Where this fits in the ladder

This plugin sits at the **first rung** of packaging — one skill, no MCP servers,
no hooks, no marketplace registration. That's intentional. Most useful packaging
stops here. The next rungs (MCP integration, hooks, marketplace distribution)
are covered in `skills-and-plugins/plugin-examples/team-standards-plugin.md`.
