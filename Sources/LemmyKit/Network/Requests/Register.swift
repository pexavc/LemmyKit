/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct Register: Request {
	public typealias Response = LoginResponse

	public var path: String { "/user/register" }
	public var method: RequestMethod { .post }

	public let username: String
	public let password: String
	public let password_verify: String
	public let show_nsfw: Bool
	public let email: String?
	public let captcha_uuid: String?
	public let captcha_answer: String?
	public let honeypot: String?
	public let answer: String?

	public init(
		username: String,
		password: String,
		password_verify: String,
		show_nsfw: Bool,
		email: String? = nil,
		captcha_uuid: String? = nil,
		captcha_answer: String? = nil,
		honeypot: String? = nil,
		answer: String? = nil
	) {
		self.username = username
		self.password = password
		self.password_verify = password_verify
		self.show_nsfw = show_nsfw
		self.email = email
		self.captcha_uuid = captcha_uuid
		self.captcha_answer = captcha_answer
		self.honeypot = honeypot
		self.answer = answer
	}
}

public struct LoginResponse: Codable, Hashable {
	public let jwt: String?
	public let registration_created: Bool
	public let verify_email_sent: Bool

	public init(
		jwt: String? = nil,
		registration_created: Bool,
		verify_email_sent: Bool
	) {
		self.jwt = jwt
		self.registration_created = registration_created
		self.verify_email_sent = verify_email_sent
	}
}
