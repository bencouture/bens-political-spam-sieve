# bens-political-spam-sieve
This sieve bounces emails from some of the most widely used political fundraising platforms in the US, regardless of which candidate sent the email

## What exactly does this do?

These rules will reject emails before they even reach your inbox. They don't go to spam. They don't go to the trash. Do not pass go. Return to sender.

Some entire platforms are blocked, so any email sent from those platforms will be rejected. Some specific campaigns are explicitly blocked, since they don't have headers that can be easily filtered upon.

## How do I enable these rules?

### Proton Mail

1. Settings -> Filters -> Add Sieve Filter
1. Copy and paste the filter into the box
1. Give it any name you want
1. Customize the rejection message (have fun with it)
1. Save it
1. Never get fundraising emails from those platforms again

## Which platforms do these rules block?

* NGP VAN https://en.wikipedia.org/wiki/NGP_VAN
* Action Network https://actionnetwork.org/
* Action Kit (NGP VAN subsidiary)