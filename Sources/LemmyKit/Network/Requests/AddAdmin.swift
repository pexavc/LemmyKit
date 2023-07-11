/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct AddAdmin: Request {
	public typealias Response = AddAdminResponse

	public var path: String { "/admin/add" }
	public var method: RequestMethod { .post }

	public let person_id: PersonId
	public let added: Bool
	public let auth: String

	public init(
		person_id: PersonId,
		added: Bool,
		auth: String
	) {
		self.person_id = person_id
		self.added = added
		self.auth = auth
	}
}

public struct AddAdminResponse: Codable, Hashable {
	public let admins: [PersonView]

	public init(
		admins: [PersonView]
	) {
		self.admins = admins
	}
}
