/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct PurgeComment: Request {
	public typealias Response = PurgeItemResponse

	public var path: String { "/admin/purge/comment" }
	public var method: RequestMethod { .post }

	public let comment_id: CommentId
	public let reason: String?
	public let auth: String

	public init(
		comment_id: CommentId,
		reason: String? = nil,
		auth: String
	) {
		self.comment_id = comment_id
		self.reason = reason
		self.auth = auth
	}
}
