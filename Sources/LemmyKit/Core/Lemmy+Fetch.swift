//
//  Lemmy+Fetch.swift
//  
//
//  Created by PEXAVC on 8/23/23.
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
        
        guard let result = try? await api.request(
            GetCommunity(id: location == .source ? nil : id,
                         name: name,
                         auth: auth,
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
        
        let resolver: FetchResolver = await .fromCommunity(community,
                                                     id: id,
                                                     auth: auth,
                                                     location: location, from: "static community(:_)")
        
        //Fetch from actor
        if  resolver.useBase == false,
            let domain = resolver.domain {
            let instancedLemmy: Lemmy = .init(apiUrl: domain)
            
            return await instancedLemmy.community(resolver.id,
                                                  name: community?.name,
                                                  auth: auth,
                                                  location: location)
            //Fetch local community
        } else {
            return await shared.community(id ?? resolver.id,
                                          name: name ?? resolver.name,
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
               id: CommunityId? = nil,
               name: String? = nil,
               type: ListingType = .local,
               page: Int? = nil,
               limit: Int? = nil,
               sort: SortType? = nil,
               auth: String? = nil,
               saved_only: Bool? = nil,
               location: FetchType? = nil) async -> [PostView] {
        
        guard let result = try? await api.request(
            GetPosts(type_: type,
                     sort: sort,
                     page: page,
                     limit: limit,
                     community_id: id,
                     community_name: name ?? community?.name,
                     saved_only: saved_only,
                     auth: auth,
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
        
        let resolver: FetchResolver = await .fromCommunity(community,
                                                     auth: auth,
                                                     location: location, from: "static posts(:_)")
        
        //Fetch from actor
        if let domain = resolver.domain {
            let instancedLemmy: Lemmy = .init(apiUrl: domain)
            
            return await instancedLemmy.posts(community,
                                              id: resolver.id,
                                              name: resolver.name,
                                              type: type,
                                              page: page,
                                              limit: limit,
                                              sort: sort,
                                              auth: nil,
                                              location: location)
            //Fetch local community
        } else {
            return await shared.posts(community,
                                      id: resolver.id,
                                      name: resolver.name,
                                      type: type,
                                      page: page,
                                      limit: limit,
                                      sort: sort,
                                      auth: resolver.auth,
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
        
        guard let result = try? await api.request(
            GetComments(type_: type,
                        sort: sort,
                        max_depth: depth,
                        page: page,
                        limit: limit,
                        community_id: community?.id,
                        community_name: community?.name,
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
        
        let resolver: FetchResolver = await .fromPost(post, community: community, auth: auth, location: location, from: "static comments(:_)")
        
        if resolver.useBase == false,
           let domain = resolver.domain {
            let instancedLemmy: Lemmy = .init(apiUrl: domain)
            return await instancedLemmy.comments(post,
                                                 postId: resolver.sourceId,
                                                 comment: comment,
                                                 community: resolver.useCommunity ? community : nil,
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
                                         postId: resolver.id,
                                         comment: comment,
                                         community: resolver.useCommunity ? community : nil,
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
    
    func person(_ person_id: PersonId? = nil,
                 sort: SortType? = nil,
                 page: Int? = nil,
                 limit: Int? = nil,
                 community_id: CommunityId? = nil,
                 saved_only: Bool? = nil,
                 auth: String? = nil,
                 location: FetchType = .base) async -> GetPersonDetailsResponse? {
        guard let result = try? await api.request(
            GetPersonDetails(person_id: person_id,
                             sort: sort,
                             page: page,
                             limit: limit,
                             community_id: community_id,
                             saved_only: saved_only,
                             auth: auth ?? self.auth,
                             location: location)
        ).async() else {
            return nil
        }
        
        return result
    }
    static func person(_ person: Person? = nil,
                        sort: SortType? = nil,
                        page: Int? = nil,
                        limit: Int? = nil,
                        community: Community? = nil,
                        saved_only: Bool? = nil,
                        auth: String? = nil,
                        location: FetchType = .base) async -> GetPersonDetailsResponse? {
        guard let shared else { return nil }
        
        let resolver: FetchResolver = await .fromPerson(person, auth: auth, location: location, from: "person(:_)")
        
        if resolver.useBase == false,
           let person,
           let actor_id = resolver.actor,
           let domain = LemmyKit.sanitize(actor_id).host { //getInstancedDomain(community: community) {
            let instancedLemmy: Lemmy = .init(apiUrl: domain)
            
            return await instancedLemmy.person(person.id,
                                                sort: sort,
                                                page: page,
                                                limit: limit,
                                                community_id: community?.id,
                                                saved_only: saved_only,
                                                auth: auth,
                                                location: location)
            //Fetch local community
        } else {
            
            return await shared.person(person?.id,
                                        sort: sort,
                                        page: page,
                                        limit: limit,
                                        community_id: community?.id,
                                        saved_only: saved_only,
                                        auth: auth,
                                        location: location)
        }
    }
}

/*
 This will be used to decide how to fetch objects such as
 
 Person
 Post
 Comment
 Community
 
 We want to be able to fetch content from anywhere despite
 the host the client is connected to.
 
 !General (Source)
 !General@ (Base)
 !General@ (Peer)
 
 !General (Source)
 !General@ (Base)
 
 !General (Source/Base)
 At most these three cases are possible
 
 The first case occurs, if a federated person posts to a community
 that is a federated community on your base
 
 (peer)  (source)
 a.com   b.com
 post -> community
 
 (base)
 c.com   c.com @ b.com    a.com @ b.com
 you  -> community     <- post
 
 (from their perspective you are their peer)
 
 actor_id is the source
 peer = the content from the source creator's actor
 
 A community's actor id is primarily used to find the source
 A post's ap_id is used to find peer
 
 */
struct FetchResolver {
    var useBase: Bool
    var actor: String?
    var id: Int?
    var sourceId: Int?
    //communityName
    var name: String?
    
    var auth: String?
    
    var useCommunity: Bool = false
    
    var domain: String? {
        guard let actor else { return nil }
        return LemmyKit.sanitize(actor).host
    }
    
    static func fromPerson(_ person: Person?,
                           auth: String? = nil,
                           location: FetchType? = nil,
                           from context: String = "") async -> FetchResolver {
        let resolver: FetchResolver
        
        resolver = .init(useBase: true,
                         actor: person?.actor_id,
                         id: person?.id)
        
        //print(resolver.description(context, from: "person", location: location ?? .base))
        return resolver
    }
    
    //fetching posts will not use id, relying on properly set community names for federated (peers) and base
    static func fromCommunity(_ community: Community? = nil,
                              id: CommunityId? = nil,
                              name: String? = nil,
                              auth: String? = nil,
                              location: FetchType? = nil,
                              from context: String = "") async -> FetchResolver {
        let resolver: FetchResolver
        switch location {
        case .source:
            let isBase: Bool = LemmyKit.host == community?.actor_id.host
            resolver = .init(useBase: isBase,
                      actor: community?.actor_id,
                      id: nil,
                      name: community?.name)
        case .peer(let host):
            let isBase: Bool = LemmyKit.host == host
            let peerName: String? = (community?.name ?? "")+"@"+(community?.actor_id.host ?? "")
            
            resolver = .init(useBase: isBase,
                             actor: host,
                             id: community?.id,
                             name: isBase ? community?.name : peerName)
        default:
            var community: Community? = community
            var name: String? = community?.name
            var id: Int? = community?.id
            if let actor_id = community?.actor_id,
               actor_id.host != LemmyKit.host {
                let response = await Lemmy.resolveURL(actor_id)
                if let resolvedCommunity = response?.community?.community {
                    LemmyLog("resolving \(resolvedCommunity.id)", logLevel: .debug)
                    community = resolvedCommunity
                    id = resolvedCommunity.id
                    name = (resolvedCommunity.name)+"@"+(actor_id.host ?? "")
                } else {
                    name = (community?.name ?? "")+"@"+(actor_id.host ?? "")
                }
            } else {
                id = nil
            }
            resolver = .init(useBase: true,
                             id: id,
                             name: name)
        }
        
        //print(resolver.description(context, from: "community", location: location ?? .base))
        return resolver
    }
    static func fromPost(_ post: Post?,
                         community: Community? = nil,
                         auth: String? = nil,
                         location: FetchType? = nil,
                         from context: String = "") async -> FetchResolver {
        
        let resolver: FetchResolver
        
        switch location {
        case .source:
            resolver = .init(useBase: false,
                             actor: community?.actor_id,
                             id: post?.id)
        case .peer(let host):
            let sourceId: Int?
            let host = host.host ?? host
            if host == post?.ap_id.host {
                sourceId = Int(post?.ap_id.components(separatedBy: "/").last ?? "")
            } else {
                sourceId = nil
            }
            
            resolver = .init(useBase: false,
                             actor: host,
                             id: post?.id,
                             sourceId: sourceId)
        default:
            var id: Int? = post?.id
            if post?.location != .base,
               let ap_id = post?.ap_id {
    
                let response = await Lemmy.resolveURL(ap_id)
                if let resolvedPost = response?.post?.post {
                    LemmyLog("resolving \(resolvedPost.id)", logLevel: .debug)
                    id = resolvedPost.id
                }
            }
            
            resolver = .init(useBase: true,
                             actor: post?.ap_id,
                             id: id)
        }
        
        //print(resolver.description(context, from: "post", location: location ?? .base))
        return resolver
    }
    
    

    static func fromComment(_ comment: Comment?,
                            location: FetchType? = nil,
                            from context: String = "") -> FetchResolver {
        .empty
    }
    
    static var empty: FetchResolver {
        .init(useBase: false, name: "")
    }
    
    static func base(withName name: String? = nil) -> FetchResolver {
        .init(useBase: false, name: name)
    }
    
    func description(_ context: String, from target: String, location: FetchType) -> String {
        """
        [FetchResolver \(location.description)] \(context) from: \(target) -----
        useBase: \(useBase)
        actor: \(actor)
        name: \(name)
        id: \(id)
        sourceId: \(sourceId)
        domain: \(domain)
        ------------------------------------------------
        """
    }
}
