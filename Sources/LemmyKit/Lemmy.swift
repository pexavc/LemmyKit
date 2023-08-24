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
    
    internal var api: Network
    internal var pictrs: Network
    
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
    
    internal var isBaseInstance: Bool
    
    internal var baseURL: String
    
    public init(id: UUID? = nil,
                apiUrl: String,
                pictrsUrl: String? = nil,
                base: Bool = false) {
        self.id = id ?? .init()
        
        let urlString = LemmyKit.sanitize(apiUrl)
        self.baseURL = urlString.baseUrl ?? apiUrl
        
        self.api = .init(urlString.apiUrl ?? apiUrl)
        let pictrsAPIURL = pictrsUrl ?? (urlString.baseUrl ?? apiUrl) + "/pictrs/image"
        self.contentURL = pictrsAPIURL
        self.pictrs = .init(pictrsAPIURL, uniqueId: "pictrs")
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
    
    internal func update(site: GetSiteResponse?) {
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


