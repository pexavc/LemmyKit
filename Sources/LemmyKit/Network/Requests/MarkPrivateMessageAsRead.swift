/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct MarkPrivateMessageAsRead: Request {
	public typealias Response = PrivateMessageResponse

	public var path: String { "/private_message/mark_as_read" }
	public var method: RequestMethod { .post }

	public let private_message_id: PrivateMessageId
	public let read: Bool
	public let auth: String

	public init(
		private_message_id: PrivateMessageId,
		read: Bool,
		auth: String
	) {
		self.private_message_id = private_message_id
		self.read = read
		self.auth = auth
	}
}
