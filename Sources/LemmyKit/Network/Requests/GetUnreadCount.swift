/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct GetUnreadCount: Request {
	public typealias Response = GetUnreadCountResponse

	public var path: String { "/user/unread_count" }
	public var method: RequestMethod { .get }

	public let auth: String

	public init(
		auth: String
	) {
		self.auth = auth
	}
}

public struct GetUnreadCountResponse: Codable, Hashable {
	public let replies: Int
	public let mentions: Int
	public let private_messages: Int

	public init(
		replies: Int,
		mentions: Int,
		private_messages: Int
	) {
		self.replies = replies
		self.mentions = mentions
		self.private_messages = private_messages
	}
}
