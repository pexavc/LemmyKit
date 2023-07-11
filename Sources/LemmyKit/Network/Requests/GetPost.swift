/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct GetPost: Request {
	public typealias Response = GetPostResponse

	public var path: String { "/post" }
	public var method: RequestMethod { .get }

	public let id: PostId?
	public let comment_id: CommentId?
	public let auth: String?

	public init(
		id: PostId? = nil,
		comment_id: CommentId? = nil,
		auth: String? = nil
	) {
		self.id = id
		self.comment_id = comment_id
		self.auth = auth
	}
}

public struct GetPostResponse: Codable, Hashable {
	public let post_view: PostView
	public let community_view: CommunityView
	public let moderators: [CommunityModeratorView]
	public let cross_posts: [PostView]

	public init(
		post_view: PostView,
		community_view: CommunityView,
		moderators: [CommunityModeratorView],
		cross_posts: [PostView]
	) {
		self.post_view = post_view
		self.community_view = community_view
		self.moderators = moderators
		self.cross_posts = cross_posts
	}
}
