/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct GetSiteMetadata: Request {
	public typealias Response = GetSiteMetadataResponse

	public var path: String { "/post/site_metadata" }
	public var method: RequestMethod { .get }

	public let url: String

	public init(
		url: String
	) {
		self.url = url
	}
}

public struct GetSiteMetadataResponse: Codable, Hashable {
	public let metadata: SiteMetadata

	public init(
		metadata: SiteMetadata
	) {
		self.metadata = metadata
	}
}
