/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct CreatePostReport: Request {
	public typealias Response = PostReportResponse

	public var path: String { "/post/report" }
	public var method: RequestMethod { .post }

	public let post_id: PostId
	public let reason: String
	public let auth: String

	public init(
		post_id: PostId,
		reason: String,
		auth: String
	) {
		self.post_id = post_id
		self.reason = reason
		self.auth = auth
	}
}

public struct PostReportResponse: Codable, Hashable {
	public let post_report_view: PostReportView

	public init(
		post_report_view: PostReportView
	) {
		self.post_report_view = post_report_view
	}
}
