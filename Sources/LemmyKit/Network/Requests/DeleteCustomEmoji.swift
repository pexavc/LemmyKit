/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct DeleteCustomEmoji: Request {
	public typealias Response = DeleteCustomEmojiResponse

	public var path: String { "/custom_emoji/delete" }
	public var method: RequestMethod { .post }

	public let id: CustomEmojiId
	public let auth: String

	public init(
		id: CustomEmojiId,
		auth: String
	) {
		self.id = id
		self.auth = auth
	}
}

public struct DeleteCustomEmojiResponse: Codable, Identifiable, Hashable {
	public let id: CustomEmojiId
	public let success: Bool

	public init(
		id: CustomEmojiId,
		success: Bool
	) {
		self.id = id
		self.success = success
	}
}
