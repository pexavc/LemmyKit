/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct DeletePost: Request {
	public typealias Response = PostResponse

	public var path: String { "/post/delete" }
	public var method: RequestMethod { .post }

	public let post_id: PostId
	public let deleted: Bool
	public let auth: String

	public init(
		post_id: PostId,
		deleted: Bool,
		auth: String
	) {
		self.post_id = post_id
		self.deleted = deleted
		self.auth = auth
	}
}
