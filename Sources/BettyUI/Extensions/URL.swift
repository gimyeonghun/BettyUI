//
//  File.swift
//  
//
//  Created by Brian Kim on 31/12/2023.
//

import Foundation

extension URL {
    init?(unicodeString: String) {
        if let url = URL(string: unicodeString) {
            self = url
            return
        }
        
        guard let encodedString = unicodeString.encodedURLString else { return nil }
        self.init(string: encodedString)
    }
    
    func preparedForOpeningInBrowser() -> URL? {
        var urlString = absoluteString.replacingOccurrences(of: " ", with: "%20")
        urlString = urlString.replacingOccurrences(of: "^", with: "%5E")
        urlString = urlString.replacingOccurrences(of: "&amp;", with: "&")
        urlString = urlString.replacingOccurrences(of: "&#38;", with: "&")
        
        return URL(string: urlString)
    }
}
