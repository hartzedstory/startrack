//
//  TaskModel.swift
//  FusionWork
//
//  Created by HartzedStory on 5/14/25.
//

import Foundation

class TaskModel: Codable {
    
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
