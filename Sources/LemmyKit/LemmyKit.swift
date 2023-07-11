//
//  LemmyKit.swift
//  
//
//  Created by PEXAVC on 7/11/23.
//

import Foundation

public class LemmyKit {
    //Not necessary if using a standalone Lemmy object
    public static var baseUrl: String {
        get {
            return _baseUrl
        }
        set {
            let host: String
            
            if #available(macOS 13.0, *),
               let sanitized = URL(string: newValue)?.host(percentEncoded: false) {
                host = sanitized
            } else if let sanitized = URL(string: newValue)?.host {
                host = sanitized
            } else {
                return
            }
            
            _baseUrl = "https://" + host + "/api/" + VERSION
            Lemmy.shared = .init(apiUrl: _baseUrl)
        }
    }
    static var _baseUrl: String = ""
    
    public static var VERSION: String = "v3"
}
