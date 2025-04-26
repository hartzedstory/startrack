//
//  FusionNetwork.swift
//  StartTrack
//
//  Created by HartzedStory on 4/25/25.
//

import Foundation
import Alamofire

class FusionNetwork {
    public static func login() {
        AF.request("http://localhost:8080/oauth2/authorization/google", method: .get)
            .validate()
            .response { response in
                switch response.result {
                case .success(let res):
                    print(res)
                case .failure(let e):
                    print(e)
                }
            }
    }
}
