//
//  String+Regex.swift
//  
//
//  Created by PEXAVC on 7/11/23.
//

import Foundation

extension String {
    var host: String? {
        if let sanitized = URL(string: self)?.host {
            return sanitized
        } else {
            return nil
        }
    }
    
    func replace(_ pattern: String,
                 with template: String,
                 options: NSRegularExpression.Options = .caseInsensitive) -> String {
        guard let regex = try? NSRegularExpression(pattern: pattern,
                                                   options: options) else {
            return self
        }
        
        return regex.stringByReplacingMatches(in: self,
                                              options: [],
                                              range: NSRange(0..<self.utf16.count),
                                              withTemplate: template)
    }
}
