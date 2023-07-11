/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct GetCommunity: Request {
	public typealias Response = GetCommunityResponse

	public var path: String { "/community" }
	public var method: RequestMethod { .get }

	public let id: CommunityId?
	public let name: String?
	public let auth: String?

	public init(
		id: CommunityId? = nil,
		name: String? = nil,
		auth: String? = nil
	) {
		self.id = id
		self.name = name
		self.auth = auth
	}
}

public struct GetCommunityResponse: Codable, Hashable {
	public let community_view: CommunityView
	public let site: Site?
	public let moderators: [CommunityModeratorView]
	public let discussion_languages: [LanguageId]

	public init(
		community_view: CommunityView,
		site: Site? = nil,
		moderators: [CommunityModeratorView],
		discussion_languages: [LanguageId]
	) {
		self.community_view = community_view
		self.site = site
		self.moderators = moderators
		self.discussion_languages = discussion_languages
	}
}
