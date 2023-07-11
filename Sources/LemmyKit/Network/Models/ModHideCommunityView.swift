/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct ModHideCommunityView: Codable, Hashable {
	public let mod_hide_community: ModHideCommunity
	public let admin: Person?
	public let community: Community

	public init(
		mod_hide_community: ModHideCommunity,
		admin: Person? = nil,
		community: Community
	) {
		self.mod_hide_community = mod_hide_community
		self.admin = admin
		self.community = community
	}
}
