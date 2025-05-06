//
//  FusionNetwork.swift
//  StartTrack
//
//  Created by HartzedStory on 4/25/25.
//

import Foundation
import Alamofire

class FusionNetwork {
    static var shareInstance = FusionNetwork()
    var rootURL = "https://f002-1-52-109-127.ngrok-free.app"
    public static func getTask() {
        

    }
    
    private func request(path: String, header: HTTPHeaders, parameter: Parameters, method: HTTPMethod, onSucces: @escaping((String) -> Void), onError: @escaping((String) -> Void)) {
        FusionLoading.show()
        AF.request("\(self.rootURL)\(path)", method: method, parameters: parameter, headers: header)
            .validate()
            .responseString { response in
                FusionLoading.hide()
                switch response.result {
                case .success(let res):
                    onSucces(res)
                case .failure(let e):
                    onError(e.localizedDescription)
                }
            }
    }
}
