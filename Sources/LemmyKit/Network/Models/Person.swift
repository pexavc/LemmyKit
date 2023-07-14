/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct Person: Codable, Identifiable, Hashable {
	public let id: PersonId
	public let name: String
	public let display_name: String?
	public let avatar: String?
	public let banned: Bool
	public let published: String
	public let updated: String?
	public let actor_id: String
	public let bio: String?
	public let local: Bool
	public let banner: String?
	public let deleted: Bool
	public let inbox_url: String?
	public let matrix_user_id: String?
	public let admin: Bool
	public let bot_account: Bool
	public let ban_expires: String?
	public let instance_id: InstanceId

	public init(
		id: PersonId,
		name: String,
		display_name: String? = nil,
		avatar: String? = nil,
		banned: Bool,
		published: String,
		updated: String? = nil,
		actor_id: String,
		bio: String? = nil,
		local: Bool,
		banner: String? = nil,
		deleted: Bool,
		inbox_url: String?,
		matrix_user_id: String? = nil,
		admin: Bool,
		bot_account: Bool,
		ban_expires: String? = nil,
		instance_id: InstanceId
	) {
		self.id = id
		self.name = name
		self.display_name = display_name
		self.avatar = avatar
		self.banned = banned
		self.published = published
		self.updated = updated
		self.actor_id = actor_id
		self.bio = bio
		self.local = local
		self.banner = banner
		self.deleted = deleted
		self.inbox_url = inbox_url
		self.matrix_user_id = matrix_user_id
		self.admin = admin
		self.bot_account = bot_account
		self.ban_expires = ban_expires
		self.instance_id = instance_id
	}
}

public extension Person {
    static var mock: Person {
        .init(
            id: 0,
            name: "J. Doe",
            display_name: nil,
            avatar: nil,
            banned: false,
            published: "\(Date())",
            updated: nil,
            actor_id: "",
            bio: "This is a bio",
            local: true,
            banner: nil,
            deleted: false,
            inbox_url: nil,
            matrix_user_id: nil,
            admin: false,
            bot_account: false,
            ban_expires: nil,
            instance_id: 0
        )
    }
}
