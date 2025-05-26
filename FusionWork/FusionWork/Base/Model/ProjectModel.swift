//
//  ProjectModel.swift
//  FusionWork
//
//  Created by HartzedStory on 5/13/25.
//

import Foundation

enum GlobalStatus: String {
    case new = "NEW"
    case inProgress = "IN_PROGRESS"
    case done = "DONE"
}
class ProjectModel: Codable {
    var id: Int?
    var status: String?
    var organization: String?
    var startDate: String?
    var endDate: String?
    var priority: String?
    var taskInfos: [ProjectTaskInfoModel]?
    var name: String?
    
}

class ProjectTaskInfoModel: Codable {
    var status: String?
    var member: ProjectTaskInfoMembersModel?
    var taskName: String?
    var taskId: Int?
    var userInfos: [ProjectTaskInfoUsersModel]?
}

class ProjectTaskInfoMembersModel: Codable {
    var views: [Int]?
}

class ProjectTaskInfoUsersModel: Codable {
    var id: Int?
    var name: String?
    var avatarUrl: String?
}


class ProjectInitializeModel: Codable {
    var name: String?
    var title: String?
    var startDate: String?
    var endDate: String?
    var members: [Int]?
    var priority: String?
    var description: String?
    var organizationId: Int?
}

class SortingModel: Codable{
    init(page: Int? = nil, size: Int? = nil, sort: [String]? = nil) {
        self.page = page
        self.size = size
        self.sort = sort
    }
    
    var page: Int?
    var size: Int?
    var sort: [String]?
}
