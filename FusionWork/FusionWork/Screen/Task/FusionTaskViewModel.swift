//
//  FusionTaskViewModel.swift
//  FusionWork
//
//  Created by Hartzed Story on 23/5/25.
//

import Foundation

class FusionTaskViewModel: NSObject {
    var listTask: [TaskModel] = []
    func getTask(sorting: SortingModel, start: String? = nil, end: String? = nil, completion: @escaping(() -> Void)) {
        FusionNetwork.getTask(pageable: sorting, start: start, end: end) { tasks in
            self.listTask.removeAll()
            self.listTask = tasks
            completion()
        } onError: { error in
            
        }
    }
    
    func getNotification(isRead: Bool, completion: @escaping(() -> Void)) {

    }
}
