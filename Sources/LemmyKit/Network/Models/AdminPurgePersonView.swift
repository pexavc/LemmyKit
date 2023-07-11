/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct AdminPurgePersonView: Codable, Hashable {
	public let admin_purge_person: AdminPurgePerson
	public let admin: Person?

	public init(
		admin_purge_person: AdminPurgePerson,
		admin: Person? = nil
	) {
		self.admin_purge_person = admin_purge_person
		self.admin = admin
	}
}
