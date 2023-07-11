/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct CreatePrivateMessage: Request {
	public typealias Response = PrivateMessageResponse

	public var path: String { "/private_message" }
	public var method: RequestMethod { .post }

	public let content: String
	public let recipient_id: PersonId
	public let auth: String

	public init(
		content: String,
		recipient_id: PersonId,
		auth: String
	) {
		self.content = content
		self.recipient_id = recipient_id
		self.auth = auth
	}
}

public struct PrivateMessageResponse: Codable, Hashable {
	public let private_message_view: PrivateMessageView

	public init(
		private_message_view: PrivateMessageView
	) {
		self.private_message_view = private_message_view
	}
}
