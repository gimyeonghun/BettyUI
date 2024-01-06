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
        Theme.init(primary: .primary, secondary: .secondary, selection: .accentColor, header: .primary, link: .indigo, background: .white, secondaryBackground: .gray.opacity(0.6))
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
```

### WebView

WebView is the front-facing view of a web template engine. It's only argument is any type that must conform to `WebPage` (original naming, I know).

Protocol `WebPage` requires one function, `render()`, which will generate the html string. BettyUI provides `Page`, a type that provides some sensible defaults.

`Page` takes 2 arguments, `name` and `substitutions`, which refer to the base html file and the substitutions required.

`WebView` takes 3 arguments, a type conforming to the `WebPage` protocol, a style sheet file and a bundleID. The latter is useful if you wish to open any links in any other browser than the default one. 

If a style sheet is applied, then the base html file in `Page` must have a `[[style]]` substitution. `WebView` will attempt to replace it with the contents provided in the `styleSheet` argument. 

```swift
let helloPage = Page(name: "hello")

WebView(page: helloPage)
    .themeStyle(.exampleTheme) // wow callback!
```

