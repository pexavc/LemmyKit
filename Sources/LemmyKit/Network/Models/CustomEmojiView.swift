/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct CustomEmojiView: Codable, Hashable {
	public let custom_emoji: CustomEmoji
	public let keywords: [CustomEmojiKeyword]

	public init(
		custom_emoji: CustomEmoji,
		keywords: [CustomEmojiKeyword]
	) {
		self.custom_emoji = custom_emoji
		self.keywords = keywords
	}
}
