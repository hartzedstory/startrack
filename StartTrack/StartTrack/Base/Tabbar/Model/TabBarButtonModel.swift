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
        case .task: return UIImage(systemName: "")
        case .project: return UIImage(systemName: "")
        case .organization: return UIImage(systemName: "")
        }
    }
    
    var highlightImage: UIImage? {
        switch self {
        case .task: return UIImage(systemName: "")
        case .project: return UIImage(systemName: "")
        case .organization: return UIImage(systemName: "")
        }
    }
    
}
