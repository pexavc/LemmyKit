//
//  File.swift
//  
//
//  Created by Ritesh Pakala on 8/7/23.
//

import Foundation

public enum FetchType: CustomStringConvertible, Equatable, Codable {
    case base
    case source
    case peer
    
    public var description: String {
        switch self {
        case .base: return "base"
        case .source: return "source"
        case .peer: return "peer"
        }
    }
}
