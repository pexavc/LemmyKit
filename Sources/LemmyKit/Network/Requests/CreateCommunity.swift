/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct CreateCommunity: Request {
	public typealias Response = CommunityResponse

	public var path: String { "/community" }
	public var method: RequestMethod { .post }

	public let name: String
	public let title: String
	public let description: String?
	public let icon: String?
	public let banner: String?
	public let nsfw: Bool?
	public let posting_restricted_to_mods: Bool?
	public let discussion_languages: [LanguageId]?
	public let auth: String

	public init(
		name: String,
		title: String,
		description: String? = nil,
		icon: String? = nil,
		banner: String? = nil,
		nsfw: Bool? = nil,
		posting_restricted_to_mods: Bool? = nil,
		discussion_languages: [LanguageId]? = nil,
		auth: String
	) {
		self.name = name
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

public struct CommunityResponse: Codable, Hashable {
	public let community_view: CommunityView
	public let discussion_languages: [LanguageId]

	public init(
		community_view: CommunityView,
		discussion_languages: [LanguageId]
	) {
		self.community_view = community_view
		self.discussion_languages = discussion_languages
	}
}
