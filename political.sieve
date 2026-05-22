require ["reject", "envelope", "fileinto", "imap4flags"];

# ==============================================================================
# The Definitive Political Email Sieve Filter
#
# Version: 2.1
# Last Updated: 2026-05-21
#
# Purpose:
# This filter provides a comprehensive, multi-layered defense against unsolicited
# US federal political and fundraising emails. It is designed to be highly
# effective while minimizing false positives on non-political mail.
#
# Methodology:
# The filter operates in two tiers:
#   1. Tier 1: High Confidence - Immediate reject for known political platforms
#   2. Tier 2: Medium Confidence - File to "junk" folder for review
#
# Changes from v2.0:
# - Added @ prefix to political campaign language patterns for better specificity
#
# Changes from v1.0:
# - Removed overly broad patterns (support*, team*, elect*, defeat*)
# - Separated into reject vs fileinto actions
# - Moved election year patterns to Tier 2
# ==============================================================================

# ==============================================================================
# Tier 1: High Confidence - Immediate Reject
# Platform fingerprints and specific political domains that are extremely
# unlikely to have false positives.
# ==============================================================================

if anyof(
    # --- Platform & Technical Fingerprints (Highest Confidence) ---
    # Targets the known infrastructure of political email service providers (ESPs).

    # Platforms identified via `List-Unsubscribe` or `Return-Path` (envelope)
    envelope :domain "from" "bounce.myngp.com",
    envelope :domain "from" "inbound-parse.actionnetwork.org",
    header :matches "list-unsubscribe" "*actionkit.com*",
    header :matches "list-unsubscribe" "*actionnetwork.org*",
    header :matches "list-unsubscribe" "*ngpvan.com*",
    header :matches "list-unsubscribe" "*secure.actblue.com*",
    header :matches "list-unsubscribe" "*secure.winred.com*",
    header :matches "list-unsubscribe" "*anedot.com*",
    header :matches "list-unsubscribe" "*bsd.net*",                  # Blue State Digital
    header :matches "list-unsubscribe" "*everyaction.net*",
    header :matches "list-unsubscribe" "*nationbuilder.com*",

    # Platforms identified via the presence of custom `X-` headers
    header :contains "X-Rpcampaign"           "",  # Epsilon platform
    header :contains "X-NationBuilder-Sub-Id" "",  # NationBuilder platform
    header :contains "X-Maropost-Campaign-Id" "",  # Maropost platform

    # Example manually added domains, for mail that slips through the cracks
    address :domain "from" "tinaforminnesota.com",
    address :domain "from" "sarahkleehoodny.com",
    envelope :domain "from" "bounce.e.savethevoteamerica.org",

    # --- Office-Specific Domains ---
    address :matches "from" "*forcongress.com",
    address :matches "from" "*forcongress.org",
    address :matches "from" "*forsenate.com",
    address :matches "from" "*forsenate.org",
    address :matches "from" "*forhouse.com",
    address :matches "from" "*forhouse.org",
    address :matches "from" "*forpresident.com",
    address :matches "from" "*forpresident.org",

    # --- Official Party Campaign Committees ---
    address :matches "from" "*dccc.org",               # Democratic Congressional Campaign Committee
    address :matches "from" "*dscc.org",               # Democratic Senatorial Campaign Committee
    address :matches "from" "*nrcc.org",               # National Republican Congressional Committee
    address :matches "from" "*nrsc.org",               # National Republican Senatorial Committee

    # --- Top-Tier PAC/Committee Naming Conventions ---
    address :matches "from" "*victoryfund.com",
    address :matches "from" "*victoryfund.org",
    address :matches "from" "*majoritypac.com",
    address :matches "from" "*majoritypac.org",
    address :matches "from" "*leadershipfund.com",
    address :matches "from" "*leadershipfund.org",
    address :matches "from" "*majorityproject.com",
    address :matches "from" "*majorityproject.org",
    address :matches "from" "*senatemajority.com",
    address :matches "from" "*senatemajority.org",
    address :matches "from" "*housemajority.com",
    address :matches "from" "*housemajority.org"

) {
    # If any of the above high-confidence conditions are met, reject the message.
    reject "This message was unsolicited spam, have a garbage day";
}

# ==============================================================================
# Tier 2: Medium Confidence - File to Junk
# Patterns that may have false positives, filed to "junk" folder for review.
# ==============================================================================

elsif anyof(
    # --- Action-Related Patterns ---
    address :matches "from" "*actionfund.com",
    address :matches "from" "*actionfund.org",
    address :matches "from" "*forourfuture.com",
    address :matches "from" "*forourfuture.org",
    address :matches "from" "*foramerica.com",
    address :matches "from" "*foramerica.org",

    # --- Election Year Patterns ---
    address :matches "from" "*2026.com",
    address :matches "from" "*2026.org",
    address :matches "from" "*2028.com",
    address :matches "from" "*2028.org",
    address :matches "from" "*2030.com",
    address :matches "from" "*2030.org",
    address :matches "from" "*2032.com",
    address :matches "from" "*2032.org",

    # --- Political Campaign Language ---
    address :matches "from" "*@standwith*.com",
    address :matches "from" "*@standwith*.org",
    address :matches "from" "*@winbackthe*.com",
    address :matches "from" "*@winbackthe*.org",
    address :matches "from" "*@defendthe*.com",
    address :matches "from" "*@defendthe*.org",
    address :matches "from" "*@takebackthe*.com",
    address :matches "from" "*@takebackthe*.org"

) {
    # If any of the above medium-confidence conditions are met, file to junk.
    addflag "\\Seen";
    addflag "Political-Junk";
    fileinto "junk";
}

# ==============================================================================
# Tier 3: Aggressive Patterns (Disabled)
# These patterns can block non-fundraising mail from advocacy and non-profit
# groups. Enable rules by removing the '#' at your own discretion.
# ==============================================================================

# address :matches "from" "americansfor*.com",
# address :matches "from" "americansfor*.org",
# address :matches "from" "peoplefor*.com",
# address :matches "from" "peoplefor*.org",
# address :matches "from" "fightfor*.com",
# address :matches "from" "fightfor*.org",
# address :matches "from" "stop*.com",
# address :matches "from" "stop*.org",
# address :matches "from" "secureour*.com",
# address :matches "from" "secureour*.org",
# address :matches "from" "*action.com",
# address :matches "from" "*action.org",
# address :matches "from" "join*.com",
# address :matches "from" "join*.org"
