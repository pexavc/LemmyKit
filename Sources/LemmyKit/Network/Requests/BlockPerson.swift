/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct BlockPerson: Request {
	public typealias Response = BlockPersonResponse

	public var path: String { "/user/block" }
	public var method: RequestMethod { .post }

	public let person_id: PersonId
	public let block: Bool
	public let auth: String

	public init(
		person_id: PersonId,
		block: Bool,
		auth: String
	) {
		self.person_id = person_id
		self.block = block
		self.auth = auth
	}
}

public struct BlockPersonResponse: Codable, Hashable {
	public let person_view: PersonView
	public let blocked: Bool

	public init(
		person_view: PersonView,
		blocked: Bool
	) {
		self.person_view = person_view
		self.blocked = blocked
	}
}
