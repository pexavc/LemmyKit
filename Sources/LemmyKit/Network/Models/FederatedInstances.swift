/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct FederatedInstances: Codable, Hashable {
	public let linked: [Instance]
	public let allowed: [Instance]
	public let blocked: [Instance]

	public init(
		linked: [Instance],
		allowed: [Instance],
		blocked: [Instance]
	) {
		self.linked = linked
		self.allowed = allowed
		self.blocked = blocked
	}
}
