/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct DeleteAccount: Request {
	public typealias Response = DeleteAccountResponse

	public var path: String { "/user/delete_account" }
	public var method: RequestMethod { .post }

	public let password: String
	public let auth: String

	public init(
		password: String,
		auth: String
	) {
		self.password = password
		self.auth = auth
	}
}

public struct DeleteAccountResponse: Codable {
	public init() {}
}
