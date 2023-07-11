/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct EditCustomEmoji: Request {
	public typealias Response = CustomEmojiResponse

	public var path: String { "/custom_emoji" }
	public var method: RequestMethod { .put }

	public let id: CustomEmojiId
	public let category: String
	public let image_url: String
	public let alt_text: String
	public let keywords: [String]
	public let auth: String

	public init(
		id: CustomEmojiId,
		category: String,
		image_url: String,
		alt_text: String,
		keywords: [String],
		auth: String
	) {
		self.id = id
		self.category = category
		self.image_url = image_url
		self.alt_text = alt_text
		self.keywords = keywords
		self.auth = auth
	}
}
