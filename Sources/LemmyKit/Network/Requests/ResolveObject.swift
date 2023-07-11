/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct ResolveObject: Request {
	public typealias Response = ResolveObjectResponse

	public var path: String { "/resolve_object" }
	public var method: RequestMethod { .get }

	public let q: String
	public let auth: String

	public init(
		q: String,
		auth: String
	) {
		self.q = q
		self.auth = auth
	}
}

public struct ResolveObjectResponse: Codable, Hashable {
	public let comment: CommentView?
	public let post: PostView?
	public let community: CommunityView?
	public let person: PersonView?

	public init(
		comment: CommentView? = nil,
		post: PostView? = nil,
		community: CommunityView? = nil,
		person: PersonView? = nil
	) {
		self.comment = comment
		self.post = post
		self.community = community
		self.person = person
	}
}
