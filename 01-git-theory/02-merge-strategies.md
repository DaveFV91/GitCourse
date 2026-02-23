Merge vs Rebase vs Cherry-pick
======================================================================

These are the three main strategies to bring commits from one branch into another. Each has a different impact on **history shape**, **safety**, and **use case**.

---

### Starting point

Imagine this history: `main` and `feature` have both added commits after a common base.

```mermaid
%%{init: {'theme': 'base', 'gitGraph': {'mainBranchName': 'main'}, 'themeVariables': { 'git0': '#1976D2', 'git1': '#43A047', 'gitBranchLabel0': '#fff', 'gitBranchLabel1': '#fff', 'commitLabelColor': '#333', 'commitLabelBackground': '#E3F2FD', 'commitLabelFontSize': '11px'}}}%%
gitGraph
    commit id: "A"
    commit id: "B"
    branch feature
    commit id: "C"
    commit id: "D"
    checkout main
    commit id: "E"
```

---

### Strategy 1 — Merge

`git merge` integrates the histories by creating a **merge commit** with two parents. The original commits are preserved exactly as they were. History is **non-linear but complete**.

```mermaid
%%{init: {'theme': 'base', 'gitGraph': {'mainBranchName': 'main'}, 'themeVariables': { 'git0': '#1976D2', 'git1': '#43A047', 'gitBranchLabel0': '#fff', 'gitBranchLabel1': '#fff', 'commitLabelColor': '#333', 'commitLabelBackground': '#E3F2FD', 'commitLabelFontSize': '11px'}}}%%
gitGraph
    commit id: "A"
    commit id: "B"
    branch feature
    commit id: "C"
    commit id: "D"
    checkout main
    commit id: "E"
    merge feature id: "M (merge commit)"
```

✅ Safe on shared branches — does not rewrite history.
✅ You always know exactly when and where integrations happened.
⚠️ History can become tangled with many parallel branches.

---

### Fast-forward Merge

If `main` has no new commits since the branch was created, Git can simply **move the pointer** forward — no merge commit needed. This is called a **fast-forward**.

```mermaid
%%{init: {'theme': 'base', 'gitGraph': {'mainBranchName': 'main'}, 'themeVariables': { 'git0': '#1976D2', 'git1': '#43A047', 'gitBranchLabel0': '#fff', 'gitBranchLabel1': '#fff', 'commitLabelColor': '#333', 'commitLabelBackground': '#E3F2FD', 'commitLabelFontSize': '11px'}}}%%
gitGraph
    commit id: "A"
    commit id: "B"
    commit id: "C (was feature)"
    commit id: "D (was feature)"
```

Use `git merge --no-ff feature` to **force a merge commit** even in fast-forward cases. This is a common convention to preserve the "this was a feature branch" evidence in history.

---

### Strategy 2 — Rebase

`git rebase` moves the base of the feature branch to the tip of `main`, **replaying** each commit one by one. The result is a **linear history**, as if the feature was developed after `E`.

```mermaid
%%{init: {'theme': 'base', 'gitGraph': {'mainBranchName': 'main'}, 'themeVariables': { 'git0': '#1976D2', 'git1': '#43A047', 'gitBranchLabel0': '#fff', 'gitBranchLabel1': '#fff', 'commitLabelColor': '#333', 'commitLabelBackground': '#C8E6C9', 'commitLabelFontSize': '11px'}}}%%
gitGraph
    commit id: "A"
    commit id: "B"
    commit id: "E"
    branch feature
    commit id: "C' (replayed)"
    commit id: "D' (replayed)"
```

> Note: the rebased commits `C'` and `D'` have **new hashes** — they are technically new objects, even if their content is identical.

At this point, you can go back to the main branch and do a fast-forward merge.

```mermaid
%%{init: {'theme': 'base', 'gitGraph': {'mainBranchName': 'main'}, 'themeVariables': { 'git0': '#1976D2', 'git1': '#43A047', 'gitBranchLabel0': '#fff', 'gitBranchLabel1': '#fff', 'commitLabelColor': '#333', 'commitLabelBackground': '#C8E6C9', 'commitLabelFontSize': '11px'}}}%%
gitGraph
    commit id: "A"
    commit id: "B"
    commit id: "E"
    branch feature
    commit id: "C' (replayed)"
    commit id: "D' (replayed)"
    checkout main
    merge feature
    commit id: "C'"
    commit id: "D'"
```

- ✅ Clean, linear history — easy to read with `git log`.
- ✅ Great for keeping a feature branch up to date with `main` before merging.
- ⚠️ **Never rebase commits that have already been pushed to a shared branch.** This rewrites hashes and forces others to reconcile the divergence.

**The golden rule of rebase**: only rebase local, private branches.

---

### Squash Commits

