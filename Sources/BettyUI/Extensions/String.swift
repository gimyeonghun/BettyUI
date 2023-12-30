//
//  File.swift
//  
//
//  Created by Brian Kim on 31/12/2023.
//

import Foundation

extension String {
    var encodedURLString: String? {
        // should i implement it?
        guard let urlParts = URLComponents(string: self) else { return nil }
        return self
    }
}
