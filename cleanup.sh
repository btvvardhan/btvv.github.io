#!/usr/bin/env bash
set -euo pipefail

echo "=== SITE CLEANUP SCRIPT ==="
read -p "Make sure you committed changes and created a backup branch. Continue? (y/N) " yn
if [[ "${yn,,}" != "y" ]]; then
  echo "Aborting."
  exit 1
fi

# 1) Check for math usage
echo "Checking for Math/KaTeX usage in content..."
if grep -R --line-number -e '\$\$' -e '\\(' -e 'KaTeX' -e 'MathJax' -- _posts _projects _featured* _posts || true; then
  echo "Found possible math usage. If you still want to remove katex/MathJax, rerun with FORCE_REMOVE_MATH=1"
  FORCE_REMOVE_MATH=${FORCE_REMOVE_MATH:-0}
else
  echo "No obvious math found."
  FORCE_REMOVE_MATH=1
fi

# list of safe removals (tweak if you want to keep something)
TO_DELETE=(
  "_site"
  "assets/bower_components"
  "assets/katex"            # sometimes vendor katex lives here
  "assets/MathJax"          # MathJax vendor (very large) - only if not used
  "bower.json"
  "bower_components"        # if exists in root
  "package-lock.json"       # optional: remove if you want to reduce repo; keep if using npm lock
  "assets/bower.json"
  "assets/bower_components"
  "img/blog/example-content-iii.jpg"
  "img/blog/example-content-iii@0,25x.jpg"
  "img/blog/example-content-iii@0,5x.jpg"
  "img/blog/hydejack-9.jpg"
  "img/blog/hydejack-9@0,5x.jpg"
  "img/blog/hydejack-9@0,25x.jpg"
  "img/blog/hydejack-9-dark.jpg"
  "img/blog/hydejack-9-dark@0,5x.jpg"
  "img/blog/hydejack-9-dark@0,25x.jpg"
  "img/blog/jeremy-bishop.jpg"
  "img/blog/jeremy-bishop@0,5x.jpg"
  "img/blog/pawel-czerwinski-848z7lbCjoo-unsplash.jpg"
  "img/blog/pawel-czerwinski-848z7lbCjoo-unsplash@0,5x.jpg"
  "img/blog/pawel-czerwinski-848z7lbCjoo-unsplash@0,25x.jpg"
  # vendor MathJax (large) inside assets (if present)
  "assets/MathJax"
  # duplicate hydejack assets - keep your preferred versions (these delete both versions; adjust if you want to keep 9.1.6)
  "assets/css/hydejack-9.1.6.css"
  "assets/css/hydejack-9.2.1.css"
)

# Add LEGACY JS patterns to delete (confirm first)
LEGACY_PATHS=$(find . -maxdepth 3 -type f -name "LEGACY-*.js" -print || true)
if [[ -n "$LEGACY_PATHS" ]]; then
  echo "Found LEGACY JS files. They may be unused."
  echo "$LEGACY_PATHS"
  read -p "Delete all LEGACY-* JS files? (y/N) " delLegacy
  if [[ "${delLegacy,,}" == "y" ]]; then
    while IFS= read -r f; do
      TO_DELETE+=("$f")
    done <<< "$LEGACY_PATHS"
  fi
fi

# Remove packages and bower components inside _site (generated duplicates)
if [[ -d "_site/assets/bower_components" ]]; then
  TO_DELETE+=("_site/assets/bower_components")
fi

# If math not used or forced, add Katex/MathJax removal
if [[ "$FORCE_REMOVE_MATH" -eq 1 ]] || [[ "${FORCE_REMOVE_MATH:-0}" -eq 1 ]]; then
  TO_DELETE+=("assets/katex" "assets/MathJax" "bower_components/MathJax" "bower_components/katex")
fi

echo
echo "Files/directories slated for deletion:"
printf '%s\n' "${TO_DELETE[@]}" | sed '/^$/d'
echo

read -p "Proceed to delete the above files/directories from git and disk? (y/N) " proceed
if [[ "${proceed,,}" != "y" ]]; then
  echo "Aborting cleanup."
  exit 1
fi

# Delete from git (so they are removed from the repo) then from disk if necessary
for p in "${TO_DELETE[@]}"; do
  if [[ -e "$p" ]]; then
    echo "git rm -r --cached --ignore-unmatch '$p' || true"
    git rm -r --cached --ignore-unmatch "$p" || true
    echo "rm -rf '$p'"
    rm -rf "$p"
  fi
done

# Add common ignores
echo "Adding common cleanup ignores to .gitignore"
cat >> .gitignore <<'EOF'

# Jekyll build output
_site/

# Bower / vendor
bower_components/
assets/bower_components/

# local node modules (if any)
node_modules/

# package locks (optional)
package-lock.json
yarn.lock

# OS artifacts
.DS_Store
Thumbs.db
EOF

git add .gitignore || true
git commit -m "Cleanup: remove vendor/build artifacts and example images" || true

