//
//  File.swift
//  
//
//  Created by Brian Kim on 31/12/2023.
//

#if os(macOS)
import AppKit
import WebKit

@MainActor struct Browser {
    /// The user-specified default browser for opening web pages.
    ///
    /// The user-assigned default browser, or `nil` if none was assigned
    /// (i.e., the system default should be used).
    static func defaultBrowser(bundleID: String?) -> MacWebBrowser? {
        if let bundleID,
           let browser = MacWebBrowser(bundleIdentifier: bundleID) {
            return browser
        }
        return nil
    }
    
    /// Opens a URL in the default browser.
    ///
    /// - Parameters:
    ///   - urlString: The URL to open.
    ///   - invert: Whether to invert the "open in background in browser" preference
    static func open(_ urlString: String, defaultBundleID: String?, invertPreference invert: Bool = false) {
        // Opens according to prefs.
        open(urlString, bundleID: defaultBundleID, inBackground: invert)
    }
    
    /// Opens a URL in the default browser.
    ///
    /// - Parameters:
    ///   - urlString: The URL to open.
    ///   - inBackground: Whether to open the URL in the background or not.
    /// - Note: Some browsers (specifically Chromium-derived ones) will ignore the request
    ///   to open in the background.
    static func open(_ urlString: String, bundleID: String?, inBackground: Bool) {
        guard let url = URL(unicodeString: urlString),
              let preparedURL = url.preparedForOpeningInBrowser() else { return }
        
        let configuration = NSWorkspace.OpenConfiguration()
        configuration.requiresUniversalLinks = true
        configuration.promptsUserIfNeeded = false
        if inBackground {
            configuration.activates = false
        }

        NSWorkspace.shared.open(preparedURL, configuration: configuration) { (runningApplication, error) in
            guard error != nil else { return }
            if let defaultBrowser = defaultBrowser(bundleID: bundleID) {
                defaultBrowser.openURL(url, inBackground: inBackground)
            } else {
                MacWebBrowser.openURL(url, inBackground: inBackground)
            }
        }
    }
}
#endif

