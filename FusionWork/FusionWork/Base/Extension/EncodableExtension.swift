//
//  EncodableExtension.swift
//  FusionWork
//
//  Created by HartzedStory on 5/13/25.
//

import Foundation

extension Encodable {
    func toDictionary() -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(self),
              let json = try? JSONSerialization.jsonObject(with: data),
              let dict = json as? [String: Any] else {
            return nil
        }
        return dict
    }
}
