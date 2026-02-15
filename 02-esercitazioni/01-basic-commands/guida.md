# Exercise 1: Git Basic Commands

## Goal
Learn the fundamental Git commands: `init`, `status`, `add`, `commit`, `log`, `diff`, `checkout`.

> 💡 **Tip**: After every meaningful change, run these two commands to observe what happened:
> ```bash
> git status
> git log --oneline --graph --all
> ```
> This habit helps you build a mental model of what Git is doing under the hood.

---

## Exercise Flow

:::mermaid
sequenceDiagram
    participant WD as 📁 Working Directory
    participant SA as 📋 Stage Area
    participant GIT as 📦 .git

    Note over WD,GIT: Step 1 — git init (create repo + copy file)
    Note over WD: 📄 progetto.txt → UNTRACKED

    Note over WD,GIT: Step 2 — First add & commit
    WD ->> SA: git add
    SA ->> GIT: git commit

    Note over WD,GIT: Step 3 — Modify & commit again
    Note over WD: ✏️ MODIFIED
    WD ->> SA: git add
    SA ->> GIT: git commit

    Note over WD,GIT: Step 4 — New file + modify & commit
    Note over WD: ✏️ MODIFIED + 📄 UNTRACKED
    WD ->> SA: git add *
    SA ->> GIT: git commit

    Note over WD,GIT: Step 5 — Navigate HEAD (checkout old commit & back)
    GIT -->> WD: git checkout ‹hash›
    GIT -->> WD: git checkout main
:::

---

## Step 1: Initialize a Repository

Navigate to the parent folder of this course repo and create a new project folder:

```bash
cd ..
mkdir repos
cd repos
mkdir my-project
cd my-project
git init
```

This creates a hidden `.git/` folder — your local repository. Open it with VS Code:

```bash
code .
```

Run `git status` and `git log` to see the initial state. The log will be empty — there are no commits yet.

Now copy the file `progetto.txt` (from `02-esercitazioni/01-basic-commands/`) into your `my-project` folder, then check the status:

```bash
git status
```

**Expected output**: you'll see `progetto.txt` listed as an **untracked** file.

Where are we in the Git areas? The file exists only in the Working Directory:

:::mermaid
sequenceDiagram
    participant WD as 📁 Working Directory
    participant SA as 📋 Stage Area
    participant GIT as 📦 .git

    Note over WD: 📄 progetto.txt → UNTRACKED
:::

---

## Step 2: Stage and Commit

Add the file to the Staging Area, then create the first commit:

```bash
git add progetto.txt
git status
```

You'll see the file is now listed under *Changes to be committed* — it's **STAGED**.

```bash
git commit -m "feat: add order project - initial version"
git status
git log --oneline --graph --all
```

The file has traveled across all three local areas:

:::mermaid
sequenceDiagram
    participant WD as 📁 Working Directory
    participant SA as 📋 Stage Area
    participant GIT as 📦 .git

    Note over WD: 📄 UNTRACKED
    WD ->> SA: git add
    Note over SA: ✅ STAGED
    SA ->> GIT: git commit
    Note over GIT: 💾 COMMITTED
:::

---

## Step 3: Modify and Commit Again

Open `progetto.txt` and append this section at the end:

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
git add progetto.txt
git commit -m "feat: add feature list v1.0"
git log --oneline --graph --all
```

**Expected output**:
```
a1b2c3d (HEAD -> main) feat: add feature list v1.0
x9y8z7w feat: add order project - initial version
```

Notice **HEAD** — it's a pointer that tells you *where you are* in the commit history. Right now it points to the latest commit on `main`.

---

## Step 4: Another Modification + New File

Edit `progetto.txt` — mark the first feature as completed:

```
FEATURES v1.0
-----------------
[x] Create order        <- DONE!
[ ] List orders
[ ] Order detail
```

Also create a new empty file called `notes.txt`.

Now stage **both files at once** and commit:

```bash
git add *
git commit -m "feat: implement create order + add notes file"
git status
git log --oneline --graph --all
```

The cycle repeats — each modify/add/commit moves your changes through the areas:

:::mermaid
sequenceDiagram
    participant WD as 📁 Working Directory
    participant SA as 📋 Stage Area
    participant GIT as 📦 .git

    Note over WD: ✏️ MODIFIED + 📄 UNTRACKED
    WD ->> SA: git add *
    Note over SA: ✅ STAGED (both files)
    SA ->> GIT: git commit
    Note over GIT: 💾 COMMITTED
    Note over WD,GIT: ✏️ Edit → MODIFIED | git add → STAGED | git commit → COMMITTED | cycle repeats ↩
:::

---

## Step 5: Navigating History with HEAD

**HEAD** is Git's pointer to "where you are right now." Let's explore the history.

View the full log:
```bash
git log --oneline --graph --all
```

You'll see something like:
```
c3d4e5f (HEAD -> main) feat: implement create order + add notes file
a1b2c3d feat: add feature list v1.0
x9y8z7w feat: add order project - initial version
```

Now let's travel back in time. Copy the hash of the first commit and run:

```bash
git checkout <first-commit-hash>
```

Open `progetto.txt` — the file is back to its original version! The features section doesn't exist yet.

Check the log:
```bash
git log --oneline --graph --all
```

Notice that **HEAD** is no longer on `main` — you are in **detached HEAD** state. This means you're looking at an old snapshot, but you're not on any branch.

To go back to the latest version:

```bash
git checkout main
```

`progetto.txt` is back to its latest state. HEAD points to `main` again.

> ⚠️ **Detached HEAD** is read-only exploration. If you want to make changes from an old commit, you need to create a branch (we'll learn that next!).

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

---

## Extra Exercise (Optional)

1. Add some text to `notes.txt` and commit
2. Modify **both** `progetto.txt` and `notes.txt`
3. Stage and commit **only one** of them
4. Run `git status` — what state is each file in?
5. Commit the remaining file

---

## Next Step

➡️ Go to the [Branches exercise](../02-branches/guida.md)
