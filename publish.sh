#!/usr/bin/env bash
# Re-render and publish the site to the website repo (DMgtAsia_DataScience_IntroR_site).
# quarto render cleans docs/ on each run (removing docs/.git), so we re-init a fresh
# single-commit tree in docs/ and force-push it. Render locally; no CI.
#
# Usage:  ./publish.sh
set -euo pipefail
cd "$(dirname "$0")"

SITE_REMOTE="https://github.com/drarunmitra/DMgtAsia_DataScience_IntroR_site.git"

echo "→ Rendering (freeze: auto)…"
quarto render

cd docs
touch .nojekyll
rm -rf .git
git init -q
git checkout -q -b main
git add -A
git -c user.name="Arun Mitra" -c user.email="dr.arunmitra@gmail.com" \
    commit -q -m "Publish site $(date +%Y-%m-%d)"
git push -q -f "$SITE_REMOTE" main
echo "→ Published → https://drarunmitra.github.io/DMgtAsia_DataScience_IntroR_site/"
