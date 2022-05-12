//
//  ExtensionHelpers.swift
//  Data
//
//  Created by user on 12/05/22.
//

import Foundation

public extension Data {
    func toModel<T: Decodable>() -> T? {
        return try? JSONDecoder().decode(T.self, from: self)
    }
}
