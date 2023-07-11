/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct ModRemovePostView: Codable, Hashable {
	public let mod_remove_post: ModRemovePost
	public let moderator: Person?
	public let post: Post
	public let community: Community

	public init(
		mod_remove_post: ModRemovePost,
		moderator: Person? = nil,
		post: Post,
		community: Community
	) {
		self.mod_remove_post = mod_remove_post
		self.moderator = moderator
		self.post = post
		self.community = community
	}
}
