/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct Language: Codable, Identifiable, Hashable {
	public let id: LanguageId
	public let code: String
	public let name: String

	public init(
		id: LanguageId,
		code: String,
		name: String
	) {
		self.id = id
		self.code = code
		self.name = name
	}
}
