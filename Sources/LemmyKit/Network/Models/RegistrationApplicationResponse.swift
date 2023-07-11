/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct RegistrationApplicationResponse: Codable, Hashable {
	public let registration_application: RegistrationApplicationView

	public init(
		registration_application: RegistrationApplicationView
	) {
		self.registration_application = registration_application
	}
}
