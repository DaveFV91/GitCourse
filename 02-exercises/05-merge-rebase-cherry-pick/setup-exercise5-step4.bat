@echo off
REM ============================================================
REM  setup-exercise5-step4.bat
REM  Creates "ex5-step4":
REM    main:          feat: initial homepage  ->  feat: add login
REM                   ->  feat: add dashboard (tag: v1.0.0)
REM                   ->  feat: add search
REM                   ->  fix: critical null pointer in auth   <- to cherry-pick
REM                   ->  feat: add analytics
REM    release/v1.0:  branches from "feat: add dashboard" (v1.0.0), no extra commits
REM ============================================================

echo.
echo  ============================================================
echo   Git Advanced - Exercise 5 / Step 4
echo   Topic: Cherry-pick (backport a fix to a release branch)
echo   Creating "ex5-step4" repository...
echo  ============================================================
echo.

if exist ex5-step4 (
    echo  [!] Removing existing "ex5-step4" folder...
    rmdir /s /q ex5-step4
)

mkdir ex5-step4
cd ex5-step4
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
echo MODULES
echo -------
echo [x] Homepage
echo [ ] Login
echo [ ] Dashboard
echo [ ] Search
) > index.txt
git add index.txt
git commit -m "feat: initial homepage"

REM -------------------------------------------------------
REM  COMMIT 2
REM -------------------------------------------------------
(
echo AUTH MODULE
echo ===========
echo login^(^):   validates username and password
echo logout^(^):  clears session token
echo getUser^(^): returns current user or null
) > auth.txt
git add auth.txt
git commit -m "feat: add login"

REM -------------------------------------------------------
REM  COMMIT 3 — release cut point
REM -------------------------------------------------------
(
echo DASHBOARD MODULE
echo ================
echo Widgets: KPI cards, activity chart, alerts
echo Data source: REST API
) > dashboard.txt
git add dashboard.txt
git commit -m "feat: add dashboard"

REM --- Cut release/v1.0 from this exact commit ---
git checkout -b release/v1.0
git tag -a v1.0.0 -m "Release version 1.0.0"
git checkout main

REM -------------------------------------------------------
REM  COMMIT 4 — post-release feature (NOT to be cherry-picked)
REM -------------------------------------------------------
(
echo SEARCH MODULE
echo =============
echo Input: text field
echo Filter: title, tags, author
echo Results: paginated list
) > search.txt
git add search.txt
git commit -m "feat: add search"

REM -------------------------------------------------------
REM  COMMIT 5 — critical fix (THIS is the commit to cherry-pick)
REM -------------------------------------------------------
(
echo AUTH MODULE
echo ===========
echo login^(^):    validates username and password
echo logout^(^):   clears session token
echo getUser^(^):  returns current user or empty object ^(never null^)
echo checkToken^(^): validates JWT, returns false instead of throwing
) > auth.txt
git add auth.txt
git commit -m "fix: critical null pointer in auth"

REM -------------------------------------------------------
REM  COMMIT 6 — another post-release feature (NOT to be cherry-picked)
REM -------------------------------------------------------
(
echo ANALYTICS MODULE
echo ================
echo pageview: tracked on every route change
echo events:   custom event tracking enabled
echo export:   CSV and JSON supported
) > analytics.txt
git add analytics.txt
git commit -m "feat: add analytics"

echo.
echo  ============================================================
echo   Done! Starting state for Step 4:
echo.
git log --oneline --graph --all
echo.
echo   Tag created:
git tag
echo.
echo   Your goal:
echo   1. Find the hash of "fix: critical null pointer in auth" on main
echo   2. git checkout release/v1.0
echo   3. git cherry-pick ^<hash^>
echo  ============================================================
echo.