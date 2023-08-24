//
//  Lemmy+Fetch.swift
//  
//
//  Created by Ritesh Pakala on 8/23/23.
//

import Foundation

//MARK: -- Fetch

public extension Lemmy {
    func site(auth: String? = nil) async -> GetSiteResponse? {
        guard let result = try? await api.request(
            GetSite(auth: auth ?? self.auth)
        ).async() else {
            return nil
        }
        
        update(site: result)
        
        return result
    }
    static func site(auth: String? = nil) async -> GetSiteResponse? {
        guard let shared else { return nil }
        
        return await shared.site(auth: auth)
    }
    func metadata(url: String) async -> GetSiteMetadataResponse? {
        guard let result = try? await api.request(
            GetSiteMetadata(url: url)
        ).async() else {
            return nil
        }
        
        return result
    }
    static func metadata(url: String) async -> GetSiteMetadataResponse? {
        guard let shared else { return nil }
        
        return await shared.metadata(url: url)
    }
    
    func instances(auth: String? = nil) async -> FederatedInstances? {
        guard let result = try? await api.request(
            GetFederatedInstances(auth: auth ?? self.auth)
        ).async() else {
            return nil
        }
        
        return result.federated_instances
    }
    static func instances(auth: String? = nil) async -> FederatedInstances? {
        guard let shared else { return nil }
        
        return await shared.instances(auth: auth)
    }
    
    func communities(_ type: ListingType = .local,
                     sort: SortType? = nil,
                     page: Int? = nil,
                     limit: Int? = nil,
                     auth: String? = nil) async -> [CommunityView] {
        guard let result = try? await api.request(
            ListCommunities(type_: type,
                            sort: sort,
                            page: page,
                            limit: limit,
                            auth: auth ?? self.auth)
            
        ).async() else {
            return []
        }
        
        return result.communities
    }
    static func communities(_ type: ListingType = .local,
                            sort: SortType? = nil,
                            page: Int? = nil,
                            limit: Int? = nil,
                            auth: String? = nil) async -> [CommunityView] {
        guard let shared else { return [] }
        
        return await shared.communities(type,
                                        sort: sort,
                                        page: page,
                                        limit: limit,
                                        auth: auth)
    }
    
