#!/usr/bin/env bash
set -euo pipefail

SIEVE_FILE="${1:-political.sieve}"

TMPFILE=$(mktemp /tmp/political-XXXXXX.sieve)
BINFILE=$(mktemp /tmp/political-XXXXXX.svbin)
trap 'rm -f "$TMPFILE" "$BINFILE"' EXIT

python3 -c "
import re, sys
with open(sys.argv[1]) as f:
    s = f.read()
s = re.sub(r',(\s*\n\s*\))', r'\1', s)
with open(sys.argv[2], 'w') as f:
    f.write(s)
" "$SIEVE_FILE" "$TMPFILE"

echo "==> Syntax check"
if sievec "$TMPFILE" "$BINFILE" 2>&1; then
    echo "  ✅ Syntax OK"
else
    echo "  ❌ Syntax FAILED"
    exit 1
fi
