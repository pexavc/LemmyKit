/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct LeaveAdmin: Request {
	public typealias Response = GetSiteResponse

	public var path: String { "/user/leave_admin" }
	public var method: RequestMethod { .post }

	public let auth: String

	public init(
		auth: String
	) {
		self.auth = auth
	}
}
