/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct GetModlog: Request {
	public typealias Response = GetModlogResponse

	public var path: String { "/modlog" }
	public var method: RequestMethod { .get }

	public let mod_person_id: PersonId?
	public let community_id: CommunityId?
	public let page: Int?
	public let limit: Int?
	public let type_: ModlogActionType?
	public let other_person_id: PersonId?
	public let auth: String?

	public init(
		mod_person_id: PersonId? = nil,
		community_id: CommunityId? = nil,
		page: Int? = nil,
		limit: Int? = nil,
		type_: ModlogActionType? = nil,
		other_person_id: PersonId? = nil,
		auth: String? = nil
	) {
		self.mod_person_id = mod_person_id
		self.community_id = community_id
		self.page = page
		self.limit = limit
		self.type_ = type_
		self.other_person_id = other_person_id
		self.auth = auth
	}
}

public struct GetModlogResponse: Codable, Hashable {
	public let removed_posts: [ModRemovePostView]
	public let locked_posts: [ModLockPostView]
	public let featured_posts: [ModFeaturePostView]
	public let removed_comments: [ModRemoveCommentView]
	public let removed_communities: [ModRemoveCommunityView]
	public let banned_from_community: [ModBanFromCommunityView]
	public let banned: [ModBanView]
	public let added_to_community: [ModAddCommunityView]
	public let transferred_to_community: [ModTransferCommunityView]
	public let added: [ModAddView]
	public let admin_purged_persons: [AdminPurgePersonView]
	public let admin_purged_communities: [AdminPurgeCommunityView]
	public let admin_purged_posts: [AdminPurgePostView]
	public let admin_purged_comments: [AdminPurgeCommentView]
	public let hidden_communities: [ModHideCommunityView]

	public init(
		removed_posts: [ModRemovePostView],
		locked_posts: [ModLockPostView],
		featured_posts: [ModFeaturePostView],
		removed_comments: [ModRemoveCommentView],
		removed_communities: [ModRemoveCommunityView],
		banned_from_community: [ModBanFromCommunityView],
		banned: [ModBanView],
		added_to_community: [ModAddCommunityView],
		transferred_to_community: [ModTransferCommunityView],
		added: [ModAddView],
		admin_purged_persons: [AdminPurgePersonView],
		admin_purged_communities: [AdminPurgeCommunityView],
		admin_purged_posts: [AdminPurgePostView],
		admin_purged_comments: [AdminPurgeCommentView],
		hidden_communities: [ModHideCommunityView]
	) {
		self.removed_posts = removed_posts
		self.locked_posts = locked_posts
		self.featured_posts = featured_posts
		self.removed_comments = removed_comments
		self.removed_communities = removed_communities
		self.banned_from_community = banned_from_community
		self.banned = banned
		self.added_to_community = added_to_community
		self.transferred_to_community = transferred_to_community
		self.added = added
		self.admin_purged_persons = admin_purged_persons
		self.admin_purged_communities = admin_purged_communities
		self.admin_purged_posts = admin_purged_posts
		self.admin_purged_comments = admin_purged_comments
		self.hidden_communities = hidden_communities
	}
}
