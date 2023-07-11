/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct Tagline: Codable, Identifiable, Hashable {
	public let id: Int
	public let local_site_id: LocalSiteId
	public let content: String
	public let published: String
	public let updated: String?

	public init(
		id: Int,
		local_site_id: LocalSiteId,
		content: String,
		published: String,
		updated: String? = nil
	) {
		self.id = id
		self.local_site_id = local_site_id
		self.content = content
		self.published = published
		self.updated = updated
	}
}
