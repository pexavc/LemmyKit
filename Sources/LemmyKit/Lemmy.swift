//
//  Lemmy.swift
//  
//
//  Created by PEXAVC on 5/12/23.
//

import Foundation
import Combine

public class Lemmy {
    public class Metadata {
        var site: Site
        public init(siteView: SiteView) {
            self.site = siteView.site
        }
    }
    
    public let id: UUID
    
    static var shared: Lemmy? {
        LemmyKit.current
    }
    
    public var auth: String? = nil
    
    public static var allInstances: [InstanceId:Instance] = [:]
    public static var allowedInstances: [InstanceId:Instance] = [:]
    public static var linkedInstances: [InstanceId:Instance] = [:]
    public static var blockedInstances: [InstanceId:Instance] = [:]
    public static var instancesLoaded: Bool = false
    
    public static var communities: [CommunityId:CommunityView] = [:]
    
    private var api: Network
    private var pictrs: Network
    
    public static var getSiteTask: Task<Void, Error>? = nil
    public static var siteLoaded: Bool = false
    
    //assigned during getSite() call
    public static var instanceId: InstanceId? = nil
    public static var admins: [PersonView] = []
    public static var emojis: [CustomEmojiView] = []
    public static var stats: SiteAggregates? = nil
    public static var metadata: Metadata? = nil
    
    private var isBaseInstance: Bool
    
    public init(id: UUID? = nil,
                apiUrl: String,
                pictrsUrl: String? = nil,
                base: Bool = false) {
        self.id = id ?? .init()
        
        let urlString = LemmyKit.sanitize(apiUrl)
        
        self.api = .init(urlString.apiUrl ?? apiUrl)
        self.pictrs = .init(pictrsUrl ?? (urlString.apiUrl ?? apiUrl) + "/pictrs/image")
        self.isBaseInstance = base
        
        if base {
            Lemmy.getSite()
        }
    }
    
    public static func getSite() {
        Lemmy.getSiteTask?.cancel()
        Lemmy.getSiteTask = Task {
            let site = await Lemmy.site()
            
            Lemmy.instanceId = site?.site_view.site.instance_id
            Lemmy.admins = site?.admins ?? []
            Lemmy.emojis = site?.custom_emojis ?? []
            Lemmy.stats = site?.site_view.counts
            if let view = site?.site_view {
                Lemmy.metadata = .init(siteView: view)
            }
            
            Lemmy.getSiteTask = nil
            Lemmy.siteLoaded = true
        }
    }
    
    public static func getInstances() async {
        let instances = await Lemmy.instances()
        
        for instance in instances?.allowed ?? [] {
            self.allowedInstances[instance.id] = instance
            self.allInstances[instance.id] = instance
        }
        
        for instance in instances?.linked ?? [] {
            self.linkedInstances[instance.id] = instance
            self.allInstances[instance.id] = instance
        }
        
        for instance in instances?.blocked ?? [] {
            self.blockedInstances[instance.id] = instance
            self.allInstances[instance.id] = instance
        }
        
        Lemmy.instancesLoaded = true
    }
    
    public func request<R: Request>(_ request: R) async -> R.TransformedResponse? {
        return try? await api.request(
            request
        ).async()
    }
    public static func request<R: Request>(_ request: R) async -> R.TransformedResponse? {
        guard let shared else { return nil }
        
        return await shared.request(request)
    }
    
    public func pictrs<R: Request>(_ request: R) async -> R.TransformedResponse? {
        return try? await pictrs.request(
            request
        ).async()
    }
    public static func pictrs<R: Request>(_ request: R) async -> R.TransformedResponse? {
        guard let shared else { return nil }
        
        return await shared.pictrs(request)
    }
    