    func community(_ id: CommunityId? = nil,
                   name: String? = nil,
                   auth: String? = nil,
                   location: FetchType? = nil) async -> CommunityView? {
        
        var communityId: CommunityId? = id
        var communityName: String? = name
        var validAuth: String? = auth ?? self.auth
        
        switch location {
        case .source:
            communityId = nil
            validAuth = nil
        default:
            break
        }
        
        guard let result = try? await api.request(
            GetCommunity(id: communityId,
                         name: communityName,
                         auth: validAuth,
                         location: location ?? .base)
        ).async() else {
            return nil
        }
        
        return result.community_view
    }
    static func community(_ id: CommunityId? = nil,
                          community: Community? = nil,
                          name: String? = nil,
                          auth: String? = nil,
                          location: FetchType? = nil) async -> CommunityView? {
        guard let shared else { return nil }
        
        LemmyLog("\(community?.actor_id ?? "") | location: \(location?.description ?? "unknown")")
        var communityId: CommunityId? = id ?? community?.id
        var name: String? = name ?? community?.name
        
        let useBase: Bool
        let actor: String?
        switch location {
        case .source:
            actor = community?.actor_id
            useBase = false
            communityId = nil
            name = community?.name
        case .peer(let host):
            actor = host
            useBase = false
        default:
            useBase = true
            actor = nil
        }
        
        //Fetch from actor
        if  useBase == false,
            let actor,
            let domain = LemmyKit.sanitize(actor).host {
            let instancedLemmy: Lemmy = .init(apiUrl: domain)
            
            return await instancedLemmy.community(communityId,
                                                  name: community?.name,
                                                  auth: auth,
                                                  location: location)
            //Fetch local community
        } else {
            return await shared.community(communityId,
                                          name: name,
                                          auth: auth,
                                          location: location)
        }
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
               auth: String? = nil,
               saved_only: Bool? = nil,
               location: FetchType? = nil) async -> [PostView] {
        
        var id: CommunityId? = nil
        var name: String? = nil
        var validAuth: String? = nil
        switch location {
        case .source:
            name = community?.name
        default:
            id = community?.id
            validAuth = auth ?? self.auth
        }
        
        guard let result = try? await api.request(
            GetPosts(type_: type,
                     sort: sort,
                     page: page,
                     limit: limit,
                     community_id: id,
                     community_name: name,
                     saved_only: saved_only,
                     auth: validAuth,
                     location: location ?? .base)
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
                      auth: String? = nil,
                      saved_only: Bool? = nil,
                      location: FetchType? = nil) async -> [PostView] {
        guard let shared else { return [] }
        
        var domain: String? = nil
        var community: Community? = community
        switch location {
        case .source:
            domain = community?.actor_id
        case .peer(let host):
            domain = host
        default:
            //Community's ap_id is a custom field
            //transformed during commentView responses
            //Comment's can be peers, but their community actor ids
            //may not reflect truthfully the source of their instance
            if let ap_id = community?.ap_id {
                let response = await Lemmy.resolveURL(ap_id)
                if let resolvedCommunity = response?.community?.community {
                    LemmyLog("resolving \(resolvedCommunity.id)", logLevel: .debug)
                    community = resolvedCommunity
                }
            }
        }
        
        //Fetch from actor
        if let domain {
            let instancedLemmy: Lemmy = .init(apiUrl: domain)
            
            return await instancedLemmy.posts(community,
                                              type: type,
                                              page: page,
                                              limit: limit,
                                              sort: sort,
                                              auth: auth ?? shared.auth,
                                              location: location)
            //Fetch local community
        } else {
            return await shared.posts(community,
                                      type: type,
                                      page: page,
                                      limit: limit,
                                      sort: sort,
                                      auth: auth,
                                      saved_only: saved_only,
                                      location: location)
        }
    }
    
    /*
     Comments can be sourced via post, community, or comment. One must be provided.
     */
    func comments(_ post: Post? = nil,
                  postId: PostId? = nil,
                  comment: Comment? = nil,
                  community: Community? = nil,
                  depth: Int = 1,
                  page: Int? = nil,
                  limit: Int? = nil,
                  type: ListingType = .local,
                  sort: CommentSortType = .hot,
                  auth: String? = nil,
                  saved_only: Bool? = nil,
                  location: FetchType? = nil) async -> [CommentView] {
        guard post != nil || comment != nil || community != nil else {
            LemmyLog("Please provide a resource object")
            return []
        }
        
        let id: CommunityId?
        let name: String?
        
        switch location {
        case .source:
            id = nil
            name = community?.name
        default:
            id = nil
            name = nil
        }
        
        guard let result = try? await api.request(
            GetComments(type_: type,
                        sort: sort,
                        max_depth: depth,
                        page: page,
                        limit: limit,
                        community_id: id,
                        community_name: name,
                        post_id: postId ?? post?.id,
                        parent_id: comment?.id,
                        saved_only: saved_only,
                        auth: auth ?? self.auth,
                        location: location ?? .base)
        ).async() else {
            return []
        }
        
        return result.comments
    }
    static func comments(_ post: Post? = nil,
                         comment: Comment? = nil,
                         community: Community? = nil,
                         depth: Int = 1,
                         page: Int? = nil,
                         limit: Int? = nil,
                         type: ListingType = .local,
                         sort: CommentSortType = .hot,
                         auth: String? = nil,
                         saved_only: Bool? = nil,
                         location: FetchType? = nil) async -> [CommentView] {
        guard let shared else { return [] }
        
        //Fetch federated comments, won't work if only comment is passed in
        let useBase: Bool
        let actor: String?
        var postId: PostId? = post?.id
        switch location {
        case .source:
            actor = community?.actor_id
            useBase = false
        case .peer:
            actor = post?.ap_id
            useBase = false
        default:
            if post?.location != .base,
               let ap_id = post?.ap_id {
                
                let response = await Lemmy.resolveURL(ap_id)
                if let resolvedPost = response?.post?.post {
                    LemmyLog("resolving \(resolvedPost.id)", logLevel: .debug)
                    postId = resolvedPost.id
                }
            }
            useBase = true
            actor = nil
        }
        
        LemmyLog("[\(actor ?? "")] | location: \(location)", logLevel: .debug)
        
        if useBase == false,
           let actor,
           let domain = LemmyKit.sanitize(actor).host {//getInstancedDomain(community: community) {
            let instancedLemmy: Lemmy = .init(apiUrl: domain)
            let postId: PostId? = PostId(post?.ap_id.components(separatedBy: "/").last ?? "")
            return await instancedLemmy.comments(post,
                                                 postId: postId,
                                                 comment: comment,
                                                 community: community,
                                                 depth: depth,
                                                 page: page,
                                                 limit: limit,
                                                 type: type,
                                                 sort: sort,
                                                 auth: auth,
                                                 location: location)
            //Fetch local community
        } else {
            return await shared.comments(post,
                                         postId: postId,
                                         comment: comment,
                                         community: community,
                                         depth: depth,
                                         page: page,
                                         limit: limit,
                                         type: type,
                                         sort: sort,
                                         auth: auth,
                                         saved_only: saved_only,
                                         location: location)
        }
    }
}
