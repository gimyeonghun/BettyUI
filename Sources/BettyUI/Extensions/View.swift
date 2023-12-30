//
//  View.swift
//
//
//  Created by Brian Kim on 30/12/2023.
//

import SwiftUI

extension View {
    /// Sets the style of the page view within the current environment.
    public func themeStyle<S>(_ style: S) -> some View where S: ThemeStyle {
        self
            .environment(\.themeStyle, style)
    }
}

extension EnvironmentValues {
    struct StyleKey: EnvironmentKey {
        static var defaultValue: any ThemeStyle = Theme.plain
    }
    
    var themeStyle: any ThemeStyle {
        get { self[StyleKey.self] }
        set { self[StyleKey.self] = newValue }
    }
}