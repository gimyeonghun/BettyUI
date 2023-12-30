//
//  File.swift
//  
//
//  Created by Brian Kim on 31/12/2023.
//

#if os(macOS)
import Foundation
import AppKit

struct ArticleRenderer {
    typealias Rendering = (style: String, html: String, title: String, baseURL: String)
    
    // MARK: Page
    
    struct Page {
        let url: URL
        let baseURL: URL
        let html: String
        
        init(name: String) {
            url = Bundle.main.url(forResource: name, withExtension: "html")!
            baseURL = url.deletingLastPathComponent()
            html = try! NSString(contentsOfFile: url.path, encoding: String.Encoding.utf8.rawValue) as String
        }
    }
    
    static var imageIconScheme = "nnwImageIcon"
    static var blank = Page(name: "blank")
    static var page = Page(name: "page")
    
    // MARK: Initialise
    
    private let title: String
    private let body: String
    private let baseURL: String?
    
    //    private let extractedArticle: ExtractedArticle?
    //    private let articleTheme: ArticleTheme
    
    private init(title: String, body: String, baseURL: URL?) {
        //, extractedArticle: ExtractedArticle?, theme: ArticleTheme) {
//        self.extractedArticle = extractedArticle
//        self.articleTheme = theme
        //        if let content = extractedArticle?.content {
        //            self.body = content
        //            self.baseURL = extractedArticle?.url
        //        } else {
        //        }
        self.title = title
        self.body = body
        self.baseURL = baseURL?.absoluteString

    }
    
    private static let longDateTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        return formatter
    }()

    private static let mediumDateTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()

    private static let shortDateTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()

    private static let longDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()

    private static let mediumDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

    private static let shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()

    private static let longTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .long
        return formatter
    }()

    private static let mediumTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .medium
        return formatter
    }()

    private static let shortTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()
    
    static var defaultStyleSheet: String = {
        let path = Bundle.main.path(forResource: "styleSheet", ofType: "css")!
        let s = try! NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue)
        return "\n\(s)\n"
    }()

    static let defaultTemplate: String = {
        let path = Bundle.main.path(forResource: "template", ofType: "html")!
        let s = try! NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue)
        return s as String
    }()
}

//extension ArticleRenderer {
//    static func articleHTML(article: HMSDArticle) -> Rendering {
//        let renderer = ArticleRenderer(article: article)
//        return (renderer.articleCSS, renderer.articleHTML, renderer.title, renderer.baseURL ?? "")
//    }
//    
//    static func noSelection() -> Rendering {
//        let renderer = ArticleRenderer(article: nil)
//        return (renderer.articleCSS, renderer.noSelectionHTML, renderer.title, "")
//    }
//}

private extension ArticleRenderer {
    private var articleHTML: String {
        return try! MacroProcessor.renderedText(withTemplate: template(), substitutions: articleSubstitutions())
    }
    
    private var noSelectionHTML: String {
        let body = "<h3 class='systemMessage'>No Selection</h3>"
        return body
    }
    
    private var articleCSS: String {
        return try! MacroProcessor.renderedText(withTemplate: styleString(), substitutions: styleSubstitutions())
    }
    
    func styleString() -> String {
        return ArticleRenderer.defaultStyleSheet
    }

    func template() -> String {
        return ArticleRenderer.defaultTemplate
    }
    
    func articleSubstitutions() -> [String: String] {
        var d = [String: String]()
        
//        guard let article = article else {
//            assertionFailure("Article should have been set before calling this function.")
//            return d
//        }
//        
//        d["title"] = title
//        
//        d["preferred_link"] = article.preferredLink ?? ""
//        
//        if let externalLink = article.externalLink, externalLink != article.preferredLink {
//            d["external_link_label"] = NSLocalizedString("label.text.link", comment: "Link: ")
//            d["external_link_stripped"] = externalLink.strippingHTTPOrHTTPSScheme
//            d["external_link"] = externalLink
//        } else {
//            d["external_link_label"] = ""
//            d["external_link_stripped"] = ""
//            d["external_link"] = ""
//        }
//        
//        d["body"] = body
//        
//        var components = URLComponents()
//        components.scheme = Self.imageIconScheme
//        components.path = article.articleID
//        if let imageIconURLString = components.string {
//            d["avatar_src"] = imageIconURLString
//        }
//        else {
//            d["avatar_src"] = ""
//        }
//        
//        if self.title.isEmpty {
//            d["dateline_style"] = "articleDatelineTitle"
//        } else {
//            d["dateline_style"] = "articleDateline"
//        }
//        
//        d["feed_link_title"] = article.feed?.name ?? ""
//        d["feed_link"] = article.feed?.homePageUrl ?? ""
//        
////        d["byline"] = byline()
//        
//        let datePublished = article.logicalDatePublished
//        d["datetime_long"] = Self.longDateTimeFormatter.string(from: datePublished)
//        d["datetime_medium"] = Self.mediumDateTimeFormatter.string(from: datePublished)
//        d["datetime_short"] = Self.shortDateTimeFormatter.string(from: datePublished)
//        d["date_long"] = Self.longDateFormatter.string(from: datePublished)
//        d["date_medium"] = Self.mediumDateFormatter.string(from: datePublished)
//        d["date_short"] = Self.shortDateFormatter.string(from: datePublished)
//        d["time_long"] = Self.longTimeFormatter.string(from: datePublished)
//        d["time_medium"] = Self.mediumTimeFormatter.string(from: datePublished)
//        d["time_short"] = Self.shortTimeFormatter.string(from: datePublished)
//        
        return d
    }
    
//    func byline() -> String {
//        guard let authors = article?.authors, !authors.isEmpty else {
//            return ""
//        }
//        
//        // If the author's name is the same as the feed, then we don't want to display it.
//        // This code assumes that multiple authors would never match the feed name so that
//        // if there feed owner has an article co-author all authors are given the byline.
//        if authors.count == 1, let author = authors.first {
//            if author.name == article?.feed?.name {
//                return ""
//            }
//        }
//        
//        var byline = ""
//        var isFirstAuthor = true
//        
//        for author in authors {
//            if !isFirstAuthor {
//                byline += ", "
//            }
//            isFirstAuthor = false
//            if !author.name.isEmpty {
//                byline += author.name
//            }
//        }
//        
//        return byline
//    }
    
    #if os(iOS)
    func styleSubstitutions() -> [String: String] {
        var d = [String: String]()
        let bodyFont = UIFont.preferredFont(forTextStyle: .body)
        d["font-size"] = String(describing: bodyFont.pointSize)
        return d
    }
    #else
    func styleSubstitutions() -> [String: String] {
        return [String: String]()
    }
    #endif
}

// MARK: - Article extension

//private extension HMSDArticle {
//
//    var baseURL: URL? {
//        var s = link
//        if s == nil {
//            s = feed?.homePageUrl
//        }
//        if s == nil {
//            s = feed?.feedUrl
//        }
//        guard let urlString = s else {
//            return nil
//        }
//        var urlComponents = URLComponents(string: urlString)
//        if urlComponents == nil {
//            return nil
//        }
//        
//        // Can’t use url-with-fragment as base URL. The webview won’t load. See scripting.com/rss.xml for example.
//        urlComponents!.fragment = nil
//        guard let url = urlComponents!.url, url.scheme == "http" || url.scheme == "https" else {
//            return nil
//        }
//        return url
//    }
//}
#endif

