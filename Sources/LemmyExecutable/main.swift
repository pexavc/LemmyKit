//
//  main.swift
//  
//
//  Created by PEXAVC on 7/11/23.
//

import Foundation
import LemmyKit

let baseUrl: String = "https://neatia.xyz/api/"+LemmyKit.VERSION

let lemmy = Lemmy(apiUrl: baseUrl)

let info = await lemmy.request(
    Login(username_or_email: "pexavc",
          password: "...")
)

print(info)

let data = await lemmy.request(
    GetSite(auth: info?.jwt)
)

print(data?.site_view.site.name)
