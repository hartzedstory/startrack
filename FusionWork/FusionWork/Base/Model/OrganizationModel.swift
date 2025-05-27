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

class OrganizationDetailModel: NSObject, Codable {
    var id: Int?
    var owner: String?
    var members: [MemberModel]?
}

class MemberModel: NSObject, Codable {
    var id: Int?
    var name: String?
    var email: String?
}

class OrganizationReportModel: NSObject, Codable {
    var monitor: OrganizationReportMonitorModel?
    var tasks: [OrganizationReportTaskModel]?
}

class OrganizationReportMonitorModel: NSObject, Codable {
    var total: Int?
    var done: Int?
    var notDone: Int?
}

class OrganizationReportTaskModel: NSObject, Codable {
    var id: Int?
    var name: String?
    var permission: OrganizationReportPermissionModel?
}

class OrganizationReportPermissionModel: NSObject, Codable {
    var views: [Int]?
}
