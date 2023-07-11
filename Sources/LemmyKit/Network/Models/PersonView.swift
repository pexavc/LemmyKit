/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct PersonView: Codable, Hashable {
	public let person: Person
	public let counts: PersonAggregates

	public init(
		person: Person,
		counts: PersonAggregates
	) {
		self.person = person
		self.counts = counts
	}
}
