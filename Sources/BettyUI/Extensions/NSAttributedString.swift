//
//  File.swift
//  
//
//  Created by Brian Kim on 30/12/2023.
//

import Foundation

extension NSAttributedString {
    static let empty = NSAttributedString(string: "")
    
    static func singleNewline(withFontSize fontSize: CGFloat) -> NSAttributedString {
        return NSAttributedString(string: "\n", attributes: [.font: UXFont.systemFont(ofSize: fontSize, weight: .regular)])
    }
    
    static func doubleNewline(withFontSize fontSize: CGFloat) -> NSAttributedString {
        return NSAttributedString(string: "\n\n", attributes: [.font: UXFont.systemFont(ofSize: fontSize, weight: .regular)])
    }
}

extension NSAttributedString.Key {
    static let listDepth = NSAttributedString.Key("ListDepth")
    static let quoteDepth = NSAttributedString.Key("QuoteDepth")
}
