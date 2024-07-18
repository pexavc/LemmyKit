import Foundation

public struct CommentView: Codable, Hashable {
	public var comment: Comment?
	public var creator: Person?
	public var post: Post?
	public var community: Community?
	public let counts: CommentAggregates?
	public let creator_banned_from_community: Bool?
	public let creator_is_moderator: Bool?
	public let creator_is_admin: Bool?
	public let subscribed: SubscribedType?
	public let saved: Bool?
	public let creator_blocked: Bool?
	public let my_vote: Int?

	public init(
		comment: Comment? = nil,
		creator: Person? = nil,
		post: Post? = nil,
		community: Community? = nil,
		counts: CommentAggregates? = nil,
		creator_banned_from_community: Bool? = nil,
		creator_is_moderator: Bool? = nil,
		creator_is_admin: Bool? = nil,
		subscribed: SubscribedType? = nil,
		saved: Bool? = nil,
		creator_blocked: Bool? = nil,
		my_vote: Int? = nil
	) {
		self.comment = comment
		self.creator = creator
		self.post = post
		self.community = community
		self.counts = counts
		self.creator_banned_from_community = creator_banned_from_community
		self.creator_is_moderator = creator_is_moderator
		self.creator_is_admin = creator_is_admin
		self.subscribed = subscribed
		self.saved = saved
		self.creator_blocked = creator_blocked
		self.my_vote = my_vote
	}
    
    mutating func update(location: FetchType) {
            post?.location = location
            creator?.location = location
            comment?.location = location
            switch location {
            case .peer(let host):
                community?.location = .peer(host)
                //community.ap_id = host //TODO: ruh roh
            default:
                community?.location = location
                //community.ap_id = creator.actor_id
            }
        }
}
