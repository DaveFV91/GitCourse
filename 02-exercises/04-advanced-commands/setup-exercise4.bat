@echo off
REM ============================================================
REM  setup-exercise3.bat
REM  Creates "advanced-project" with a realistic commit history
REM  for the Tags / Stash / Squash / Reflog / Conflicts exercise
REM ============================================================

echo.
echo  ============================================================
echo   Git Advanced - Exercise 4 Setup
echo   Creating "advanced-project" repository...
echo  ============================================================
echo.

REM --- Clean up any previous run ---
if exist advanced-project (
    echo  [!] Removing existing "advanced-project" folder...
    rmdir /s /q advanced-project
)

REM --- Create repo ---
mkdir advanced-project
cd advanced-project
git init
git config user.name "Dev User"
git config user.email "dev@example.com"

REM -------------------------------------------------------
REM  COMMIT 1 — app.txt initial version
REM -------------------------------------------------------
(
echo APP: My Application
echo ==============================
echo Version: 1.0.0
echo.
echo MODULES
echo -------
echo [x] Authentication
echo [ ] Dashboard
echo [ ] Reports
echo [ ] Export
echo.
echo ENVIRONMENT=development
) > app.txt
git add app.txt
git commit -m "feat: initial application structure"

REM -------------------------------------------------------
REM  COMMIT 2 — login module
REM -------------------------------------------------------
(
echo APP: My Application
echo ==============================
echo Version: 1.0.0
echo.
echo MODULES
echo -------
echo [x] Authentication
echo [x] Login form
echo [ ] Dashboard
echo [ ] Reports
echo [ ] Export
echo.
echo ENVIRONMENT=development
) > app.txt
git add app.txt
git commit -m "feat: implement login form"

REM -------------------------------------------------------
REM  COMMIT 3 — config file
REM -------------------------------------------------------
(
echo APP CONFIG
echo ==============================
echo VERSION=1.0.0
echo DB_HOST=localhost
echo DB_PORT=5432
echo DB_NAME=app_db
echo LOG_LEVEL=DEBUG
) > config.txt
git add config.txt
git commit -m "chore: add application config file"

REM -------------------------------------------------------
REM  COMMIT 4 — dashboard (this will become v1.0.0 tag)
REM -------------------------------------------------------
(
echo APP: My Application
echo ==============================
echo Version: 1.0.0
echo.
echo MODULES
echo -------
echo [x] Authentication
echo [x] Login form
echo [x] Dashboard
echo [ ] Reports
echo [ ] Export
echo.
echo ENVIRONMENT=development
) > app.txt
git add app.txt
git commit -m "feat: add dashboard"

REM -------------------------------------------------------
REM  BRANCH: feature/reports — messy WIP commits to squash
REM -------------------------------------------------------
git checkout -b feature/reports

(
echo REPORTS MODULE
echo ==============
echo Status: stub
) > reports.txt
git add reports.txt
git commit -m "add reports stub"

(
echo REPORTS MODULE
echo ==============
echo Status: in progress
echo.
echo [ ] Monthly summary
echo [ ] Export to CSV
) > reports.txt
git add reports.txt
git commit -m "WIP reports page"

echo. >> reports.txt
git add reports.txt
git commit -m "forgot semicolon"

(
echo REPORTS MODULE
echo ==============
echo Status: complete
echo.
echo [x] Monthly summary
echo [x] Export to CSV
echo.
echo Tests: passing
) > reports.txt
git add reports.txt
git commit -m "fix tests again"

REM -------------------------------------------------------
REM  BRANCH: feature/export — will conflict with main on app.txt
REM -------------------------------------------------------
git checkout main

(
echo APP: My Application
echo ==============================
echo Version: 1.1.0
echo.
echo MODULES
echo -------
echo [x] Authentication
echo [x] Login form
echo [x] Dashboard
echo [x] Reports
echo [ ] Export
echo.
echo ENVIRONMENT=development
) > app.txt
git add app.txt
git commit -m "feat: add reports page to main"

git checkout -b feature/export

(
echo APP: My Application
echo ==============================
echo Version: 1.1.0
echo.
echo MODULES
echo -------
echo [x] Authentication
echo [x] Login form
echo [x] Dashboard
echo [x] Reports
echo [x] Export
echo.
echo ENVIRONMENT=development
) > app.txt
(
echo EXPORT MODULE
echo =============
echo Formats: CSV, JSON, PDF
) > export.txt
git add app.txt export.txt
git commit -m "feat: add export module"

REM --- Return to main ---
git checkout main

echo.
echo  ============================================================
echo   Done! Repository structure:
echo.
git log --oneline --graph --all
echo.
echo   Ready for Exercise 4.
echo  ============================================================
echo.
