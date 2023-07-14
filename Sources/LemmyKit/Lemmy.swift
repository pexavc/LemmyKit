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

//MARK: -- Auth/Registration

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
}

//MARK: -- Fetch
    
public extension Lemmy {
    
    func communities(_ type: ListingType = .local,
                     auth: String? = nil) async -> [CommunityView] {
        guard let result = try? await api.request(
            ListCommunities(type_: .local,
                            auth: auth ?? self.auth)
        ).async() else {
            return []
        }
        
        return result.communities
    }
    static func communities(_ type: ListingType = .local,
                            auth: String? = nil) async -> [CommunityView] {
        guard let shared else { return [] }
        
        return await shared.communities(type, auth: auth)
    }
    
    func community(_ id: CommunityId? = nil,
                   name: String? = nil,
                   auth: String? = nil) async -> CommunityView? {
        guard let result = try? await api.request(
            GetCommunity(id: id,
                         name: name,
                         auth: auth)
        ).async() else {
            return nil
        }
        
        return result.community_view
    }
    static func community(_ id: CommunityId? = nil,
                          name: String? = nil,
                          auth: String? = nil) async -> CommunityView? {
        guard let shared else { return nil }
        
        return await shared.community(id,
                                      name: name,
                                      auth: auth ?? shared.auth)
    }
    
    func post(_ postId: PostId? = nil,
              comment: Comment? = nil,
              auth: String? = nil) async -> PostView? {
        guard let result = try? await api.request(
            GetPost(id: postId,
                    comment_id: comment?.id,
                    auth: auth ?? self.auth)
        ).async() else {
            return nil
        }
        
        return result.post_view
    }
    static func post(_ postId: PostId? = nil,
                     comment: Comment? = nil,
                     auth: String? = nil) async -> PostView? {
        guard let shared else { return nil }
        
        return await shared.post(postId, comment: comment, auth: auth)
    }
    
    func posts(_ community: Community? = nil,
               type: ListingType = .local,
               page: Int? = nil,
               limit: Int? = nil,
               sort: SortType? = nil,
               auth: String? = nil) async -> [PostView] {
        guard let result = try? await api.request(
            GetPosts(type_: type,
                     sort: sort,
                     page: page,
                     limit: limit,
                     community_id: community?.id,
                     community_name: community?.name,
                     auth: auth ?? self.auth)
        ).async() else {
            return []
        }
        
        return result.posts
    }
    static func posts(_ community: Community? = nil,
                      type: ListingType = .local,
                      page: Int? = nil,
                      limit: Int? = nil,
                      sort: SortType? = nil,
                      auth: String? = nil) async -> [PostView] {
        guard let shared else { return [] }
        
        return await shared.posts(community, type: type, page: page, limit: limit, sort: sort, auth: auth)
    }
    
    /*
     Comments can be sourced via post, community, or comment. One must be provided.
     */
    func comments(_ post: Post? = nil,
                  comment: Comment? = nil,
                  community: Community? = nil,
                  type: ListingType = .local,
                  auth: String? = nil) async -> [CommentView] {
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
        
        return result.comments
    }
    static func comments(_ post: Post? = nil,
                         comment: Comment? = nil,
                         community: Community? = nil,
                         type: ListingType = .local,
                         auth: String? = nil) async -> [CommentView] {
        guard let shared else { return [] }
        
        return await shared.comments(post,
                                     comment: comment,
                                     community: community,
                                     type: type,
                                     auth: auth)
    }
}

//MARK: -- Create

public extension Lemmy {
    @discardableResult
    func createCommunity(_ title: String, auth: String) async -> Community? {
        guard let result = try? await api.request(
            CreateCommunity(name: title.lowercased(), title: title, auth: auth)
        ).async() else {
            return nil
        }
        
        return result.community_view.community
    }
    @discardableResult
    static func createCommunity(_ title: String, auth: String? = nil) async -> Community? {
        guard let shared else { return nil }
        
        let validAuth: String? = auth ?? shared.auth
        
        guard let validAuth else {
            LemmyLog("Authentication required")
            return nil
        }
        
        return await shared.createCommunity(title, auth: validAuth)
    }
    
    @discardableResult
    func createPost(_ title: String,
                    content: String,
                    url: String? = nil,
                    body: String? = nil,
                    community: Community,
                    auth: String) async -> Post? {
        guard let result = try? await api.request(
            CreatePost(name: title,
                       community_id: community.id,
                       url: url,
                       body: body,
                       auth: auth)
        ).async() else {
            return nil
        }
        
        return result.post_view.post
    }
    @discardableResult
    static func createPost(_ title: String,
                           content: String,
                           url: String? = nil,
                           body: String? = nil,
                           community: Community,
                           auth: String? = nil) async -> Post? {
        guard let shared else { return nil }
        
        let validAuth: String? = auth ?? shared.auth
        
        guard let validAuth else {
            LemmyLog("Authentication required")
            return nil
        }
        
        return await shared.createPost(title,
                                       content: content,
                                       url: url,
                                       body: body,
                                       community: community,
                                       auth: validAuth)
    }
    
    @discardableResult
    func createComment(_ content: String,
                       post: Post,
                       parent: Comment? = nil,
                       auth: String) async -> Comment? {
        guard let result = try? await api.request(
            CreateComment(content: content,
                          post_id: post.id,
                          parent_id: parent?.id,
                          auth: auth)
        ).async() else {
            return nil
        }
        
        return result.comment_view.comment
    }
    @discardableResult
    static func createComment(_ content: String,
                              post: Post,
                              parent: Comment? = nil,
                              auth: String? = nil) async -> Comment? {
        guard let shared else { return nil }
        
        let validAuth: String? = auth ?? shared.auth
        
        guard let validAuth else {
            LemmyLog("Authentication required")
            return nil
        }
        
        return await shared.createComment(content,
                                          post: post,
                                          parent: parent,
                                          auth: validAuth)
    }
}
