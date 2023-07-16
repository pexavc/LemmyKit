/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct PostView: Codable, Hashable {
	public var post: Post
	public var creator: Person
	public let community: Community
	public let creator_banned_from_community: Bool
	public let counts: PostAggregates
	public let subscribed: SubscribedType
	public let saved: Bool
	public let read: Bool
	public let creator_blocked: Bool
	public let my_vote: Int?
	public let unread_comments: Int

	public init(
		post: Post,
		creator: Person,
		community: Community,
		creator_banned_from_community: Bool,
		counts: PostAggregates,
		subscribed: SubscribedType,
		saved: Bool,
		read: Bool,
		creator_blocked: Bool,
		my_vote: Int? = nil,
		unread_comments: Int
	) {
		self.post = post
		self.creator = creator
		self.community = community
		self.creator_banned_from_community = creator_banned_from_community
		self.counts = counts
		self.subscribed = subscribed
		self.saved = saved
		self.read = read
		self.creator_blocked = creator_blocked
		self.my_vote = my_vote
		self.unread_comments = unread_comments
	}
    
    mutating func isLocal(_ state: Bool) {
        post.local = state
        creator.local = state
    }
}

public extension PostView {
    static var mock: PostView {
        .init(
            post: .mock,
            creator: .mock,
            community: .mock,
            creator_banned_from_community: false,
            counts: .mock,
            subscribed: .notSubscribed,
            saved: false,
            read: false,
            creator_blocked: false,
            my_vote: 0,
            unread_comments: 0
        )
    }
}
