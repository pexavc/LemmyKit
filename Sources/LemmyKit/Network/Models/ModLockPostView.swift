/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct ModLockPostView: Codable, Hashable {
	public let mod_lock_post: ModLockPost
	public let moderator: Person?
	public let post: Post
	public let community: Community

	public init(
		mod_lock_post: ModLockPost,
		moderator: Person? = nil,
		post: Post,
		community: Community
	) {
		self.mod_lock_post = mod_lock_post
		self.moderator = moderator
		self.post = post
		self.community = community
	}
}
