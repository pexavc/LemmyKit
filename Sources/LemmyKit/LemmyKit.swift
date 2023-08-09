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
            let sanitizedValue = sanitize(newValue)
            
            self.host = sanitizedValue.host ?? ""
            _baseUrl = sanitizedValue.baseUrl ?? ""
            current = .init(apiUrl: _baseUrl, base: true)
        }
    }
    static var _baseUrl: String = ""
    
    public static var host: String = ""
    
    public static var current: Lemmy = .init(apiUrl: "")
    
    public static var auth: String? {
        get {
            return Lemmy.shared?.auth
        }
        set {
            Lemmy.shared?.auth = newValue
        }
    }
    
    public static var Version: String = "v3"
    
    public static var logLevel: LemmyLogLevel = .debug
    
    
    static func sanitize(_ base: String) -> (host: String?, baseUrl: String?, apiUrl: String?) {
        let value: String = (base.contains("http") ? "" : "https://") + base
        
        let host: String
        
        //TODO: odd malloc issue
        /*if #available(macOS 13.0, iOS 16.0, *),
           let sanitized = URL(string: value)?.host(percentEncoded: false) {
            host = sanitized
        } else */if let sanitized = URL(string: value)?.host {
            host = sanitized
        } else {
            return (nil, nil, nil)
        }
        let url: String = "https://" + host
//        LemmyLog(url, logLevel: .debug)
        return (host, url, "https://" + host + "/api/" + Version)
    }
}
