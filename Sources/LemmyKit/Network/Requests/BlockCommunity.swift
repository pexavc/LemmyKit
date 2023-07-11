/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct BlockCommunity: Request {
	public typealias Response = BlockCommunityResponse

	public var path: String { "/community/block" }
	public var method: RequestMethod { .post }

	public let community_id: CommunityId
	public let block: Bool
	public let auth: String

	public init(
		community_id: CommunityId,
		block: Bool,
		auth: String
	) {
		self.community_id = community_id
		self.block = block
		self.auth = auth
	}
}

public struct BlockCommunityResponse: Codable, Hashable {
	public let community_view: CommunityView
	public let blocked: Bool

	public init(
		community_view: CommunityView,
		blocked: Bool
	) {
		self.community_view = community_view
		self.blocked = blocked
	}
}
