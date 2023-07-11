/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct EditPost: Request {
	public typealias Response = PostResponse

	public var path: String { "/post" }
	public var method: RequestMethod { .put }

	public let post_id: PostId
	public let name: String?
	public let url: String?
	public let body: String?
	public let nsfw: Bool?
	public let language_id: LanguageId?
	public let auth: String

	public init(
		post_id: PostId,
		name: String? = nil,
		url: String? = nil,
		body: String? = nil,
		nsfw: Bool? = nil,
		language_id: LanguageId? = nil,
		auth: String
	) {
		self.post_id = post_id
		self.name = name
		self.url = url
		self.body = body
		self.nsfw = nsfw
		self.language_id = language_id
		self.auth = auth
	}
}
