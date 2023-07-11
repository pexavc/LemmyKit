/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct ModJoin: Codable, Hashable {
	public let community_id: CommunityId

	public init(
		community_id: CommunityId
	) {
		self.community_id = community_id
	}
}
