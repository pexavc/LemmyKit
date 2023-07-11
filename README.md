# LemmyKit

A Swift http and websocket client and type system for Lemmy on iOS & macOS.

This Swift Package is based on [lemmy-js-client](https://github.com/LemmyNet/lemmy-js-client) by [@LemmyNet](https://github.com/LemmyNet)

All functions are auto-transpiled and upto date with the related js library. This will be updated manually if they are out of sync.

## Requirements

- iOS 14 or later
- macOS 12.4 or later

## Usage

> Choose the build scheme `LemmyExecutable` to test functions immediately. Can be used as a debugger for a live instances for example. Or simply turned into a CLI tool. Otherwise examples are meant to showcase in-app usage.

```swift
import LemmyKit

let baseUrl: String = "https://neatia.xyz/api/"+LemmyKit.VERSION

let lemmy = Lemmy(apiUrl: baseUrl)

let info = await lemmy.request(
    Login(username_or_email: "pexavc",
          password: "...")
)

print(info)

let data = await lemmy.request(
    GetSite(auth: info?.jwt)
)

print(data?.site_view.site.name)
```

### Other

---

#### Why

I spun up a Lemmy instance to function as a content aggregator for my personal applications. While investigating iOS/macOS solutions I deemed it necessary to spin up my own implementation to interact with the lemmy instance as well as open-source it for others.
