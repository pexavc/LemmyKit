/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct DeleteComment: Request {
	public typealias Response = CommentResponse

	public var path: String { "/comment/delete" }
	public var method: RequestMethod { .post }

	public let comment_id: CommentId
	public let deleted: Bool
	public let auth: String

	public init(
		comment_id: CommentId,
		deleted: Bool,
		auth: String
	) {
		self.comment_id = comment_id
		self.deleted = deleted
		self.auth = auth
	}
}
