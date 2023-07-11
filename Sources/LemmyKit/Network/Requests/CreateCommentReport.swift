/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct CreateCommentReport: Request {
	public typealias Response = CommentReportResponse

	public var path: String { "/comment/report" }
	public var method: RequestMethod { .post }

	public let comment_id: CommentId
	public let reason: String
	public let auth: String

	public init(
		comment_id: CommentId,
		reason: String,
		auth: String
	) {
		self.comment_id = comment_id
		self.reason = reason
		self.auth = auth
	}
}

public struct CommentReportResponse: Codable, Hashable {
	public let comment_report_view: CommentReportView

	public init(
		comment_report_view: CommentReportView
	) {
		self.comment_report_view = comment_report_view
	}
}
