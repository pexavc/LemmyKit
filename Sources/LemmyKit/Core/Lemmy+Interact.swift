//
//  Lemmy+Interact.swift
//  
//
//  Created by PEXAVC on 8/23/23.
//

import Foundation

//MARK: -- Interact

public extension Lemmy {
    func upvotePost(_ post: Post,
                    score: Int,
                    auth: String? = nil) async -> PostView? {
        guard let auth = auth ?? self.auth else {
            return nil
        }
        
        guard let result = try? await api.request(
            CreatePostLike(post_id: post.id,
                           score: score,
                           auth: auth)
        ).async() else {
            return nil
        }
        
        return result.post_view
    }
    static func upvotePost(_ post: Post,
                           score: Int,
                           auth: String? = nil) async -> PostView? {
        guard let shared else { return nil }
        
        return await shared.upvotePost(post,
                                       score: score,
                                       auth: auth)
    }
    
    func removePost(post_id: PostId,
                    removed: Bool,
                    reason: String? = nil,
                    auth: String) async -> PostResponse? {
        guard let result = try? await api.request(
            RemovePost(post_id: post_id,
                       removed: removed,
                       reason: reason,
                       auth: auth)
        ).async() else {
            return nil
        }
        
        return result
    }
    static func removePost(_ post: Post,
                           removed: Bool,
                           reason: String? = nil,
                           auth: String? = nil) async -> PostResponse? {
        guard let shared else { return nil }
        
        let validAuth: String? = auth ?? shared.auth
        
        guard let validAuth else {
            LemmyLog("Authentication required")
            return nil
        }
        
        return await shared.removePost(post_id: post.id,
                                       removed: removed,
                                       reason: reason,
                                       auth: validAuth)
    }
    
    func deletePost(post_id: PostId,
                    deleted: Bool,
                    auth: String) async -> PostResponse? {
        guard let result = try? await api.request(
            DeletePost(post_id: post_id,
                       deleted: deleted,
                       auth: auth)
        ).async() else {
            return nil
        }
        
        return result
    }
    static func deletePost(_ post: Post,
                           deleted: Bool,
                           auth: String? = nil) async -> PostResponse? {
        guard let shared else { return nil }
        
        let validAuth: String? = auth ?? shared.auth
        
        guard let validAuth else {
            LemmyLog("Authentication required")
            return nil
        }
        
        return await shared.deletePost(post_id: post.id,
                                       deleted: deleted,
                                       auth: validAuth)
    }
    
    func savePost(_ post: Post,
                  save: Bool,
                  auth: String) async -> PostResponse? {
        guard let result = try? await api.request(
            SavePost(post_id: post.id,
                     save: save,
                     auth: auth)
        ).async() else {
            return nil
        }
        
        return result
    }
    static func savePost(_ post: Post,
                         save: Bool,
                         auth: String? = nil) async -> PostResponse? {
        guard let shared else { return nil }
        
        let validAuth: String? = auth ?? shared.auth
        
        guard let validAuth else {
            LemmyLog("Authentication required")
            return nil
        }
        
        return await shared.savePost(post,
                                     save: save,
                                     auth: validAuth)
    }
    
    func upvoteComment(_ comment: Comment,
                       score: Int,
                       auth: String? = nil) async -> CommentView? {
        guard let auth = auth ?? self.auth else {
            return nil
        }
        guard let result = try? await api.request(
            CreateCommentLike(comment_id: comment.id,
                              score: score,
                              auth: auth)
        ).async() else {
            return nil
        }
        
        return result.comment_view
    }
    static func upvoteComment(_ comment: Comment,
                              score: Int,
                              auth: String? = nil) async -> CommentView? {
        guard let shared else { return nil }
        
        return await shared.upvoteComment(comment,
                                          score: score,
                                          auth: auth)
    }
    
    func removeComment(comment_id: CommentId,
                       removed: Bool,
                       reason: String? = nil,
                       auth: String) async -> CommentResponse? {
        guard let result = try? await api.request(
            RemoveComment(comment_id: comment_id,
                          removed: removed,
                          reason: reason,
                          auth: auth)
        ).async() else {
            return nil
        }
        
        return result
    }
    static func removeComment(_ comment: Comment,
                              removed: Bool,
                              reason: String? = nil,
                              auth: String? = nil) async -> CommentResponse? {
        guard let shared else { return nil }
        
        let validAuth: String? = auth ?? shared.auth
        
        guard let validAuth else {
            LemmyLog("Authentication required")
            return nil
        }
        
        return await shared.removeComment(comment_id: comment.id,
                                          removed: removed,
                                          reason: reason,
                                          auth: validAuth)
    }
    
