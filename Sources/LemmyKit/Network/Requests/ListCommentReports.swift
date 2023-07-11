/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct ListCommentReports: Request {
	public typealias Response = ListCommentReportsResponse

	public var path: String { "/comment/report/list" }
	public var method: RequestMethod { .get }

	public let page: Int?
	public let limit: Int?
	public let unresolved_only: Bool?
	public let community_id: CommunityId?
	public let auth: String

	public init(
		page: Int? = nil,
		limit: Int? = nil,
		unresolved_only: Bool? = nil,
		community_id: CommunityId? = nil,
		auth: String
	) {
		self.page = page
		self.limit = limit
		self.unresolved_only = unresolved_only
		self.community_id = community_id
		self.auth = auth
	}
}

public struct ListCommentReportsResponse: Codable, Hashable {
	public let comment_reports: [CommentReportView]

	public init(
		comment_reports: [CommentReportView]
	) {
		self.comment_reports = comment_reports
	}
}
