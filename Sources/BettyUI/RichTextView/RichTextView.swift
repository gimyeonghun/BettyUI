//
//  RichTextView.swift
//
//
//  Created by Brian Kim on 30/12/2023.
//

import SwiftUI

public struct RichTextView: View {
    @Environment(\.themeStyle) private var theme
    
    public var text: String
    public var html: Bool
    
    var configuration: ThemeStyleConfiguration {
        .init(label: text, htmlRender: html, foreground: theme.foreground, foregroundLight: theme.foregroundLight, foregroundFaded: theme.foregroundFaded, background: theme.background, accent: theme.accent)
    }
    
    public init(_ text: String, html: Bool = true) {
        self.text = text
        self.html = html
    }
    
    public var body: some View {
        WrappedRichTextView(configuration: configuration)
    }
}
