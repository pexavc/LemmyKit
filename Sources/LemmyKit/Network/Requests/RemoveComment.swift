/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct RemoveComment: Request {
	public typealias Response = CommentResponse

	public var path: String { "/comment/remove" }
	public var method: RequestMethod { .post }

	public let comment_id: CommentId
	public let removed: Bool
	public let reason: String?
	public let auth: String

	public init(
		comment_id: CommentId,
		removed: Bool,
		reason: String? = nil,
		auth: String
	) {
		self.comment_id = comment_id
		self.removed = removed
		self.reason = reason
		self.auth = auth
	}
}
