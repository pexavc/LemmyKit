/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public enum PostFeatureType: String, Codable, CustomStringConvertible, CaseIterable {
	case local = "Local"
	case community = "Community"

	public var description: String {
		return rawValue
	}
}
