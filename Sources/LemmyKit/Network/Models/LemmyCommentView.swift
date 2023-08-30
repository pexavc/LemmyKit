/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct LemmyCommentView: Codable, Hashable {
	public var comment: LemmyComment
	public var creator: LemmyPerson
	public var post: LemmyPost
	public var community: LemmyCommunity
	public let counts: CommentAggregates
	public let creator_banned_from_community: Bool
	public let subscribed: SubscribedType
	public let saved: Bool
	public let creator_blocked: Bool
	public let my_vote: Int?

	public init(
		comment: LemmyComment,
		creator: LemmyPerson,
		post: LemmyPost,
		community: LemmyCommunity,
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
        switch location {
        case .peer(let host):
            community.location = .peer(host)
            community.ap_id = host
        default:
            community.location = location
            community.ap_id = creator.actor_id
        }
    }
}
