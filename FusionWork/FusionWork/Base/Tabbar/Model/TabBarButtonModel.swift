//
//  TabBarButtonModel.swift
// CustomTabBar
//

//

import UIKit

struct TabBarButtonModel {
    let title: String
    let image: UIImage?
}


enum TabBarButton: Int, CaseIterable {
    case task
    case project
    case organization
    
    var title: String {
        switch self {
        case .task: return "Task"
        case .project: return "Project"
        case .organization: return "Organization"
        }
    }
    
    var normalImage: UIImage? {
        switch self {
        case .task: return UIImage(named: "ic_tabbar_task")
        case .project: return UIImage(named: "ic_tabbar_project")
        case .organization: return UIImage(named: "ic_tabbar_org")
        }
    }
    
    var highlightImage: UIImage? {
        switch self {
        case .task: return UIImage(named: "ic_tabbar_task_highlighted")
        case .project: return UIImage(named: "ic_tabbar_project_highlighted")
        case .organization: return UIImage(named: "ic_tabbar_org_highlighted")
        }
    }
    
}
