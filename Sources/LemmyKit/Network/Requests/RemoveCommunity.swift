/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct RemoveCommunity: Request {
	public typealias Response = CommunityResponse

	public var path: String { "/community/remove" }
	public var method: RequestMethod { .post }

	public let community_id: CommunityId
	public let removed: Bool
	public let reason: String?
	public let expires: Int?
	public let auth: String

	public init(
		community_id: CommunityId,
		removed: Bool,
		reason: String? = nil,
		expires: Int? = nil,
		auth: String
	) {
		self.community_id = community_id
		self.removed = removed
		self.reason = reason
		self.expires = expires
		self.auth = auth
	}
}
