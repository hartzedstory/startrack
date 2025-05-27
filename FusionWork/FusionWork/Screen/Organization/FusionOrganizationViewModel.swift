//
//  FusionOrganizationViewModel.swift
//  FusionWork
//
//  Created by HartzedStory on 5/11/25.
//

import Foundation
class FusionOrganizationViewModel: NSObject {
    var organizations: [OrganizationModel] = []
    var filteredOrganizations: [OrganizationModel] = []
    internal func getOrganization(completion: @escaping(() -> Void)) {
        FusionNetwork.getOrganization { response in
            print("-----------DATA---------")
            self.organizations = response
            self.filteredOrganizations = response
            completion()
        } onError: { error in
            print(error)
        }
    }
    
    internal func getOrganizationDetail(id: Int) {
        FusionNetwork.getOrganizationDetail(id: id) { response in
            print("-----------DATA---------")
            
        } onError: { error in
            print(error)
        }
    }
}
