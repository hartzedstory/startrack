//
//  AppAttestProviderFactory.swift
//  FusionWork
//
//  Created by HartzedStory on 5/24/25.
//

import Foundation
import FirebaseAppCheck
import Firebase

class AppAttestProviderFactory: NSObject, AppCheckProviderFactory {
    func createProvider(with app: FirebaseApp) -> AppCheckProvider? {
        if #available(iOS 14.0, *) {
            return AppAttestProvider(app: app)
        } else {
            return DeviceCheckProvider(app: app)
        }
    }
}
