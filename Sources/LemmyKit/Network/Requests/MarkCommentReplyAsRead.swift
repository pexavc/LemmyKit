/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct MarkCommentReplyAsRead: Request {
	public typealias Response = CommentReplyResponse

	public var path: String { "/comment/mark_as_read" }
	public var method: RequestMethod { .post }

	public let comment_reply_id: CommentReplyId
	public let read: Bool
	public let auth: String

	public init(
		comment_reply_id: CommentReplyId,
		read: Bool,
		auth: String
	) {
		self.comment_reply_id = comment_reply_id
		self.read = read
		self.auth = auth
	}
}

public struct CommentReplyResponse: Codable, Hashable {
	public let comment_reply_view: CommentReplyView

	public init(
		comment_reply_view: CommentReplyView
	) {
		self.comment_reply_view = comment_reply_view
	}
}
