/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct GetPersonDetails: Request {
	public typealias Response = GetPersonDetailsResponse

	public var path: String { "/user" }
	public var method: RequestMethod { .get }

	public let person_id: PersonId?
	public let username: String?
	public let sort: SortType?
	public let page: Int?
	public let limit: Int?
	public let community_id: CommunityId?
	public let saved_only: Bool?
	public let auth: String?

	public init(
		person_id: PersonId? = nil,
		username: String? = nil,
		sort: SortType? = nil,
		page: Int? = nil,
		limit: Int? = nil,
		community_id: CommunityId? = nil,
		saved_only: Bool? = nil,
		auth: String? = nil
	) {
		self.person_id = person_id
		self.username = username
		self.sort = sort
		self.page = page
		self.limit = limit
		self.community_id = community_id
		self.saved_only = saved_only
		self.auth = auth
	}
}

public struct GetPersonDetailsResponse: Codable, Hashable {
	public let person_view: PersonView
	public let comments: [CommentView]
	public let posts: [PostView]
	public let moderates: [CommunityModeratorView]

	public init(
		person_view: PersonView,
		comments: [CommentView],
		posts: [PostView],
		moderates: [CommunityModeratorView]
	) {
		self.person_view = person_view
		self.comments = comments
		self.posts = posts
		self.moderates = moderates
	}
}
