/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct EditCommunity: Request {
	public typealias Response = CommunityResponse

	public var path: String { "/community" }
	public var method: RequestMethod { .put }

	public let community_id: CommunityId
	public let title: String?
	public let description: String?
	public let icon: String?
	public let banner: String?
	public let nsfw: Bool?
	public let posting_restricted_to_mods: Bool?
	public let discussion_languages: [LanguageId]?
	public let auth: String

	public init(
		community_id: CommunityId,
		title: String? = nil,
		description: String? = nil,
		icon: String? = nil,
		banner: String? = nil,
		nsfw: Bool? = nil,
		posting_restricted_to_mods: Bool? = nil,
		discussion_languages: [LanguageId]? = nil,
		auth: String
	) {
		self.community_id = community_id
		self.title = title
		self.description = description
		self.icon = icon
		self.banner = banner
		self.nsfw = nsfw
		self.posting_restricted_to_mods = posting_restricted_to_mods
		self.discussion_languages = discussion_languages
		self.auth = auth
	}
}
