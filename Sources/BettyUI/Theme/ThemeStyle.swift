//
//  ThemeStyle.swift
//
//
//  Created by Brian Kim on 30/12/2023.
//

import SwiftUI

public protocol ThemeStyle: DynamicProperty, Identifiable, Hashable, Equatable {
    var primary: Color { get }
    var secondary: Color { get }
    var selection: Color { get }
    var header: Color { get }
    var link: Color { get }
    var background: Color { get }
    var secondaryBackground: Color { get }
    
    var description: [String : String] { get }
}

extension ThemeStyle where Self == Theme {
    public static var system: Self { .system }
}
