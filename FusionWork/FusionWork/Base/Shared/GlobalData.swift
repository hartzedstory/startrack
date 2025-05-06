//
//  GlobalData.swift
//  FusionWork
//
//  Created by HartzedStory on 4/27/25.
//

import Foundation
class GlobalData: NSObject {
    static let sharedInstance = GlobalData()
    var user = UserModel()
    var access_token = ""
}
