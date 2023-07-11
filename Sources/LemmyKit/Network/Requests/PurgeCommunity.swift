/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct PurgeCommunity: Request {
	public typealias Response = PurgeItemResponse

	public var path: String { "/admin/purge/community" }
	public var method: RequestMethod { .post }

	public let community_id: CommunityId
	public let reason: String?
	public let auth: String

	public init(
		community_id: CommunityId,
		reason: String? = nil,
		auth: String
	) {
		self.community_id = community_id
		self.reason = reason
		self.auth = auth
	}
}
