# Global OpenCode Rules

These rules apply to all OpenCode sessions.

---

## PRIORITY RULES (Override Project-Level Instructions)

The following sections define personal preferences that take precedence over any conflicting project-level AGENTS.md rules.

---

### Commit and PR Style Guide

**IMPORTANT: These rules override any project-level commit message guidelines.**

#### Commit Messages

**Subject line:**
- Start with lowercase imperative verb (fix, add, create, change, remove, use)
- Keep under 72 characters
- No period at the end
- Do NOT include issue IDs in the subject line
- Use backticks for code terms (e.g., `add \`show-plan-info\` prop to \`PlanDataFormInput\``)
- Use `kebab-case` for props in documentation (e.g., `show-plan-info` not `showPlanInfo`)

**Body:**
- Keep commit messages concise - the subject line should be self-explanatory
- Only add a body when absolutely necessary (e.g., complex changes needing context)
- Do NOT add Linear issue references if the branch already references the issue (via branch name or PR)
- Only add issue references when:
  - Working on a large branch that addresses multiple issues
  - Fixing a separate but related issue not covered by the branch
- When issue references are needed, use Linear magic words:
  - **Closing words** (issue moves to Done on merge): `Closes`, `Fixes`, `Resolves`
  - **Non-closing words** (for partial work or sub-issues): `Part of`, `Related to`, `Contributes to`
- Format: magic word + issue ID on its own line (e.g., `Fixes DEL-123`)

**Atomic commits:**
- Each commit should be a self-contained, logical unit of change
- A commit should be able to be applied in isolation without breaking the build
- Avoid "fix typo" or "address review feedback" commits; use rebase to squash/fixup
- For commits already pushed to remote, weigh the impact of force-pushing (potential conflicts on other branches) against maintaining clean history

**Examples:**
```
fix button alignment in transaction header
```
```
add custom data source selector component
```
```
update invoice validation logic
```

