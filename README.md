# BettyUI

A collection of multiplatform and reusable SwiftUI Components

## Usage

### Theme

You can use custom defined theme styles to provide a consistent look to your app.

Ensure that your theme conforms to the `ThemeStyle` Protocol. You can use `Theme`, which conforms to the protocol out of the box.

Extend `Theme` by doing the following:

```swift
extension Theme {
    public static var exampleTheme: Theme {
        Theme(foreground: Color(red: 0.267, green: 0.267, blue: 0.267),
            foregroundLight: Color(red: 0.467, green: 0.467, blue: 0.467),
            foregroundFaded: Color(red: 0.772, green: 0.772, blue: 0.772),
            background: Color(red: 0.957, green: 0.961, blue: 0.961),
            accent: Color(red: 0.553, green: 0.863, blue: 0.765))
    }
}

// Optional

extension ThemeStyle where Self == Theme {
    public static var exampleTheme: Self { .exampleTheme }
}
``` 

The view modifier `.themeStyle` injects the theme into the environment.

```swift
struct ContentView: View {
    var body: some View {
        SampleView(text: "Hello World")
            .themeStyle(.exampleTheme)
    }
}

struct SampleView: View {
    @Environment(\.themeStyle) private var style
    let text: String
    
    var body: some View {
        Text(text)
            .foregroundStyle(style.foreground)
    }
}
``

### WebView

WebView is the front-facing view of a web template engine. It's only argument is any type that must conform to `WebPage` (original naming, I know).

Protocol `WebPage` requires one function, `render()`, which will generate the html string. BettyUI provides `Page`, a type that provides some sensible defaults.

```swift
let helloPage = Page(name: "hello")

WebView(page: helloPage)
    .themeStyle(.exampleTheme) // wow callback!
```

