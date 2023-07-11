/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct PersonAggregates: Codable, Identifiable, Hashable {
	public let id: Int
	public let person_id: PersonId
	public let post_count: Int
	public let post_score: Int
	public let comment_count: Int
	public let comment_score: Int

	public init(
		id: Int,
		person_id: PersonId,
		post_count: Int,
		post_score: Int,
		comment_count: Int,
		comment_score: Int
	) {
		self.id = id
		self.person_id = person_id
		self.post_count = post_count
		self.post_score = post_score
		self.comment_count = comment_count
		self.comment_score = comment_score
	}
}
