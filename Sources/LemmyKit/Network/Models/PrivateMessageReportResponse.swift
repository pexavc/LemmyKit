/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct PrivateMessageReportResponse: Codable, Hashable {
	public let private_message_report_view: PrivateMessageReportView

	public init(
		private_message_report_view: PrivateMessageReportView
	) {
		self.private_message_report_view = private_message_report_view
	}
}
