/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct ChangePassword: Request {
	public typealias Response = LoginResponse

	public var path: String { "/user/change_password" }
	public var method: RequestMethod { .put }

	public let new_password: String
	public let new_password_verify: String
	public let old_password: String
	public let auth: String

	public init(
		new_password: String,
		new_password_verify: String,
		old_password: String,
		auth: String
	) {
		self.new_password = new_password
		self.new_password_verify = new_password_verify
		self.old_password = old_password
		self.auth = auth
	}
}