echo "Cleanup finished. Run 'git status' and check changes, then push if all good."
#!/usr/bin/env bash
set -euo pipefail

echo "=== SITE CLEANUP SCRIPT ==="
read -p "Make sure you committed changes and created a backup branch. Continue? (y/N) " yn
if [[ "${yn,,}" != "y" ]]; then
  echo "Aborting."
  exit 1
fi

# 1) Check for math usage
echo "Checking for Math/KaTeX usage in content..."
if grep -R --line-number -e '\$\$' -e '\\(' -e 'KaTeX' -e 'MathJax' -- _posts _projects _featured* _posts || true; then
  echo "Found possible math usage. If you still want to remove katex/MathJax, rerun with FORCE_REMOVE_MATH=1"
  FORCE_REMOVE_MATH=${FORCE_REMOVE_MATH:-0}
else
  echo "No obvious math found."
  FORCE_REMOVE_MATH=1
fi

# list of safe removals (tweak if you want to keep something)
TO_DELETE=(
  "_site"
  "assets/bower_components"
  "assets/katex"            # sometimes vendor katex lives here
  "assets/MathJax"          # MathJax vendor (very large) - only if not used
  "bower.json"
  "bower_components"        # if exists in root
  "package-lock.json"       # optional: remove if you want to reduce repo; keep if using npm lock
  "assets/bower.json"
  "assets/bower_components"
  "img/blog/example-content-iii.jpg"
  "img/blog/example-content-iii@0,25x.jpg"
  "img/blog/example-content-iii@0,5x.jpg"
  "img/blog/hydejack-9.jpg"
  "img/blog/hydejack-9@0,5x.jpg"
  "img/blog/hydejack-9@0,25x.jpg"
  "img/blog/hydejack-9-dark.jpg"
  "img/blog/hydejack-9-dark@0,5x.jpg"
  "img/blog/hydejack-9-dark@0,25x.jpg"
  "img/blog/jeremy-bishop.jpg"
  "img/blog/jeremy-bishop@0,5x.jpg"
  "img/blog/pawel-czerwinski-848z7lbCjoo-unsplash.jpg"
  "img/blog/pawel-czerwinski-848z7lbCjoo-unsplash@0,5x.jpg"
  "img/blog/pawel-czerwinski-848z7lbCjoo-unsplash@0,25x.jpg"
  # vendor MathJax (large) inside assets (if present)
  "assets/MathJax"
  # duplicate hydejack assets - keep your preferred versions (these delete both versions; adjust if you want to keep 9.1.6)
  "assets/css/hydejack-9.1.6.css"
  "assets/css/hydejack-9.2.1.css"
)

# Add LEGACY JS patterns to delete (confirm first)
LEGACY_PATHS=$(find . -maxdepth 3 -type f -name "LEGACY-*.js" -print || true)
if [[ -n "$LEGACY_PATHS" ]]; then
  echo "Found LEGACY JS files. They may be unused."
  echo "$LEGACY_PATHS"
  read -p "Delete all LEGACY-* JS files? (y/N) " delLegacy
  if [[ "${delLegacy,,}" == "y" ]]; then
    while IFS= read -r f; do
      TO_DELETE+=("$f")
    done <<< "$LEGACY_PATHS"
  fi
fi

# Remove packages and bower components inside _site (generated duplicates)
if [[ -d "_site/assets/bower_components" ]]; then
  TO_DELETE+=("_site/assets/bower_components")
fi

# If math not used or forced, add Katex/MathJax removal
if [[ "$FORCE_REMOVE_MATH" -eq 1 ]] || [[ "${FORCE_REMOVE_MATH:-0}" -eq 1 ]]; then
  TO_DELETE+=("assets/katex" "assets/MathJax" "bower_components/MathJax" "bower_components/katex")
fi

echo
echo "Files/directories slated for deletion:"
printf '%s\n' "${TO_DELETE[@]}" | sed '/^$/d'
echo

read -p "Proceed to delete the above files/directories from git and disk? (y/N) " proceed
if [[ "${proceed,,}" != "y" ]]; then
  echo "Aborting cleanup."
  exit 1
fi

# Delete from git (so they are removed from the repo) then from disk if necessary
for p in "${TO_DELETE[@]}"; do
  if [[ -e "$p" ]]; then
    echo "git rm -r --cached --ignore-unmatch '$p' || true"
    git rm -r --cached --ignore-unmatch "$p" || true
    echo "rm -rf '$p'"
    rm -rf "$p"
  fi
done

# Add common ignores
echo "Adding common cleanup ignores to .gitignore"
cat >> .gitignore <<'EOF'

# Jekyll build output
_site/

# Bower / vendor
bower_components/
assets/bower_components/

# local node modules (if any)
node_modules/

# package locks (optional)
package-lock.json
yarn.lock

# OS artifacts
.DS_Store
Thumbs.db
EOF

git add .gitignore || true
git commit -m "Cleanup: remove vendor/build artifacts and example images" || true

echo "Cleanup finished. Run 'git status' and check changes, then push if all good."
