/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct DeleteCommunity: Request {
	public typealias Response = CommunityResponse

	public var path: String { "/community/delete" }
	public var method: RequestMethod { .post }

	public let community_id: CommunityId
	public let deleted: Bool
	public let auth: String

	public init(
		community_id: CommunityId,
		deleted: Bool,
		auth: String
	) {
		self.community_id = community_id
		self.deleted = deleted
		self.auth = auth
	}
}
