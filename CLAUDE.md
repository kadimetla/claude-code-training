# Claude Code Training Course Development

This project contains comprehensive training materials for teaching Claude Code to professional software developers. The course emphasizes practical, hands-on learning with real-world scenarios.

## Cross-tool conventions

Claude Code does not natively read `AGENTS.md` (the convention used by Codex and other tools). To pick up shared cross-tool conventions in this repo, this file imports it explicitly:

@AGENTS.md

This is the recommended bridge pattern when a project needs to expose the same guidance to both Claude Code and AGENTS.md-aware tools without duplicating content.

## Project Structure & Standards

### Core Course Materials
- **`slides.md`**: Main Slidev presentation with progressive learning path
- **`lab_handout.md`**: Six progressive hands-on labs (Lab 0-6) for students
- **`instructor-guide.md`**: Detailed instructor guidance with specific demo scenarios
- **`exercises/`**: Collection of real-world sample projects across multiple languages

### Sample Projects Architecture
- **Python Projects**:
  - `weather-app`: Clean Flask application for feature addition exercises
  - `flask-api`: Intentionally poorly-written API for refactoring demonstrations
- **JavaScript/TypeScript**:
  - `lyrics-trainer`: Interactive web app with TypeScript and comprehensive test suite
- **Java Projects**:
  - `certificate-service`: Modern Spring Boot application with PDF generation
  - `shopping-service`: Legacy Grails/Groovy application for modernization exercises

### Skills and Custom Commands Integration
- **`custom-commands.md`**: Skills-first walkthrough with a backwards-compat callout for `.claude/commands/`
- **`skills/`**: Ready-to-copy skill directories migrated from the older command form. Each demonstrates a different frontmatter capability (paths, allowed-tools, context: fork, disable-model-invocation, $ARGUMENTS).
- **`commands/`**: One legacy `.claude/commands/` example (`docs.md`) preserved so students can compare old and new forms.
- **`skills-and-plugins/`**: Larger teaching-library skills used during Lab 6 (api-documentation-skill, spring-boot-skill, security-review-skill, plus a plugin example).
- Skills cover Java modernization, Spring scaffolding, security reviews, documentation generation, and onboarding automation.

## Development Workflow

### Presentation Development
1. **Run development server:** `pnpm dev`
2. **Build for production:** `pnpm build`
3. **Export to PDF locally:** `pnpm export` (produces `slides-export.pdf`, gitignored)
4. **Export to PowerPoint:** `pnpm export --format pptx --output slides-export.pptx`

**Note**: For local exporting, you may need to install Playwright's Chromium first:
```bash
pnpm exec playwright install chromium
```

### Slides PDF distribution
The published PDF is **not committed to the repo**. `.github/workflows/build-slides-pdf.yml` auto-builds on every push to `main` that touches `slides.md` (or `package.json` / `pnpm-lock.yaml` / the workflow itself) and attaches `slides-export.pdf` to a rolling `slides-latest` release. Stable URL:

```
https://github.com/kousen/claude-code-training/releases/latest/download/slides-export.pdf
```

- **Manual trigger:** Actions → "Build & publish slides PDF" → "Run workflow", or `gh workflow run build-slides-pdf.yml`
- **Do not commit** `slides-export.pdf` — it's gitignored on purpose
- **Snapshot for a specific training:** after a build, `gh release create slides-YYYY-MM-DD slides-export.pdf --notes "<event>"` makes a sibling release without disrupting the rolling tag

### Content Development Standards
- **Branch-First Approach**: All exercises emphasize creating branches before changes
- **Progressive Complexity**: Labs build from simple to advanced workflows
- **Real-World Focus**: Use actual project scenarios, not contrived examples
- **Multi-Language Support**: Ensure examples work across Python, JavaScript, and Java

### Lab Design Principles
- **Lab 0**: Project creation from scratch (lyrics display app - origins of lyrics-trainer)
- **Labs 1-3**: Foundation skills (exploration, testing, documentation)
- **Labs 4-6**: Advanced workflows (refactoring, Plan Mode, custom commands)

### Skills Teaching Integration
- **Demonstration**: Showcase skills during Lab 6 advanced workflows; show legacy `commands/docs.md` for contrast
- **Hands-on Practice**: Students copy a skill from `skills-and-plugins/` and write their own with deliberate frontmatter (paths, allowed-tools, etc.)
- **Real-world Application**: Use Java skills with certificate-service, security skills with vulnerable examples
- **Team Sharing**: Demonstrate how teams standardize workflows through shared skills (project scope) or plugins

## Teaching Philosophy

### Core Principles
- **Practical First**: Get students productive immediately
- **Safety Through Branching**: Always demonstrate branch-first workflow
- **Real Scenarios**: Use diverse, realistic codebases (modern to legacy)
- **Professional Workflows**: Emphasize enterprise development practices

### Key Messaging
- Claude Code creates complete projects from scratch
- AI assistance accelerates understanding of unfamiliar codebases
- Branch-first workflow enables fearless experimentation
- Tool adapts to any language/framework combination

## Content Guidelines

### Exercise Design
- Start each significant change with: "Create a new branch for this exercise"
- Use specific project names and concrete examples
- Include realistic time estimates (Lab 0: 20min, others: 15-60min)
- Provide both instructor demos and student hands-on activities

### Prompt Engineering Examples
- Always include complete, copy-pasteable prompts in code blocks
- Demonstrate iterative refinement techniques
- Show context-aware instructions that reference specific files/frameworks
- Include error recovery and troubleshooting scenarios

## Technical Requirements

### Development Environment
- Node.js and pnpm for presentation
- Python 3.x for Flask applications
- Java 17+ for Spring Boot/Grails projects
- TypeScript for modern web development

### Student Prerequisites
- Claude Code installed and configured
- Git workflow familiarity
- Multi-language development environment setup
- Basic understanding of web development concepts
