require ["reject", "fileinto", "imap4flags"];

if anyof(
    header :contains "from" "political@example.com"
) {
    reject "Political spam";
}
elsif anyof(
    header :contains "from" "maybe-political@example.com"
) {
    addflag "\\Seen";
    addflag "Political-Junk";
    fileinto "junk";
}
