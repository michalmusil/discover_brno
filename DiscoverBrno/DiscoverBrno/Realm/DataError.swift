//
//  DataError.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 13.01.2023.
//

import Foundation

enum DataError: Error{
    case realmInstanceNil
    case userInstanceNil
    case configurationInstanceNil
    case dataProcessingFailed
}
