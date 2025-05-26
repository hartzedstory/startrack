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
    }
}
