# Exercise 1: Git Basic Commands

## Goal
Learn the fundamental Git commands: `init`, `status`, `add`, `commit`, `log`, `diff`, `checkout`, `rm --cached`, `reset`.

> 💡 **Tip**: After every meaningful change, run these two commands to observe what happened:
> ```bash
> git status # display the state of the working directory and the staging area 
> git log --oneline --graph --all # display commit history
> ```
> This habit helps you build a mental model of what Git is doing under the hood.

---

## Exercise Flow

```mermaid
sequenceDiagram
    participant WD as 📁 Working Directory
    participant SA as 📋 Stage Area
    participant GIT as 📦 .git

    Note over WD,GIT: Step 1 — git init (create repo + copy file)
    Note over WD: 📄 project.txt → UNTRACKED

    Note over WD,GIT: Step 2 — First add & commit
    WD ->> SA: git add
    SA ->> GIT: git commit

    Note over WD,GIT: Step 3 — Modify & commit again
    Note over WD: ✏️ MODIFIED
    WD ->> SA: git add
    SA ->> GIT: git commit

    Note over WD,GIT: Step 4 — Navigate HEAD (checkout old commit & back)
    GIT -->> WD: git checkout <hash>
    GIT -->> WD: git checkout main

    Note over WD,GIT: Step 5 — Sensitive file mistake & history cleanup
    Note over WD: 🔑 credentials.txt
    WD ->> SA: git add (oops!)
    SA -->> WD: git rm --cached
    WD ->> SA: git add (deliberate)
    SA ->> GIT: git commit
    GIT -->> GIT: git reset (rewrite history)
```

---

## Step 1: Initialize a Repository

- Create a "my-project" folder
- Initialize a git repository

```bash
mkdir my-project
cd my-project
git init
```

This creates a hidden `.git/` folder — your local repository.

Run `git status` and `git log` to see the initial state. The log will be empty — there are no commits yet.

Now copy the file `project.txt` (from `02-exercises/01-basic-commands/`) into your `my-project` folder, then check the status:

```bash
git status
```

**Expected output**: you'll see `project.txt` listed as an **untracked** file.

Where are we in the Git areas? The file exists only in the Working Directory:

```mermaid
sequenceDiagram
    participant WD as 📁 Working Directory
    participant SA as 📋 Stage Area
    participant GIT as 📦 .git

    Note over WD: 📄 project.txt → UNTRACKED
```

---

## Step 2: Stage and Commit

Add the file to the Staging Area, then create the first commit:

```bash
git add project.txt
git status
```

You'll see the file is now listed under *Changes to be committed* — it's **STAGED**.

```bash
git commit -m "feat: add order project - initial version"
git status
git log --oneline --graph --all
```

The file has traveled across all three local areas:

```mermaid
sequenceDiagram
    participant WD as 📁 Working Directory
    participant SA as 📋 Stage Area
    participant GIT as 📦 .git

    Note over WD: 📄 UNTRACKED
    WD ->> SA: git add
    Note over SA: ✅ STAGED
    SA ->> GIT: git commit
    Note over GIT: 💾 COMMITTED
```

---

## Step 3: Modify and Commit Again

Open `project.txt` and append this section at the end:

```
FEATURES v1.0
-----------------
[ ] Create order
[ ] List orders
[ ] Order detail
```

Save the file, then check what changed:

```bash
git status
git diff
```

`git diff` shows the exact differences between the Working Directory and the last commit.

Now stage and commit:

```bash
git add project.txt
git status
git commit -m "feat: add feature list v1.0"
git log --oneline --graph --all
```

**Expected output**:
```
a1b2c3d (HEAD -> main) feat: add feature list v1.0
x9y8z7w feat: add order project - initial version
```

Notice **HEAD** — it's a pointer that tells you *where you are* in the commit history. Right now it points to the latest commit on `main`.

