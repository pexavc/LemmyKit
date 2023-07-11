/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct PostJoin: Codable, Hashable {
	public let post_id: PostId

	public init(
		post_id: PostId
	) {
		self.post_id = post_id
	}
}
