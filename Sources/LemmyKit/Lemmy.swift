//
//  Lemmy.swift
//  
//
//  Created by PEXAVC on 5/12/23.
//

import Foundation
import Combine

public class Lemmy {
    public let id: UUID
    
    static var shared: Lemmy? {
        LemmyKit.current
    }
    
    public var auth: String? = nil
    
    private var api: Network
    private var pictrs: Network
    
    public init(id: UUID? = nil,
                apiUrl: String,
                pictrsUrl: String? = nil) {
        self.id = id ?? .init()
        self.api = .init(apiUrl)
        self.pictrs = .init(pictrsUrl ?? apiUrl + "/pictrs/image")
    }
    
    public func request<R: Request>(_ request: R) async -> R.TransformedResponse? {
        return try? await api.request(
            request
        ).async()
    }
    
    public func pictrs<R: Request>(_ request: R) async -> R.TransformedResponse? {
        return try? await pictrs.request(
            request
        ).async()
    }
    
    public static func request<R: Request>(_ request: R) async -> R.TransformedResponse? {
        guard let shared else { return nil }
        
        return await shared.request(request)
    }
    
    public static func pictrs<R: Request>(_ request: R) async -> R.TransformedResponse? {
        guard let shared else { return nil }
        
        return await shared.pictrs(request)
    }
}

public extension Lemmy {
    func login(username: String, password: String) async -> String? {
        guard let result = try? await api.request(
            Login(username_or_email: username,
                  password: password)
        ).async() else {
            return nil
        }
        
        return result.jwt
    }
    static func login(username: String, password: String) async -> String? {
        guard let shared else { return nil }
        
        return await shared.login(username: username, password: password)
    }
    
    func communities(_ type: ListingType = .local,
                     auth: String? = nil) async -> [Community] {
        guard let result = try? await api.request(
            ListCommunities(type_: .local,
                            auth: auth ?? self.auth)
        ).async() else {
            return []
        }
        
        return result.communities.map { $0.community }
    }
    static func communities(_ type: ListingType = .local,
                            auth: String? = nil) async -> [Community] {
        guard let shared else { return [] }
        
        return await shared.communities(type, auth: auth)
    }
    
    func posts(_ community: Community,
               type: ListingType = .local,
               auth: String? = nil) async -> [Post] {
        guard let result = try? await api.request(
            GetPosts(type_: type,
                     community_id: community.id,
                     community_name: community.name,
                     auth: auth ?? self.auth)
        ).async() else {
            return []
        }
        
        return result.posts.map { $0.post }
    }
    static func posts(_ community: Community,
                      type: ListingType = .local,
                      auth: String? = nil) async -> [Post] {
        guard let shared else { return [] }
        
        return await shared.posts(community, type: type, auth: auth)
    }
    
    /*
     Comments can be sourced via post, community, or comment. One must be provided.
     */
    func comments(_ post: Post? = nil,
                  comment: Comment? = nil,
                  community: Community? = nil,
                  type: ListingType = .local,
                  auth: String? = nil) async -> [Comment] {
        guard post != nil || comment != nil || community != nil else {
            LemmyLog("Please provide a post, comment, or communit reference")
            return []
        }
        
        guard let result = try? await api.request(
            GetComments(type_: type,
                        community_id: community?.id,
                        community_name: community?.name,
                        post_id: post?.id,
                        parent_id: comment?.id,
                        auth: auth ?? self.auth)
        ).async() else {
            return []
        }
        
        return result.comments.map { $0.comment }
    }
    static func comments(_ post: Post? = nil,
                         comment: Comment? = nil,
                         community: Community? = nil,
                         type: ListingType = .local,
                         auth: String? = nil) async -> [Comment] {
        guard let shared else { return [] }
        
        return await shared.comments(post,
                                     comment: comment,
                                     community: community,
                                     type: type,
                                     auth: auth)
    }
}
