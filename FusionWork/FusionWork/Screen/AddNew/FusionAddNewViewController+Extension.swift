//
//  FusionAddNewViewController+Extension.swift
//  StartTrack
//
//  Created by HartzedStory on 3/16/25.
//

import Foundation
import UIKit

extension FusionAddNewViewController {
    func layoutStackView(arrView: [UIView]) {
        arrView.forEach { view in
            self.stackView.addArrangedSubview(view)
        }
        calculateHeight()
    }
    
    private func calculateHeight() {
        var totalHeight = 0
        for view in stackView.arrangedSubviews {
            totalHeight += Int(view.intrinsicContentSize.height)
        }
        
        self.heightContainer.constant = CGFloat(totalHeight)
//        self.heightContainer.isActive = true
    }
    
    func validateField(forKind: AddNewType) -> Bool {
        switch forKind {
        case .project:
            if (self.viewModel.projectName == "") {
                self.showAlert(message: "Project name must not be empty")
                return false
            }
            
            if (self.viewModel.title == "") {
                self.showAlert(message: "Title must not be empty")
                return false
            }
            
            if (self.viewModel.dateStart == "") {
                self.showAlert(message: "Date-start must not be empty")
                return false
            }
            
            if (self.viewModel.dateEnd == "") {
                self.showAlert(message: "Date-end must not be empty")
                return false
            }
            
            if (self.viewModel.priority.rawValue == "") {
                self.showAlert(message: "Please select the priority")
                return false
            }
            
            return true
        case .task:
            if (self.viewModel.taskName == "") {
                self.showAlert(message: "Task name must not be empty")
                return false
            }
            
            if (self.viewModel.tempSelectProject.id == nil) {
                self.showAlert(message: "Title must not be empty")
                return false
            }
            
            if (self.viewModel.dateStart == "") {
                self.showAlert(message: "Date-start must not be empty")
                return false
            }
            
            if (self.viewModel.dateEnd == "") {
                self.showAlert(message: "Date-end must not be empty")
                return false
            }
            
            if (self.viewModel.priority.rawValue == "") {
                self.showAlert(message: "Please select the priority")
                return false
            }
            
            return true
        case .subtask:
            if (self.viewModel.taskName == "") {
                self.showAlert(message: "Sub-task name must not be empty")
                return false
            }
            
            if self.isAddSubtaskInside {
                
            } else {
                if (self.viewModel.tempSelectProject.id == nil) {
                    self.showAlert(message: "Project parent must not be empty")
                    return false
                }
            }
            
            if (self.viewModel.dateStart == "") {
                self.showAlert(message: "Date-start must not be empty")
                return false
            }
            
            if (self.viewModel.dateEnd == "") {
                self.showAlert(message: "Date-end must not be empty")
                return false
            }
            
            if (self.viewModel.priority.rawValue == "") {
                self.showAlert(message: "Please select the priority")
                return false
            }
            
            return true
        case .organization:
            if (self.viewModel.orgName == "") {
                self.showAlert(message: "Organization name must not be empty")
                return false
            }
            
            if (self.viewModel.orgOwner == "") {
                self.showAlert(message: "Owner must not be empty")
                return false
            }
            
            return true
        }
    }
}
