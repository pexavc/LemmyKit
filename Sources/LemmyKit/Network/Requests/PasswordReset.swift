/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct PasswordReset: Request {
	public typealias Response = PasswordResetResponse

	public var path: String { "/user/password_reset" }
	public var method: RequestMethod { .post }

	public let email: String

	public init(
		email: String
	) {
		self.email = email
	}
}

public struct PasswordResetResponse: Codable {
	public init() {}
}
