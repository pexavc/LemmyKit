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
        public var site: Site
        public init(siteView: SiteView) {
            self.site = siteView.site
        }
    }
    
    public let id: UUID
    
    static var shared: Lemmy? {
        LemmyKit.current
    }
    
    public var auth: String? = nil
    
    public var allInstances: [InstanceId:Instance] = [:]
    public var allowedInstances: [InstanceId:Instance] = [:]
    public var linkedInstances: [InstanceId:Instance] = [:]
    public var blockedInstances: [InstanceId:Instance] = [:]
    public var instancesLoaded: Bool = false
    
    public var communities: [CommunityId:CommunityView] = [:]
    
    private var api: Network
    private var pictrs: Network
    
    public var contentURL: String
    
    public var getSiteTask: Task<Void, Error>? = nil
    public var siteLoaded: Bool = false
    
    //assigned during getSite() call
    public var instanceId: InstanceId? = nil
    public var admins: [PersonView] = []
    public var emojis: [CustomEmojiView] = []
    public var stats: SiteAggregates? = nil
    public var metadata: Metadata? = nil
    public var user: MyUserInfo? = nil
    
    private var isBaseInstance: Bool
    
    public init(id: UUID? = nil,
                apiUrl: String,
                pictrsUrl: String? = nil,
                base: Bool = false) {
        self.id = id ?? .init()
        
        let urlString = LemmyKit.sanitize(apiUrl)
        
        self.api = .init(urlString.apiUrl ?? apiUrl)
        let pictrsAPIURL = pictrsUrl ?? (urlString.baseUrl ?? apiUrl) + "/pictrs/image"
        self.contentURL = pictrsAPIURL
        self.pictrs = .init(pictrsAPIURL)
        self.isBaseInstance = base
    }
    
    public func getSite() {
        getSiteTask?.cancel()
        getSiteTask = Task {
            let site = await Lemmy.site()
            
            update(site: site)
        }
    }
    public static func getSite() {
        shared?.getSite()
    }
    
    private func update(site: GetSiteResponse?) {
        instanceId = site?.site_view.site.instance_id
        admins = site?.admins ?? []
        emojis = site?.custom_emojis ?? []
        stats = site?.site_view.counts
        user = site?.my_user
        print("[LemmyKit] Setting session user: \(site?.my_user?.local_user_view.person.name), from: \(site?.my_user?.local_user_view.person.actor_id)")
        if let view = site?.site_view {
            metadata = .init(siteView: view)
        }
        
        getSiteTask = nil
        siteLoaded = true
    }
    
    public func getInstances() async {
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
        
        instancesLoaded = true
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
    
    public func getInstancedDomain(community: Community, instanceId: Int? = nil) -> String? {
        var id: Int = instanceId ?? community.instance_id
        var instancedDomain: String? = nil
        
        if let allowedInstance = allowedInstances[id] {
            instancedDomain = allowedInstance.domain
        } else if let linkedInstance = linkedInstances[id] {
            instancedDomain = linkedInstance.domain
        }
        
        return instancedDomain
    }
    
    public static func getInstancedDomain(community: Community, instanceId: Int? = nil) -> String? {
        shared?.getInstancedDomain(community: community, instanceId: instanceId)
    }
}

//MARK: -- Auth/Registration

public extension Lemmy {
    func login(username: String, password: String, token2FA: String? = nil) async -> String? {
        guard let result = try? await api.request(
            Login(username_or_email: username,
                  password: password,
                  totp_2fa_token: token2FA)
        ).async() else {
            return nil
        }
        
        if isBaseInstance {
            LemmyKit.auth = result.jwt
            
            //Update user info
            _ = await Lemmy.site(auth: result.jwt)
        } else {
            self.auth = result.jwt
            await site(auth: result.jwt)
        }
        
        return result.jwt
    }
    static func login(username: String, password: String, token2FA: String? = nil) async -> String? {
        guard let shared else { return nil }
        
        return await shared.login(username: username, password: password, token2FA: token2FA)
    }
    
