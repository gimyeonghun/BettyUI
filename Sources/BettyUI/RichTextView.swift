//
//  RichTextView.swift
//
//
//  Created by Brian Kim on 30/12/2023.
//

import SwiftUI

public struct RichTextView: View {
    public let text: String
    
    public init(_ text: String) {
        self.text = text
    }
    
    public var body: some View {
        Text(text)
    }
}
