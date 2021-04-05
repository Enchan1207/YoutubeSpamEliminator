//
//  Targets.swift
//
//
//  Created by EnchantCode on 2021/04/05.
//

import Serializable
import Foundation

struct Targets: Serializable {
    let channels: [Target]
}

struct Target: Serializable {
    let id: String
    let name: String
}
