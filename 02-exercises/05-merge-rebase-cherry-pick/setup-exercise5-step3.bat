@echo off
REM ============================================================
REM  setup-exercise5-step3.bat
REM  Creates "ex5-step3":
REM    main:           feat: initial homepage  ->  chore: update config
REM                    ->  fix: button color values  ->  feat: add search
REM    feature/footer: feat: add footer  ->  feat: footer social links
REM  feature/footer diverges from the FIRST commit (very old base)
REM  -> rebase will replay footer commits on top of current main tip
REM ============================================================

echo.
echo  ============================================================
echo   Git Advanced - Exercise 5 / Step 3
echo   Topic: Rebase + fast-forward merge
echo   Creating "ex5-step3" repository...
echo  ============================================================
echo.

if exist ex5-step3 (
    echo  [!] Removing existing "ex5-step3" folder...
    rmdir /s /q ex5-step3
)

mkdir ex5-step3
cd ex5-step3
git init
git config user.name "Dev User"
git config user.email "dev@example.com"

REM -------------------------------------------------------
REM  COMMIT 1 — common ancestor (feature/footer will branch from here)
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
REM  BRANCH: feature/footer  (diverges from commit 1)
REM  Developed in isolation while main moved on
REM -------------------------------------------------------
git checkout -b feature/footer

(
echo FOOTER COMPONENT
echo ================
echo Copyright: 2026 My App
echo Links: Privacy, Terms
) > footer.txt
git add footer.txt
git commit -m "feat: add footer"

(
echo FOOTER COMPONENT
echo ================
echo Copyright: 2026 My App
echo Links: Privacy, Terms, Contact
echo Social: Twitter, GitHub, LinkedIn
) > footer.txt
git add footer.txt
git commit -m "feat: footer social links"

REM -------------------------------------------------------
REM  Back to main — add 3 commits to move main far ahead
REM  feature/footer will need to be rebased onto these
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

(
echo /* Button styles */
echo .btn-primary   { background: #1976D2; color: #ffffff; }
echo .btn-secondary { background: #43A047; color: #ffffff; }
echo .btn-danger    { background: #E53935; color: #ffffff; }
) > styles.css
git add styles.css
git commit -m "fix: button color values"

(
echo SEARCH COMPONENT
echo ================
echo Input: text field
echo Filter: title, tags, author
echo Results: paginated
) > search.txt
git add search.txt
git commit -m "feat: add search"

echo.
echo  ============================================================
echo   Done! Starting state for Step 3:
echo.
git log --oneline --graph --all
echo.
echo   Your goal (Phase A):
echo   git checkout feature/footer
echo   git rebase main
echo.
echo   Your goal (Phase B):
echo   git checkout main
echo   git merge feature/footer
echo  ============================================================
echo.
