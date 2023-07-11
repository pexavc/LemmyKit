/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct MarkAllAsRead: Request {
	public typealias Response = GetRepliesResponse

	public var path: String { "/user/mark_all_as_read" }
	public var method: RequestMethod { .post }

	public let auth: String

	public init(
		auth: String
	) {
		self.auth = auth
	}
}
