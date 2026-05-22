#!/usr/bin/env bash
set -euo pipefail

SIEVE_FILE="${1:-political.sieve}"
TEST_DIR="${2:-test}"

# Normalize the sieve file for Dovecot:
# Proton Mail allows trailing commas before closing parens; Dovecot does not.
TMPFILE=$(mktemp /tmp/political-XXXXXX.sieve)
trap 'rm -f "$TMPFILE"' EXIT
python3 -c "
import re, sys
with open(sys.argv[1]) as f:
    s = f.read()
s = re.sub(r',(\s*\n\s*\))', r'\1', s)
with open(sys.argv[2], 'w') as f:
    f.write(s)
" "$SIEVE_FILE" "$TMPFILE"

PASS=0
FAIL=0
ERRORS=()

run_test() {
    local file="$1" expect="$2" label="$3"
    local safecopy out result
    safecopy=$(mktemp /tmp/sieve-email-XXXXXX.eml)
    cp "$file" "$safecopy"
    out=$(sieve-test "$TMPFILE" "$safecopy" 2>/dev/null) || true
    rm -f "$safecopy"
    if echo "$out" | grep -q "reject message"; then
        result="reject"
    elif echo "$out" | grep -q "store message in folder: junk"; then
        result="junk"
    else
        result="none"
    fi
    if [ "$result" = "$expect" ]; then
        PASS=$((PASS+1))
    else
        FAIL=$((FAIL+1))
        ERRORS+=("  ❌ $label (expected $expect, got $result)")
    fi
}

echo "==> Pattern matching tests"
run_test "$TEST_DIR/pattern-matching/platform-fingerprints/ngpvan-email.eml"        "reject" "NGP VAN platform fingerprint"
run_test "$TEST_DIR/pattern-matching/platform-fingerprints/actionnetwork-email.eml" "reject" "Action Network platform fingerprint"
run_test "$TEST_DIR/pattern-matching/domain-patterns/office-domains.eml"            "reject" "Office domain pattern"
run_test "$TEST_DIR/pattern-matching/domain-patterns/party-committees.eml"          "reject" "Party committee domain pattern"
run_test "$TEST_DIR/pattern-matching/heuristic-patterns/election-year.eml"          "junk"   "Election year pattern"
run_test "$TEST_DIR/pattern-matching/heuristic-patterns/campaign-language.eml"      "junk"   "Campaign language pattern"

echo "==> False positive tests"
run_test "$TEST_DIR/false-positives/business-support.eml"   "none" "Business support email"
run_test "$TEST_DIR/false-positives/tech-auto-reply.eml"     "none" "Tech auto-reply"
run_test "$TEST_DIR/false-positives/financial-statement.eml" "none" "Financial statement"

echo "==> Political example tests"
run_test "$TEST_DIR/political-examples/ngpvan-platform.eml"              "reject" "NGP VAN platform"
run_test "$TEST_DIR/political-examples/campaign-domain.eml"              "reject" "Campaign domain"
run_test "$TEST_DIR/political-examples/actionfund-pattern.eml"           "junk"   "Action fund"
run_test "$TEST_DIR/political-examples/election-year-pattern.eml"        "junk"   "Election year"
run_test "$TEST_DIR/political-examples/dccc-status-announcement.eml"     "reject" "DCCC status announcement"
run_test "$TEST_DIR/political-examples/fightforreform-abolish-ec.eml"    "reject" "Fight For Reform"
run_test "$TEST_DIR/political-examples/giffords-postal-service.eml"      "reject" "Giffords"
run_test "$TEST_DIR/political-examples/ossoff-cup-of-coffee.eml"         "reject" "Ossoff"
run_test "$TEST_DIR/political-examples/lujan-heartbreak-nm.eml"          "reject" "Lujan"
run_test "$TEST_DIR/political-examples/cbcpac-odonnell-warning.eml"      "reject" "CBCPAC"
run_test "$TEST_DIR/political-examples/bluewave-nbc-warning.eml"         "reject" "Blue Wave America"
run_test "$TEST_DIR/political-examples/roycooper-two-decades.eml"        "reject" "Roy Cooper"
run_test "$TEST_DIR/political-examples/occupydem-maddow-wallace.eml"     "reject" "Occupy Democrats Fund"
run_test "$TEST_DIR/political-examples/teamjulie-voter-suppression.eml"  "reject" "Team Julie"
run_test "$TEST_DIR/political-examples/dccc-republican-nonsense.eml"     "reject" "DCCC Republican nonsense"
run_test "$TEST_DIR/political-examples/savedemocracy-costco.eml"         "reject" "Save Democracy PAC"
run_test "$TEST_DIR/political-examples/talarico-five-dollars.eml"        "reject" "Talarico"
run_test "$TEST_DIR/political-examples/grahamplatner-bernie.eml"         "reject" "Graham Platner"
run_test "$TEST_DIR/political-examples/teamwarner-donation.eml"          "reject" "Team Warner"

TOTAL=$((PASS+FAIL))
echo ""
if [ ${#ERRORS[@]} -gt 0 ]; then
    printf '%s\n' "${ERRORS[@]}"
    echo ""
    echo "Test Summary: $PASS/$TOTAL passed, $FAIL failed"
    exit 1
else
    echo "Test Summary: $PASS/$TOTAL passed ✅"
fi
