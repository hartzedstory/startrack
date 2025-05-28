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
            self.listTask = tasks.filter({ task in
                task.status == "NEW" || task.status == "IN_PROGRESS"
            })
            completion()
        } onError: { error in
            
        }
    }
    
    func updateTask(id: Int, status: GlobalStatus, completion: @escaping(() -> Void)) {
        FusionNetwork.updateTaskStatus(id: id, status: status) { model in
            completion()
        } onError: { error in
            completion()
        }
    }
}
