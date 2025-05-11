//
//  FusionAddNewViewModel.swift
//  StartTrack
//
//  Created by HartzedStory on 3/16/25.
//

import Foundation
enum AddInputFieldType: String {
    case projectName = "Tên dự án"
    case title = "Tiêu đề"
    case dateStart = "Từ ngày"
    case dateEnd = "Tới ngày"
    case orgName = "Tên doanh nghiệp"
    case orgOwner = "Chủ doanh nghiệp"
    case none = ""
}
class FusionAddNewViewModel: NSObject {
    var projectName = ""
    var title = ""
    var dateStart = ""
    var dateEnd = ""
    var orgName = ""
    var orgOwner = ""
    var none = ""
    
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
    
    
}
