/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct LocalSiteRateLimit: Codable, Identifiable, Hashable {
	public let id: Int
	public let local_site_id: LocalSiteId
	public let message: Int
	public let message_per_second: Int
	public let post: Int
	public let post_per_second: Int
	public let register: Int
	public let register_per_second: Int
	public let image: Int
	public let image_per_second: Int
	public let comment: Int
	public let comment_per_second: Int
	public let search: Int
	public let search_per_second: Int
	public let published: String
	public let updated: String?

	public init(
		id: Int,
		local_site_id: LocalSiteId,
		message: Int,
		message_per_second: Int,
		post: Int,
		post_per_second: Int,
		register: Int,
		register_per_second: Int,
		image: Int,
		image_per_second: Int,
		comment: Int,
		comment_per_second: Int,
		search: Int,
		search_per_second: Int,
		published: String,
		updated: String? = nil
	) {
		self.id = id
		self.local_site_id = local_site_id
		self.message = message
		self.message_per_second = message_per_second
		self.post = post
		self.post_per_second = post_per_second
		self.register = register
		self.register_per_second = register_per_second
		self.image = image
		self.image_per_second = image_per_second
		self.comment = comment
		self.comment_per_second = comment_per_second
		self.search = search
		self.search_per_second = search_per_second
		self.published = published
		self.updated = updated
	}
}
