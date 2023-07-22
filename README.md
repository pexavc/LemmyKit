# LemmyKit

A Swift http and websocket client and type system for Lemmy on iOS & macOS.

This Swift Package is based on [lemmy-js-client](https://github.com/LemmyNet/lemmy-js-client) by [@LemmyNet](https://github.com/LemmyNet)

All functions are auto-transpiled and upto date with the related js library. This will be updated manually if they are out of sync.

For an online doc to reference the API supported please visit this [link](https://join-lemmy.org/api/). The docs are meant for the JS side of things, but those parameters and functions are similarly implemented here.

## Requirements

- iOS 14 or later
- macOS 12.4 or later

## Usage

> Choose the build scheme `LemmyExecutable` to test functions immediately. Can be used as a debugger for a live instances for example. Or simply turned into a CLI tool. Otherwise examples are meant to showcase in-app usage.

### Basic Requests

```swift
import LemmyKit

let baseUrl: String = "https://neatia.xyz"

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

/* OR via static usage */

//Must be set to use static functions
//Must be the baseURL of your instance
LemmyKit.baseUrl = "https://neatia.xyz"

let staticInfo = await Lemmy.request(
    Login(username_or_email: "pexavc",
          password: "...")
)

print(staticInfo)
```

### Swift Interface

> Requests wrapped in easy to call swift functions for simple get, set, and puts.

```swift
//Setting authentication with a login
LemmyKit.auth = await Lemmy.login(username: "pexavc",
                                  password: "...")

```

```swift
//Getting all Local Communities
let communities = await Lemmy.communities(.local)

var debugCommunity: Community?
for community in communities {
    print("Community found: \(community.name)")
    if community.name == "debug" {
        debugCommunity = community
    }
}
```

```swift
//Getting posts for a specific community
let posts = await Lemmy.posts(debugCommunity)

for post in posts {
    print("Post found: \(post.name)")
}
```

```swift
//Getting comments from a post
let comments = await Lemmy.comments(posts.first)

for comment in comments {
    print("Comment found: \(comment.content)")
}
```

```swift
//Posting to a community
let post = await Lemmy.createPost("[DEBUG] From LemmyKit",
                                  content: "Hello World",
                                  community: debugCommunity)

```

```swift
//Commenting on a post
let comment = await Lemmy.createComment("Test comment", post: post)
```

```swift
//Replying to a comment
await Lemmy.createComment("Reply to a comment",
                          post: post,
                          parent: comment)
```

## Swift Interface API

> Currently supported requests in the Swift interface. Will be updated periodically.

### Auth/Registration

```swift
func login(username: String, password: String) async -> String?
```

### Fetch

```swift
func communities(_ type: ListingType = .local,
                 auth: String? = nil) async -> [Community]
                 
func posts(_ community: Community,
           type: ListingType = .local,
           auth: String? = nil) async -> [Post]

func comments(_ post: Post? = nil,
              comment: Comment? = nil,
              community: Community? = nil,
              type: ListingType = .local,
              auth: String? = nil) async -> [Comment]
```

### Create

```swift
func createCommunity(_ title: String, auth: String) async -> Community?
                 
func createPost(_ title: String,
                content: String,
                url: String? = nil,
                body: String? = nil,
                community: Community,
                auth: String) async -> Post?

func createComment(_ content: String,
                   post: Post,
                   parent: Comment? = nil,
                   auth: String) async -> Comment? {
```


## Other

---

### Why

I spun up a Lemmy instance to function as a content aggregator for my personal applications. While investigating iOS/macOS solutions I deemed it necessary to spin up my own implementation to interact with the lemmy instance as well as open-source it for others.
