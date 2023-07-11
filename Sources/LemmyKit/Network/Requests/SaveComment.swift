/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct SaveComment: Request {
	public typealias Response = CommentResponse

	public var path: String { "/comment/save" }
	public var method: RequestMethod { .put }

	public let comment_id: CommentId
	public let save: Bool
	public let auth: String

	public init(
		comment_id: CommentId,
		save: Bool,
		auth: String
	) {
		self.comment_id = comment_id
		self.save = save
		self.auth = auth
	}
}
