/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct CommentReport: Codable, Identifiable, Hashable {
	public let id: CommentReportId
	public let creator_id: PersonId
	public let comment_id: CommentId
	public let original_comment_text: String
	public let reason: String
	public let resolved: Bool
	public let resolver_id: PersonId?
	public let published: String
	public let updated: String?

	public init(
		id: CommentReportId,
		creator_id: PersonId,
		comment_id: CommentId,
		original_comment_text: String,
		reason: String,
		resolved: Bool,
		resolver_id: PersonId? = nil,
		published: String,
		updated: String? = nil
	) {
		self.id = id
		self.creator_id = creator_id
		self.comment_id = comment_id
		self.original_comment_text = original_comment_text
		self.reason = reason
		self.resolved = resolved
		self.resolver_id = resolver_id
		self.published = published
		self.updated = updated
	}
}
