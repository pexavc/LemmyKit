/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct GetCaptcha: Request {
	public typealias Response = GetCaptchaResponse

	public var path: String { "/user/get_captcha" }
	public var method: RequestMethod { .get }

	public let auth: String?

	public init(
		auth: String? = nil
	) {
		self.auth = auth
	}
}

public struct GetCaptchaResponse: Codable, Hashable {
	public let ok: CaptchaResponse?

	public init(
		ok: CaptchaResponse? = nil
	) {
		self.ok = ok
	}
}
