# Global OpenCode Rules

These rules apply to all OpenCode sessions.

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

**Workflow integration:**
1. Before making changes, check `gitbutler_project_status` to understand the current state
2. Create descriptive branches for new features or fixes
3. Use `gitbutler_commit` to create commits with proper messages
4. Group related changes into the same branch for cleaner history

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

## Integrated Development Workflow

When working on tasks, follow this integrated workflow:

### Starting a Task
1. If an issue ID is provided, use `linear_get_issue` to understand the requirements
2. Use `gitbutler_project_status` to check current state
3. Create a new branch with `gitbutler_create_branch` using Linear's suggested branch name if available

### During Development
1. Make changes to the codebase
2. Periodically check `gitbutler_project_status` to track your changes
3. Add comments to the Linear issue if you encounter blockers or have questions
4. Wait for the user to manually verify changes before committing

### Completing a Task
1. After user verification, use `gitbutler_commit` to create well-structured commits
2. Update the Linear issue status with `linear_update_issue`
3. Add a completion comment if relevant

## General Tool Usage

- Prefer specialized tools over bash commands when available
- Use the TodoWrite tool to track multi-step tasks
- When exploring codebases, use the Task tool with specialized agents for efficiency
- Always read files before editing them

## Commit and PR Style Guide

### Commit Messages

**Subject line:**
- Start with lowercase imperative verb (fix, add, create, change, remove, use)
- Keep under 72 characters
- No period at the end
- Do NOT include issue IDs in the subject line

**Body (when needed):**
- Use Linear magic words to link issues:
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

Closes DEL-976
```
```
update invoice validation logic

Part of DEL-980
```

**For open source projects only**, use conventional commits following each repo's conventions:
```
fix(auth): handle expired token gracefully
feat(api): add pagination support
build(deps): upgrade to bundler 2.6
ci: add Ruby 3.4 to test matrix
```

### PR Titles

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

### PR Descriptions

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
