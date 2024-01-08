//
//  NSMutableAttributedString.swift
//
//
//  Created by Brian Kim on 30/12/2023.
//

import Foundation
#if os(macOS)
import AppKit
#else
import UIKit
#endif

extension NSMutableAttributedString {
    func addAttribute(_ name: NSAttributedString.Key, value: Any) {
        addAttribute(name, value: value, range: NSRange(location: 0, length: length))
    }
    
    func addAttributes(_ attrs: [NSAttributedString.Key : Any]) {
        addAttributes(attrs, range: NSRange(location: 0, length: length))
    }

    func applyParagraph(color textColor: UXColor) {
        enumerateAttribute(.foregroundColor, in: NSRange(location: 0, length: length), options: []) { value, range, stop in
            addAttribute(.foregroundColor, value: textColor, range: range)
        }
    }
    
    func applyEmphasis() {
        enumerateAttribute(.font, in: NSRange(location: 0, length: length), options: []) { value, range, stop in
            guard let font = value as? UXFont else { return }
            
            #if os(macOS)
            let newFont = font.apply(newTraits: .italic)
            #else
            let newFont = font.apply(newTraits: .traitItalic)
            #endif
            addAttribute(.font, value: newFont, range: range)
        }
    }
    
    func applyStrong() {
        enumerateAttribute(.font, in: NSRange(location: 0, length: length), options: []) { value, range, stop in
            guard let font = value as? UXFont else { return }
            #if os(macOS)
            let newFont = font.apply(newTraits: .bold)
            #else
            let newFont = font.apply(newTraits: .traitBold)
            #endif
            addAttribute(.font, value: newFont, range: range)
        }
    }
    
    func applyLink(color textColor: UXColor, withURL url: URL?) {
        addAttribute(.foregroundColor, value: textColor)
        
        if let url = url {
            addAttribute(.link, value: url)
        }
    }
    
    func applyBlockquote(color textColor: UXColor) {
        addAttribute(.foregroundColor, value: textColor)
    }
    
    func applyHeading(color textColor: UXColor, withLevel headingLevel: Int) {
        enumerateAttribute(.font, in: NSRange(location: 0, length: length), options: []) { value, range, stop in
            guard let font = value as? UXFont else { return }
            
            #if os(macOS)
            let newFont = font.apply(newTraits: .bold, newPointSize: 28.0 - CGFloat(headingLevel * 2))
            #else
            let newFont = font.apply(newTraits: .traitBold, newPointSize: 28.0 - CGFloat(headingLevel * 2))
            #endif
            addAttribute(.font, value: newFont, range: range)
            addAttribute(.foregroundColor, value: textColor, range: range)
        }
    }
    
    func applyStrikethrough() {
        addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue)
    }
}
