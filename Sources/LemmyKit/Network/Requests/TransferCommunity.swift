/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct TransferCommunity: Request {
	public typealias Response = GetCommunityResponse

	public var path: String { "/community/transfer" }
	public var method: RequestMethod { .post }

	public let community_id: CommunityId
	public let person_id: PersonId
	public let auth: String

	public init(
		community_id: CommunityId,
		person_id: PersonId,
		auth: String
	) {
		self.community_id = community_id
		self.person_id = person_id
		self.auth = auth
	}
}
