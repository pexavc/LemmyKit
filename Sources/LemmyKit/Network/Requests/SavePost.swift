/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct SavePost: Request {
	public typealias Response = PostResponse

	public var path: String { "/post/save" }
	public var method: RequestMethod { .put }

	public let post_id: PostId
	public let save: Bool
	public let auth: String

	public init(
		post_id: PostId,
		save: Bool,
		auth: String
	) {
		self.post_id = post_id
		self.save = save
		self.auth = auth
	}
}
