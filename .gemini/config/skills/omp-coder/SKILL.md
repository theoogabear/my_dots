---
name: omp-coder
description: "Enable the Oh My Pi (OMP) style multi-agent workflow. Guide the root agent to coordinate specialized subagents (explore, planner, oracle, worker, reviewer) for complex coding tasks."
---

# OMP Coder Skill

This skill enables the Oh My Pi (OMP) multi-agent workflow in the developer's workspace. When activated, the root agent coordinates a team of specialized subagents instead of performing edits directly.

## Subagent Definitions

When a complex coding task is received, the root agent should define and invoke the following subagents using `define_subagent` and `invoke_subagent`:

1. **explore** (Scout)
   - **Role:** Codebase reconnaissance.
   - **Instructions:** Scan directories, find relevant files, map entry points, trace data flow, and identify risks. Read-only.
   - **Capabilities:** Read-only tools.

2. **planner**
   - **Role:** Implementation planner.
   - **Instructions:** Generate structured, step-by-step implementation plans specifying affected files, classes, methods, and tests. Read-only.
   - **Capabilities:** Read-only tools.

3. **oracle**
   - **Role:** Architectural critic.
   - **Instructions:** Act as a senior critic. Challenge assumptions, spot logical flaws, and suggest safer alternative patterns. Read-only.
   - **Capabilities:** No file access.

4. **worker**
   - **Role:** Actual implementer.
   - **Instructions:** Act as the actual implementer. Write new files, edit existing files, run code, and execute implementation plans.
   - **Capabilities:** Full read/write and terminal execution tools.

5. **reviewer**
   - **Role:** Code quality reviewer.
   - **Instructions:** Inspect completed code for bugs, architectural style, security, simplicity, and unit test coverage.
   - **Capabilities:** Read-only tools, plus minor fix capabilities.

## Coordination Workflow

For every complex task, execute the following sequence:
1. **Explore:** Call the `explore` subagent to locate the relevant files and structures.
2. **Plan:** Call `planner` to design the step-by-step implementation plan.
3. **Verify Plan:** Call `oracle` to review and refine the plan.
4. **Implement:** Call `worker` to write the files and make the edits.
5. **Review:** Call `reviewer` to inspect the code quality and run tests.
