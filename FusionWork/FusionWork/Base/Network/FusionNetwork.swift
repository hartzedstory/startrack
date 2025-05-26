//
//  FusionNetwork.swift
//  FusionWork
//
//  Created by HartzedStory on 4/25/25.
//

import Foundation
import Alamofire
class ResponseModel<T: Decodable>: Decodable {
    let message: String
    let data: T
    let code: String
}
class FusionNetwork {
    static var shareInstance = FusionNetwork()
    static var rootURL = "https://api.imagination.vn"
    
    
    ///1: Create organization
    public static func createOrganization(orgModel: OrganizationInitializeModel,onSucces: @escaping((String) -> Void), onError: @escaping((String) -> Void)) {
        let path = "/v1/organization"
        let header: HTTPHeaders = ["Authorization":"Bearer \(GlobalData.sharedInstance.access_token)"]
        let method: HTTPMethod = .post

        FusionLoading.show()
        
        AF.request("\(self.rootURL)\(path)",
                   method: method,
                   parameters: orgModel,
                   encoder: JSONParameterEncoder.default,
                   headers: header)
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
    
    ///2: Get organization
    public static func getOrganization(onSucces: @escaping(([OrganizationModel]) -> Void), onError: @escaping((String) -> Void)) {
        let path = "/v1/organization"
        let header: HTTPHeaders = ["Authorization":"Bearer \(GlobalData.sharedInstance.access_token)"]
        let method: HTTPMethod = .get
        FusionLoading.show()

        AF.request(
            "\(self.rootURL)\(path)",
            method: method,
            headers: header
        )
        .validate()
        .responseDecodable(of: ResponseModel<[OrganizationModel]>.self) { response in
            FusionLoading.hide()
            switch response.result {
            case .success(let result):
                onSucces(result.data)
            case .failure(let error):
                onError(error.localizedDescription)
            }
        }
    }
    
    ///3: Get organization detail
    public static func getOrganizationDetail(id:Int, onSucces: @escaping((OrganizationDetailModel) -> Void), onError: @escaping((String) -> Void)) {
        let path = "/v1/organization/\(id)"
        let header: HTTPHeaders = ["Authorization":"Bearer \(GlobalData.sharedInstance.access_token)"]
        let method: HTTPMethod = .get
        FusionLoading.show()

        AF.request(
            "\(self.rootURL)\(path)",
            method: method,
            headers: header
        )
        .validate()
        .responseDecodable(of: ResponseModel<OrganizationDetailModel>.self) { response in
            FusionLoading.hide()
            switch response.result {
            case .success(let result):
                onSucces(result.data)
            case .failure(let error):
                onError(error.localizedDescription)
            }
        }
    }
    
    ///4: Get organization report
    public static func getOrganizationReport(id:Int, onSucces: @escaping((OrganizationReportModel) -> Void), onError: @escaping((String) -> Void)) {
        let path = "/v1/organization/report"
        let header: HTTPHeaders = ["Authorization":"Bearer \(GlobalData.sharedInstance.access_token)"]
        let param: Parameters = ["organizationId":id, "isDone": true]
        let method: HTTPMethod = .get
        FusionLoading.show()

        AF.request(
            "\(self.rootURL)\(path)",
            method: method,
            parameters: param,
            headers: header
        )
        .validate()
        .responseDecodable(of: ResponseModel<OrganizationReportModel>.self) { response in
            FusionLoading.hide()
            switch response.result {
            case .success(let result):
                onSucces(result.data)
            case .failure(let error):
                onError(error.localizedDescription)
            }
        }
    }
    
    ///5: Create project
    public static func createProject(projModel: ProjectInitializeModel,onSucces: @escaping((String) -> Void), onError: @escaping((String) -> Void)) {
        let path = "/v1/project"
        let header: HTTPHeaders = ["Authorization":"Bearer \(GlobalData.sharedInstance.access_token)"]
        let method: HTTPMethod = .post

        FusionLoading.show()
        
        AF.request("\(self.rootURL)\(path)", method: method, parameters: projModel, encoder: JSONParameterEncoder.default, headers: header)
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
    
    ///6: Get user by organization id
    public static func getUserByOrganization(email: String, organizationId: Int, onSucces: @escaping((MemberModel) -> Void), onError: @escaping((String) -> Void)) {
        let path = "/v1/user/organization"
        let header: HTTPHeaders = ["Authorization":"Bearer \(GlobalData.sharedInstance.access_token)"]
        let params: Parameters = ["query":email, "organizationId": organizationId]
        let method: HTTPMethod = .get
        FusionLoading.show()

        AF.request(
            "\(self.rootURL)\(path)",
            method: method,
            parameters: params,
            headers: header
        )
        .validate()
        .responseDecodable(of: ResponseModel<MemberModel>.self) { response in
            FusionLoading.hide()
            switch response.result {
            case .success(let result):
                onSucces(result.data)
            case .failure(let error):
                onError(error.localizedDescription)
            }
        }
    }
    
    ///7: Get project by organization id
    public static func getListProject(pageable: SortingModel, organizationId: Int, onSucces: @escaping(([ProjectModel]) -> Void), onError: @escaping((String) -> Void)) {
        let path = "/v1/project/view"
        let header: HTTPHeaders = ["Authorization":"Bearer \(GlobalData.sharedInstance.access_token)"]
        let params: Parameters = ["page":pageable.page,
                                  "size": pageable.size,
                                  "organizationId": organizationId]
        let method: HTTPMethod = .get
        FusionLoading.show()

        AF.request(
            "\(self.rootURL)\(path)",
            method: method,
            parameters: params,
            headers: header
        )
        .validate()
        .responseDecodable(of: ResponseModel<[ProjectModel]>.self) { response in
            FusionLoading.hide()
            switch response.result {
            case .success(let result):
                onSucces(result.data)
            case .failure(let error):
                onError(error.localizedDescription)
            }
        }
    }
    
    ///8: Delete project
    public static func deleteProject(id: Int, onSucces: @escaping(([ProjectModel]) -> Void), onError: @escaping((String) -> Void)) {
        let path = "/v1/project/\(id)"
        let header: HTTPHeaders = ["Authorization":"Bearer \(GlobalData.sharedInstance.access_token)"]
        let method: HTTPMethod = .delete
        FusionLoading.show()

        AF.request(
            "\(self.rootURL)\(path)",
            method: method,
            headers: header
        )
        .validate()
        .responseDecodable(of: ResponseModel<[ProjectModel]>.self) { response in
            FusionLoading.hide()
            switch response.result {
            case .success(let result):
                onSucces(result.data)
            case .failure(let error):
                onError(error.localizedDescription)
            }
        }
    }
    
    ///9: Delete project
    public static func updateProject(id: Int, project: ProjectInitializeModel, onSucces: @escaping(([ProjectModel]) -> Void), onError: @escaping((String) -> Void)) {
        let path = "/v1/project/\(id)"
        let header: HTTPHeaders = ["Authorization":"Bearer \(GlobalData.sharedInstance.access_token)"]
        let method: HTTPMethod = .put
        FusionLoading.show()

        AF.request(
            "\(self.rootURL)\(path)",
            method: method,
            parameters: project,
            encoder: JSONParameterEncoder.default,
            headers: header
        )
        .validate()
        .responseDecodable(of: ResponseModel<[ProjectModel]>.self) { response in
            FusionLoading.hide()
            switch response.result {
            case .success(let result):
                onSucces(result.data)
            case .failure(let error):
                onError(error.localizedDescription)
            }
        }
    }
    
    ///10: Create task
    public static func createTask(model: TaskInitializeModel, onSucces: @escaping((String) -> Void), onError: @escaping((String) -> Void)) {
        let path = "/v1/task"
        let header: HTTPHeaders = ["Authorization":"Bearer \(GlobalData.sharedInstance.access_token)"]
        let method: HTTPMethod = .post
        FusionLoading.show()

        AF.request(
            "\(self.rootURL)\(path)",
            method: method,
            parameters: model,
            encoder: JSONParameterEncoder.default,
            headers: header
        )
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
    
    ///11: Get task
    public static func getTask(pageable: SortingModel, start: String? = nil, end: String? = nil,  onSucces: @escaping(([TaskModel]) -> Void), onError: @escaping((String) -> Void)) {
        let path = "/v1/task"
        let header: HTTPHeaders = ["Authorization":"Bearer \(GlobalData.sharedInstance.access_token)"]
        var params: Parameters = ["page":pageable.page,
                                  "size": pageable.size]
        if let _start = start {
            params["start"] = _start
        }
        
        if let _end = end {
            params["end"] = _end
        }
        let method: HTTPMethod = .get
        FusionLoading.show()

        AF.request(
            "\(self.rootURL)\(path)",
            method: method,
            parameters: params,
            headers: header
        )
        .validate()
        .responseDecodable(of: ResponseModel<[TaskModel]>.self) { response in
            FusionLoading.hide()
            switch response.result {
            case .success(let result):
                onSucces(result.data)
            case .failure(let error):
                onError(error.localizedDescription)
            }
        }
    }
    
    ///12: Post DeviceID
    public static func setDeviceID(userID: Int, deviceID: String ,onSucces: @escaping((String) -> Void), onError: @escaping((String) -> Void)) {
        let path = "/v1/user/deviceId"
        let header: HTTPHeaders = ["Authorization":"Bearer \(GlobalData.sharedInstance.access_token)" ]
        let params: Parameters = ["userId":userID, "deviceId": deviceID]
        let method: HTTPMethod = .post

        FusionLoading.show()
        
        AF.request("\(self.rootURL)\(path)",
                   method: method,
                   parameters: params,
                   encoding: JSONEncoding.default,
                   headers: header)
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
    
    ///13: Post Logout
    public static func logout() {
        let path = "/v1/auth/logout"
        let header: HTTPHeaders = ["Authorization":"Bearer \(GlobalData.sharedInstance.access_token)" ]
        let method: HTTPMethod = .post

        FusionLoading.show()
        
        AF.request("\(self.rootURL)\(path)",
                   method: method,
                   encoding: JSONEncoding.default,
                   headers: header)
            .validate()
            .responseString { response in
                FusionLoading.hide()
                switch response.result {
                case .success(let res):
                    print(res)
                case .failure(let e):
                    print(e)
                }
            }
    }
    
    private static func request(path: String, header: HTTPHeaders, parameter: Parameters, method: HTTPMethod, onSucces: @escaping((String) -> Void), onError: @escaping((String) -> Void)) {
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

extension FusionNetwork {
    public static func parse<T: Codable>(_ type: T.Type, from stringData: String) -> T? {
        let decoder = JSONDecoder()
        let jsonData = Data(stringData.utf8)
        var model: T? = nil
        
        do {
            model = try decoder.decode(T.self, from: jsonData)
        } catch {
            print("Parsing error")
        }
        return model
    }
}
