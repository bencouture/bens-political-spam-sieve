# Political Sieve Filter Makefile
# Uses sieve-test (dovecot-sieve) as the evaluation engine

SIEVE_FILE ?= political.sieve
TEST_DIR   ?= test

.PHONY: all test lint clean help

all: lint test

lint: $(SIEVE_FILE)
	@bash scripts/lint.sh $(SIEVE_FILE)

test: $(SIEVE_FILE)
	@bash scripts/run-tests.sh $(SIEVE_FILE) $(TEST_DIR)

clean:
	@echo "Nothing to clean"

help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  all   - Run lint and test (default)"
	@echo "  lint  - Syntax-check the sieve file via sievec"
	@echo "  test  - Run all tests via sieve-test"
	@echo ""
	@echo "Requires: dovecot-sieve (apt install dovecot-sieve)"
