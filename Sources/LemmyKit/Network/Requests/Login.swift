/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct Login: Request {
	public typealias Response = LoginResponse

	public var path: String { "/user/login" }
	public var method: RequestMethod { .post }

	public let username_or_email: String
	public let password: String
	public let totp_2fa_token: String?

	public init(
		username_or_email: String,
		password: String,
		totp_2fa_token: String? = nil
	) {
		self.username_or_email = username_or_email
		self.password = password
		self.totp_2fa_token = totp_2fa_token
	}
}
