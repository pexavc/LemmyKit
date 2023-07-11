/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct GetPrivateMessages: Request {
	public typealias Response = PrivateMessagesResponse

	public var path: String { "/private_message/list" }
	public var method: RequestMethod { .get }

	public let unread_only: Bool?
	public let page: Int?
	public let limit: Int?
	public let auth: String

	public init(
		unread_only: Bool? = nil,
		page: Int? = nil,
		limit: Int? = nil,
		auth: String
	) {
		self.unread_only = unread_only
		self.page = page
		self.limit = limit
		self.auth = auth
	}
}

public struct PrivateMessagesResponse: Codable, Hashable {
	public let private_messages: [PrivateMessageView]

	public init(
		private_messages: [PrivateMessageView]
	) {
		self.private_messages = private_messages
	}
}
