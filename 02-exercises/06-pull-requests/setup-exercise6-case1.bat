@echo off
REM ============================================================
REM  setup-exercise6-case1.bat
REM  Creates "ex6-case1":
REM    A realistic repo where passwords.txt was committed in
REM    "feat: add login", then deleted in "fix: remove passwords file".
REM    The file no longer exists on disk, but is still readable
REM    in the Git history. Several commits exist after the deletion.
REM
REM  Student goal:
REM    1. Find which commit introduced passwords.txt
REM       (git log --all --full-history --oneline -- passwords.txt)
REM    2. Purge it from every commit
REM       (git filter-repo --path passwords.txt --invert-paths)
REM    3. Verify it is gone and inspect the rewritten history
REM ============================================================

echo.
echo  ============================================================
echo   Git Advanced - Exercise 6 / Case 1
echo   Topic: Purge a deleted file from full Git history
echo   Creating "ex6-case1" repository...
echo  ============================================================
echo.

if exist ex6-case1 (
    echo  [!] Removing existing "ex6-case1" folder...
    rmdir /s /q ex6-case1
)

mkdir ex6-case1
cd ex6-case1
git init
git config user.name "Dev User"
git config user.email "dev@example.com"

REM -------------------------------------------------------
REM  COMMIT 1 — clean initial setup
REM -------------------------------------------------------
(
echo APP: My Application
echo ==============================
echo Version: 1.0.0
echo.
echo MODULES
echo -------
echo [ ] Authentication
echo [ ] Dashboard
echo [ ] Reports
) > index.txt
git add index.txt
git commit -m "feat: initial setup"

REM -------------------------------------------------------
REM  COMMIT 2 — database config (clean)
REM -------------------------------------------------------
(
echo DB CONFIG
echo ==============================
echo HOST=localhost
echo PORT=5432
echo NAME=app_db
) > db.txt
git add db.txt
git commit -m "chore: add db config"

REM -------------------------------------------------------
REM  COMMIT 3 — passwords.txt accidentally committed HERE
REM  This is the commit students need to find
REM -------------------------------------------------------
(
echo AUTH MODULE
echo ===========
echo login^(^):   validates username and password
echo logout^(^):  clears session token
echo getUser^(^): returns current user or null
) > auth.txt
(
echo DB_PASSWORD=S3cr3tP4ssw0rd!
echo API_KEY=sk-prod-abc123def456ghi789jkl012
echo JWT_SECRET=my-super-secret-jwt-key-do-not-share
echo ADMIN_TOKEN=admin-bearer-xyz987
) > passwords.txt
git add auth.txt passwords.txt
git commit -m "feat: add login"

REM -------------------------------------------------------
REM  COMMIT 4 — dashboard (clean, passwords.txt still present)
REM -------------------------------------------------------
(
echo DASHBOARD MODULE
echo ================
echo Widgets: KPI cards, activity chart, alerts
echo Data source: REST API
) > dashboard.txt
git add dashboard.txt
git commit -m "feat: add dashboard"

REM -------------------------------------------------------
REM  COMMIT 5 — someone notices and deletes the file
REM  But: the history still contains commits 3 and 4 with the secret
REM -------------------------------------------------------
git rm passwords.txt
git commit -m "fix: remove passwords file"

REM -------------------------------------------------------
REM  COMMIT 6 — life goes on, more commits after the deletion
REM -------------------------------------------------------
(
echo REPORTS MODULE
echo ==============
echo Status: complete
echo Formats: PDF, CSV, JSON
) > reports.txt
git add reports.txt
git commit -m "feat: add reports"

REM -------------------------------------------------------
REM  COMMIT 7
REM -------------------------------------------------------
(
echo EXPORT MODULE
echo =============
echo Formats: CSV, JSON
echo Schedule: daily at 02:00
) > export.txt
git add export.txt
git commit -m "feat: add export"

echo.
echo  ============================================================
echo   Done! Starting state for Case 1:
echo.
git log --oneline --graph --all
echo.
echo   Note: passwords.txt does NOT exist on disk.
echo   But try: git show HEAD~4:passwords.txt
echo   The secret is still in history!
echo.
echo   Your goal:
echo   1. git log --all --full-history --oneline -- passwords.txt
echo   2. pip install git-filter-repo  (if not installed)
echo   3. git filter-repo --path passwords.txt --invert-paths --force
echo   4. git log --all --full-history --oneline -- passwords.txt
echo  ============================================================
echo.
