/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct LockPost: Request {
	public typealias Response = PostResponse

	public var path: String { "/post/lock" }
	public var method: RequestMethod { .post }

	public let post_id: PostId
	public let locked: Bool
	public let auth: String

	public init(
		post_id: PostId,
		locked: Bool,
		auth: String
	) {
		self.post_id = post_id
		self.locked = locked
		self.auth = auth
	}
}
