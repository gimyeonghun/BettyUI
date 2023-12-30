//
//  ThemeStyleConfiguration.swift
//
//
//  Created by Brian Kim on 30/12/2023.
//

import SwiftUI
import SwiftSoup

public struct ThemeStyleConfiguration: ThemeStyle {
    public let label: String
    
    public let htmlRender: Bool
    
    public var foreground: Color
    
    public var foregroundLight: Color
    
    public var foregroundFaded: Color
    
    public var background: Color
    
    public var accent: Color
    
    public var fgColor: UXColor { UXColor(foreground) }
    public var fgLightColor: UXColor { UXColor(foregroundLight) }
    public var fgFadedColor: UXColor { UXColor(foregroundFaded) }
    public var bgColor: UXColor { UXColor(background) }
    public var accentColor: UXColor { UXColor(accent) }
    
    public func attributedString() -> NSAttributedString {
        if htmlRender {
            do {
                let document: SwiftSoup.Document = try SwiftSoup.parse(label)
                var render = HTMLRender(with: self)
                return render.attributedString(from: document)
            } catch {
                return NSAttributedString.empty
            }
        }
        
//        let document = Markdown.Document(parsing: label)
//        var render = MarkdownRender(foreground: foreground, foregroundLight: foregroundLight, foregroundFaded: foregroundFaded, background: background, accent: accent)
//        return render.attributedString(from: "")
        return NSAttributedString.empty
    }
}
