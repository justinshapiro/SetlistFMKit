# SetlistFmKit - A Setlist.fm API wrapper for Swift
A simple Swift wrapper around the Setlist.fm API. [Setlist.FM](setlist.fm) is a large internet database of detailed, community-provided live-concert setlists (lists of songs played) by any artist throughout history.

This wrapper is intended to help you integrate data from Setlist.fm into your iOS or macOS application, without having to know the various idiosyncrasies of the API. A basic built-in networking implementation using `URLSession` handles RESTful `GET` requests to the 15 available endpoints, and the corresponding method signatures allow fully parameterized requests to those endpoints. Calling any one of the 15 wrapper methods will return asynchronously a deserialized object corresponding to the JSON returned from the associated endpoint behind-the-scenes. All wrapper methods are covered fully by Unit Tests, which utilize sample reponses from the API. These Unit Tests verify correctness of this wrapper but also serve as a reference for the API and useage of the wrapper.

Although the default networking implementation for this wrapper uses `URLSession.shared`, you may specify your own networking implementation that this wrapper should use, as long as your networking implementation conforms to the wrapper's `URLSessionProtocol`.

### Requirements
- Swift 4.2
- Xcode 10
- A user account at [Setlist.fm](setlist.fm) (to get an API key)

#### Usage

To use this API wrapper, you must generate your own Setlist.fm API key. Generating a key is free and can be done quickly here: [api.setlist.fm](api.setlist.fm). 

After generating your key, you are ready to go!

```swift
import SetlistFmKit

let wrapper = SetlistFmWrapper(apiKey: "your-api-key")
wrapper.searchSetlists(artistName: "Radiohead") { result in
    switch result {
    case .success(let setlistResponse):
        let matchingSetlists = setlistResponse.setlist
        print(matchingSetlists)
    case .failure(let error):
        print(error.code)
        print(error.message)
    }
}
```

### Languages
This API wrapper is capable of returning results in up to 8 languages, as these are the languages supported by the Setlist.FM API currently:
- English
- Spanish
- French
- German
- Portuguese
- Turkish
- Italian
- Polish

To get results in any of these languages, pass in their associated enum case in the initializer of the wrapper. For example:

```swift
let wrapper = SetlistFmWrapper(apiKey: "your-api-key", language: .portugese)
```

### Documentation

Full documentation for the Setlist.FM API is available here: [https://api.setlist.fm/docs/1.0/ui/index.html](https://api.setlist.fm/docs/1.0/ui/index.html)

This wrapper also features documentation comments ported from the documentation provided in the link above, so all methods and properties are annotated with helpful, descriptive sentences that describe their purpose and usage.

