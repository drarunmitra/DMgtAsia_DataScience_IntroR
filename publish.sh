#!/usr/bin/env bash
# Re-render and publish the site to the website repo (DMgtAsia_DataScience_IntroR_site).
# quarto render cleans docs/ on each run (removing docs/.git), so we re-init a fresh
# single-commit tree in docs/ and force-push it. Render locally; no CI.
#
# Usage:  ./publish.sh
set -euo pipefail
cd "$(dirname "$0")"

SITE_REMOTE="https://github.com/drarunmitra/DMgtAsia_DataScience_IntroR_site.git"

echo "→ Clean render (clear output + project cache, keep _freeze)…"
# Force a fresh pandoc render of every page so metadata-only changes (e.g. header
# includes) always propagate. _freeze is kept, so R chunks are not re-executed.
rm -rf docs .quarto
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
