/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct VerifyEmail: Request {
	public typealias Response = VerifyEmailResponse

	public var path: String { "/user/verify_email" }
	public var method: RequestMethod { .post }

	public let token: String

	public init(
		token: String
	) {
		self.token = token
	}
}

public struct VerifyEmailResponse: Codable {
	public init() {}
}
