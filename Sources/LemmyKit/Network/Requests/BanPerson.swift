/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct BanPerson: Request {
	public typealias Response = BanPersonResponse

	public var path: String { "/user/ban" }
	public var method: RequestMethod { .post }

	public let person_id: PersonId
	public let ban: Bool
	public let remove_data: Bool?
	public let reason: String?
	public let expires: Int?
	public let auth: String

	public init(
		person_id: PersonId,
		ban: Bool,
		remove_data: Bool? = nil,
		reason: String? = nil,
		expires: Int? = nil,
		auth: String
	) {
		self.person_id = person_id
		self.ban = ban
		self.remove_data = remove_data
		self.reason = reason
		self.expires = expires
		self.auth = auth
	}
}

public struct BanPersonResponse: Codable, Hashable {
	public let person_view: PersonView
	public let banned: Bool

	public init(
		person_view: PersonView,
		banned: Bool
	) {
		self.person_view = person_view
		self.banned = banned
	}
}
