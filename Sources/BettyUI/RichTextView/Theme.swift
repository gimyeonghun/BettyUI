//
//  Theme.swift
//
//
//  Created by Brian Kim on 30/12/2023.
//

import SwiftUI

public struct Theme: ThemeStyle {
    public var foreground: Color
    
    public var foregroundLight: Color
    
    public var foregroundFaded: Color
    
    public var background: Color
    
    public var accent: Color
    
    public init(foreground: Color,
                foregroundLight: Color? = nil,
                foregroundFaded: Color? = nil,
                background: Color,
                accent: Color) {
        self.foreground = foreground
        self.foregroundLight = foregroundLight == nil ? foreground.opacity(0.7) : foregroundLight!
        self.foregroundFaded = foregroundFaded == nil ? foreground.opacity(0.25) : foregroundFaded!
        self.background = background
        self.accent = accent
    }
    
    public static var plain: Theme {
        Theme(foreground: .primary, foregroundLight: .primary.opacity(0.5), foregroundFaded: .secondary, background: .white, accent: .primary)
    }
    
    public static var light: Theme {
        Theme(foreground: Color(red: 0.267, green: 0.267, blue: 0.267),
            foregroundLight: Color(red: 0.467, green: 0.467, blue: 0.467),
            foregroundFaded: Color(red: 0.772, green: 0.772, blue: 0.772),
            background: Color(red: 0.957, green: 0.961, blue: 0.961),
            accent: Color(red: 0.553, green: 0.863, blue: 0.765))
    }
    
    public static var dark: Theme {
        Theme(foreground: Color.white,
            foregroundLight: Color(red: 0.467, green: 0.467, blue: 0.467),
            foregroundFaded: Color(red: 0.467, green: 0.467, blue: 0.467),
            background: Color(red: 0.133, green: 0.133, blue: 0.137),
            accent: Color(red: 0.957, green: 0.722, blue: 0.361)
        )
    }
    
    public static var blackWhite: Theme {
        Theme(foreground: .white, background: .black, accent: .white)
    }
    
    public static var futureLand: Theme {
        Theme(foreground: Color(hex: "#A5A5A5"),
                   background: Color(hex: "#000000"),
                   accent: Color(hex: "#9A98FF"))
    }
    
    public static var oneDark: Theme {
        Theme(foreground: Color(hex: "#A5A5A5"),
                   background: Color(hex: "#000000"),
                   accent: Color(hex: "#9A98FF"))
    }
    
    public static var neon: Theme {
        Theme(foreground: Color(hex: "#E797CE"),
                   background: Color(hex: "#1E142D"),
                   accent: Color(hex: "#EB5267"))
    }
    
    public static var pastel: Theme {
        Theme(foreground: Color(hex: "#524135"),
                   background: Color(hex: "#E5DFDA"),
                   accent: Color(hex: "#9E8C96"))
    }
    
    private func foregroundLight(from colour: Color) -> Color {
        return opacity(colour, 0.7)
    }
    
    private func foregroundFaded(from colour: Color) -> Color {
        return opacity(colour, 0.25)
    }
    
    private func opacity(_ colour: Color, _ value: Double) -> Color {
        colour.opacity(value)
    }
}
