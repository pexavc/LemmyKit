/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct CommentView: Codable, Hashable {
	public var comment: Comment
	public var creator: Person
	public var post: Post
	public let community: Community
	public let counts: CommentAggregates
	public let creator_banned_from_community: Bool
	public let subscribed: SubscribedType
	public let saved: Bool
	public let creator_blocked: Bool
	public let my_vote: Int?

	public init(
		comment: Comment,
		creator: Person,
		post: Post,
		community: Community,
		counts: CommentAggregates,
		creator_banned_from_community: Bool,
		subscribed: SubscribedType,
		saved: Bool,
		creator_blocked: Bool,
		my_vote: Int? = nil
	) {
		self.comment = comment
		self.creator = creator
		self.post = post
		self.community = community
		self.counts = counts
		self.creator_banned_from_community = creator_banned_from_community
		self.subscribed = subscribed
		self.saved = saved
		self.creator_blocked = creator_blocked
		self.my_vote = my_vote
	}
    
    mutating func update(location: FetchType) {
        post.location = location
        creator.location = location
        comment.location = location
    }
}
