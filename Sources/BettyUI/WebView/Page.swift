//
//  Page.swift
//
//
//  Created by Brian Kim on 6/1/2024.
//

import Foundation

public protocol WebPage {
    var template: Template { get }
    func render<S: ThemeStyle>(_ theme: S) -> String
}

public struct Template {
    public let url: URL
    public let baseURL: URL
    public let html: String
    
    public init(name: String) {
        url = Bundle.main.url(forResource: name, withExtension: "html")!
        baseURL = url.deletingLastPathComponent()
        html = try! String(contentsOfFile: url.path, encoding: .utf8)
    }
    
    public static var `default` = Template(name: "page")
}

public struct Page: WebPage {
    public let template: Template
    let substitutions: [String : String]
    
    public init(name: String, with substitutions: [String: String] = [:]) {
        self.template = Template(name: name)
        self.substitutions = substitutions
    }
    
    public func render<S: ThemeStyle>(_ theme: S = Theme.light) -> String {
        do {
            let render = try MacroProcessor.renderedText(withTemplate: template.html, substitutions: substitutions, theme: theme)
            return render
        } catch {
            return ""
        }
    }
}
