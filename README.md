# Claude Code Training Course

A comprehensive training presentation and hands-on lab exercises for using Claude Code in professional software development workflows.

## 🎯 What You'll Learn

This course teaches professional developers how to:
- Create complete projects from scratch using Claude Code
- Navigate and understand complex codebases with AI assistance
- Implement the "branch-first" workflow for safe experimentation
- Generate comprehensive tests and documentation
- Refactor legacy code and modernize applications
- Use advanced Claude Code features like Plan Mode, `/code-review`, subagents, and dynamic workflows
- Extend capabilities with Skills and Plugins for specialized workflows
- Customize output styles for different learning preferences
- Understand and leverage subagents for complex multi-step tasks
- Implement sophisticated automation with hooks and event-driven workflows

## 🚀 Course Materials

This repository contains all the materials for the Claude Code Training course:

- **`slides.md`**: The main Slidev presentation with interactive demos
- **`lab_handout.md`**: Progressive hands-on labs from beginner to advanced
- **`instructor-guide.md`**: Instructor-led demos and exercises using real codebases
- **`half-day-outline.md`**: Condensed outline for half-day training sessions
- **`events/`**: Event-specific descriptions and course configurations
- **`glossary.md`**: Vocabulary reference for the course concepts
- **`webinar_slides.md`** / **`webinar_demos.md`**: Shorter 90-minute webinar variant
- **`custom-commands.md`**: Skills-first walkthrough of workflow automation, with the legacy command form for comparison
- **`skills/`**: Ready-to-copy skills, each demonstrating a different frontmatter capability
- **`commands/`**: One legacy `.claude/commands/` example kept for contrast with skills
- **`skills-and-plugins/`**: Larger teaching-library skills and a plugin example used in Lab 6
- **`hooks-examples/`**: Advanced hook patterns for workflow automation
- **`sample-claude-md/`**: Example `CLAUDE.md` files worth borrowing from
- **`exercises/`**: A collection of diverse sample projects:
  - **Python**: Flask web app (`weather-app`) and legacy API (`flask-api`)
  - **JavaScript/TypeScript**: Interactive web application (`lyrics-trainer`)
  - **Java**: Modern Spring Boot service (`certificate-service`) and legacy Grails app (`shopping-service`)

## 🏃‍♀️ Running the Presentation

1.  **Install dependencies:**
    ```bash
    pnpm install
    ```

2.  **Start the presentation:**
    ```bash
    pnpm dev
    ```

3.  Open your browser at <http://localhost:3030>

### 📄 Latest PDF

A current PDF of the slides is rebuilt automatically whenever `slides.md` lands on `main` and attached to a rolling release. Stable download URL:

**<https://github.com/kousen/claude-code-training/releases/latest/download/slides-export.pdf>**

No PDF is committed to the repo — it lives only in [GitHub Releases](https://github.com/kousen/claude-code-training/releases/tag/slides-latest), built by [`.github/workflows/build-slides-pdf.yml`](.github/workflows/build-slides-pdf.yml).

## 📚 Getting Started with the Labs

### Prerequisites
- Claude Code installed and configured
- Signed in with a Claude subscription (Pro / Max / Team / Enterprise) via `/login`, **or** an API key: `export ANTHROPIC_API_KEY="your-key"`
- Development environment for Python, JavaScript/TypeScript, and Java
- VS Code (optional, for IDE integration demonstrations)
- Docker (optional, for MCP and containerized workflow examples)

### Lab Structure
The `lab_handout.md` contains six progressive labs:

0. **Project Creation from Scratch** - Build a lyrics display app (recreates the `lyrics-trainer` origin story)
1. **Claude Code Basics** - Interface and project exploration
2. **Code Exploration** - Understanding complex codebases
3. **Test Generation** - Automated testing with AI
4. **Documentation Creation** - Professional documentation workflows
5. **Legacy Code Refactoring** - Modernizing Grails/Groovy applications
6. **Advanced Workflows** - Plan Mode, Skills, Plugins, Output Styles, Hooks, CLAUDE.md, Agent Teams, and Dynamic Workflows

### Skills (formerly Custom Commands)
As of Claude Code 2.1, custom slash commands are merged into skills. Students can explore and use the pre-built ones:
- Copy a skill directory from `skills/` to `~/.claude/skills/` (user scope) or `.claude/skills/` (project scope)
- See `custom-commands.md` for the walkthrough; `commands/docs.md` shows the legacy form for comparison
- Skills include Java modernization, Spring generators, security reviews, and onboarding

### Teaching Notes
The `instructor-guide.md` file contains detailed instructor guidance with specific prompts and a progressive story arc using the `flask-api` project as the primary demonstration vehicle.

## 🏗️ Course Philosophy

- **Branch-First Workflow**: Emphasizes safe experimentation through Git branching
- **Practical Learning**: Real-world projects across multiple languages and frameworks
- **Progressive Complexity**: From simple tasks to advanced enterprise workflows
- **Best Practices**: Professional development patterns and security considerations
- **Extensibility First**: Skills and plugins provide persistent, reusable domain expertise
- **Adaptive Learning**: Output styles and hooks adapt to diverse learning contexts
- **Intelligent Automation**: Subagents handle specialized tasks automatically for optimal performance

## 📖 Companion Book

*Claude Code: Up and Running — Harness the Power of Agentic Coding* (O'Reilly Media), by Ken Kousen:
<https://learning.oreilly.com/library/view/claude-code-up/0642572388782/>

## 👤 Author

**Ken Kousen**
- Email: ken.kousen@kousenit.com
- Website: kousenit.com
- Course: Professional Claude Code Training
