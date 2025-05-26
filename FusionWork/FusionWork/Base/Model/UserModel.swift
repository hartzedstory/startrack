//
//  UserModel.swift
//  FusionWork
//
//  Created by HartzedStory on 4/27/25.
//

import Foundation
import SwiftJWT

class UserClaimModel: NSObject, Codable, Claims {
    var sub: String?
    var iat: Int?
    var exp: Int?
    var accessUser: UserModel?
}

class UserModel: NSObject, Codable {
    var userId: Int?
    var email: String?
    var name: String?
    var avatarUrl: String?
    var phone: String?
}
