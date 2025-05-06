//
//  JWT.swift
//  FusionWork
//
//  Created by HartzedStory on 4/27/25.
//

import Foundation
import SwiftJWT

class JWTWorker {
    static func pareAccessTokene<T: Claims>(_ access_token: String, toModel model: T.Type) -> T? {
        do {
            let jwt = try JWT<T>(jwtString: access_token)
            return jwt.claims
            
        } catch {
            print("Pare failed")
            return nil
        }
    }
}
