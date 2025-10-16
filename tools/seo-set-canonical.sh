#!/usr/bin/env bash
set -euo pipefail
# Usage: tools/seo-set-canonical.sh [DOMAIN]
if [ $# -ge 1 ]; then DOMAIN="$1"; else
  read -r -p "Domain: " DOMAIN
fi
DOMAIN=$(echo "$DOMAIN" | xargs)
DOMAIN=${DOMAIN%/}
case "$DOMAIN" in
  http://*|https://*) ;;
  *) DOMAIN="https://$DOMAIN" ;;
esac
BASE=$(printf '%s\n' "$DOMAIN" | sed -E 's#^([a-zA-Z][a-zA-Z0-9+.-]*://[^/]+).*#\1#')
if [ -z "$BASE" ]; then echo "Aborted: invalid domain"; exit 1; fi
HOST_ONLY=${BASE#*://}
export BASE HOST_ONLY
echo "Using base domain: $BASE"

FILES=$(find frontend/public -type f -name "*.html")
for f in $FILES; do
  bk="$f.bak.$(date +%s)"
  cp "$f" "$bk"
  # Use Perl with env vars to safely do replacements
  perl -0777 -i -pe 'BEGIN{$b=$ENV{BASE}; $h=$ENV{HOST_ONLY}};
    s{(rel="canonical"[^>]*href=")https?://[^/]+}{$1.$b}ge;
    s{(property="og:url"[^>]*content=")https?://[^/]+}{$1.$b}ge;
    s{(name="twitter:url"[^>]*content=")https?://[^/]+}{$1.$b}ge;
    s{\bexample\.(?:com|org)\b}{$h}ge;' "$f"
  echo "Updated: $f (backup: $bk)"
done

# preview updated tags
grep -Hn -E 'rel="canonical"|og:url|twitter:url' frontend/public/*.html frontend/public/*/*.html || true

echo "Done. Check HTML canonical and social tags."
