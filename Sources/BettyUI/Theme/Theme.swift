//
//  Theme.swift
//
//
//  Created by Brian Kim on 30/12/2023.
//

import SwiftUI
#if os(macOS)
import AppKit
#else
import UIKit
#endif

public struct Theme: ThemeStyle {
    public var primary: Color
    
    public var secondary: Color
    
    public var selection: Color
    
    public var header: Color
    
    public var link: Color
    
    public var background: Color
    
    public var secondaryBackground: Color
    
    
    private var _primary: String
    private var _secondary: String
    private var _selection: String
    private var _header: String
    private var _link: String
    private var _background: String
    private var _secondaryBackground: String
    
    public var description: [String : String] {
        var d = [String : String]()
        d["primary-colour"] = _primary
        d["secondary-colour"] = _secondary
        d["selection-colour"] = _selection
        d["header-colour"] = _header
        d["link-colour"] = _link
        d["background-colour"] = _background
        d["secondary-background-colour"] = _secondaryBackground
        
        return d
    }
    
    // MARK: Identifiable
    
    public var id: UUID { self.uuid }
    
    private let uuid: UUID
        
    public init(primary: String,
                secondary: String,
                selection: String,
                header: String,
                link: String,
                background: String,
                secondaryBackground: String) {
        self.uuid = UUID()
        self.primary = Color(hex: primary)
        self.secondary = Color(hex: secondary)
        self.selection = Color(hex: selection)
        self.header = Color(hex: header)
        self.link = Color(hex: link)
        self.background = Color(hex: background)
        self.secondaryBackground = Color(hex: secondaryBackground)
        
        self._primary = primary
        self._secondary = secondary
        self._selection = selection
        self._header = header
        self._link = link
        self._background = background
        self._secondaryBackground = secondaryBackground
    }
    
    public static var system: Theme {
        #if os(macOS)
        let selection = UXColor.controlAccentColor.usingColorSpace(.sRGB)!
        #else
        let selection = UXColor.tintColor
        #endif
        return Theme.init(primary: "#1b1b1b", secondary: "#dcdcdc", selection: selection.hex, header: "#1b1b1b", link: "#416ed2", background: "#f7f7f7", secondaryBackground: "#282828")
    }
}
