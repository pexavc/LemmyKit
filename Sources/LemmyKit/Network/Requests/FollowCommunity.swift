/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct FollowCommunity: Request {
	public typealias Response = CommunityResponse

	public var path: String { "/community/follow" }
	public var method: RequestMethod { .post }

	public let community_id: CommunityId
	public let follow: Bool
	public let auth: String

	public init(
		community_id: CommunityId,
		follow: Bool,
		auth: String
	) {
		self.community_id = community_id
		self.follow = follow
		self.auth = auth
	}
}
