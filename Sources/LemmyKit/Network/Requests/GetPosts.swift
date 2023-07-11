/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

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
	public let auth: String?

	public init(
		type_: ListingType? = nil,
		sort: SortType? = nil,
		page: Int? = nil,
		limit: Int? = nil,
		community_id: CommunityId? = nil,
		community_name: String? = nil,
		saved_only: Bool? = nil,
		auth: String? = nil
	) {
		self.type_ = type_
		self.sort = sort
		self.page = page
		self.limit = limit
		self.community_id = community_id
		self.community_name = community_name
		self.saved_only = saved_only
		self.auth = auth
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
