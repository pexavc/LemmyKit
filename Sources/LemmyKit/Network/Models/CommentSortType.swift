/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public enum CommentSortType: String, Codable, CustomStringConvertible, CaseIterable {
	case hot = "Hot"
	case top = "Top"
	case new = "New"
	case old = "Old"

	public var description: String {
		return rawValue
	}
}
