/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct CreateCustomEmoji: Request {
	public typealias Response = CustomEmojiResponse

	public var path: String { "/custom_emoji" }
	public var method: RequestMethod { .post }

	public let category: String
	public let shortcode: String
	public let image_url: String
	public let alt_text: String
	public let keywords: [String]
	public let auth: String

	public init(
		category: String,
		shortcode: String,
		image_url: String,
		alt_text: String,
		keywords: [String],
		auth: String
	) {
		self.category = category
		self.shortcode = shortcode
		self.image_url = image_url
		self.alt_text = alt_text
		self.keywords = keywords
		self.auth = auth
	}
}

public struct CustomEmojiResponse: Codable, Hashable {
	public let custom_emoji: CustomEmojiView

	public init(
		custom_emoji: CustomEmojiView
	) {
		self.custom_emoji = custom_emoji
	}
}
