Here is the refined Markdown formatting for your documentation.

### High Level PRD

| Component | Description |
| :--- | :--- |
| **Product Name** | Personal AI Infrastructure (Lite) |
| **Objective** | Create a local, privacy-first orchestration layer for research, documentation, and code reviews using Claude Code. |
| **Core Stack** | **Engine**: Claude Code CLI; **Storage**: Private GitHub; **Config**: Local `.env` & `.mcp.json`. |
| **Architecture** | **Router-Based**: Root `CLAUDE.md` acts as the central dispatch, routing commands to hidden file structures. |
| **Agent System** | **File-Based Personas**: Specialized agents (Researcher, Cyber, Designer) defined in markdown within `.claude/agents/`. |
| **Workflows** | **Standardized SOPs**: Repeatable procedures (e.g., `YoutubeExtraction.md`) stored in `.claude/skills/` for consistent output. |
| **Tooling** | **MCP Integration**: Brave Search & Filesystem tools enabled via `.mcp.json` for agent capabilities. |
| **Data Privacy** | **Local-First**: All keys/secrets in `.env`; sensitive outputs in `.gitignore`; no external database. |
| **User Interface** | **CLI Native**: Natural language triggers (e.g., *"Act as Researcher..."*) mapped directly to file paths. |
| **Success Metrics** | Zero-latency context switching; standardized Markdown outputs; fully reproducible research/review cycles. |

### Repository Structure

```text
├── CLAUDE.md                             # Router & Project Context
├── .mcp.json                             # MCP Tool Configuration
├── .gitignore                            # Git Ignore Rules
├── .env.example                          # Example Environment Variables
│
├── .claude/                              # The AI Brain
│   ├── agents/                           # Persona Definitions
│   │   ├── Researcher.md
│   │   ├── GeminiResearcher.md
│   │   ├── CybersecurityResearcher.md
│   │   ├── CybersecurityArchitect.md
│   │   ├── Designer.md
│   │   ├── TechSupportSpecialist.md
│   │   └── Brainstormer.md
│   │
│   └── skills/                           # Capabilities & Procedures
│       ├── Research/
│       │   ├── general-search.md
│       │   └── workflows/
│       │       ├── InterviewResearch.md
│       │       ├── ExtractKnowledge.md
│       │       └── YoutubeExtraction.md
│       │
│       ├── Prompting/
│       │   ├── meta-prompting.md
│       │   └── workflows/
│       │       └── RefinePrompt.md
│       │
│       └── Security/
│           ├── threat-modeling.md
│           └── workflows/
│               └── CodeAudit.md
│
├── inputs/                               # Raw Data Ingestion
│   └── .keep
│
├── runs/                                 # Artifact Output (Gitignored)
│   ├── drafts/
│   ├── logs/
│   └── .keep
│
├── docs/                                 # Permanent Knowledge Base
│   ├── architecture/
│   └── standards/
│
└── scripts/                              # Utility Scripts
    ├── check_env.sh
```

Would you like me to prepare the `check_env.sh` script next to ensure all your directories and `.env` variables are correctly set up before you start?