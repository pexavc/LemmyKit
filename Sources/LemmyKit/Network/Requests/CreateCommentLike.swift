/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct CreateCommentLike: Request {
	public typealias Response = CommentResponse

	public var path: String { "/comment/like" }
	public var method: RequestMethod { .post }

	public let comment_id: CommentId
	public let score: Int
	public let auth: String

	public init(
		comment_id: CommentId,
		score: Int,
		auth: String
	) {
		self.comment_id = comment_id
		self.score = score
		self.auth = auth
	}
}
