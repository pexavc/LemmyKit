/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct LemmyPersonView: Codable, Hashable {
	public let person: LemmyPerson
	public let counts: PersonAggregates

	public init(
		person: LemmyPerson,
		counts: PersonAggregates
	) {
		self.person = person
		self.counts = counts
	}
}
