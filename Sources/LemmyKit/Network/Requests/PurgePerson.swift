/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct PurgePerson: Request {
	public typealias Response = PurgeItemResponse

	public var path: String { "/admin/purge/person" }
	public var method: RequestMethod { .post }

	public let person_id: PersonId
	public let reason: String?
	public let auth: String

	public init(
		person_id: PersonId,
		reason: String? = nil,
		auth: String
	) {
		self.person_id = person_id
		self.reason = reason
		self.auth = auth
	}
}

public struct PurgeItemResponse: Codable, Hashable {
	public let success: Bool

	public init(
		success: Bool
	) {
		self.success = success
	}
}
