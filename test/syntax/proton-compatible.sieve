require ["reject", "envelope", "fileinto", "imap4flags"];

if anyof(
    envelope :domain "from" "bounce.ngp.com",
    header :matches "list-unsubscribe" "*actionnetwork.org*"
) {
    reject "Political spam";
}
elsif anyof(
    address :matches "from" "*actionfund.com"
) {
    addflag "\\Seen";
    fileinto "junk";
}
