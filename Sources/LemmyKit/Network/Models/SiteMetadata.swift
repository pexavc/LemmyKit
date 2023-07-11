/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct SiteMetadata: Codable, Hashable {
	public let title: String?
	public let description: String?
	public let image: String?
	public let embed_video_url: String?

	public init(
		title: String? = nil,
		description: String? = nil,
		image: String? = nil,
		embed_video_url: String? = nil
	) {
		self.title = title
		self.description = description
		self.image = image
		self.embed_video_url = embed_video_url
	}
}
