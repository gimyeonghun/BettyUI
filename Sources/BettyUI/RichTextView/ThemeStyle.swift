//
//  ThemeStyle.swift
//
//
//  Created by Brian Kim on 30/12/2023.
//

import SwiftUI

public protocol ThemeStyle: DynamicProperty {
    var foreground: Color { get }
    var foregroundLight: Color { get }
    var foregroundFaded: Color { get }
    var background: Color { get }
    var accent: Color { get }
}

extension ThemeStyle where Self == Theme {
    public static var plain: Self { .plain }
    public static var light: Self { .light }
    public static var dark: Self { .dark }
    public static var blackWhite: Self { .blackWhite }
    public static var futureLand: Self { .futureLand }
    public static var oneDark: Self { .oneDark }
    public static var neon: Self { .neon }
    public static var pastel: Self { .pastel }
}
