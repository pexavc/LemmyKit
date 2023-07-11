/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct GetReportCount: Request {
	public typealias Response = GetReportCountResponse

	public var path: String { "/user/report_count" }
	public var method: RequestMethod { .get }

	public let community_id: CommunityId?
	public let auth: String

	public init(
		community_id: CommunityId? = nil,
		auth: String
	) {
		self.community_id = community_id
		self.auth = auth
	}
}

public struct GetReportCountResponse: Codable, Hashable {
	public let community_id: CommunityId?
	public let comment_reports: Int
	public let post_reports: Int
	public let private_message_reports: Int?

	public init(
		community_id: CommunityId? = nil,
		comment_reports: Int,
		post_reports: Int,
		private_message_reports: Int? = nil
	) {
		self.community_id = community_id
		self.comment_reports = comment_reports
		self.post_reports = post_reports
		self.private_message_reports = private_message_reports
	}
}
