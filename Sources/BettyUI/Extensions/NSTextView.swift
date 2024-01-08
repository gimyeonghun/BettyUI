//
//  NSTextView.swift
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

#if os(macOS)
extension NSTextView {
    var attributedText: NSAttributedString? {
        get { nil }
        set { textStorage?.setAttributedString(newValue ?? NSAttributedString()) }
    }
    
    var text: String {
        get { string }
        set { string = newValue }
    }
}
#endif
