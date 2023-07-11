/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public enum SearchType: String, Codable, CustomStringConvertible, CaseIterable {
	case all = "All"
	case comments = "Comments"
	case posts = "Posts"
	case communities = "Communities"
	case users = "Users"
	case url = "Url"

	public var description: String {
		return rawValue
	}
}
