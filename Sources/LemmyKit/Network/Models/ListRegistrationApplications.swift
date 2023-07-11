/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct ListRegistrationApplications: Codable, Hashable {
	public let unread_only: Bool?
	public let page: Int?
	public let limit: Int?
	public let auth: String

	public init(
		unread_only: Bool? = nil,
		page: Int? = nil,
		limit: Int? = nil,
		auth: String
	) {
		self.unread_only = unread_only
		self.page = page
		self.limit = limit
		self.auth = auth
	}
}
