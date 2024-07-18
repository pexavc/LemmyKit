//
//  Lemmy+Create.swift
//  
//
//  Created by PEXAVC on 8/23/23.
//

import Foundation

//MARK: -- Create

public extension Lemmy {
    @discardableResult
    func createCommunity(_ title: String, auth: String? = nil) async -> Community? {
        
        let validAuth: String? = auth ?? self.auth
        
        guard let validAuth else {
            LemmyLog("Authentication required")
            return nil
        }
        
        guard let result = try? await api.request(
            CreateCommunity(name: title.lowercased(), title: title, auth: validAuth)
        ).async() else {
            return nil
        }
        
        return result.community_view.community
    }
    @discardableResult
    static func createCommunity(_ title: String,
                                auth: String? = nil) async -> Community? {
        guard let shared else { return nil }
        return await shared.createCommunity(title, auth: auth)
    }
    
    @discardableResult
    func createPost(_ title: String,
                    url: String? = nil,
                    body: String? = nil,
                    community: Community,
                    auth: String? = nil) async -> PostView? {
        
        let validAuth: String? = auth ?? self.auth
        
        guard let validAuth else {
            LemmyLog("Authentication required")
            return nil
        }
        
        guard let result = try? await api.request(
            CreatePost(name: title,
                       community_id: community.id ?? -1,
                       url: url,
                       body: body,
                       auth: validAuth)
        ).async() else {
            return nil
        }
        
        return result.post_view
    }
    @discardableResult
    static func createPost(_ title: String,
                           url: String? = nil,
                           body: String? = nil,
                           community: Community,
                           auth: String? = nil) async -> PostView? {
        guard let shared else { return nil }
        
        return await shared.createPost(title,
                                       url: url,
                                       body: body,
                                       community: community,
                                       auth: auth)
    }
    
    @discardableResult
    func editPost(_ postId: PostId,
                    title: String,
                    url: String? = nil,
                    body: String? = nil,
                    nsfw: Bool = false,
                    language_id: LanguageId? = nil,
                    auth: String? = nil) async -> PostView? {
        
        let validAuth: String? = auth ?? self.auth
        
        guard let validAuth else {
            LemmyLog("Authentication required")
            return nil
        }
        
        guard let result = try? await api.request(
            EditPost(
                post_id: postId,
                name: title,
                url: url,
                body: body,
                nsfw: nsfw,
                language_id: language_id,
                auth: validAuth
            )
        ).async() else {
            return nil
        }
        
        return result.post_view
    }
    @discardableResult
    static func editPost(_ postId: PostId,
                         title: String,
                         url: String? = nil,
                         body: String? = nil,
                         nsfw: Bool = false,
                         language_id: LanguageId? = nil,
                         auth: String? = nil) async -> PostView? {
        guard let shared else { return nil }
        return await shared.editPost(postId,
                                     title: title,
                                     url: url,
                                     body: body,
                                     nsfw: nsfw,
                                     language_id: language_id,
                                     auth: auth)
    }
    
    @discardableResult
    func createComment(_ content: String,
                       post: Post,
                       parent: Comment? = nil,
                       auth: String? = nil) async -> Comment? {
        
        let validAuth: String? = auth ?? self.auth
        
        guard let validAuth else {
            LemmyLog("Authentication required")
            return nil
        }
        
        guard let result = try? await api.request(
            CreateComment(content: content,
                          post_id: post.id ?? -1,
                          parent_id: parent?.id,
                          auth: validAuth)
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
        
        return await shared.createComment(content,
                                          post: post,
                                          parent: parent,
                                          auth: auth)
    }
    
    @discardableResult
    func editComment(_ comment_id: CommentId,
                     content: String? = nil,
                     language_id: LanguageId? = nil,
                     form_id: String? = nil,
                     auth: String? = nil) async -> Comment? {
        
        let validAuth: String? = auth ?? self.auth
        
        guard let validAuth else {
            LemmyLog("Authentication required")
            return nil
        }
        
        guard let result = try? await api.request(
            EditComment(comment_id: comment_id,
                        content: content,
                        language_id: language_id,
                        form_id: form_id,
                        auth: validAuth
            )
        ).async() else {
            return nil
        }
        
        return result.comment_view.comment
    }
    @discardableResult
    static func editComment(_ comment_id: CommentId,
                            content: String? = nil,
                            language_id: LanguageId? = nil,
                            form_id: String? = nil,
                            auth: String? = nil) async -> Comment? {
        guard let shared else { return nil }
        
        return await shared.editComment(comment_id,
                                        content: content,
                                        language_id: language_id,
                                        form_id: form_id,
                                        auth: auth)
    }
}
