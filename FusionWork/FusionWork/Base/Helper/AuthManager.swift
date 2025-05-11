//
//  AuthManager.swift
//  FusionWork
//
//  Created by HartzedStory on 4/26/25.
//

import Foundation
import AuthenticationServices

class AuthManager: NSObject {
    private var session: ASWebAuthenticationSession?
    
    func startLogin(onSuccess: @escaping((_ access_token: String) -> Void), onError: @escaping((_ error: Error) -> Void)) {
        let authURL = URL(string: "\(FusionNetwork.rootURL)/oauth2/authorization/google")!
        let callbackURLScheme = "fusionwork"
        
        session = ASWebAuthenticationSession(url: authURL, callbackURLScheme: callbackURLScheme) { callbackURL, error in
            if let error = error {
                print("Login error: \(error.localizedDescription)")
                onError(error as Error)
                return
            }
            
            guard let callbackURL = callbackURL else {
                print("No callback URL")
                onError(error! as Error)
                return
            }
            
            // Parse code from callbackURL
            if let access_token = self.getQueryStringParameter(url: callbackURL.absoluteString, param: "access") {
                onSuccess(access_token)
            } else {
                print("No code found in callback URL")
                onError(error! as Error)
            }
        }
        
        session?.presentationContextProvider = self
        session?.start()
    }
    
    private func getQueryStringParameter(url: String, param: String) -> String? {
        guard let url = URLComponents(string: url) else { return nil }
        return url.queryItems?.first(where: { $0.name == param })?.value
    }
}

extension AuthManager: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
            return keyWindow
        }
        // fallback
        return UIApplication.shared.delegate!.window!!
    }
}
