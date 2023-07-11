/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct ResolveCommentReport: Request {
	public typealias Response = CommentReportResponse

	public var path: String { "/comment/report/resolve" }
	public var method: RequestMethod { .put }

	public let report_id: CommentReportId
	public let resolved: Bool
	public let auth: String

	public init(
		report_id: CommentReportId,
		resolved: Bool,
		auth: String
	) {
		self.report_id = report_id
		self.resolved = resolved
		self.auth = auth
	}
}
