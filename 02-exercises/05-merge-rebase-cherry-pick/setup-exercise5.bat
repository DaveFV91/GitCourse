@echo off
REM ============================================================
REM  setup-exercise4.bat
REM  Creates "integration-project" with a realistic commit history
REM  for the Merge vs Rebase vs Cherry-pick exercise
REM ============================================================

echo.
echo  ============================================================
echo   Git Advanced - Exercise 4 Setup
echo   Creating "integration-project" repository...
echo  ============================================================
echo.

REM --- Clean up any previous run ---
if exist integration-project (
    echo  [!] Removing existing "integration-project" folder...
    rmdir /s /q integration-project
)

REM --- Create repo ---
mkdir integration-project
cd integration-project
git init
git config user.name "Dev User"
git config user.email "dev@example.com"

REM -------------------------------------------------------
REM  COMMIT 1 — homepage base (this will be the common ancestor)
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
echo [ ] Search
) > index.txt
git add index.txt
git commit -m "feat: initial homepage structure"

REM -------------------------------------------------------
REM  BRANCH: feature/navbar — diverges from first commit
REM -------------------------------------------------------
git checkout -b feature/navbar

(
echo NAVBAR COMPONENT
echo ================
echo Links: Home, About, Contact
echo Active state: false
) > navbar.txt
git add navbar.txt
git commit -m "feat: add navbar component"

(
echo NAVBAR COMPONENT
echo ================
echo Links: Home, About, Contact
echo Active state: true
echo Highlight: current page
) > navbar.txt
git add navbar.txt
git commit -m "feat: navbar active state indicator"

REM -------------------------------------------------------
REM  Back to main — add a commit so it diverges from feature/navbar
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
git commit -m "chore: update application config"

REM -------------------------------------------------------
REM  BRANCH: feature/footer — diverges from main after config commit
REM  (will be used for rebase demo)
REM -------------------------------------------------------
git checkout -b feature/footer

(
echo FOOTER COMPONENT
echo ================
echo Copyright: 2026 My App
echo Links: Privacy, Terms
) > footer.txt
git add footer.txt
git commit -m "feat: add footer component"

(
echo FOOTER COMPONENT
echo ================
echo Copyright: 2026 My App
echo Links: Privacy, Terms, Contact
echo Social: Twitter, GitHub
) > footer.txt
git add footer.txt
git commit -m "feat: add footer social links"

REM -------------------------------------------------------
REM  Back to main — add hotfix branch for fast-forward demo
REM  (branches off from the CURRENT tip of main after the merge)
REM  We can't actually do the merge here, so we create it now
REM  and it will be fast-forward because main won't advance before the demo
REM -------------------------------------------------------
git checkout main

git checkout -b hotfix/button-color

(
echo /* Button styles */
echo .btn-primary { background: #1976D2; color: #fff; }
echo .btn-secondary { background: #43A047; color: #fff; }
) > styles.css
git add styles.css
git commit -m "fix: correct button color values"

REM -------------------------------------------------------
REM  Back to main — add release/v1.0 branch to simulate backport
REM -------------------------------------------------------
git checkout main

(
echo WEBSITE: My App
echo ==============================
echo Version: 1.0.0
echo.
echo PAGES
echo -----
echo [x] Homepage
echo [x] Navbar
echo [x] Footer
echo [ ] Search
) > index.txt
git add index.txt
git commit -m "feat: homepage updated with module status"

REM --- Cut the v1.0 release branch ---
git checkout -b release/v1.0
git tag -a v1.0.0 -m "Release version 1.0.0"

REM -------------------------------------------------------
REM  Back to main — add commits AFTER the release cut
REM  including a critical fix that will be cherry-picked
REM -------------------------------------------------------
git checkout main

(
echo SEARCH COMPONENT
echo ================
echo Input: text
echo Filter: title, tags
) > search.txt
git add search.txt
git commit -m "feat: add search component"

REM Critical fix — this will be cherry-picked onto release/v1.0
(
echo AUTH MODULE
echo ===========
echo login(): validates user
echo logout(): clears session
echo checkToken(): never returns null now
) > auth.txt
git add auth.txt
git commit -m "fix: critical null pointer in auth"

(
echo ANALYTICS MODULE
echo ================
echo pageview: tracked
echo events: tracked
) > analytics.txt
git add analytics.txt
git commit -m "feat: add analytics module"

REM --- Return to main ---
git checkout main

echo.
echo  ============================================================
echo   Done! Repository structure:
echo.
git log --oneline --graph --all
echo.
echo   Branches available:
git branch
echo.
echo   Tags:
git tag
echo.
echo   Ready for Exercise 4.
echo  ============================================================
echo.
