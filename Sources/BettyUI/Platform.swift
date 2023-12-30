//
//  Platform.swift
//
//
//  Created by Brian Kim on 30/12/2023.
//

import SwiftUI

#if os(iOS)
public typealias UXFont = UIFont
public typealias UXColor = UIColor
public typealias UXTextView = UITextView
public typealias UXFontDescriptor = UIFontDescriptor
#elseif os(macOS)
public typealias UXFont = NSFont
public typealias UXColor = NSColor
public typealias UXTextView = NSTextView
public typealias UXFontDescriptor = NSFontDescriptor
#endif
