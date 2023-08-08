//
//  File.swift
//  
//
//  Created by Ritesh Pakala on 8/7/23.
//

import Foundation

public enum FetchType: CustomStringConvertible, Equatable, Codable, Hashable {
    case base
    case source
    case peer(String)
    
   public var isPeer: Bool {
        switch self {
        case .peer:
            return true
        default:
            return false
        }
    }
    
    public var description: String {
        switch self {
        case .base: return "base"
        case .source: return "source"
        case .peer: return "peer"
        }
    }
    
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .peer(let host):
            hasher.combine(self.description+host)
        default:
            hasher.combine(self.description)
        }
    }
}