    func register(username: String,
                  password: String,
                  password_verify: String,
                  show_nsfw: Bool,
                  email: String? = nil,
                  captcha_uuid: String? = nil,
                  captcha_answer: String? = nil,
                  honeypot: String? = nil,
                  answer: String? = nil
    ) async -> String? {
        guard let result = try? await api.request(
            Register(username: username,
                     password: password,
                     password_verify: password_verify,
                     show_nsfw: show_nsfw,
                     email: email,
                     captcha_uuid: captcha_uuid,
                     captcha_answer: captcha_answer,
                     honeypot: honeypot,
                     answer: answer
                    )
        ).async() else {
            return nil
        }
        
        if isBaseInstance {
            LemmyKit.auth = result.jwt
            
            //Update user info
            _ = await Lemmy.site(auth: result.jwt)
        } else {
            self.auth = result.jwt
            await site(auth: result.jwt)
        }
        
        return result.jwt
    }
    static func register(username: String,
                         password: String,
                         password_verify: String,
                         show_nsfw: Bool,
                         email: String? = nil,
                         captcha_uuid: String? = nil,
                         captcha_answer: String? = nil,
                         honeypot: String? = nil,
                         answer: String? = nil
    ) async -> String? {
        guard let shared else { return nil }
        
        return await shared.register(username: username,
                                     password: password,
                                     password_verify: password_verify,
                                     show_nsfw: show_nsfw,
                                     email: email,
                                     captcha_uuid: captcha_uuid,
                                     captcha_answer: captcha_answer,
                                     honeypot: honeypot,
                                     answer: answer)
    }
}

//MARK: -- User info

