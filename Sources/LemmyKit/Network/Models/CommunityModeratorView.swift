/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct CommunityModeratorView: Codable, Hashable {
	public let community: Community
	public let moderator: Person

	public init(
		community: Community,
		moderator: Person
	) {
		self.community = community
		self.moderator = moderator
	}
}
