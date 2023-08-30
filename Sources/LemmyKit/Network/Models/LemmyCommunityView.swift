/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct LemmyCommunityView: Codable, Hashable {
	public var community: LemmyCommunity
	public let subscribed: SubscribedType
	public let blocked: Bool
	public let counts: CommunityAggregates

	public init(
		community: LemmyCommunity,
		subscribed: SubscribedType,
		blocked: Bool,
		counts: CommunityAggregates
	) {
		self.community = community
		self.subscribed = subscribed
		self.blocked = blocked
		self.counts = counts
	}
}
