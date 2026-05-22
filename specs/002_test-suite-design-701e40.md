# Test Suite Design Specification

## Overview
This specification defines a comprehensive test suite for the political email sieve filter, designed to validate both functionality and Proton Mail compatibility while ensuring privacy for public publication.

## Objectives

### Primary Objectives
- Validate tiered filter structure (Tier 1 reject, Tier 2 fileinto)
- Test against false positive examples to ensure they're no longer caught
- Verify political email filtering still works correctly
- Ensure Proton Mail compatibility with supported extensions
- Provide comprehensive test coverage for all rule categories
- Enable automated testing with anonymized data

### Secondary Objectives
- Create reproducible test results
- Enable continuous integration testing
- Document test cases for future maintenance
- Provide clear pass/fail criteria

## Test Architecture

### Test Categories

#### 1. Syntax Validation Tests
- **Sieve parsing**: Verify script syntax is valid
- **Require statements**: Check all required extensions are properly declared
- **Rule structure**: Validate if/elsif/else control flow
- **String escaping**: Verify proper quote and escape handling

#### 2. Pattern Matching Tests
- **Platform fingerprints**: Test ngpvan, actionnetwork, actblue patterns
- **Domain patterns**: Test wildcard matching for political domains
- **Header extraction**: Verify list-unsubscribe and X-header detection
- **Case sensitivity**: Ensure matching works regardless of case

#### 3. Action Verification Tests
- **Reject action**: Verify rejection messages are sent correctly
- **Fileinto action**: Confirm messages are filed to correct folder
- **Flag setting**: Test imap4flags are applied properly
- **Control flow**: Ensure correct if/elsif/else execution

#### 4. False Positive Prevention Tests
- **Business domains**: Test legitimate company emails
- **Auto-replies**: Test automated response emails
- **Financial services**: Test bank/brokerage communications
- **Tech companies**: Test software/service notifications
- **Generic patterns**: Test emails matching broad patterns

#### 5. Political Email Tests
- **Known platforms**: Test emails from blocked political ESPs
- **Campaign domains**: Test forcongress, forsenate patterns
- **PAC fundraising**: Test victoryfund, majoritypac patterns
- **Election cycles**: Test 2026, 2028, 2030 patterns

#### 6. Edge Case Tests
- **Empty headers**: Test emails missing expected headers
- **Malformed addresses**: Test invalid email address formats
- **Unicode content**: Test international character handling
- **Large messages**: Test size limits and performance
- **Nested conditions**: Test complex rule combinations

## Test Data Strategy

### Anonymization Requirements
All test data must be anonymized to remove:
- Personal email addresses
- Real names and identifying information
- Specific company names
- Message-Id headers with unique identifiers
- Date/time stamps
- Subject lines with sensitive content

### Test File Organization
```
test-data/
├── syntax/
│   ├── valid-scripts/
│   │   ├── minimal-valid.sieve
│   │   ├── tiered-structure.sieve
│   │   └── proton-compatible.sieve
│   └── invalid-scripts/
│       ├── missing-require.sieve
│       ├── invalid-syntax.sieve
│       └── unsupported-extension.sieve
├── pattern-matching/
│   ├── platform-fingerprints/
│   │   ├── ngpvan-email.eml
│   │   ├── actionnetwork-email.eml
│   │   └── actblue-email.eml
│   ├── domain-patterns/
│   │   ├── office-domains.eml
│   │   ├── party-committees.eml
│   │   └── pac-patterns.eml
│   └── heuristic-patterns/
│       ├── action-fund.eml
│       ├── election-year.eml
│       └── campaign-language.eml
├── false-positives/
│   ├── business-support.eml
│   ├── tech-auto-reply.eml
│   ├── financial-statement.eml
│   └── generic-team.eml
├── political-examples/
│   ├── known-platforms.eml
│   ├── campaign-fundraising.eml
│   └── election-cycle.eml
└── edge-cases/
    ├── empty-headers.eml
    ├── malformed-address.eml
    └── unicode-subject.eml
```

## Test Execution Framework

