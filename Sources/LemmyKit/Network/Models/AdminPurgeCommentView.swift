/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct AdminPurgeCommentView: Codable, Hashable {
	public let admin_purge_comment: AdminPurgeComment
	public let admin: Person?
	public let post: Post

	public init(
		admin_purge_comment: AdminPurgeComment,
		admin: Person? = nil,
		post: Post
	) {
		self.admin_purge_comment = admin_purge_comment
		self.admin = admin
		self.post = post
	}
}
