require ["reject", "imap4flags", "envelope"];
if anyof(
    # platforms
    envelope :domain "from" "bounce.myngp.com",
    envelope :domain "from" "inbound-parse.actionnetwork.org",
    header :matches "list-unsubscribe" "*actionkit.com*",
    header :matches "list-unsubscribe" "*actionnetwork.org*",
    header :matches "list-unsubscribe" "*ngpvan.com*",

    # individual campaigns
    address :domain "from" "tinaforminnesota.com",
    address :domain "from" "sarahkleehoodny.com"

) {
    reject "This message was unsolicited spam, have a garbage day";
}
