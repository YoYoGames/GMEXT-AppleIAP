## IMPORTANT

- This extension is to be used with **GM 2023.8** and newer releases (for LTS you will need LTSr2)
- If you are using an old version of the extension you should remove it and install this one (installing over the old extension will not work properly).
- Works with **macOS**, **iOS** and **tvOS**.

## CHANGES SINCE ${releaseOldVersion}

https://github.com/YoYoGames/GMEXT-AppleIAP/compare/${releaseOldVersion}...${releaseNewVersion}

## DESCRIPTION

Extensions for integrating iOS/tvOS and macOS IAPs into your games.

## FEATURES 

- Consumables
- Durables
- Subscriptions (renewing and non-renewing).

## DOCUMENTATION

The full documentation of the API is included in the extension asset (included files).
Included in the asset are mini-manuals for the two platforms - be aware the code is extremely similar and the two "stores" require almost identical behaviour, but the function names and IAP event cases have different prefixes, etc., so please do pay attention to both manuals.

## NOTES

Note that some functionality for verifying purchases relies on you to have your own custom web server - there are no custom functions in the extension for this, as you should use the existing http_get() functionality to communicate with your server. The mini-manuals link to Apple documentation on what your payment server needs to do.

## REFERENCES

You can also find more "how to" documentation on our Helpdesk at [macOS IAPs setup guide] and [iOS/tvOS IAPs setup guide].

[macOS IAPs setup guide]:https://help.yoyogames.com/hc/en-us/articles/360002237237
[iOS/tvOS IAPs setup guide]:https://help.yoyogames.com/hc/en-us/articles/360002237257
