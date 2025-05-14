//
//  ProjectModel.swift
//  FusionWork
//
//  Created by HartzedStory on 5/13/25.
//

import Foundation

class ProjectModel: Codable {
    var id: Int?
    var status: String?
    var organization: String?
    var startDate: String?
    var endDate: String?
    var priority: String?
    var taskInfos: [Int]?
    var name: String?
    
}

class ProjectInitializeModel: Codable {
    var name: String?
    var title: String?
    var startDate: String?
    var endDate: String?
    var members: [Int]?
    var status: String?
    var priority: String?
    var description: String?
    var organizationId: Int?
}

class ProjectSortingModel: Codable{
    var page: Int?
    var size: Int?
    var sort: [String]?
}
