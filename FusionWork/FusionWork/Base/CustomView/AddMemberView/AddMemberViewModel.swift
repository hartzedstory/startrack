//
//  AddMemberViewModel.swift
//  FusionWork
//
//  Created by HartzedStory on 5/13/25.
//

import Foundation

class AddMemberViewModel: NSObject {
    var organizationID: Int?
    var inputEmail = ""
    var memberList: [MemberModel] = []
    var memberIDSelected: [Int] = []
    
    func findUser(email: String, onSucces: @escaping(([MemberModel]) -> Void), onError: @escaping((String) -> Void)) {
        FusionNetwork.getUserList(email: email, onSucces: onSucces, onError: onError)
        
    }
}
