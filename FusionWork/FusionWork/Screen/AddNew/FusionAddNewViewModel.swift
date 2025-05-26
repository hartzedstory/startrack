//
//  FusionAddNewViewModel.swift
//  StartTrack
//
//  Created by HartzedStory on 3/16/25.
//

import Foundation
enum AddInputFieldType: String {
    case projectName = "Project"
    case taskName = "Task"
    case title = "Title"
    case dateStart = "Start date"
    case dateEnd = "End date"
    case orgName = "Organization"
    case orgOwner = "Owner"
    case inProject = "In project"
    case none = ""
}
class FusionAddNewViewModel: NSObject {
    var projectName = ""
    var title = ""
    var dateStart = ""
    var dateEnd = ""
    var orgName = ""
    var orgOwner = ""
    var taskName = ""
    var none = ""
    
    
    internal var descriptionText = ""
    internal var priority: State = .none
    internal var memberList: [MemberModel] = []
    internal var organizationID: Int?
    var selectedOrganization: OrganizationModel = OrganizationModel()
    var projects: [ProjectModel] = []
    var listSubtask: [SubtaskInitializeModel] = []
    var tempSelectProject: ProjectModel = ProjectModel()
    internal func handleInputData(type: AddInputFieldType, value: String) {
        switch type {
        case .projectName:
            self.projectName = value
        case .title:
            self.title = value
        case .dateStart:
            self.dateStart = value
        case .dateEnd:
            self.dateEnd = value
        case .orgName:
            self.orgName = value
        case .orgOwner:
            self.orgOwner = value
        case .none:
            self.none = value
        case .taskName:
            self.taskName = value
        case .inProject:
            self.projectName = value
        }
    }
    
    internal func createOrganization(model:OrganizationInitializeModel, completion: @escaping(() -> Void)) {
        FusionNetwork.createOrganization(orgModel: model) { response in
            print("-----------DATA---------")
            print(response)
            completion()
        } onError: { error in
            print(error)
        }
    }
    
    internal func createProject(model: ProjectInitializeModel,onSucces: @escaping((String) -> Void), onError: @escaping((String) -> Void)) {
        FusionNetwork.createProject(projModel: model, onSucces: onSucces, onError: onError)
    }
    
    internal func createTask(model: TaskInitializeModel,onSucces: @escaping((String) -> Void), onError: @escaping((String) -> Void)) {
        FusionNetwork.createTask(model: model, onSucces: onSucces, onError: onError)
    }
}
