/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public enum RegistrationMode: String, Codable, CustomStringConvertible, CaseIterable {
	case closed = "Closed"
	case requireApplication = "RequireApplication"
	case open = "Open"

	public var description: String {
		return rawValue
	}
}
