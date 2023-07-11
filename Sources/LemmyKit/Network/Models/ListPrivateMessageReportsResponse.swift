/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct ListPrivateMessageReportsResponse: Codable, Hashable {
	public let private_message_reports: [PrivateMessageReportView]

	public init(
		private_message_reports: [PrivateMessageReportView]
	) {
		self.private_message_reports = private_message_reports
	}
}
