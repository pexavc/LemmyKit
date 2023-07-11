/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct PersonMention: Codable, Identifiable, Hashable {
	public let id: PersonMentionId
	public let recipient_id: PersonId
	public let comment_id: CommentId
	public let read: Bool
	public let published: String

	public init(
		id: PersonMentionId,
		recipient_id: PersonId,
		comment_id: CommentId,
		read: Bool,
		published: String
	) {
		self.id = id
		self.recipient_id = recipient_id
		self.comment_id = comment_id
		self.read = read
		self.published = published
	}
}
