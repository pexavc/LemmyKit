/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation

public struct CaptchaResponse: Codable, Hashable {
	public let png: String
	public let wav: String
	public let uuid: String

	public init(
		png: String,
		wav: String,
		uuid: String
	) {
		self.png = png
		self.wav = wav
		self.uuid = uuid
	}
}
