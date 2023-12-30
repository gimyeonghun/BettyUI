//
//  UXFont.swift
//
//
//  Created by Brian Kim on 30/12/2023.
//

import Foundation

extension UXFont {
    func apply(newTraits: UXFontDescriptor.SymbolicTraits, newPointSize: CGFloat? = nil) -> UXFont {
        var existingTraits = fontDescriptor.symbolicTraits
        existingTraits.insert(newTraits)
        
        #if os(macOS)
        let newFontDescriptor = fontDescriptor.withSymbolicTraits(existingTraits)
        guard let font = UXFont(descriptor: newFontDescriptor, size: newPointSize ?? pointSize) else { return self }
        return font
        #else
        guard let newFontDescriptor = fontDescriptor.withSymbolicTraits(existingTraits) else { return self }
        return HiggsFont(descriptor: newFontDescriptor, size: newPointSize ?? pointSize)
        #endif

    }
}
