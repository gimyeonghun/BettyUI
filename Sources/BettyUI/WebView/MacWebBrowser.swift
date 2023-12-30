//
//  File.swift
//  
//
//  Created by Brian Kim on 31/12/2023.
//

#if os(macOS)
import AppKit
import UniformTypeIdentifiers

public class MacWebBrowser {
    
    /// Opens a URL in the default browser.
    @discardableResult public class func openURL(_ url: URL, inBackground: Bool = false) -> Bool {
        guard let preparedURL = url.preparedForOpeningInBrowser() else {
            return false
        }
        
        if (inBackground) {
            let configuration = NSWorkspace.OpenConfiguration()
            configuration.activates = false
            NSWorkspace.shared.open(preparedURL, configuration: configuration)

            return true
        }
        
        return NSWorkspace.shared.open(preparedURL)
    }

    /// Returns an array of the browsers installed on the system, sorted by name.
    ///
    /// "Browsers" are applications that can both handle `https` URLs, and display HTML documents.
    public class func sortedBrowsers() -> [MacWebBrowser] {
        let ws = NSWorkspace.shared
        let httpsIDs = ws.urlsForApplications(toOpen: URL(string: "https:///")!).map { $0.absoluteString }

        let htmlIDs = ws.urlsForApplications(toOpen: UTType.html).map { $0.absoluteString }

        let browserIDs = Set(httpsIDs).intersection(Set(htmlIDs))

        return browserIDs.compactMap { MacWebBrowser(bundleIdentifier: $0) }.sorted {
            if let leftName = $0.name, let rightName = $1.name {
                return leftName < rightName
            }

            return false
        }
    }

    /// The filesystem URL of the default web browser.
    private class var defaultBrowserURL: URL? {
        return NSWorkspace.shared.urlForApplication(toOpen: URL(string: "https:///")!)
    }

    /// The user's default web browser.
    public class var defaultBrowser: MacWebBrowser {
        return MacWebBrowser(url: defaultBrowserURL!)
    }

    /// The filesystem URL of the web browser.
    public let url: URL

    private lazy var _icon: NSImage? = {
        if let values = try? url.resourceValues(forKeys: [.effectiveIconKey]) {
            return values.effectiveIcon as? NSImage
        }

        return nil
    }()

    /// The application icon of the web browser.
    public var icon: NSImage? {
        return _icon
    }

    private lazy var _name: String? = {
        if let values = try? url.resourceValues(forKeys: [.localizedNameKey]), var name = values.localizedName {
            if let extensionRange = name.range(of: ".app", options: [.anchored, .backwards]) {
                name = name.replacingCharacters(in: extensionRange, with: "")
            }

            return name
        }

        return nil
    }()

    /// The localized name of the web browser, with any `.app` extension removed.
    public var name: String? {
        return _name
    }

    private lazy var _bundleIdentifier: String? = {
        return Bundle(url: url)?.bundleIdentifier
    }()

    /// The bundle identifier of the web browser.
    public var bundleIdentifier: String? {
        return _bundleIdentifier
    }

    /// Initializes a `MacWebBrowser` with a URL on disk.
    /// - Parameter url: The filesystem URL of the browser.
    public init(url: URL) {
        self.url = url
    }

    /// Initializes a `MacWebBrowser` from a bundle identifier.
    /// - Parameter bundleIdentifier: The bundle identifier of the browser.
    public convenience init?(bundleIdentifier: String) {
        guard let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: bundleIdentifier) else {
            return nil
        }

        self.init(url: url)
    }

    /// Opens a URL in this browser.
    /// - Parameters:
    ///   - url: The URL to open.
    ///   - inBackground: If `true`, attempt to load the URL without bringing the browser to the foreground.
    @discardableResult public func openURL(_ url: URL, inBackground: Bool = false) -> Bool {
        guard let preparedURL = url.preparedForOpeningInBrowser() else {
            return false
        }
        
        guard let bundleIdentifier,
              let appBundleURL = NSWorkspace.shared.urlForApplication(withBundleIdentifier: bundleIdentifier) else {
            return false
        }
        
        let configuration = NSWorkspace.OpenConfiguration()
        configuration.activates = inBackground ? false : true
        NSWorkspace.shared.open([preparedURL], withApplicationAt: appBundleURL, configuration: configuration)
        return true
    }

}
#endif

