require ["reject", "imap4flags", "envelope"];

if anyof(
    envelope :domain "from" "amd-inc.jp",
    envelope :domain "from" "bourgognemoniot.com"
) {
  reject "This message was unsolicited spam, have a garbage day";
}

