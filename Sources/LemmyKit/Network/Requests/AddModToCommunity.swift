/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct AddModToCommunity: Request {
	public typealias Response = AddModToCommunityResponse

	public var path: String { "/community/mod" }
	public var method: RequestMethod { .post }

	public let community_id: CommunityId
	public let person_id: PersonId
	public let added: Bool
	public let auth: String

	public init(
		community_id: CommunityId,
		person_id: PersonId,
		added: Bool,
		auth: String
	) {
		self.community_id = community_id
		self.person_id = person_id
		self.added = added
		self.auth = auth
	}
}

public struct AddModToCommunityResponse: Codable, Hashable {
	public let moderators: [CommunityModeratorView]

	public init(
		moderators: [CommunityModeratorView]
	) {
		self.moderators = moderators
	}
}
