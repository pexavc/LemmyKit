/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct CreatePostLike: Request {
	public typealias Response = PostResponse

	public var path: String { "/post/like" }
	public var method: RequestMethod { .post }

	public let post_id: PostId
	public let score: Int
	public let auth: String

	public init(
		post_id: PostId,
		score: Int,
		auth: String
	) {
		self.post_id = post_id
		self.score = score
		self.auth = auth
	}
}
