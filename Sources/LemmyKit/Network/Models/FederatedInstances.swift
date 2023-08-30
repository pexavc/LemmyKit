/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct FederatedInstances: Codable, Hashable {
	public let linked: [LemmyInstance]
	public let allowed: [LemmyInstance]
	public let blocked: [LemmyInstance]

	public init(
		linked: [LemmyInstance],
		allowed: [LemmyInstance],
		blocked: [LemmyInstance]
	) {
		self.linked = linked
		self.allowed = allowed
		self.blocked = blocked
	}
}
