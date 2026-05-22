require ["reject"];

if header :contains "from" "test@example.com" {
    reject "Test message"
# Missing closing brace and semicolon
