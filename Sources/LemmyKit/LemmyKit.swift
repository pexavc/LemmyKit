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
            
            #if os(macOS)
            if #available(macOS 13.0, *),
               let sanitized = URL(string: newValue)?.host(percentEncoded: false) {
                host = sanitized
            } else if let sanitized = URL(string: newValue)?.host {
                host = sanitized
            } else {
                return
            }
            #else
            if #available(iOS 16.0, *),
               let sanitized = URL(string: newValue)?.host(percentEncoded: false) {
                host = sanitized
            } else if let sanitized = URL(string: newValue)?.host {
                host = sanitized
            } else {
                return
            }
            #endif
            
            _baseUrl = "https://" + host + "/api/" + Version
            current = .init(apiUrl: _baseUrl)
        }
    }
    static var _baseUrl: String = ""
    
    public static var current: Lemmy?
    
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
}
