/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct CommunityFollowerView: Codable, Hashable {
	public let community: Community
	public let follower: Person

	public init(
		community: Community,
		follower: Person
	) {
		self.community = community
		self.follower = follower
	}
}
