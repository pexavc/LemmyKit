/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public enum ListingType: String, Codable, CustomStringConvertible, CaseIterable {
	case all = "All"
	case local = "Local"
	case subscribed = "Subscribed"

	public var description: String {
		return rawValue
	}
}
