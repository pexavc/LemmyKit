/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct MarkPostAsRead: Request {
	public typealias Response = PostResponse

	public var path: String { "/post/mark_as_read" }
	public var method: RequestMethod { .post }

	public let post_id: PostId
	public let read: Bool
	public let auth: String

	public init(
		post_id: PostId,
		read: Bool,
		auth: String
	) {
		self.post_id = post_id
		self.read = read
		self.auth = auth
	}
}
