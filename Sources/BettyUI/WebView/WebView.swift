//
//  File.swift
//  
//
//  Created by Brian Kim on 31/12/2023.
//

import SwiftUI
import WebKit

#if os(macOS)
public struct WebView<T: WebPage>: NSViewRepresentable {
    @Environment(\.themeStyle) private var theme
    
    public let page: T
    public let styleSheet: String
    public let defaultBundleID: String
    
    public init(page: T, styleSheet: String, bundle: String = "") {
        self.page = page
        self.styleSheet = styleSheet
        self.defaultBundleID = bundle
    }
    
    public func makeNSView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        let webView = WKWebView(frame: NSRect.zero, configuration: configuration)
        let userContentController = WKUserContentController()
        configuration.userContentController = userContentController
        webView.loadHTMLString(configureView(), baseURL: nil)
        return webView
    }
    
    public func updateNSView(_ nsView: WKWebView, context: Context) {
        nsView.navigationDelegate = context.coordinator
        nsView.loadHTMLString(configureView(), baseURL: nil)
    }
    
    public func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    private func configureView() -> String {
        let render = page.render()
        let d = try? MacroProcessor.renderedText(withTemplate: styleSheet, substitutions: theme.description)
        guard let d,
              let finalRender = try? MacroProcessor.renderedText(withTemplate: render, substitutions: ["style" : d]) else {
            return render
        }
        return finalRender
    }
    
    public class Coordinator: NSObject, WKNavigationDelegate {
        public var parent: WebView
        
        public init(_ parent: WebView) {
            self.parent = parent
        }
        
        public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if navigationAction.navigationType == .linkActivated {
                if let url = navigationAction.request.url {
                    Task { @MainActor in Browser.open(url.absoluteString, defaultBundleID: parent.defaultBundleID) }
                }
                decisionHandler(.cancel)
                return
            }
            decisionHandler(.allow)
        }
    }
}
#endif

//import SwiftUI
//#if os(macOS)
//import AppKit
//#else
//import UIKit
//#endif
//import WebKit
//
//#if os(macOS)
//public struct WebView: NSViewRepresentable {
//    @Binding public  var htmlString: String
//    public var baseURL: URL?
//    public let defaultBundleID: String?
//    
//    public init(htmlString: Binding<String>, baseURL: URL? = nil, defaultBundleID: String?) {
//        _htmlString = htmlString
//        self.baseURL = baseURL
//        self.defaultBundleID = defaultBundleID
//    }
//    
//    public func makeNSView(context: Context) -> WKWebView {
//        let configuration = WKWebViewConfiguration()
//        let userContentController = WKUserContentController()
//        let baseURL = ArticleRenderer.page.baseURL
//        let appScriptsWorld = WKContentWorld.world(name: "Hypermnesia")
//        for fileName in ["main.js", "main_mac.js", "newsfoot.js"] {
//            userContentController.addUserScript(
//                .init(source: try! String(contentsOf: baseURL.appending(path: fileName,
//                                                                        directoryHint: .notDirectory)),
//                      injectionTime: .atDocumentStart,
//                      forMainFrameOnly: true,
//                      in: appScriptsWorld))
//        }
//        
//        configuration.userContentController = userContentController
//        
//        let view = WKWebView(frame: NSRect.zero, configuration: configuration)
//        view.loadHTMLString(htmlString, baseURL: baseURL)
//        return view
//    }
//    
//    public func updateNSView(_ nsView: WKWebView, context: Context) {
//        nsView.navigationDelegate = context.coordinator
//        nsView.loadHTMLString(htmlString, baseURL: baseURL)
//    }
//    
//    public func makeCoordinator() -> Coordinator {
//        Coordinator(self, bundleID: defaultBundleID)
//    }
//    
//    public class Coordinator: NSObject, WKNavigationDelegate {
//        public var parent: WebView!
//        public let defaultBundleID: String?
//        
//        public init(_ parent: WebView!, bundleID: String?) {
//            self.parent = parent
//            self.defaultBundleID = bundleID
//        }
//
//}
//#endif
