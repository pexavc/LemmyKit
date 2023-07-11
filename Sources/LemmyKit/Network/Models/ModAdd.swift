/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct ModAdd: Codable, Identifiable, Hashable {
	public let id: Int
	public let mod_person_id: PersonId
	public let other_person_id: PersonId
	public let removed: Bool
	public let when_: String

	public init(
		id: Int,
		mod_person_id: PersonId,
		other_person_id: PersonId,
		removed: Bool,
		when_: String
	) {
		self.id = id
		self.mod_person_id = mod_person_id
		self.other_person_id = other_person_id
		self.removed = removed
		self.when_ = when_
	}
}