**Squash** means collapsing multiple commits into a single, clean commit. This is done via **interactive rebase** (`git rebase -i`) and is used to clean up a messy feature branch before merging.

#### Before squash

```mermaid
%%{init: {'theme': 'base', 'gitGraph': {'mainBranchName': 'main'}, 'themeVariables': { 'git0': '#1976D2', 'git1': '#43A047', 'gitBranchLabel0': '#fff', 'gitBranchLabel1': '#fff', 'commitLabelColor': '#333', 'commitLabelBackground': '#E3F2FD', 'commitLabelFontSize': '11px'}}}%%
gitGraph
    commit id: "feat: dashboard"
    branch feature/login
    commit id: "WIP login form"
    commit id: "fix typo"
    commit id: "fix typo again"
    commit id: "ok now it works"
    commit id: "added tests"
```

#### After squash

```mermaid
%%{init: {'theme': 'base', 'gitGraph': {'mainBranchName': 'main'}, 'themeVariables': { 'git0': '#1976D2', 'git1': '#43A047', 'gitBranchLabel0': '#fff', 'gitBranchLabel1': '#fff', 'commitLabelColor': '#333', 'commitLabelBackground': '#C8E6C9', 'commitLabelFontSize': '11px'}}}%%
gitGraph
    commit id: "feat: dashboard"
    branch feature/login
    commit id: "feat(login): implement login with tests"
```

#### How interactive rebase works

```bash
git rebase -i HEAD~4   # open interactive editor for last 4 commits
```

Git opens an editor with a list of commits. You change the word `pick` to `squash` (or `s`) for every commit you want to fold into the one above it:

```
pick  a1b2c3d WIP login form
squash b2c3d4e fix typo
squash c3d4e5f fix typo again
squash d4e5f6g ok now it works
pick  e5f6g7h added tests
```

After saving, Git opens a second editor to write the **combined commit message**.

> ⚠️ Squash rewrites history. Only squash commits that have **not been pushed** to a shared remote, or use with care and coordinate with your team.

---

### Strategy 3 — Cherry-pick

`git cherry-pick` copies a **single specific commit** (or a range) from any branch and applies it to the current branch. It does not merge anything — it just picks one commit.

```mermaid
%%{init: {'theme': 'base', 'gitGraph': {'mainBranchName': 'main'}, 'themeVariables': { 'git0': '#1976D2', 'git1': '#43A047', 'git2': '#F57C00', 'gitBranchLabel0': '#fff', 'gitBranchLabel1': '#fff', 'gitBranchLabel2': '#fff', 'commitLabelColor': '#333', 'commitLabelBackground': '#FFF3E0', 'commitLabelFontSize': '11px'}}}%%
gitGraph
    commit id: "A"
    commit id: "B"
    branch feature
    commit id: "C"
    commit id: "D 🍒"
    commit id: "E"
    checkout main
    commit id: "F"
    cherry-pick id: "D 🍒" 
```

✅ Surgical: bring only the fix you need without the whole branch.
✅ Useful to **backport a hotfix** from `main` to a release branch.
⚠️ Creates a duplicate commit with a new hash — can cause confusion if the branch is later fully merged.

```bash
git cherry-pick <commit-hash>            # pick one commit
git cherry-pick A..B                     # pick a range of commits
git cherry-pick --no-commit <hash>       # apply changes without committing (inspect first)
git cherry-pick --abort                  # cancel if a conflict is too complex
```

---

### Decision Guide

```mermaid
flowchart TD
    A["🤔 How should I integrate changes?"] --> B{"Has the branch\nbeen pushed/shared?"}
    B -->|No, it's local| C{"Do I want a\nclean linear history?"}
    B -->|Yes, it's shared| D["✅ git merge\n(safe, preserves history)"]
    C -->|Yes| E["✅ git rebase\nthen merge"]
    C -->|No| D
    A --> F{"Do I only need\none specific commit?"}
    F -->|Yes| G["🍒 git cherry-pick"]
```

| Strategy        | History shape             | Rewrites history | Safe on shared branches | Best for                           |
| --------------- | ------------------------- | ---------------- | ----------------------- | ---------------------------------- |
| `merge`         | Non-linear                | ❌ No             | ✅ Yes                   | Integrating features into `main`   |
| `merge --no-ff` | Non-linear + merge commit | ❌ No             | ✅ Yes                   | Preserving feature branch evidence |
| `rebase`        | Linear                    | ✅ Yes            | ⚠️ Local only           | Cleaning up before a PR/merge      |
| `cherry-pick`   | Adds one commit           | ✅ Yes (new hash) | ⚠️ Use carefully        | Backporting a specific fix         |

---

### Final Takeaway

> **Merge integrates.**  
> **Rebase reshapes.**  
> **Cherry-pick extracts.**
> 
> Each strategy changes the shape of your history.  
> Make the change intentionally.
