import Granite
import SwiftUI
import Foundation
import LemmyKit

extension Home: View {
    var site: Site? {
        state.siteView?.site
    }
    
    var title: String {
        site?.name ?? "Could not find lemmy site"
    }
    
    var sidebar: String {
        site?.sidebar ?? ""
    }
    
    public var view: some View {
        VStack {
            Text(title)
                .font(.largeTitle)
            Text(sidebar)
                .font(.headline)
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
