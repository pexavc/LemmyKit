/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct RemovePost: Request {
	public typealias Response = PostResponse

	public var path: String { "/post/remove" }
	public var method: RequestMethod { .post }

	public let post_id: PostId
	public let removed: Bool
	public let reason: String?
	public let auth: String

	public init(
		post_id: PostId,
		removed: Bool,
		reason: String? = nil,
		auth: String
	) {
		self.post_id = post_id
		self.removed = removed
		self.reason = reason
		self.auth = auth
	}
}