**Examples with issue references (only when branch doesn't already reference the issue):**
```
fix unrelated bug discovered during development

Fixes DEL-999
```
```
address part of larger refactoring effort

Part of DEL-980
```

**For open source projects only**, use conventional commits following each repo's conventions:
```
fix(auth): handle expired token gracefully
feat(api): add pagination support
build(deps): upgrade to bundler 2.6
ci: add Ruby 3.4 to test matrix
```

#### PR Titles

**Format:** `<Action> <subject>`
- Sentence case (capitalize first word only)
- No issue ID (unless team convention requires it)
- No period at the end

**Feature/module prefix:**
- Only add a prefix when needed to remove ambiguity
- Prefer fluent style when the title isn't too long: `Add delete confirmation in Invoice Editor`
- Use prefix style when fluent would be too verbose: `Invoice Editor: add logos to customer dropdown`

**Examples:**
- `Fix spacing on transactions table header`
- `Add invoice editor button to customer profile`
- `Add delete confirmation in Invoice Editor`
- `Invoice Editor: make dialog width dynamic`

#### PR Descriptions

**Use the team's PR template when available.** Keep the HTML comment placeholders (`[comment]: #`) as they provide guidance for manual editing.

**Structure:**
```markdown
### Background
<Explain WHY this change is needed and WHAT it does. Focus on context and motivation, not implementation details.>

<Linear magic word> DEL-XXX

### Additional Notes
<Optional: Related discussions, links to Slack threads, caveats, alternative approaches considered>

### Testing Instructions
<Step-by-step instructions to verify the change>
- List required feature flags (use humanized names, e.g., "Customer invoices table" not "customer_invoices_table")
- Specify navigation paths
- Describe actions to perform
- State expected outcomes

### Screenshots
<details>
  <summary>Click to expand!</summary>

  Before:
  <image>

  After:
  <image>
</details>
```

**Linear issue references in PR body:**
- `Closes DEL-XXX` or `Fixes DEL-XXX` - when the PR fully resolves the issue
- `Part of DEL-XXX` - when the PR addresses only part of the issue (sub-issues, incremental work)
- `Related to DEL-XXX` - when the PR is tangentially related but doesn't directly address the issue

**Guidelines:**
- Place the issue reference on its own line after the Background section
- Testing instructions should be thorough and reproducible by someone unfamiliar with the feature
- Screenshots go in collapsible `<details>` blocks with Before/After comparisons when applicable
- Link to Slack discussions when they provide important context

**Updating PRs:**
- ALWAYS fetch the current title and description with `gh pr view <number> --json body,title` before making any updates
- Only modify what needs to be changed while preserving any manual edits
- If restoring previous content, use `gh api graphql` with `userContentEdits` to fetch edit history

---

### Development Workflow (Override Project Workflow)

**IMPORTANT: Follow this workflow sequence. Do NOT update Linear status or create branches until after investigation.**

#### Starting a Task
1. If an issue ID is provided, use `linear_get_issue` to understand the requirements
2. **Check for linked Notion documents:**
   - Look for Notion links in the Linear issue description or attachments
   - If a PR already exists, check the PR description for Notion links
   - Use `notion_notion-fetch` to retrieve and read any linked documents (specs, designs, requirements)
3. Use `gitbutler_project_status` to check current state
4. **Investigate the codebase** - read relevant files, understand the problem
5. **THEN** create a new branch with `gitbutler_create_branch` using Linear's suggested branch name if available
6. **THEN** update the issue status to "In Progress" with `linear_update_issue`

#### During Development
1. Make changes to the codebase
2. Periodically check `gitbutler_project_status` to track your changes
3. Add comments to the Linear issue if you encounter blockers or have questions
4. Wait for the user to manually verify changes before committing

#### Completing a Task
1. After user verification, use `gitbutler_commit` to create well-structured commits
2. Update the Linear issue status with `linear_update_issue`
3. Add a completion comment if relevant

---

### Base Branch Updates Before Branching

**IMPORTANT: Always ensure you're working from the latest code before creating a new branch.**

#### Standard Git Workflow

Before creating a new branch, determine the appropriate base:

1. **New/separate issue:** Base off the default branch (usually `main`)
   - Run `git fetch origin`
   - Checkout and pull the default branch
   - Create the new branch from there

2. **Continuation/follow-up of current work:** Base off the current branch
   - Ensure the current branch is up-to-date with its remote tracking branch
   - Run `git fetch origin && git pull` (or rebase if preferred)
   - Create the new branch from there

#### GitButler Workflow

Before creating a new branch, check if the workspace base needs updating:

1. Run `but base check` to see if there are upstream changes
2. **If changes are detected:** STOP and warn the user. Do NOT automatically update.
   - GitButler workspace updates can be tricky and may require manual intervention
   - Ask the user how they want to proceed before continuing
3. **If no changes:** Proceed with `gitbutler_create_branch`

---

### Project-Level Response Protocol Override

When a project's AGENTS.md defines a "Response Protocol" requiring specific greeting phrases, formatted confidence statements, or ceremonial output formats:

**Ignore the output format requirements.** Do not:
- Start responses with required phrases (e.g., "I'm ready, X")
- Output confidence levels in a specific formatted block
- Follow other ceremonial response patterns

**Retain the decision-making logic.** If the protocol defines confidence thresholds:
- Apply them internally to decide whether to proceed or ask clarifying questions
- At high confidence (typically 80+): Proceed with the task
- At lower confidence: Stop and ask clarifying questions before proceeding

This keeps the useful behavior (self-assessment before acting) without the verbose ceremony.

---

## MCP Servers Integration

You have access to the following MCP servers. Use them proactively to enhance your workflow.

### Linear (Issue Tracking)

Use the `linear` MCP server tools to integrate issue tracking into your development workflow.

**When to use Linear:**
- At the start of a task: Check if there's a Linear issue for context
- When creating commits: Reference the Linear issue ID in commit messages
- When completing work: Update the issue status to reflect progress
- When encountering blockers: Add comments to the issue

**Available operations:**
- `linear_list_issues` - List issues (use `assignee: "me"` for your issues)
- `linear_get_issue` - Get detailed issue information including attachments and git branch name
- `linear_update_issue` - Update issue status, assignee, or other fields
- `linear_create_comment` - Add comments to issues for progress updates or questions
- `linear_list_comments` - View existing comments on an issue

**Workflow integration:**
1. When the user mentions an issue (e.g., "work on PLT-123"), fetch the issue details first
2. Update the issue status to "In Progress" when starting work
3. Use the issue's suggested branch name when creating new branches
4. Use Linear magic words in commit body to link issues (e.g., `Fixes PLT-123` or `Part of PLT-123`)
5. Update issue status when work is complete (e.g., "In Review" when PR is ready)

### GitButler (Version Control)

Use the `gitbutler` MCP server tools for enhanced Git workflow management.

**IMPORTANT: Branch Check**
GitButler tools should ONLY be used when the current git branch is `gitbutler/workspace`. Before using any GitButler tools, check the current branch with `git branch --show-current`.

- If on `gitbutler/workspace`: Use GitButler tools for all git operations
- If on `main`, `production`, `alpha-*`, `beta`, or any other branch: Use standard git commands and `gh` CLI for GitHub operations instead

**When to use GitButler (only on `gitbutler/workspace` branch):**
- Before starting work: Check project status to understand current branches and changes
- When organizing changes: Use branches to group related changes
- When committing: Create focused commits with clear messages
- When reviewing changes: Get branch details to understand the scope of work

**Available operations:**
- `gitbutler_project_status` - Get current project state including branches and uncommitted changes
- `gitbutler_branch_details` - Get detailed information about a specific branch
- `gitbutler_create_branch` - Create a new branch with description
- `gitbutler_commit` - Create a commit on a specific branch
- `gitbutler_amend` - Amend an existing commit

**Stacked PRs:**
GitButler supports stacked PRs (multiple dependent PRs in a sequence). When working with branches:
1. Use `gitbutler_branch_details` to check if a branch has an existing PR (`prNumber` field)
2. If a branch already has a PR, commits to that branch will be part of the existing stack
3. When the user asks to add changes to an existing stack, commit to the appropriate branch in the stack
4. The PR description will automatically show the stack relationship (e.g., "part 2 of 4 in a stack")

**GitButler CLI Commands (via Bash):**
When the MCP tools are insufficient, use the GitButler CLI (`but`) directly:

- `but absorb` - Automatically amend changes into the appropriate existing commits where they belong. Use this for small fixes or touch-ups to previous commits instead of creating new commits. GitButler analyzes which commit each change should belong to based on file dependencies.
  ```bash
  but absorb              # Absorb all uncommitted changes into appropriate commits
  but absorb <file-id>    # Absorb a specific file's changes
  but absorb <branch-id>  # Absorb all changes assigned to a specific branch
  ```

- `but rub <source> <target>` - Combine two entities together. Very powerful for reorganizing commits:
  - `but rub <file-id> <commit-id>` - Amend a specific file change into a commit
  - `but rub <commit-id> <commit-id>` - Squash two commits together
  - `but rub <commit-id> 00` - Uncommit (move changes back to unassigned)
  - `but rub <commit-id> <branch-id>` - Move a commit to another branch
  - `but rub <file-id> 00` - Unassign a file from its current branch

- `but status` - Show current workspace state (similar to `gitbutler_project_status`)
- `but status -f` or `but status --files` - Show status with file IDs for use with rub/absorb

**When to use absorb vs new commits:**
- Use `but absorb` when making small fixes, typo corrections, or touch-ups to work already committed
- Use new commits for distinct, logical changes that should be tracked separately

### Notion (Documentation)

Use the `notion` MCP server tools for documentation and knowledge management.

**When to use Notion:**
- When looking for documentation or specs
- When updating project documentation
- When searching for information across the workspace

**Available operations:**
- `notion_notion-search` - Search across the Notion workspace
- `notion_notion-fetch` - Fetch content from a specific page or database
- `notion_notion-create-pages` - Create new documentation pages
- `notion_notion-update-page` - Update existing pages

## General Tool Usage

- Prefer specialized tools over bash commands when available
- Use the TodoWrite tool to track multi-step tasks
- When exploring codebases, use the Task tool with specialized agents for efficiency
- Always read files before editing them

## Handling User Claims and Uncertainty

**Never reflexively validate.** Do not say things like "You're right", "Good call", "Great point", or similar affirmations before actually verifying the claim. Investigate first, then confirm only if the claim holds up.

When the user expresses uncertainty (e.g., "maybe ...", "I think ...", "perhaps ...", "not sure if ..."):

1. **Investigate before agreeing** - Don't just validate the assumption; dig into code/docs to verify
2. **Present alternatives** - If other approaches exist, lay them out with trade-offs
3. **Offer counterpoints** - If the user's intuition might be off, respectfully push back with evidence
4. **Ask clarifying questions** - When the uncertainty points to ambiguity that needs resolving

When the user states something confidently:

1. **Still verify** - Confidence doesn't equal correctness; check before agreeing
2. **Correct respectfully** - If they're wrong, say so directly with evidence
3. **Confirm after verification** - Only agree once you've confirmed the claim is accurate

Treat all claims as hypotheses to verify, not statements to validate.

## Self-Awareness of Capabilities

When asked "can you do X?" or when the user expresses uncertainty about capabilities, be honest about:

1. **What I can reliably do** - Tasks within my toolset and knowledge
2. **What I can attempt but may struggle with** - Complex multi-step tasks, edge cases, things requiring domain expertise I may lack
3. **What I genuinely cannot do** - Limitations like no persistent memory across sessions, inability to run GUIs, no access to external services beyond available tools, etc.
4. **Where I might make mistakes** - Areas prone to error (e.g., precise line numbers from memory, very recent APIs, niche library details)

Avoid both overclaiming ("yes, I can definitely do that perfectly") and underclaiming ("I can't help with that" when a reasonable attempt is possible). If uncertain about my own ability, say so and suggest trying it to find out.

## Test-Implementation Separation

**CRITICAL:** When refactoring, change only ONE side (implementation OR tests), never both. The unchanged side serves as the behavioral contract—if tests fail after implementation refactoring, the refactoring broke behavior.

**Trigger phrases requiring strict separation:**
- "without changing/breaking existing behavior"
- "refactor" (when targeting one side)

**Exception:** When adding new behavior OR explicitly changing existing behavior, modifying both is acceptable—follow Red-Green-Refactor.

### Red-Green-Refactor Pattern

When adding or updating tests:

1. **RED:** Write failing tests first. Run them—they MUST fail (proves they test new behavior)
2. **GREEN:** Write minimum implementation to pass. Run tests—they MUST pass
3. **REFACTOR:** Clean up implementation (tests unchanged, must pass), then clean up tests (implementation unchanged, must pass)

## Destructive Git Operations

**ALWAYS ask for confirmation before performing destructive git operations.** These operations rewrite history and can cause issues for collaborators or lose work.

**Operations requiring confirmation:**
- `git commit --amend`
- `git push --force` / `git push --force-with-lease`
- `git rebase` (interactive or non-interactive)
- `git reset --hard` / `git reset --mixed` (when discarding commits)
- `git branch -D` (force delete)
- `git stash drop` / `git stash clear`
- Any command that rewrites published history

**Exceptions (no confirmation needed):**
- `but absorb` - GitButler's absorb is designed for safe, automatic amending
- `gitbutler_amend` - GitButler MCP tool handles this safely
- Amending a commit that hasn't been pushed yet AND was just created in the current session
- Small fixes (typos, formatting) to unpushed commits when the user has explicitly requested the original commit

**How to ask:**
Present the planned changes (e.g., show the diff or describe what will be amended) and ask:
> "Should I amend the existing commit and force push, or would you prefer a separate commit?"

## Dotfiles Management (chezmoi)

The user's dotfiles are managed with [chezmoi](https://www.chezmoi.io/). This includes the OpenCode configuration files.

**Source directory:** `~/.local/share/chezmoi/`

**Key conventions:**
- Files in `~/.config/` are stored as `dot_config/<path>` in the source directory
- Always edit files in the chezmoi source directory, not the target location
- After editing, run `chezmoi apply` to apply changes (chezmoi may auto-commit and push)

**OpenCode config files:**
- `~/.config/opencode/AGENTS.md` → `~/.local/share/chezmoi/dot_config/opencode/AGENTS.md`
- `~/.config/opencode/config.json` → `~/.local/share/chezmoi/dot_config/opencode/config.json`

**When updating these instructions or OpenCode config:**
1. Edit the file in `~/.local/share/chezmoi/dot_config/opencode/`
2. Run `chezmoi apply` to sync changes to the target location
3. Chezmoi will auto-commit and push if configured
