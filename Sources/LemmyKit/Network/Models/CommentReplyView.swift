/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct CommentReplyView: Codable, Hashable {
	public let comment_reply: CommentReply
	public let comment: Comment
	public let creator: Person
	public let post: Post
	public let community: Community
	public let recipient: Person
	public let counts: CommentAggregates
	public let creator_banned_from_community: Bool
	public let subscribed: SubscribedType
	public let saved: Bool
	public let creator_blocked: Bool
	public let my_vote: Int?

	public init(
		comment_reply: CommentReply,
		comment: Comment,
		creator: Person,
		post: Post,
		community: Community,
		recipient: Person,
		counts: CommentAggregates,
		creator_banned_from_community: Bool,
		subscribed: SubscribedType,
		saved: Bool,
		creator_blocked: Bool,
		my_vote: Int? = nil
	) {
		self.comment_reply = comment_reply
		self.comment = comment
		self.creator = creator
		self.post = post
		self.community = community
		self.recipient = recipient
		self.counts = counts
		self.creator_banned_from_community = creator_banned_from_community
		self.subscribed = subscribed
		self.saved = saved
		self.creator_blocked = creator_blocked
		self.my_vote = my_vote
	}
}