```mermaid
sequenceDiagram
    participant WD as 📁 Working Directory
    participant SA as 📋 Stage Area
    participant GIT as 📦 .git

    Note over WD: ✏️ MODIFIED
    WD ->> SA: git add
    Note over SA: ✅ STAGED
    SA ->> GIT: git commit
    Note over GIT: 💾 COMMITTED
```

---

## Step 4: Navigating History with HEAD

**HEAD** is Git's pointer to "where you are right now." Let's explore the history.

View the full log:
```bash
git log --oneline --graph --all
```

You'll see something like:
```
a1b2c3d (HEAD -> main) feat: add feature list v1.0
x9y8z7w feat: add order project - initial version
```

Now let's travel back in time. Copy the hash of the first commit and run:

```bash
git checkout <first-commit-hash>
```

Open `project.txt` — the file is back to its original version! The features section doesn't exist yet.

Check the log:
```bash
git log --oneline --graph --all
```

Notice that **HEAD** is no longer on `main` — you are in **detached HEAD** state. This means you're looking at an old snapshot, but you're not on any branch.

To go back to the latest version:

```bash
git checkout main
```

`project.txt` is back to its latest state. HEAD points to `main` again.

> ⚠️ **Detached HEAD** is read-only exploration. If you want to make changes from an old commit, you should create a branch (we'll learn that next!).

---

## Step 5: Mistakes Happen — Removing Sensitive Files

This is one of the most common (and dangerous) mistakes in real-world projects: accidentally adding a file with passwords, API keys, or tokens to Git.

### Part A: Remove a file from the Staging Area (before committing)

Create a file called `credentials.txt` with fake credentials:

```
DB_HOST=localhost
DB_USER=admin
DB_PASSWORD=super_secret_123
API_KEY=sk-abc123def456ghi789
```

Now accidentally stage it:

```bash
git add credentials.txt
git status
```

**Expected output**: `credentials.txt` is listed under *Changes to be committed* — it's **STAGED**.

Oops! We don't want to track this file. Remove it from the Staging Area **without deleting it from disk**:

```bash
git rm --cached credentials.txt
git status
```

**Expected output**: `credentials.txt` is back to **untracked**. The file is still on disk, but Git no longer knows about it.

```mermaid
sequenceDiagram
    participant WD as 📁 Working Directory
    participant SA as 📋 Stage Area
    participant GIT as 📦 .git

    Note over WD: 🔑 credentials.txt
    WD ->> SA: git add (oops!)
    Note over SA: ✅ STAGED
    SA -->> WD: git rm --cached
    Note over WD: 🔑 UNTRACKED (safe!)
```

> 💡 `git rm --cached <file>` removes a file from Git's tracking **but keeps it in your Working Directory**. It's the opposite of `git add`.

### Part B: What if you already committed it?

Let's simulate a worse scenario — committing the credentials file:

```bash
git add credentials.txt # (modify + stage)
git commit -m "add credentials"
git log --oneline --graph --all
```

The credentials are now **saved in a commit**. Let's try to fix it the naive way — delete the file and commit:

```bash
git rm credentials.txt
git commit -m "fix: remove credentials"
git log --oneline --graph --all
```

> 💡Quick note:
> ```bash
> # alternative: manually remove credentials.txt and then --> git add credentials.txt
> rm credentials.txt # delete the file locally (file is in "modified" state)
> git add credentials.txt
> git commit -m "fix: remove credentials"
> ```

The file is gone from the Working Directory. Problem solved? **Not at all.** Let's check:

```bash
git show HEAD~1:credentials.txt
```

> 💡Alternative:
> ```bash
> git show <second-last-commit-hash>:credentials.txt
> ```

**Your passwords are still in the Git history!** Anyone who clones this repository can see them. A new commit that deletes a file does NOT erase old commits — Git remembers everything.

```mermaid
sequenceDiagram
    participant H as 📜 History
    participant WD as 📁 Working Directory

    Note over H: commit: "add credentials" → 🔑 VISIBLE!
    Note over H: commit: "fix: remove credentials" → ❌ deleted
    Note over WD: 🔑 gone from disk
    Note over H: ⚠️ Still in history!
```

### Part C: Rewriting history with `git reset`

To truly remove those commits, we need to **rewrite history**. Go back 2 commits:

```bash
git reset --hard HEAD~2
```

This moves HEAD back by 2 commits and **erases** both the "add credentials" and "fix: remove credentials" commits.

```bash
git log --oneline --graph --all
```

The two commits are gone. The repository is back to where it was after Step 3.

> ⚠️ **`git reset --hard` is destructive** — it permanently removes commits and discards all uncommitted changes. Use it with caution, and **never on commits that were already pushed** to a shared remote.

### Part D: Prevention — `.gitignore`

The best fix is to **prevent the mistake entirely**. Create a `.gitignore` file:

```bash
echo credentials.txt > .gitignore
git add .gitignore
git commit -m "chore: add .gitignore to exclude credentials"
```

Now try:

```bash
echo "SECRET=oops" > credentials.txt
git status
```

**Expected output**: `credentials.txt` does NOT appear — it will NOT even show up among *untracked* files; Git ignores it completely.

> 💡 In real projects, always create a `.gitignore` **as one of your first commits**. Common entries: `.env`, `*.log`, `node_modules/`, `__pycache__/`, `*.secret`.

---

## Command Summary

| Command | Description |
|---------|-------------|
| `git init` | Initialize a repository |
| `git status` | Show the state of files |
| `git add <file>` | Add files to the staging area |
| `git add *` | Add all changed files |
| `git commit -m "msg"` | Create a commit |
| `git log --oneline --graph --all` | Show commit history |
| `git diff` | Show differences vs last commit |
| `git checkout <hash>` | Move HEAD to a specific commit |
| `git checkout main` | Return HEAD to the main branch |
| `git rm --cached <file>` | Unstage a file (keep on disk) |
| `git rm <file>` | Remove a file from repo and disk |
| `git reset --hard HEAD~N` | Rewrite history: remove last N commits |
| `git show <hash>:<file>` | View a file at a specific commit |
| `.gitignore` | File listing patterns Git should ignore |

---

## Extra Exercise (Optional): Your First Day at Work 💼

It's your first day as a developer at a startup. Your team lead gives you a series of tasks. You need to figure out the right Git commands on your own.

> 💡 Use `git status` and `git log --oneline --graph --all` after every task to verify.

---

### Scenario 1 — The Blog Engine

Your team is building a blog engine. Start fresh:

1. Create a folder called `blog-engine`, initialize a Git repo, and create a file called `README.md` with:
   ```
   # Blog Engine
   A simple static blog generator.
   ```
   Commit it.

2. Your team lead asks you to add a roadmap. Create `roadmap.md`:
   ```
   # Roadmap

   ## v1.0
   - Markdown rendering
   - Post listing

   ## v2.0
   - Tags and categories
   - Search
   ```
   Commit it.

3. A colleague asks: *"What exactly did you change between the first and second commit?"*
   Find the command that shows the differences between two specific commits (not just the last one).

---

### Scenario 2 — The Wrong File

The ops team sends you a database connection file to test locally. You save it as `db-config.env`:
```
MONGO_URI=mongodb+srv://admin:Rl$9kWq!@cluster0.example.net
REDIS_URL=redis://:hunter2@cache.internal:6379
```

4. You run `git add .` out of habit. Before committing, you realize `db-config.env` should NOT be tracked. Fix it — but keep it on disk.

5. Your lead says: *"Make sure this can never happen again."* Set up the project so that `*.env` files are always ignored by Git. Commit your solution.

---

### Scenario 3 — The Broken Deploy

You're developing the deploy script. Create `deploy.sh`:
```
#!/bin/bash
echo "Deploying to staging..."
TARGET=staging
```

7. Commit `deploy.sh`. Then edit it — change `TARGET=staging` to `TARGET=production` and also add a new line `echo "Done!"` at the end. **Before staging**, inspect the exact changes you made.

8. Your lead reviews your changes and says: *"I only see the final version. How can I see what the file looked like in the first commit without losing my current work?"* Show the file at a specific commit without switching branches.

---

### Scenario 4 — The Disaster Recovery

A junior developer made a mess. Simulate it:

9. Create a file called `passwords.txt` with some fake passwords and commit it.
10. Realize the mistake, delete the file, and commit the deletion.
11. Your security team asks: *"Are the passwords truly gone from the repository?"* Prove they are still accessible and explain why.
12. Clean up: erase both commits so the repository has no trace of `passwords.txt`.
13. After the cleanup, add `passwords.txt` to your `.gitignore` as a preventive measure. Commit the change.

---

### Scenario 5 — The Time Traveler

14. You now have multiple commits. Your lead asks you to review the state of the project at the very first commit. Navigate there, verify the files, then come back to the latest version. What warning did Git give you when you went back?

---

### Bonus Challenges 🏆

15. **Selective staging**: Create two new files (`analytics.md` and `metrics.md`). Stage and commit them in **two separate commits** with different messages — one file per commit.

16. **The audit trail**: Without opening any file, determine how many commits exist in the repo and list every filename that was ever committed (even if later deleted). *(Hint: explore `git log` flags.)*

17. **The undo puzzle**: You edit `README.md` and stage the change, but then change your mind. How do you unstage it without losing the edit? And how do you also discard the edit entirely, restoring the last committed version?

---

## Next Step

➡️ Go to the [Branches exercise](../02-branches/branches-walkthrough.md)

---

## Deep Dive — Alternatives to `git reset --hard HEAD~2`

Below you'll find some common alternatives to `git reset --hard HEAD~2`, with a brief note on when to use each.

- `git reset --hard <commit>`
    ```bash
    git reset --hard HEAD~2
    # or use the commit hash
    git reset --hard a1b2c3d
    ```
    Use: locally deletes the last commits and discards all changes (destructive).

- `git reset --mixed HEAD~2`
    ```bash
    git reset --mixed HEAD~2
    ```
    Use: moves HEAD back by 2 commits but leaves changes in the working tree (unstaged).

- `git reset --soft HEAD~2`
    ```bash
    git reset --soft HEAD~2
    ```
    Use: moves HEAD back but keeps changes as staged (useful for combining commits or rewriting messages).

- `git revert --no-commit HEAD~2..HEAD && git commit -m "Revert last 2 commits"`
    ```bash
    git revert --no-commit HEAD~2..HEAD
    git commit -m "Revert last 2 commits"
    ```
    Use: cancels the last commits by creating new revert commits — safe on repositories already pushed.

- Interactive rebase (modify or remove individual commits)
    ```bash
    git rebase -i HEAD~3
    # in the editor: use `drop` or remove the lines of commits to delete
    ```
    Use: clean up or reorganize local commits before pushing; rewrites history.

- `git reflog` + `git reset --hard <ref>`
    ```bash
    git reflog
    git reset --hard HEAD@{3}
    ```
    Use: find a previous state and optionally return to it (useful for recovery).

- Remove sensitive files from history (dedicated tools)
    ```bash
    # example with git-filter-repo (recommended over filter-branch)
    git filter-repo --path credentials.txt --invert-paths
    git push --force
    ```
    Use: remove files/secrets from entire history; requires force-push and team coordination.

---

Quick warnings:
- `reset --hard` and `rebase` rewrite history: don't use them on commits already shared without coordination (may require `git push --force`).
- If problem commits are already on a public remote, prefer `git revert` or coordinate a force-push with your team.

