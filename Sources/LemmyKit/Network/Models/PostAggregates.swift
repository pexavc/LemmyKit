/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct PostAggregates: Codable, Identifiable, Hashable {
	public let id: Int
	public let post_id: PostId
	public let comments: Int
	public let score: Int
	public let upvotes: Int
	public let downvotes: Int
	public let published: String
	public let newest_comment_time_necro: String
	public let newest_comment_time: String
	public let featured_community: Bool
	public let featured_local: Bool
	public let hot_rank: Int
	public let hot_rank_active: Int

	public init(
		id: Int,
		post_id: PostId,
		comments: Int,
		score: Int,
		upvotes: Int,
		downvotes: Int,
		published: String,
		newest_comment_time_necro: String,
		newest_comment_time: String,
		featured_community: Bool,
		featured_local: Bool,
		hot_rank: Int,
		hot_rank_active: Int
	) {
		self.id = id
		self.post_id = post_id
		self.comments = comments
		self.score = score
		self.upvotes = upvotes
		self.downvotes = downvotes
		self.published = published
		self.newest_comment_time_necro = newest_comment_time_necro
		self.newest_comment_time = newest_comment_time
		self.featured_community = featured_community
		self.featured_local = featured_local
		self.hot_rank = hot_rank
		self.hot_rank_active = hot_rank_active
	}
}

public extension PostAggregates {
    static var mock: PostAggregates {
        .init(
            id: 0,
            post_id: 12,
            comments: 0,
            score: 12,
            upvotes: 12,
            downvotes: 12,
            published: "\(Date())",
            newest_comment_time_necro: "\(Date())",
            newest_comment_time: "\(Date())",
            featured_community: false,
            featured_local: false,
            hot_rank: 12,
            hot_rank_active: 16
        )
    }
}
