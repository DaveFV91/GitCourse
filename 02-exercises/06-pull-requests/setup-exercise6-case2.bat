@echo off
REM ============================================================
REM  setup-exercise6-case2.bat
REM  Creates "ex6-case2":
REM
REM  Simulates the squash merge trap:
REM    - feature/A (3 commits) was squash-merged into main
REM      producing a single commit "S: squash of feature/A"
REM    - feature/B was branched from feature/A BEFORE the merge
REM      and still carries the original A-1, A-2, A-3 commits
REM    - Result: feature/B is simultaneously ahead (A-1, A-2, A-3, B-1, B-2)
REM      and behind (S) main, even though module.txt is identical
REM
REM  Student goal:
REM    1. Observe the problem (git log main..feature/B and vice versa)
REM    2. Verify that module.txt content is identical on both branches
REM    3. Fix with: git checkout feature/B && git rebase main
REM    4. Verify that feature/B is now only ahead (B-1, B-2) with 0 behind
REM ============================================================

echo.
echo  ============================================================
echo   Git Advanced - Exercise 6 / Case 2
echo   Topic: The Squash Merge Trap (ahead + behind on same content)
echo   Creating "ex6-case2" repository...
echo  ============================================================
echo.

if exist ex6-case2 (
    echo  [!] Removing existing "ex6-case2" folder...
    rmdir /s /q ex6-case2
)

mkdir ex6-case2
cd ex6-case2
git init
git config user.name "Dev User"
git config user.email "dev@example.com"

REM -------------------------------------------------------
REM  COMMIT 1 — common base on main
REM -------------------------------------------------------
(
echo MODULE: Authentication
echo ======================
echo Status: planned
) > module.txt
(
echo APP: My Application
echo Version: 1.0.0
) > index.txt
git add module.txt index.txt
git commit -m "feat: initial setup"

REM -------------------------------------------------------
REM  BRANCH: feature/A — 3 commits
REM  (These are the commits that will be squash-merged)
REM -------------------------------------------------------
git checkout -b feature/A

(
echo MODULE: Authentication
echo ======================
echo Status: in progress
echo.
echo FUNCTIONS
echo ---------
echo login^(^):   stub
echo logout^(^):  stub
) > module.txt
git add module.txt
git commit -m "A-1: add module skeleton"

(
echo MODULE: Authentication
echo ======================
echo Status: in progress
echo.
echo FUNCTIONS
echo ---------
echo login^(^):   validates username and password, returns JWT
echo logout^(^):  invalidates token, clears session
echo getUser^(^): returns current user from token
) > module.txt
git add module.txt
git commit -m "A-2: implement logic"

(
echo MODULE: Authentication
echo ======================
echo Status: complete
echo.
echo FUNCTIONS
echo ---------
echo login^(^):   validates username and password, returns JWT
echo logout^(^):  invalidates token, clears session
echo getUser^(^): returns current user from token
echo.
echo TESTS
echo -----
echo [x] login with valid credentials
echo [x] login with invalid credentials
echo [x] logout clears session
echo [x] getUser returns correct user
) > module.txt
git add module.txt
git commit -m "A-3: add tests"

REM -------------------------------------------------------
REM  BRANCH: feature/B — branches from feature/A BEFORE merge
REM  This is the mistake: depending on an unmerged branch
REM -------------------------------------------------------
git checkout -b feature/B

(
echo MODULE: Authentication
echo ======================
echo Status: complete
echo.
echo FUNCTIONS
echo ---------
echo login^(^):   validates username and password, returns JWT
echo logout^(^):  invalidates token, clears session
echo getUser^(^): returns current user from token
echo refreshToken^(^): issues a new JWT if current is valid
echo.
echo TESTS
echo -----
echo [x] login with valid credentials
echo [x] login with invalid credentials
echo [x] logout clears session
echo [x] getUser returns correct user
echo [x] refreshToken returns new token
) > module.txt
git add module.txt
git commit -m "B-1: extend module"

(
echo INTEGRATION TESTS
echo =================
echo [x] full login-refresh-logout cycle
echo [x] expired token is rejected
echo [x] concurrent sessions handled correctly
) > integration-tests.txt
git add integration-tests.txt
git commit -m "B-2: add integration test"

REM -------------------------------------------------------
REM  Back to main — SQUASH MERGE feature/A
REM  This simulates what Azure DevOps does with "Squash commit"
REM  git merge --squash collapses all commits into staged changes
REM  then we commit manually → produces ONE new commit with a NEW hash
REM -------------------------------------------------------
git checkout main
git merge --squash feature/A
git commit -m "S: squash of feature/A"

REM --- feature/A can now be deleted (as ADO would do) ---
git branch -d feature/A

echo.
echo  ============================================================
echo   Done! Starting state for Case 2:
echo.
git log --oneline --graph --all
echo.
echo   Observe the problem:
echo   -- Commits in feature/B not in main (ahead):
git log main..feature/B --oneline
echo   -- Commits in main not in feature/B (behind):
git log feature/B..main --oneline
echo.
echo   Check that module.txt content is IDENTICAL on both branches:
echo   [main]      last line:
git show main:module.txt | findstr "Status"
echo   [feature/B] last line:
git show feature/B:module.txt | findstr "Status"
echo.
echo   Your goal:
echo   git checkout feature/B
echo   git rebase main
echo   git log main..feature/B --oneline   (should show only B-1 and B-2)
echo   git log feature/B..main --oneline   (should be empty)
echo  ============================================================
echo.
