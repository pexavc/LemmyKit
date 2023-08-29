//
//  File.swift
//  
//
//  Created by PEXAVC on 8/7/23.
//

import Foundation

public enum ResourceType: CustomStringConvertible {
    case post(PostView)
    case comment(CommentView)
    case creator(PersonView)
    case community(CommunityView)
    
    public var description: String {
        switch self {
        case .post: return "post"
        case .comment: return "comment"
        case .creator(_): return "creator"
        case .community(_): return "community"
        }
    }
}

public protocol LemmyResource {
    var viewableHosts: [String] { get }
    var isBaseResource: Bool { get }
    var isPeerResource: Bool { get }
    func host(for location: FetchType) -> String
    func location(for host: String) -> FetchType
}


extension CommentView: LemmyResource {
    public var viewableHosts: [String] {
        var hosts: [String] = [LemmyKit.host]
        
//        if let baseHost = community.actor_id.host,
//           baseHost != hosts.last {
//            hosts += [baseHost]
//        }
        
//        if let peerHost = creator.actor_id.host,
//           peerHost != hosts.last,
//           peerHost != LemmyKit.host {
//            hosts += [peerHost]
//        }
        
        if let peerHost = post.ap_id.host,
           peerHost != hosts.last,
           peerHost != LemmyKit.host {
            hosts += [peerHost]
        }
        
        return hosts
    }
    
    public var isBaseResource: Bool {
        LemmyKit.host == community.actor_id.host
    }
    
    public var isPeerResource: Bool {
        community.actor_id.host != creator.actor_id.host
    }
    
    public func host(for location: FetchType) -> String {
        switch location {
        case .base:
            return LemmyKit.host
        case .source:
            return community.actor_id.host ?? LemmyKit.host
        case .peer(let host):
            return host
        }
    }
    
    public func location(for host: String) -> FetchType {
        if LemmyKit.host == host {
            return .base
        } else if community.actor_id.host ?? LemmyKit.host == host {
            return .source
        } else {
            return .peer(host)
        }
    }
}

extension PostView: LemmyResource {
    public var viewableHosts: [String] {
        var hosts: [String] = [LemmyKit.host]
        
        //we would need auth to resolve the post to the source community's location
//        if let baseHost = community.actor_id.host,
//           baseHost != hosts.last {
//            hosts += [baseHost]
//        }
        
        if let peerHost = creator.actor_id.host,
           peerHost != hosts.last,
           peerHost != LemmyKit.host {
            hosts += [peerHost]
        }
        
        return hosts
    }
    
    public var isBaseResource: Bool {
        LemmyKit.host == community.actor_id.host
    }
    
    public var isPeerResource: Bool {
        community.actor_id.host != creator.actor_id.host
    }
    
    public func host(for location: FetchType) -> String {
        switch location {
        case .base:
            return LemmyKit.host
        case .source:
            return community.actor_id.host ?? LemmyKit.host
        case .peer(let host):
            return host
        }
    }
    
    public func location(for host: String) -> FetchType {
        if LemmyKit.host == host {
            return .base
        } else if community.actor_id.host ?? LemmyKit.host == host {
            return .source
        } else {
            return .peer(host)
        }
    }
}

extension CommunityView: LemmyResource {
    public var viewableHosts: [String] {
        var hosts: [String] = [LemmyKit.host]
        
        if let baseHost = community.actor_id.host,
           baseHost != hosts.last {
            hosts += [baseHost]
        }
        
        return hosts
    }
    
    public var isBaseResource: Bool {
        LemmyKit.host == community.actor_id.host
    }
    
    public var isPeerResource: Bool {
        false
    }
    
    public func host(for location: FetchType) -> String {
        switch location {
        case .base:
            return LemmyKit.host
        case .source:
            return community.actor_id.host ?? LemmyKit.host
        case .peer(let host):
            return host
        }
    }
    
    public func location(for host: String) -> FetchType {
        if LemmyKit.host == host {
            return .base
        } else if community.actor_id.host ?? LemmyKit.host == host {
            return .source
        } else {
            return .peer(host)
        }
    }
}

//extension Community {
//    var location: FetchType {
//        if actor_id.host != LemmyKit.host,
//           let peerHost = actor_id.host {
//            if peerHost == community?.ap_id?.host {
//                return .source
//            } else {
//                return .peer(peerHost)
//            }
//        } else {
//            return .base
//        }
//    }
//}

extension PersonView: LemmyResource {
    public var viewableHosts: [String] {
        var hosts: [String] = [LemmyKit.host]
        
        if let baseHost = self.person.actor_id.host,
           baseHost != hosts.last {
            hosts += [baseHost]
        }
        
        return hosts
    }
    
    public var isBaseResource: Bool {
        LemmyKit.host == person.actor_id.host
    }
    
    public var isPeerResource: Bool {
        false
    }
    
    public func host(for location: FetchType) -> String {
        switch location {
        case .base:
            return LemmyKit.host
        case .source:
            return person.actor_id.host ?? LemmyKit.host
        case .peer(let host):
            return host
        }
    }
    
    public func location(for host: String) -> FetchType {
        if LemmyKit.host == host {
            return .base
        } else if person.actor_id.host ?? LemmyKit.host == host {
            return .source
        } else {
            return .peer(host)
        }
    }
}
