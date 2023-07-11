/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct EditComment: Request {
	public typealias Response = CommentResponse

	public var path: String { "/comment" }
	public var method: RequestMethod { .put }

	public let comment_id: CommentId
	public let content: String?
	public let language_id: LanguageId?
	public let form_id: String?
	public let auth: String

	public init(
		comment_id: CommentId,
		content: String? = nil,
		language_id: LanguageId? = nil,
		form_id: String? = nil,
		auth: String
	) {
		self.comment_id = comment_id
		self.content = content
		self.language_id = language_id
		self.form_id = form_id
		self.auth = auth
	}
}
