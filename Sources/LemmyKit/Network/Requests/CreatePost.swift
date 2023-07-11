/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct CreatePost: Request {
	public typealias Response = PostResponse

	public var path: String { "/post" }
	public var method: RequestMethod { .post }

	public let name: String
	public let community_id: CommunityId
	public let url: String?
	public let body: String?
	public let honeypot: String?
	public let nsfw: Bool?
	public let language_id: LanguageId?
	public let auth: String

	public init(
		name: String,
		community_id: CommunityId,
		url: String? = nil,
		body: String? = nil,
		honeypot: String? = nil,
		nsfw: Bool? = nil,
		language_id: LanguageId? = nil,
		auth: String
	) {
		self.name = name
		self.community_id = community_id
		self.url = url
		self.body = body
		self.honeypot = honeypot
		self.nsfw = nsfw
		self.language_id = language_id
		self.auth = auth
	}
}

public struct PostResponse: Codable, Hashable {
	public let post_view: PostView

	public init(
		post_view: PostView
	) {
		self.post_view = post_view
	}
}
