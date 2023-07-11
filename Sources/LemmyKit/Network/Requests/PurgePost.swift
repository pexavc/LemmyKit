/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct PurgePost: Request {
	public typealias Response = PurgeItemResponse

	public var path: String { "/admin/purge/post" }
	public var method: RequestMethod { .post }

	public let post_id: PostId
	public let reason: String?
	public let auth: String

	public init(
		post_id: PostId,
		reason: String? = nil,
		auth: String
	) {
		self.post_id = post_id
		self.reason = reason
		self.auth = auth
	}
}
