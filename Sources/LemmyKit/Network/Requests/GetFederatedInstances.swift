/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct GetFederatedInstances: Request {
	public typealias Response = GetFederatedInstancesResponse

	public var path: String { "/federated_instances" }
	public var method: RequestMethod { .get }

	public let auth: String?

	public init(
		auth: String? = nil
	) {
		self.auth = auth
	}
}

public struct GetFederatedInstancesResponse: Codable, Hashable {
	public let federated_instances: FederatedInstances?

	public init(
		federated_instances: FederatedInstances? = nil
	) {
		self.federated_instances = federated_instances
	}
}
