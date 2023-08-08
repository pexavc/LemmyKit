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
    
    public var location: FetchType
    
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
        location: FetchType = .base
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
        self.location = location
	}
    
    public func transform(_ publisher: AnyPublisher<GetPostsResponse, Error>) throws -> AnyPublisher<GetPostsResponse, Error> {
        return publisher
            .map { response in
                var newPosts: [PostView] = []
                for post in response.posts {
                    var newPost = post
                    newPost.update(location: self.location)
                    newPost.community.ap_id = newPost.post.ap_id
                    newPosts.append(newPost)
                }
                return GetPostsResponse(posts: newPosts)
            }.eraseToAnyPublisher()
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
