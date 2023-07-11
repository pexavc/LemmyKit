/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct PostJoinResponse: Codable, Hashable {
	public let joined: Bool

	public init(
		joined: Bool
	) {
		self.joined = joined
	}
}
