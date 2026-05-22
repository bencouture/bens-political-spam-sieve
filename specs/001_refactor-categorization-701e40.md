# Refactor and Categorization Specification

## Overview
This specification defines the refactoring of the political email sieve filter from a monolithic structure to a tiered system with clear categorization and improved maintainability.

## Background

The original political.sieve filter was a single monolithic `anyof` block containing all rules. This approach had several issues:
- Mixed confidence levels in single block made it hard to understand which rules were safe vs risky
- Overly broad patterns like `support*.com` caused false positives with legitimate business emails
- No clear separation between platform fingerprints (high confidence) and heuristic patterns (medium confidence)
- Difficult to maintain and test individual rule categories

## Requirements

### Functional Requirements
- Separate rules into confidence tiers with different actions
- Remove overly broad patterns that cause false positives
- Maintain all existing high-confidence political filtering
- Improve code organization and readability
- Enable easier testing of individual rule categories

### Non-Functional Requirements
- Must remain compatible with Proton Mail's sieve implementation
- Must follow RFC 5228 sieve language standard
- Should not break existing functionality for legitimate political email filtering

## Design

### Tier System Architecture

```
┌─────────────────┐
│   Tier 1     │  High Confidence - Immediate Reject
├─────────────────┤
│   Tier 2     │  Medium Confidence - File to Junk
└─────────────────┘
```

#### Tier 1: High Confidence Rules
**Action**: `reject`
**Criteria**:
- Platform fingerprints (ngpvan, actionnetwork, actblue, etc.)
- Office-specific domains (*forcongress.com, *forsenate.com, etc.)
- Official party committees (dccc.org, nrcc.org, etc.)
- Top-tier PAC naming conventions (*victoryfund.com, *majoritypac.com, etc.)

#### Tier 2: Medium Confidence Rules  
**Action**: `fileinto "junk"` with flags
**Criteria**:
- Action-related patterns (*actionfund.com, *foramerica.com, etc.)
- Election year patterns (*2026.com, *2028.com, etc.)
- Political campaign language (standwith*, winbackthe*, defendthe*, etc.)

#### Removed Patterns
**Action**: Remove entirely
**Criteria**:
- Overly broad patterns: support*, team*, elect*, defeat*
- These patterns have demonstrated false positives with legitimate business communications

## Implementation Details

### File Structure
```
political.sieve (main filter file)
├── require statements
├── Tier 1: High Confidence Block
│   ├── Platform fingerprints
│   ├── Office-specific domains  
│   ├── Official party committees
│   └── Top-tier PAC conventions
└── elsif Tier 2: Medium Confidence Block
    ├── Action-related patterns
    ├── Election year patterns
    └── Political campaign language
```

### Require Statements
```sieve
require ["reject", "envelope", "fileinto", "imap4flags"];
```

### Control Flow
```sieve
if anyof(
    # Tier 1: High confidence rules
    # ... platform fingerprints and specific political domains
) {
    reject "This message was unsolicited spam, have a garbage day";
}
elsif anyof(
    # Tier 2: Medium confidence rules  
    # ... potentially political patterns for review
) {
    addflag "\\Seen";
    addflag "Political-Junk";
    fileinto "junk";
}
```

## Migration Strategy

### Phase 1: Analysis and Planning
1. Inventory existing rules by category
2. Identify overly broad patterns causing false positives
3. Map rules to new tier structure
4. Plan removal of problematic patterns

### Phase 2: Implementation
1. Update require statements for new actions
2. Reorganize rules into tier structure
3. Remove identified overly broad patterns
4. Update comments and documentation

### Phase 3: Testing and Validation
1. Test against false positive examples
2. Test against known political emails
3. Verify Proton Mail compatibility
4. Update based on test results

## Success Criteria

- ✅ All high-confidence political rules preserved in Tier 1
- ✅ Overly broad patterns removed (support*, team*, elect*, defeat*)
- ✅ Medium-confidence patterns moved to Tier 2 with fileinto action
- ✅ Filter syntax remains valid for Proton Mail
- ✅ No false positives from removed patterns
- ✅ Legitimate political emails still properly filtered

## Risks and Mitigations

### Risk: Accidentally removing legitimate political rules
**Mitigation**: Careful review of each removed pattern against known political domains

### Risk: Breaking Proton Mail compatibility  
**Mitigation**: Test with Proton Mail's sieve validator before deployment

### Risk: New false positives in Tier 2
**Mitigation**: Users can review "junk" folder and whitelist legitimate senders

## Future Considerations

### Potential Enhancements
- Add auto-whitelist functionality for legitimate senders in Tier 2
- Implement logging to track which rules trigger most frequently
- Create separate folders for different political categories (PAC vs campaign)
- Add date-based expiration for junk folder items

### Maintenance
- Review Tier 2 monthly for missed political emails that should be in Tier 1
- Update platform fingerprints as new political ESPs emerge
- Monitor election cycle patterns and update year ranges accordingly

This specification provides a clear roadmap for refactoring the political sieve filter while maintaining functionality and reducing false positives.
