//
//  WrappedRichTextView.swift
//  
//
//  Created by Brian Kim on 30/12/2023.
//

import SwiftUI
import SwiftSoup

public struct WrappedRichTextView: NSViewControllerRepresentable {
    let configuration: ThemeStyleConfiguration
    
    public func makeNSViewController(context: Context) -> NSViewController {
        let vc = TextEditorController(with: configuration)
        vc.textView.delegate = context.coordinator
        configureTextView(vc.textView)
        setColors(vc.textView, style: configuration)
        return vc
    }
    
    public func updateNSViewController(_ nsViewController: NSViewController, context: Context) {
        guard let vc = nsViewController as? TextEditorController else { return }
        
        do {
            var render = HTMLRender(with: configuration)
            let document: Document = try SwiftSoup.parse(configuration.label)
            vc.textView.attributedText = render.attributedString(from: document)
        } catch {
            vc.textView.attributedText = NSAttributedString(string: "")
        }
        
        setColors(vc.textView, style: configuration)
        
        if !context.coordinator.selectedRanges.isEmpty {
            vc.textView.selectedRanges = context.coordinator.selectedRanges
        }
        print(vc.textView.selectedRanges)
    }
    
    private func setColors(_ textView: UXTextView, style: ThemeStyleConfiguration) {
//        textView.textColor = style.platformForegroundLight
//        textView.backgroundColor = style.platformBackground
//        textView.insertionPointColor = NSColor(style.accent)
//        textView.selectedTextAttributes[.backgroundColor] = style.platformForegroundFaded
//        textView.selectedTextAttributes[.foregroundColor] = style.platformAccent
    }
    
    public func makeCoordinator() -> Coordinator {
        let coordinator = Coordinator()
        return coordinator
    }
    
    public class Coordinator: NSObject, NSTextViewDelegate {
        var onLinkTapped: ((URL) -> Bool)?
        var selectedRanges: [NSValue] = []
        
        public func textView(_ textView: NSTextView, clickedOnLink link: Any, at charIndex: Int) -> Bool {
            guard let url = link as? URL else {
                return false
            }
            if let onLinkTapped = onLinkTapped,
               onLinkTapped(url) {
                return true
            }
            return false
        }
        
        public func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? UXTextView else { return }
            self.selectedRanges = textView.selectedRanges
        }
        
        public func textViewDidChangeSelection(_ notification: Notification) {
            guard let textView = notification.object as? UXTextView else { return }
            selectedRanges = textView.selectedRanges
        }
    }
}

fileprivate final class TextEditorController: NSViewController {
    let scrollView: NSScrollView
    let textView: UXTextView
    let configuration: ThemeStyleConfiguration
    
    init(with configuration: ThemeStyleConfiguration) {
        self.scrollView = UXTextView.scrollableTextView()
        self.textView = scrollView.documentView as! UXTextView
        self.configuration = configuration
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        scrollView.hasVerticalRuler = true
        scrollView.autohidesScrollers = true
        
        textView.textContainerInset = NSSize(width: 32, height: 32) // another kind of calculation
        
        if textView.textLayoutManager != nil {
            var render = HTMLRender(with: configuration)
            do {
                let document: SwiftSoup.Document = try SwiftSoup.parse(configuration.label)
                textView.attributedText = render.attributedString(from: document)
            } catch {
                textView.attributedText = NSAttributedString(string: "")
            }
        }
        
        self.view = scrollView
    }
}

private func configureTextView(_ textView: UXTextView) {
    textView.isSelectable = true
    textView.isEditable = false
    textView.linkTextAttributes = [
        .underlineStyle: 1
    ]
#if os(macOS)
    textView.isAutomaticSpellingCorrectionEnabled = false
    textView.autoresizingMask = [.width]
    textView.usesFindBar = true
    textView.isIncrementalSearchingEnabled = true
#endif
}
