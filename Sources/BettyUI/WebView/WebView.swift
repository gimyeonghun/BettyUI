//
//  File.swift
//  
//
//  Created by Brian Kim on 31/12/2023.
//

import SwiftUI
#if os(macOS)
import AppKit
#else
import UIKit
#endif
import WebKit

#if os(macOS)
public struct WebView: NSViewRepresentable {
    @Binding public  var htmlString: String
    public var baseURL: URL?
    public let defaultBundleID: String?
    
    public func makeNSView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        let userContentController = WKUserContentController()
        let baseURL = ArticleRenderer.page.baseURL
        let appScriptsWorld = WKContentWorld.world(name: "Hypermnesia")
        for fileName in ["main.js", "main_mac.js", "newsfoot.js"] {
            userContentController.addUserScript(
                .init(source: try! String(contentsOf: baseURL.appending(path: fileName,
                                                                        directoryHint: .notDirectory)),
                      injectionTime: .atDocumentStart,
                      forMainFrameOnly: true,
                      in: appScriptsWorld))
        }
        
        configuration.userContentController = userContentController
        
        let view = WKWebView(frame: NSRect.zero, configuration: configuration)
        view.loadHTMLString(htmlString, baseURL: baseURL)
        return view
    }
    
    public func updateNSView(_ nsView: WKWebView, context: Context) {
        nsView.navigationDelegate = context.coordinator
        nsView.loadHTMLString(htmlString, baseURL: baseURL)
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self, bundleID: defaultBundleID)
    }
    
    public class Coordinator: NSObject, WKNavigationDelegate {
        public var parent: WebView!
        public let defaultBundleID: String?
        
        public init(_ parent: WebView!, bundleID: String?) {
            self.parent = parent
            self.defaultBundleID = bundleID
        }
        
        public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if navigationAction.navigationType == .linkActivated {
                if let url = navigationAction.request.url {
                    Task { @MainActor in Browser.open(url.absoluteString, defaultBundleID: defaultBundleID) }
                }
                decisionHandler(.cancel)
                return
            }
            decisionHandler(.allow)
        }
    }
}
#endif
