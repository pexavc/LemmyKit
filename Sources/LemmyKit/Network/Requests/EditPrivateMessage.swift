/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct EditPrivateMessage: Request {
	public typealias Response = PrivateMessageResponse

	public var path: String { "/private_message" }
	public var method: RequestMethod { .put }

	public let private_message_id: PrivateMessageId
	public let content: String
	public let auth: String

	public init(
		private_message_id: PrivateMessageId,
		content: String,
		auth: String
	) {
		self.private_message_id = private_message_id
		self.content = content
		self.auth = auth
	}
}
