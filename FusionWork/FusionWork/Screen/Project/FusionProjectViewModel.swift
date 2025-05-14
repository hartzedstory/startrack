//
//  FusionProjectViewModel.swift
//  FusionWork
//
//  Created by HartzedStory on 5/13/25.
//

import Foundation
import UIKit

class FusionProjectViewModel: NSObject {
    var organizations: [OrganizationModel] = []
    var selectedOrganization: OrganizationModel?
    var projects: [ProjectModel] = []
    internal func getOrganization(completion: @escaping(() -> Void)) {
        FusionNetwork.getOrganization { response in
            print("-----------DATA---------")
            self.organizations = response
            completion()
        } onError: { error in
            print(error)
        }
    }
    
    internal func getListProject(completion: @escaping(() -> Void)) {
        let queryModel = ProjectSortingModel()
        queryModel.page = 0
        queryModel.size = 50
        FusionNetwork.getListProject(pageable: queryModel, organizationId: self.selectedOrganization?.id ?? 0) { list in
            self.projects = list
            completion()
        } onError: { error in
            
        }
    }
    
    internal func deleteProject(id:Int, completion: @escaping(() -> Void)) {
        FusionNetwork.deleteProject(id: id) { model in
            
            completion()
        } onError: { error in
    
        }

    }
    
    
}
