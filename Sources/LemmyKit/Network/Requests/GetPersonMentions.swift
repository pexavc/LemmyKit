/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct GetPersonMentions: Request {
	public typealias Response = GetPersonMentionsResponse

	public var path: String { "/user/mention" }
	public var method: RequestMethod { .get }

	public let sort: CommentSortType?
	public let page: Int?
	public let limit: Int?
	public let unread_only: Bool?
	public let auth: String

	public init(
		sort: CommentSortType? = nil,
		page: Int? = nil,
		limit: Int? = nil,
		unread_only: Bool? = nil,
		auth: String
	) {
		self.sort = sort
		self.page = page
		self.limit = limit
		self.unread_only = unread_only
		self.auth = auth
	}
}

public struct GetPersonMentionsResponse: Codable, Hashable {
	public let mentions: [PersonMentionView]

	public init(
		mentions: [PersonMentionView]
	) {
		self.mentions = mentions
	}
}
