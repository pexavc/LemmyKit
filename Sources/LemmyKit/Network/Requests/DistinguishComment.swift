/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct DistinguishComment: Request {
	public typealias Response = CommentResponse

	public var path: String { "/comment/distinguish" }
	public var method: RequestMethod { .post }

	public let comment_id: CommentId
	public let distinguished: Bool
	public let auth: String

	public init(
		comment_id: CommentId,
		distinguished: Bool,
		auth: String
	) {
		self.comment_id = comment_id
		self.distinguished = distinguished
		self.auth = auth
	}
}
