//
//  OrganizationModel.swift
//  FusionWork
//
//  Created by HartzedStory on 5/11/25.
//

import Foundation
class OrganizationModel: NSObject, Codable {
    var id: Int?
    var name: String?
}

class OrganizationInitializeModel: NSObject, Codable {
    var name: String?
    var owner: String?
    var userId: [Int]?
    var tasks: [String]?
}

class OrganizationDetailModelInfo: NSObject, Codable {
    var id: Int?
    var owner: String?
    var members: [MemberModel]?
}

class MemberModel: NSObject, Codable {
    var id: Int?
    var name: String?
    var email: String?
}