### Test Runner Interface
```go
type TestResult struct {
    Passed     bool
    Message    string
    Details    []string
    Duration   time.Duration
}

type TestSuite interface {
    RunTests(testDir string) []TestResult
    ValidateSyntax(sieveFile string) TestResult
    TestCompatibility(sieveFile string) TestResult
}
```

### Test Categories Implementation
```go
func (ts *TestSuite) RunFalsePositiveTests() []TestResult {
    // Test business emails should NOT match any rules
    // Test auto-replies should NOT match any rules  
    // Test financial services should NOT match any rules
}

func (ts *TestSuite) RunPoliticalEmailTests() []TestResult {
    // Test known political platforms should match Tier 1
    // Test campaign domains should match appropriate tier
    // Test election year patterns should match Tier 2
}
```

## Proton Mail Compatibility Testing

### Extension Validation
```go
var protonSupportedExtensions = map[string]bool{
    "reject": true,
    "envelope": true, 
    "fileinto": true,
    "imap4flags": true,
    "variables": true,
    "relational": true,
    "vnd.proton.expire": true,
}

var protonUnsupportedExtensions = map[string]bool{
    "editheader": false,
    "vacation": false,
    "include": false,
    "spamtest": false,
    "virustest": false,
    "copy": false,
    "regex": false,
}
```

### Compatibility Checks
- Verify require statements only use supported extensions
- Check actions are within Proton Mail capability set
- Validate syntax against Proton's implementation limitations
- Test regex patterns work with Proton's limited regex support

## Success Metrics

### Coverage Metrics
- **Rule coverage**: Percentage of rule types tested
- **Pattern coverage**: Number of distinct patterns validated
- **Action coverage**: All supported actions tested
- **Extension coverage**: All Proton extensions verified

### Quality Metrics
- **False positive rate**: 0% for business/tech/financial emails
- **Political detection rate**: 95%+ for known political platforms
- **Test reliability**: 100% reproducible results
- **Performance**: <100ms average test execution time

## Integration with Makefile

### Test Targets
```makefile
test: test-syntax test-patterns test-actions test-false-positives test-political test-compatibility test-all

test-syntax: $(BUILD_DIR)/test-suite --syntax-only
test-patterns: $(BUILD_DIR)/test-suite --pattern-tests
test-actions: $(BUILD_DIR)/test-suite --action-tests
test-false-positives: $(BUILD_DIR)/test-suite --false-positive-tests
test-political: $(BUILD_DIR)/test-suite --political-tests
test-compatibility: $(BUILD_DIR)/test-suite --proton-compatibility
test-all: $(BUILD_DIR)/test-suite --all-tests
```

### Continuous Integration
```yaml
# .github/workflows/test.yml
name: Test Suite
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: actions/setup-go@v2
        with:
          go-version: '1.19'
      - run: make test-all
```

## Documentation and Reporting

### Test Report Format
```markdown
# Test Results Summary

## Syntax Validation
✅ All sieve scripts passed syntax validation
✅ Required extensions properly declared

## Pattern Matching Tests
✅ Platform fingerprints: 15/15 tests passed
✅ Domain patterns: 12/12 tests passed  
✅ Heuristic patterns: 8/8 tests passed

## False Positive Tests
✅ Business emails: 4/4 tests passed (no matches)
✅ Auto-replies: 3/3 tests passed (no matches)
✅ Financial services: 2/2 tests passed (no matches)

## Political Email Tests
✅ Known platforms: 5/5 tests passed (Tier 1 matches)
✅ Campaign domains: 8/8 tests passed (appropriate tier matches)
✅ Election patterns: 4/4 tests passed (Tier 2 matches)

## Proton Mail Compatibility
✅ Extension validation: All supported extensions verified
✅ Action verification: All actions Proton-compatible
✅ Syntax compatibility: No unsupported features detected

## Performance Metrics
⚡ Average execution time: 45ms
📊 Test coverage: 94.7%
🎯 False positive rate: 0.0%
```

This specification provides a comprehensive foundation for building and maintaining a robust test suite that ensures the political sieve filter works correctly while protecting user privacy.
