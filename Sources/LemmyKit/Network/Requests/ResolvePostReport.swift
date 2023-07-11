/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct ResolvePostReport: Request {
	public typealias Response = PostReportResponse

	public var path: String { "/post/report/resolve" }
	public var method: RequestMethod { .put }

	public let report_id: PostReportId
	public let resolved: Bool
	public let auth: String

	public init(
		report_id: PostReportId,
		resolved: Bool,
		auth: String
	) {
		self.report_id = report_id
		self.resolved = resolved
		self.auth = auth
	}
}
