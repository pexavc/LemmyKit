/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct GetSite: Request {
	public typealias Response = GetSiteResponse

	public var path: String { "/site" }
	public var method: RequestMethod { .get }

	public let auth: String?

	public init(
		auth: String? = nil
	) {
		self.auth = auth
	}
}

public struct GetSiteResponse: Codable, Hashable {
	public let site_view: SiteView
	public let admins: [PersonView]
	public let version: String
	public let my_user: MyUserInfo?
	public let all_languages: [Language]
	public let discussion_languages: [LanguageId]
	public let taglines: [Tagline]
	public let custom_emojis: [CustomEmojiView]

	public init(
		site_view: SiteView,
		admins: [PersonView],
		version: String,
		my_user: MyUserInfo? = nil,
		all_languages: [Language],
		discussion_languages: [LanguageId],
		taglines: [Tagline],
		custom_emojis: [CustomEmojiView]
	) {
		self.site_view = site_view
		self.admins = admins
		self.version = version
		self.my_user = my_user
		self.all_languages = all_languages
		self.discussion_languages = discussion_languages
		self.taglines = taglines
		self.custom_emojis = custom_emojis
	}
}
