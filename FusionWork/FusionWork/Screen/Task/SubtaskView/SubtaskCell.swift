//
//  SubtaskCell.swift
//  FusionWork
//
//  Created by HartzedStory on 5/26/25.
//

import UIKit

class SubtaskCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var vPriority: UIView!
    @IBOutlet weak var vMain: UIView!
    @IBOutlet weak var ivCheck: UIImageView!
    var isCheck = false
    var projectTaskModel: ProjectTaskInfoModel?
    var taskModel: TaskModel?
    var status: GlobalStatus = .new
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindingData(task: ProjectTaskInfoModel) {
        let priority = State(rawValue: task.status ?? "")
        let status = GlobalStatus(rawValue: task.status ?? "")
        self.projectTaskModel = task
        if status == .done {
            self.ivCheck.isHighlighted = true
        } else {
            self.ivCheck.isHighlighted = false
        }
        switch priority {
        case .high:
            self.vPriority.backgroundColor = UIColor(hex: "#DD4A01", alpha: 1)
        case .medium:
            self.vPriority.backgroundColor = UIColor(hex: "#FFBB00", alpha: 1)
        case .low:
            self.vPriority.backgroundColor = UIColor(hex: "#03DA5D", alpha: 1)
        case .none, .some(.none):
            break
        }
        self.lblTitle.text = task.taskName
    }
    
    func bindingData(task: TaskModel) {
        let priority = State(rawValue: task.status ?? "")
        let status = GlobalStatus(rawValue: task.status ?? "")
        self.taskModel = task
        if status == .done {
            self.ivCheck.isHighlighted = true
        } else {
            self.ivCheck.isHighlighted = false
        }
        switch priority {
        case .high:
            self.vPriority.backgroundColor = UIColor(hex: "#DD4A01", alpha: 1)
        case .medium:
            self.vPriority.backgroundColor = UIColor(hex: "#FFBB00", alpha: 1)
        case .low:
            self.vPriority.backgroundColor = UIColor(hex: "#03DA5D", alpha: 1)
        case .none, .some(.none):
            break
        }
        self.lblTitle.text = task.taskName
    }
    
    @IBAction func changeStatus(_ sender: Any) {
        self.isCheck = !self.isCheck
        self.ivCheck.isHighlighted = isCheck
        
        if self.isCheck {
            self.status = .done
        } else {
            self.status = .inProgress
        }
        
        if let _taskModel = projectTaskModel {
            FusionNetwork.updateTaskStatus(id: _taskModel.taskId ?? 0, status: status) { model in
            } onError: { error in
            }
        }
        
        if let _subTaskModel = taskModel {
            FusionNetwork.updateSubTaskStatus(id: _subTaskModel.id ?? 0, status: status) { model in
            } onError: { error in
            }
        }
    }
}
