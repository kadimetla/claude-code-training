# Skills and Plugins — Teaching Library

This directory contains larger, more pedagogical skill examples and plugin configurations used during Lab 6 of the training course. They are designed to be **read, discussed, and copied** as starting points for your own work.

For the project's *own* working skills (migrated from `.claude/commands/`), see `../skills/` instead.

## Directory Structure

```
skills-and-plugins/
├── README.md                           # This file
├── spring-boot-skill/                  # Example: Java Spring Boot generator
│   └── SKILL.md
├── api-documentation-skill/            # Example: API documentation generator
│   └── SKILL.md
├── security-review-skill/              # Example: OWASP-aligned security analysis
│   └── SKILL.md
├── osquery-plugin/                     # Reference plugin for Lab 6 Part B
│   ├── .claude-plugin/plugin.json     #   (skill → plugin walkthrough)
│   ├── skills/osquery/SKILL.md
│   └── README.md
└── plugin-examples/                    # Larger plugin example (multi-component)
    └── team-standards-plugin.md
```

## What Are Skills?

**Skills** extend Claude with persistent, reusable domain expertise. As of Claude Code 2.1, **custom slash commands have been merged into skills** — the older `.claude/commands/` form still works, but skills are the recommended path because they add:

- A directory structure (templates, scripts, reference files alongside the instructions)
- Frontmatter for `allowed-tools`, `context: fork`, `paths`, `disable-model-invocation`, `user-invocable`, `model`, `effort`
- Automatic loading when the `description` matches the conversation
- Hot-reload — edits take effect immediately

If a command and a skill share a name, the skill wins. Precedence is `Enterprise > Personal > Project`; plugin skills are namespaced separately.

## What Are Plugins?

**Plugins** (Claude Code 2.0.12+) are installable packages that bundle:

- Skills (one or more)
- Slash commands (legacy `.claude/commands/` form)
- Hook scripts
- MCP server configurations
- Output styles

Plugins are how teams distribute a coherent set of automations across many repos.

## Using These Examples

### Installing a skill

```bash
# Personal install — available across all your projects
cp -r spring-boot-skill ~/.claude/skills/

# Project install — shared with the team via the repo
mkdir -p .claude/skills
cp -r spring-boot-skill .claude/skills/
```

The skill activates automatically when its `description` matches the conversation, or you can invoke it explicitly if `user-invocable: true` is set in its frontmatter.

### Plugin Development

The `plugin-examples/` directory shows how to structure plugins for team distribution.

## Lab Exercises

In Lab 6 Part B students will:

1. See the **decision ladder**: prompt → skill → plugin → MCP/hook
2. Build a skill that wraps a CLI tool (`osqueryi`) — the wrapper pattern
3. Wrap that skill as a plugin and test it with `claude --plugin-dir`
4. Discuss when a plugin grows further (MCP, hooks, marketplace)

Reference implementations: `osquery-plugin/` (single-skill plugin) and
`plugin-examples/team-standards-plugin.md` (multi-component plugin).

## Resources

- [Agent Skills Documentation](https://code.claude.com/docs/en/skills.md)
- [Plugin System Guide](https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md#plugin-system)
