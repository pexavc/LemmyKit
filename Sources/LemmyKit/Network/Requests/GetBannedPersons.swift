/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct GetBannedPersons: Request {
	public typealias Response = BannedPersonsResponse

	public var path: String { "/user/banned" }
	public var method: RequestMethod { .get }

	public let auth: String

	public init(
		auth: String
	) {
		self.auth = auth
	}
}

public struct BannedPersonsResponse: Codable, Hashable {
	public let banned: [PersonView]

	public init(
		banned: [PersonView]
	) {
		self.banned = banned
	}
}