    public static func getInstancedDomain(community: Community, instanceId: Int? = nil) -> String? {
        var id: Int = instanceId ?? community.instance_id
        var instancedDomain: String? = nil
        
        if let allowedInstance = Lemmy.allowedInstances[id] {
            instancedDomain = allowedInstance.domain
        } else if let linkedInstance = Lemmy.linkedInstances[id] {
            instancedDomain = linkedInstance.domain
        }
        
        return instancedDomain
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
    func site(auth: String? = nil) async -> GetSiteResponse? {
        guard let result = try? await api.request(
            GetSite(auth: auth ?? self.auth)
        ).async() else {
            return nil
        }
        
        return result
    }
    static func site(auth: String? = nil) async -> GetSiteResponse? {
        guard let shared else { return nil }
        
        return await shared.site(auth: auth)
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
            GetCommunity(/*id: id,*/ //id sometimes fails?
                         name: name,
                         auth: auth ?? self.auth)
        ).async() else {
            return nil
        }
        
        return result.community_view
    }
    static func community(_ id: CommunityId? = nil,
                          community: Community? = nil,
                          name: String? = nil,
                          auth: String? = nil) async -> CommunityView? {
        guard let shared else { return nil }
        
        //Fetch federated community
        if let community,
           let domain = getInstancedDomain(community: community) {
            let instancedLemmy: Lemmy = .init(apiUrl: domain)
            
            return await instancedLemmy.community(id,
                                                  name: name ?? community.name,
                                                  auth: auth)
        //Fetch local community
        } else {
            return await shared.community(id,
                                          name: name ?? community?.name,
                                          auth: auth)
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
               isLocal: Bool = true) async -> [PostView] {
        guard let result = try? await api.request(
            GetPosts(type_: type,
                     sort: sort,
                     page: page,
                     limit: limit,
                     //id can conflict if an instanced server is requested with base Lemmy client. Since the community ids could be different
                     //community_id: community?.id,
                     community_name: community?.name,
                     auth: auth ?? self.auth,
                     isLocal: isLocal)
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
        
        //Fetch federated community
        if let community,
           let domain = LemmyKit.sanitize(community.actor_id).host { //getInstancedDomain(community: community) {
            let instancedLemmy: Lemmy = .init(apiUrl: domain)
            
            return await instancedLemmy.posts(community,
                                              type: type,
                                              page: page,
                                              limit: limit,
                                              sort: sort,
                                              auth: auth,
                                              isLocal: false)
        //Fetch local community
        } else {
            return await shared.posts(community,
                                      type: type,
                                      page: page,
                                      limit: limit,
                                      sort: sort,
                                      auth: auth)
        }
    }
    
    /*
     Comments can be sourced via post, community, or comment. One must be provided.
     */
    func comments(_ post: Post? = nil,
                  comment: Comment? = nil,
                  community: Community? = nil,
                  depth: Int = 1,
                  page: Int? = nil,
                  limit: Int? = nil,
                  type: ListingType = .local,
                  sort: CommentSortType = .hot,
                  auth: String? = nil,
                  isLocal: Bool = true) async -> [CommentView] {
        guard post != nil || comment != nil || community != nil else {
            LemmyLog("Please provide a post, comment, or communit reference")
            return []
        }
        
        guard let result = try? await api.request(
            GetComments(type_: type,
                        sort: sort,
                        max_depth: depth,
                        page: page,
                        limit: limit,
                        //id can conflict if an instanced server is requested with base Lemmy client. Since the community ids could be different
                        //community_id: community?.id,
                        community_name: community?.name,
                        post_id: post?.id,
                        parent_id: comment?.id,
                        auth: auth ?? self.auth,
                        isLocal: isLocal)
        ).async() else {
            return []
        }
        
        return result.comments
    }
    /* Should only use post when viewing comments to resolve against base client
    post id with a community passed in that is not of the same community id as seen in the base client will not resolve
     */
    static func comments(_ post: Post? = nil,
                         comment: Comment? = nil,
                         community: Community? = nil,//required to get instanced community incase
                         depth: Int = 1,
                         page: Int? = nil,
                         limit: Int? = nil,
                         type: ListingType = .local,
                         sort: CommentSortType = .hot,
                         auth: String? = nil) async -> [CommentView] {
        guard let shared else { return [] }
        
        //Fetch federated comments, won't work if only comment is passed in
        if let community,
           let domain = LemmyKit.sanitize(community.actor_id).host {//getInstancedDomain(community: community) {
            let instancedLemmy: Lemmy = .init(apiUrl: domain)
            
            return await instancedLemmy.comments(post,
                                                 comment: comment,
                                                 community: community,
                                                 depth: depth,
                                                 page: page,
                                                 limit: limit,
                                                 type: type,
                                                 sort: sort,
                                                 auth: auth,
                                                 isLocal: false)
        //Fetch local community
        } else {
            return await shared.comments(post,
                                         comment: comment,
                                         community: community,
                                         depth: depth,
                                         page: page,
                                         limit: limit,
                                         type: type,
                                         sort: sort,
                                         auth: auth)
        }
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