public extension Lemmy {
    func user(_ person_id: PersonId? = nil,
              username: String? = nil,
              sort: SortType? = nil,
              auth: String? = nil) async -> GetPersonDetailsResponse? {
        guard let result = try? await api.request(
            GetPersonDetails(person_id: person_id,
                             username: username,
                             sort: sort,
                             auth: auth ?? self.auth)
        ).async() else {
            return nil
        }
        
        return result
    }
    static func user(_ person_id: PersonId? = nil,
                     username: String? = nil,
                     sort: SortType? = nil,
                     auth: String? = nil) async -> GetPersonDetailsResponse? {
        
        return await shared?.user(person_id,
                                  username: username,
                                  sort: sort,
                                  auth: auth)
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
                LemmyLog("resolving \(response?.community?.community.id)", logLevel: .debug)
                community = response?.community?.community
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
                LemmyLog("resolving \(response?.post?.post.id)", logLevel: .debug)
                postId = response?.post?.post.id
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
                                         location: location)
        }
    }
}

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
                    auth: String) async -> PostView? {
        guard let result = try? await api.request(
            CreatePost(name: title,
                       community_id: community.id,
                       url: url,
                       body: body,
                       auth: auth)
        ).async() else {
            return nil
        }
        
        return result.post_view
    }
    @discardableResult
    static func createPost(_ title: String,
                           content: String,
                           url: String? = nil,
                           body: String? = nil,
                           community: Community,
                           auth: String? = nil) async -> PostView? {
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

//MARK: -- Search

public extension Lemmy {
    @discardableResult
    func search(_ q: String,
                type_: SearchType,
                communityId: CommunityId? = nil,
                communityName: String? = nil,
                creatorId: PersonId? = nil,
                sort: SortType = .hot,
                listingType: ListingType = .all,
                page: Int?,
                limit: Int?,
                auth: String?) async -> Search.Response? {
        guard let result = try? await api.request(
            Search(q: q,
                   community_id: communityId,
                   community_name: communityName,
                   creator_id: creatorId,
                   type_: type_,
                   sort: sort,
                   listing_type: listingType,
                   page: page,
                   limit: limit,
                   auth: auth ?? self.auth)
        ).async() else {
            return nil
        }
        
        return result
    }
    @discardableResult
    static func search(_ q: String,
                       type_: SearchType,
                       communityId: CommunityId? = nil,
                       communityName: String? = nil,
                       creatorId: PersonId? = nil,
                       sort: SortType = .hot,
                       listingType: ListingType = .all,
                       page: Int?,
                       limit: Int?,
                       auth: String? = nil) async -> Search.Response? {
        guard let shared else { return nil }
        
        return await shared.search(q,
                                   type_: type_,
                                   communityId: communityId,
                                   communityName: communityName,
                                   creatorId: creatorId,
                                   sort: sort,
                                   listingType: listingType,
                                   page: page,
                                   limit: limit,
                                   auth: auth)
    }
}

//MARK: -- User

public extension Lemmy {
    
    func saveUserSettings(show_nsfw: Bool? = nil,
                          show_scores: Bool? = nil,
                          theme: String? = nil,
                          default_sort_type: SortType? = nil,
                          default_listing_type: ListingType? = nil,
                          interface_language: String? = nil,
                          avatar: String? = nil,
                          banner: String? = nil,
                          display_name: String? = nil,
                          email: String? = nil,
                          bio: String? = nil,
                          matrix_user_id: String? = nil,
                          show_avatars: Bool? = nil,
                          send_notifications_to_email: Bool? = nil,
                          bot_account: Bool? = nil,
                          show_bot_accounts: Bool? = nil,
                          show_read_posts: Bool? = nil,
                          show_new_post_notifs: Bool? = nil,
                          discussion_languages: [LanguageId]? = nil,
                          generate_totp_2fa: Bool? = nil,
                          auth: String,
                          open_links_in_new_tab: Bool? = nil
    ) async -> LoginResponse? {
        guard let result = try? await api.request(
            SaveUserSettings(show_nsfw: show_nsfw,
                             show_scores: show_scores,
                             theme: theme,
                             default_sort_type: default_sort_type,
                             default_listing_type: default_listing_type,
                             interface_language: interface_language,
                             avatar: avatar,
                             banner: banner,
                             display_name: display_name,
                             email: email,
                             bio: bio,
                             matrix_user_id: matrix_user_id,
                             show_avatars: show_avatars,
                             send_notifications_to_email: send_notifications_to_email,
                             bot_account: bot_account,
                             show_bot_accounts: show_bot_accounts,
                             show_read_posts: show_read_posts,
                             show_new_post_notifs: show_new_post_notifs,
                             discussion_languages: discussion_languages,
                             generate_totp_2fa: generate_totp_2fa,
                             auth: auth,
                             open_links_in_new_tab: open_links_in_new_tab)
        ).async() else {
            return nil
        }
        
        if isBaseInstance {
            LemmyKit.auth = result.jwt
            
            //Update user info
            _ = await Lemmy.site(auth: result.jwt)
        }
        
        return result
    }
    static func saveUserSettings(show_nsfw: Bool? = nil,
                                 show_scores: Bool? = nil,
                                 theme: String? = nil,
                                 default_sort_type: SortType? = nil,
                                 default_listing_type: ListingType? = nil,
                                 interface_language: String? = nil,
                                 avatar: String? = nil,
                                 banner: String? = nil,
                                 display_name: String? = nil,
                                 email: String? = nil,
                                 bio: String? = nil,
                                 matrix_user_id: String? = nil,
                                 show_avatars: Bool? = nil,
                                 send_notifications_to_email: Bool? = nil,
                                 bot_account: Bool? = nil,
                                 show_bot_accounts: Bool? = nil,
                                 show_read_posts: Bool? = nil,
                                 show_new_post_notifs: Bool? = nil,
                                 discussion_languages: [LanguageId]? = nil,
                                 generate_totp_2fa: Bool? = nil,
                                 auth: String? = nil,
                                 open_links_in_new_tab: Bool? = nil
    ) async -> LoginResponse? {
        guard let shared else { return nil }
        
        let validAuth: String? = auth ?? shared.auth
        
        guard let validAuth else {
            LemmyLog("Authentication required")
            return nil
        }
        
        return await shared.saveUserSettings(show_nsfw: show_nsfw,
                                             show_scores: show_scores,
                                             theme: theme,
                                             default_sort_type: default_sort_type,
                                             default_listing_type: default_listing_type,
                                             interface_language: interface_language,
                                             avatar: avatar,
                                             banner: banner,
                                             display_name: display_name,
                                             email: email,
                                             bio: bio,
                                             matrix_user_id: matrix_user_id,
                                             show_avatars: show_avatars,
                                             send_notifications_to_email: send_notifications_to_email,
                                             bot_account: bot_account,
                                             show_bot_accounts: show_bot_accounts,
                                             show_read_posts: show_read_posts,
                                             show_new_post_notifs: show_new_post_notifs,
                                             discussion_languages: discussion_languages,
                                             generate_totp_2fa: generate_totp_2fa,
                                             auth: validAuth,
                                             open_links_in_new_tab: open_links_in_new_tab)
    }
    
    func details(_ person_id: PersonId? = nil,
                 sort: SortType? = nil,
                 page: Int? = nil,
                 limit: Int? = nil,
                 community_id: CommunityId? = nil,
                 saved_only: Bool? = nil,
                 auth: String? = nil) async -> GetPersonDetailsResponse? {
        guard let result = try? await api.request(
            GetPersonDetails(person_id: person_id,
                             sort: sort,
                             page: page,
                             limit: limit,
                             community_id: community_id,
                             saved_only: saved_only,
                             auth: auth ?? self.auth)
        ).async() else {
            return nil
        }
        
        return result
    }
    static func details(_ person: Person? = nil,
                        sort: SortType? = nil,
                        page: Int? = nil,
                        limit: Int? = nil,
                        community: Community? = nil,
                        saved_only: Bool? = nil,
                        auth: String? = nil,
                        useBase: Bool = true) async -> GetPersonDetailsResponse? {
        guard let shared else { return nil }
        
        if useBase == false,
           let community,
           let domain = LemmyKit.sanitize(community.actor_id).host { //getInstancedDomain(community: community) {
            let instancedLemmy: Lemmy = .init(apiUrl: domain)
            
            return await instancedLemmy.details(person?.id,
                                                sort: sort,
                                                page: page,
                                                limit: limit,
                                                community_id: community.id,
                                                saved_only: saved_only,
                                                auth: auth)
            //Fetch local community
        } else {
            
            return await shared.details(person?.id,
                                        sort: sort,
                                        page: page,
                                        limit: limit,
                                        community_id: community?.id,
                                        saved_only: saved_only,
                                        auth: auth)
        }
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

//MARK: Mention/Replies/unreadcount

public extension Lemmy {
    func mentions(sort: CommentSortType? = nil,
                  page: Int? = nil,
                  limit: Int? = nil,
                  unreadOnly: Bool? = nil,
                  auth: String) async -> GetPersonMentionsResponse? {
        guard let result = try? await api.request(
            GetPersonMentions(sort: sort,
                              page: page,
                              limit: limit,
                              unread_only: unreadOnly,
                              auth: auth)
        ).async() else {
            return nil
        }
        
        return result
    }
    static func mentions(sort: CommentSortType? = nil,
                         page: Int? = nil,
                         limit: Int? = nil,
                         unreadOnly: Bool? = nil,
                         auth: String? = nil) async -> GetPersonMentionsResponse? {
        guard let shared else { return nil }
        
        let validAuth: String? = auth ?? shared.auth
        
        guard let validAuth else {
            LemmyLog("Authentication required")
            return nil
        }
        
        return await shared.mentions(sort: sort,
                                     page: page,
                                     limit: limit,
                                     unreadOnly: unreadOnly,
                                     auth: validAuth)
    }
    
    func replies(sort: CommentSortType? = nil,
                 page: Int? = nil,
                 limit: Int? = nil,
                 unreadOnly: Bool? = nil,
                 auth: String) async -> GetRepliesResponse? {
        guard let result = try? await api.request(
            GetReplies(sort: sort,
                       page: page,
                       limit: limit,
                       unread_only: unreadOnly,
                       auth: auth)
        ).async() else {
            return nil
        }
        
        return result
    }
    static func replies(sort: CommentSortType? = nil,
                        page: Int? = nil,
                        limit: Int? = nil,
                        unreadOnly: Bool? = nil,
                        auth: String? = nil) async -> GetRepliesResponse? {
        guard let shared else { return nil }
        
        let validAuth: String? = auth ?? shared.auth
        
        guard let validAuth else {
            LemmyLog("Authentication required")
            return nil
        }
        
        return await shared.replies(sort: sort,
                                    page: page,
                                    limit: limit,
                                    unreadOnly: unreadOnly,
                                    auth: validAuth)
    }
    
    func unreadCount(auth: String) async -> GetUnreadCountResponse? {
        guard let result = try? await api.request(
            GetUnreadCount(auth: auth)
        ).async() else {
            return nil
        }
        
        return result
    }
    static func unreadCount(auth: String? = nil) async -> GetUnreadCountResponse? {
        guard let shared else { return nil }
        
        let validAuth: String? = auth ?? shared.auth
        
        guard let validAuth else {
            LemmyLog("Authentication required")
            return nil
        }
        
        return await shared.unreadCount(auth: validAuth)
    }
}

//MARK: -- Upload Image

public extension Lemmy {
    func uploadImage(_ imageData: Data,
                     auth: String) async -> UploadImageResponse? {
        guard let result = try? await pictrs.request(
            UploadImage(image: imageData, auth: auth)
        ).async() else {
            return nil
        }
        
        return result
    }
    static func uploadImage(_ imageData: Data, auth: String? = nil) async -> UploadImageResponse? {
        guard let shared else { return nil }
        
        let validAuth: String? = auth ?? shared.auth
        
        guard let validAuth else {
            LemmyLog("Authentication required")
            return nil
        }
        
        return await shared.uploadImage(imageData, auth: validAuth)
    }
    
    func deleteImage(_ imageFile: ImageFile,
                     auth: String) async -> EmptyResponse? {
        guard let result = try? await pictrs.request(
            DeleteImage(file: imageFile.file,
                        deleteToken: imageFile.delete_token,
                        auth: auth)
        ).async() else {
            return nil
        }
        
        return result
    }
    static func deleteImage(_ imageFile: ImageFile,
                            auth: String? = nil) async -> EmptyResponse? {
        guard let shared else { return nil }
        
        let validAuth: String? = auth ?? shared.auth
        
        guard let validAuth else {
            LemmyLog("Authentication required")
            return nil
        }
        
        return await shared.deleteImage(imageFile, auth: validAuth)
    }
}

public extension Lemmy {
    func captcha(auth: String? = nil) async -> GetCaptchaResponse? {
        guard let result = try? await api.request(
            GetCaptcha(auth: auth ?? self.auth)
        ).async() else {
            return nil
        }
        
        return result
    }
    static func captcha(auth: String? = nil) async -> GetCaptchaResponse? {
        guard let shared else { return nil }
        
        return await shared.captcha(auth: auth)
    }
}

//MARK: -- Resolve
//WORK IN PROGRESS
public extension Lemmy {
    func resolve(_ resource: ResourceType,
                 auth: String) async -> ResourceType? {
        let q: String

        switch resource {
        case .post(let model):
            q = model.post.ap_id
        default:
            q = ""
        }

        LemmyLog(q, logLevel: .debug)

        guard let result = try? await api.request(
            ResolveObject(q: q, auth: auth)
        ).async() else {
            LemmyLog("failed", logLevel: .error)
            return nil
        }

        switch resource {
        case .post:
            guard let model = result.post else { return nil }
            LemmyLog("resolved: \(model.post.id)", logLevel: .debug)
            return .post(model)
        case .comment:
            guard let model = result.comment else { return nil }
            return .comment(model)
        case .creator:
            guard let model = result.person else { return nil }
            return .creator(model)
        case .community:
            guard let model = result.community else { return nil }
            return .community(model)
        }
    }
    static func resolve(_ object: ResourceType,
                        auth: String? = nil) async -> ResourceType? {
        guard let shared else { return nil }

        let validAuth: String? = auth ?? shared.auth

        guard let validAuth else {
            LemmyLog("Authentication required")
            return nil
        }

        return await shared.resolve(object, auth: validAuth)
    }
    
    func resolveURL(_ q: String,
                    auth: String) async -> ResolveObject.Response? {

        guard let result = try? await api.request(
            ResolveObject(q: q, auth: auth)
        ).async() else {
            LemmyLog("failed", logLevel: .error)
            return nil
        }
        
        return result
    }
    static func resolveURL(_ q: String,
                           auth: String? = nil) async -> ResolveObject.Response? {
        guard let shared else { return nil }

        let validAuth: String? = auth ?? shared.auth

        guard let validAuth else {
            LemmyLog("Authentication required")
            return nil
        }

        return await shared.resolveURL(q, auth: validAuth)
    }
}