    func deleteComment(comment_id: CommentId,
                       deleted: Bool,
                       auth: String) async -> CommentResponse? {
        guard let result = try? await api.request(
            DeleteComment(comment_id: comment_id,
                          deleted: deleted,
                          auth: auth)
        ).async() else {
            return nil
        }
        
        return result
    }
    static func deleteComment(_ comment: Comment,
                              deleted: Bool,
                              auth: String? = nil) async -> CommentResponse? {
        guard let shared else { return nil }
        
        let validAuth: String? = auth ?? shared.auth
        
        guard let validAuth else {
            LemmyLog("Authentication required")
            return nil
        }
        
        return await shared.deleteComment(comment_id: comment.id,
                                          deleted: deleted,
                                          auth: validAuth)
    }
    
    func saveComment(_ comment: Comment,
                     save: Bool,
                     auth: String) async -> CommentResponse? {
        guard let result = try? await api.request(
            SaveComment(comment_id: comment.id,
                        save: save,
                        auth: auth)
        ).async() else {
            return nil
        }
        
        return result
    }
    static func saveComment(_ comment: Comment,
                            save: Bool,
                            auth: String? = nil) async -> CommentResponse? {
        guard let shared else { return nil }
        
        let validAuth: String? = auth ?? shared.auth
        
        guard let validAuth else {
            LemmyLog("Authentication required")
            return nil
        }
        
        return await shared.saveComment(comment,
                                        save: save,
                                        auth: validAuth)
    }
}

//MARK: remove/block posts/communities/person

public extension Lemmy {
    func report(post: Post,
                reason: String,
                auth: String
    ) async -> PostReportView? {
        guard let result = try? await api.request(
            CreatePostReport(post_id: post.id,
                             reason: reason,
                             auth: auth)
        ).async() else {
            return nil
        }
        
        return result.post_report_view
    }
    static func report(post: Post,
                       reason: String,
                       auth: String? = nil) async -> PostReportView? {
        guard let shared else { return nil }
        
        let validAuth: String? = auth ?? shared.auth
        
        guard let validAuth else {
            LemmyLog("Authentication required")
            return nil
        }
        
        return await shared.report(post: post,
                                   reason: reason,
                                   auth: validAuth)
    }
    
    func report(comment: Comment,
                reason: String,
                auth: String
    ) async -> CommentReportResponse? {
        guard let result = try? await api.request(
            CreateCommentReport(comment_id: comment.id,
                                reason: reason,
                                auth: auth)
        ).async() else {
            return nil
        }
        
        return result
    }
    static func report(comment: Comment,
                       reason: String,
                       auth: String? = nil) async -> CommentReportResponse? {
        guard let shared else { return nil }
        
        let validAuth: String? = auth ?? shared.auth
        
        guard let validAuth else {
            LemmyLog("Authentication required")
            return nil
        }
        
        return await shared.report(comment: comment,
                                   reason: reason,
                                   auth: validAuth)
    }
    
    func block(person: Person,
               block: Bool,
               auth: String
    ) async -> BlockPersonResponse? {
        guard let result = try? await api.request(
            BlockPerson(person_id: person.id,
                        block: block,
                        auth: auth)
        ).async() else {
            return nil
        }
        
        return result
    }
    static func block(person: Person,
                      block: Bool,
                      auth: String? = nil) async -> BlockPersonResponse? {
        guard let shared else { return nil }
        
        let validAuth: String? = auth ?? shared.auth
        
        guard let validAuth else {
            LemmyLog("Authentication required")
            return nil
        }
        
        return await shared.block(person: person,
                                  block: block,
                                  auth: validAuth)
    }
    
    func block(community: Community,
               block: Bool,
               auth: String
    ) async -> BlockCommunityResponse? {
        guard let result = try? await api.request(
            BlockCommunity(community_id: community.id,
                           block: block,
                           auth: auth)
        ).async() else {
            return nil
        }
        
        return result
    }
    static func block(community: Community,
                      block: Bool,
                      auth: String? = nil) async -> BlockCommunityResponse? {
        guard let shared else { return nil }
        
        let validAuth: String? = auth ?? shared.auth
        
        guard let validAuth else {
            LemmyLog("Authentication required")
            return nil
        }
        
        return await shared.block(community: community,
                                  block: block,
                                  auth: validAuth)
    }
}

//MARK: Subscribe/Unsubscribe

public extension Lemmy {
    func follow(community: Community,
                follow: Bool,
                auth: String) async -> CommunityResponse? {
        guard let result = try? await api.request(
            FollowCommunity(community_id: community.id,
                            follow: follow,
                            auth: auth)
        ).async() else {
            return nil
        }
        
        return result
    }
    static func follow(community: Community,
                       follow: Bool,
                       auth: String? = nil) async -> CommunityResponse? {
        guard let shared else { return nil }
        
        let validAuth: String? = auth ?? shared.auth
        
        guard let validAuth else {
            LemmyLog("Authentication required")
            return nil
        }
        
        return await shared.follow(community: community,
                                   follow: follow,
                                   auth: validAuth)
    }
}
