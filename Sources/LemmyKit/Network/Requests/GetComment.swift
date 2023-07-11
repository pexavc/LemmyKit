/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct GetComment: Request {
	public typealias Response = CommentResponse

	public var path: String { "/comment" }
	public var method: RequestMethod { .get }

	public let id: CommentId
	public let auth: String?

	public init(
		id: CommentId,
		auth: String? = nil
	) {
		self.id = id
		self.auth = auth
	}
}
