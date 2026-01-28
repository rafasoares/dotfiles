---
name: pr-checks
description: Wait for CI checks to pass, address automated feedback from Copilot, and mark PR ready for human review
---

## What I do

1. Poll CI check status until all checks complete
2. If an unrelated test fails, re-run it (do not attempt to fix it)
3. Once checks pass, ask if user wants to add Copilot as a reviewer
4. If yes, wait for Copilot's review and address feedback
5. Once all feedback is addressed, mark PR as ready and assign human reviewers

## Workflow

### Step 1: Wait for CI checks

Poll the PR checks until they complete:

```bash
gh pr checks <PR_NUMBER> 2>&1
```

If checks are still pending, wait 60-120 seconds and poll again. Continue until all checks have a final status (pass/fail).

### Step 2: Handle check failures

- **Related test failure**: Investigate and fix the issue, then push the fix
- **Unrelated test failure**: Re-run the failed job:
  ```bash
  gh run rerun <RUN_ID> --failed
  ```
- **Lint/typecheck failure**: Fix the issues and push

### Step 3: Ask about Copilot review (on success)

Once all checks pass, ask the user: "Would you like to add Copilot as a reviewer? (You'll need to add it manually via the GitHub UI)"

- If **no**: Skip to Step 5
- If **yes**: Continue to Step 4

### Step 4: Wait for Copilot review and address feedback

Poll for review status:

```bash
gh pr view <PR_NUMBER> --json reviews
```

Wait until Copilot's review appears (usually 1-3 minutes).

Fetch Copilot's review comments:

```bash
gh api repos/{owner}/{repo}/pulls/<PR_NUMBER>/comments
gh api repos/{owner}/{repo}/pulls/<PR_NUMBER>/reviews
```

For each piece of feedback:
- If it's a valid suggestion, implement the change
- If it's incorrect or not applicable, explain why in a reply
- Push any changes and wait for checks again (repeat from Step 1)

### Step 5: Mark PR ready and assign human reviewers

Once all checks pass (and Copilot feedback is addressed, if applicable):

```bash
gh pr ready <PR_NUMBER>
gh pr edit <PR_NUMBER> --add-reviewer @chartmogul/delta
```

## When to use me

Use this skill when asked to:
- "Wait for checks"
- "Monitor PR"
- "Get the PR reviewed"
- "Finalize the PR"

## Notes

- Always use `--failed` flag when re-running jobs to only re-run failed ones
- Be patient with polling - CI can take several minutes
- Do NOT attempt to assign Copilot via the API - it doesn't work
- Only mark PR as ready after ALL checks have passed and feedback is addressed
