/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct GetUnreadRegistrationApplicationCountResponse: Codable, Hashable {
	public let registration_applications: Int

	public init(
		registration_applications: Int
	) {
		self.registration_applications = registration_applications
	}
}
