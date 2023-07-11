/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct ListRegistrationApplicationsResponse: Codable, Hashable {
	public let registration_applications: [RegistrationApplicationView]

	public init(
		registration_applications: [RegistrationApplicationView]
	) {
		self.registration_applications = registration_applications
	}
}
