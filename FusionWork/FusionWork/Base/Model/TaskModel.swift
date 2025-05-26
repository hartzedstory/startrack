//
//  TaskModel.swift
//  FusionWork
//
//  Created by HartzedStory on 5/14/25.
//

import Foundation

class TaskModel: Codable {
    var status: String?
    var endDate: String?
    var startDate: String?
    var organization: String?
    var taskName: String?
    var parentTag: String?
    var subtaskList: [TaskModel]?
}

class TaskInitializeModel: Codable {
    var name: String?
    var projectId: Int?
    var startDate: String?
    var endDate: String?
    var priority: String?
    var subTasks: [SubtaskInitializeModel]?
}

class SubtaskInitializeModel: Codable {
    var name: String?
    var startDate: String?
    var endDate: String?
    var priority: String?
    
}
