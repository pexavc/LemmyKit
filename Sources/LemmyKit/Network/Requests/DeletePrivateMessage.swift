/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct DeletePrivateMessage: Request {
	public typealias Response = PrivateMessageResponse

	public var path: String { "/private_message/delete" }
	public var method: RequestMethod { .post }

	public let private_message_id: PrivateMessageId
	public let deleted: Bool
	public let auth: String

	public init(
		private_message_id: PrivateMessageId,
		deleted: Bool,
		auth: String
	) {
		self.private_message_id = private_message_id
		self.deleted = deleted
		self.auth = auth
	}
}
