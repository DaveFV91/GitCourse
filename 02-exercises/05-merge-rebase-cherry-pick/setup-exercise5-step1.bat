@echo off
REM ============================================================
REM  setup-exercise5-step1.bat
REM  Creates "ex5-step1":
REM    main:           feat: initial homepage  ->  chore: update config
REM    feature/navbar: feat: add navbar  ->  feat: navbar active state
REM  (branches diverged from "feat: initial homepage")
REM ============================================================

echo.
echo  ============================================================
echo   Git Advanced - Exercise 5 / Step 1
echo   Topic: Merge with merge commit (--no-ff)
echo   Creating "ex5-step1" repository...
echo  ============================================================
echo.

if exist ex5-step1 (
    echo  [!] Removing existing "ex5-step1" folder...
    rmdir /s /q ex5-step1
)

mkdir ex5-step1
cd ex5-step1
git init
git config user.name "Dev User"
git config user.email "dev@example.com"

REM -------------------------------------------------------
REM  COMMIT 1 — common ancestor (both branches start here)
REM -------------------------------------------------------
(
echo WEBSITE: My App
echo ==============================
echo Version: 1.0.0
echo.
echo PAGES
echo -----
echo [x] Homepage
echo [ ] Navbar
echo [ ] Footer
) > index.txt
git add index.txt
git commit -m "feat: initial homepage"

REM -------------------------------------------------------
REM  BRANCH: feature/navbar
REM  Diverges from commit 1
REM -------------------------------------------------------
git checkout -b feature/navbar

(
echo NAVBAR COMPONENT
echo ================
echo Links: Home, About, Contact
echo Active state: false
) > navbar.txt
git add navbar.txt
git commit -m "feat: add navbar"

(
echo NAVBAR COMPONENT
echo ================
echo Links: Home, About, Contact
echo Active state: true
echo Highlight: current page
) > navbar.txt
git add navbar.txt
git commit -m "feat: navbar active state"

REM -------------------------------------------------------
REM  Back to main — add a commit to diverge from feature/navbar
REM  This makes fast-forward impossible: a merge commit is required
REM -------------------------------------------------------
git checkout main

(
echo APP CONFIG
echo ==============================
echo VERSION=1.0.0
echo DEBUG=false
echo API_URL=https://api.myapp.com
) > config.txt
git add config.txt
git commit -m "chore: update config"

echo.
echo  ============================================================
echo   Done! Starting state for Step 1:
echo.
git log --oneline --graph --all
echo.
echo   Your goal:
echo   git merge --no-ff feature/navbar -m "merge: integrate navbar feature"
echo  ============================================================
echo.
