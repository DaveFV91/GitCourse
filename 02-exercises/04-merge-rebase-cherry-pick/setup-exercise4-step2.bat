@echo off
REM ============================================================
REM  setup-exercise4-step2.bat
REM  Creates "ex4-step2":
REM    main:                 feat: initial homepage  ->  chore: update config
REM    hotfix/button-color:  fix: button color values
REM  hotfix branches from the CURRENT TIP of main (chore: update config)
REM  -> main has NO new commits after the branch -> fast-forward is possible
REM ============================================================

echo.
echo  ============================================================
echo   Git Advanced - Exercise 5 / Step 2
echo   Topic: Fast-forward merge
echo   Creating "ex4-step2" repository...
echo  ============================================================
echo.

if exist ex4-step2 (
    echo  [!] Removing existing "ex4-step2" folder...
    rmdir /s /q ex4-step2
)

mkdir ex4-step2
cd ex4-step2
git init
git config user.name "Dev User"
git config user.email "dev@example.com"

REM -------------------------------------------------------
REM  COMMIT 1
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
REM  COMMIT 2 — tip of main (hotfix will branch from here)
REM -------------------------------------------------------
(
echo APP CONFIG
echo ==============================
echo VERSION=1.0.0
echo DEBUG=false
echo API_URL=https://api.myapp.com
) > config.txt
git add config.txt
git commit -m "chore: update config"

REM -------------------------------------------------------
REM  BRANCH: hotfix/button-color
REM  Branches from the current tip of main.
REM  main will NOT receive any new commits after this point
REM  -> git merge hotfix/button-color will be a fast-forward
REM -------------------------------------------------------
git checkout -b hotfix/button-color

(
echo /* Button styles */
echo .btn-primary   { background: #1976D2; color: #ffffff; }
echo .btn-secondary { background: #43A047; color: #ffffff; }
echo .btn-danger    { background: #E53935; color: #ffffff; }
) > styles.css
git add styles.css
git commit -m "fix: button color values"

REM --- Return to main (do NOT add any commit here — that would break FF) ---
git checkout main

echo.
echo  ============================================================
echo   Done! Starting state for Step 2:
echo.
git log --oneline --graph --all
echo.
echo   Your goal:
echo   git merge hotfix/button-color
echo   (observe: Git prints "Fast-forward", no merge commit created)
echo  ============================================================
echo.
