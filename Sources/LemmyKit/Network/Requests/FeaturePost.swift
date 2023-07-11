/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct FeaturePost: Request {
	public typealias Response = PostResponse

	public var path: String { "/post/feature" }
	public var method: RequestMethod { .post }

	public let post_id: PostId
	public let featured: Bool
	public let feature_type: PostFeatureType
	public let auth: String

	public init(
		post_id: PostId,
		featured: Bool,
		feature_type: PostFeatureType,
		auth: String
	) {
		self.post_id = post_id
		self.featured = featured
		self.feature_type = feature_type
		self.auth = auth
	}
}
