//
//  Theme.swift
//
//
//  Created by Brian Kim on 30/12/2023.
//

import SwiftUI

public struct Theme: ThemeStyle {
    public var primary: Color
    
    public var secondary: Color
    
    public var selection: Color
    
    public var header: Color
    
    public var link: Color
    
    public var background: Color
    
    public var secondaryBackground: Color
    
    public var description: [String : String] {
        var d = [String : String]()
        d["primary-colour"] = self.primary.css
        d["secondary-colour"] = self.secondary.css
        d["selection-colour"] = self.selection.css
        d["header-colour"] = self.header.css
        d["link-colour"] = self.link.css
        d["background-colour"] = self.background.css
        d["secondary-background-colour"] = self.secondaryBackground.css
        
        return d
    }
    
    // MARK: Identifiable
    
    public var id: UUID { self.uuid }
    
    private let uuid: UUID
        
    public init(primary: Color,
                secondary: Color,
                selection: Color,
                header: Color,
                link: Color,
                background: Color,
                secondaryBackground: Color) {
        self.uuid = UUID()
        self.primary = primary
        self.secondary = secondary
        self.selection = selection
        self.header = header
        self.link = link
        self.background = background
        self.secondaryBackground = secondaryBackground
    }
    
    public static var system: Theme {
        Theme.init(primary: .primary, secondary: .secondary, selection: .accentColor, header: .primary, link: .indigo, background: .white, secondaryBackground: .gray.opacity(0.6))
    }
}
