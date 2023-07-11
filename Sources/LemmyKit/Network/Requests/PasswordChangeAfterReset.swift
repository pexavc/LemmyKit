/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct PasswordChangeAfterReset: Request {
	public typealias Response = LoginResponse

	public var path: String { "/user/password_change" }
	public var method: RequestMethod { .post }

	public let token: String
	public let password: String
	public let password_verify: String

	public init(
		token: String,
		password: String,
		password_verify: String
	) {
		self.token = token
		self.password = password
		self.password_verify = password_verify
	}
}
