//
//  LemmyLog.swift
//  
//
//  Created by PEXAVC on 7/13/23.
//

import Foundation

public enum LemmyLogLevel: Int32, CustomStringConvertible {
    case panic = 0
    case fatal = 8
    case error = 16
    case warning = 24
    case info = 32
    case verbose = 40
    case debug = 48
    case trace = 56

    public var description: String {
        switch self {
        case .panic:
            return "panic"
        case .fatal:
            return "fault"
        case .error:
            return "error"
        case .warning:
            return "warning"
        case .info:
            return "info"
        case .verbose:
            return "verbose"
        case .debug:
            return "debug"
        case .trace:
            return "trace"
        }
    }
}

@inline(__always) public func LemmyLog(_ message: CustomStringConvertible,
                                       logLevel: LemmyLogLevel = .warning,
                                       file: String = #file,
                                       function: String = #function,
                                       line: Int = #line) {
    if logLevel.rawValue <= LemmyKit.logLevel.rawValue {
        let fileName = (file as NSString).lastPathComponent
        print("logLevel: \(logLevel) Lemmy: \(fileName):\(line) \(function) | \(message)")
    }
}
