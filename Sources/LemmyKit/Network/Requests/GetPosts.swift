/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation
import Combine

public struct GetPosts: Request {
	public typealias Response = GetPostsResponse

	public var path: String { "/post/list" }
	public var method: RequestMethod { .get }

	public let type_: ListingType?
	public let sort: SortType?
	public let page: Int?
	public let limit: Int?
	public let community_id: CommunityId?
	public let community_name: String?
	public let saved_only: Bool?
    public let moderator_view: Bool?
	public let auth: String?
    
    /* When a base lemmy instance is fetching posts from
     a fed. instance we are setting this manually as requests
     are made from the fed. instance domain the local variable won't
     be correct in model PostView.Post  */
    public let isLocal: Bool
    
	public init(
		type_: ListingType? = nil,
		sort: SortType? = nil,
		page: Int? = nil,
		limit: Int? = nil,
		community_id: CommunityId? = nil,
		community_name: String? = nil,
		saved_only: Bool? = nil,
        moderator_view: Bool? = nil,
		auth: String? = nil,
        isLocal: Bool = true
	) {
		self.type_ = type_
		self.sort = sort
		self.page = page
		self.limit = limit
		self.community_id = community_id
		self.community_name = community_name
		self.saved_only = saved_only
        self.moderator_view = moderator_view
		self.auth = auth
        self.isLocal = isLocal
	}
    
    public func transform(_ publisher: AnyPublisher<GetPostsResponse, Error>) throws -> AnyPublisher<GetPostsResponse, Error> {
        guard isLocal == false else {
            return publisher
        }
        
        return publisher
            .map { response in
                if self.isLocal == false {
                    var newPosts: [PostView] = []
                    for post in response.posts {
                        var newPost = post
                        //isLocal only if actor id is the same as base domain
                        newPost.isLocal(post.creator.actor_id.contains(LemmyKit.host))
                        newPosts.append(newPost)
                    }
                    return GetPostsResponse(posts: newPosts)
                }
                return response
            }.upstream
    }
    
    enum CodingKeys: CodingKey {
        case type_, sort, page, limit, community_id, community_name, saved_only, moderator_view, auth
    }
}

public struct GetPostsResponse: Codable, Hashable {
	public let posts: [PostView]

	public init(
		posts: [PostView]
	) {
		self.posts = posts
	}
}
