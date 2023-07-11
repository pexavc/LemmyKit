/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct UserJoin: Codable, Hashable {
	public let auth: String

	public init(
		auth: String
	) {
		self.auth = auth
	}
}
