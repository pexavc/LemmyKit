/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct MarkPersonMentionAsRead: Request {
	public typealias Response = PersonMentionResponse

	public var path: String { "/user/mention/mark_as_read" }
	public var method: RequestMethod { .post }

	public let person_mention_id: PersonMentionId
	public let read: Bool
	public let auth: String

	public init(
		person_mention_id: PersonMentionId,
		read: Bool,
		auth: String
	) {
		self.person_mention_id = person_mention_id
		self.read = read
		self.auth = auth
	}
}

public struct PersonMentionResponse: Codable, Hashable {
	public let person_mention_view: PersonMentionView

	public init(
		person_mention_view: PersonMentionView
	) {
		self.person_mention_view = person_mention_view
	}
}
