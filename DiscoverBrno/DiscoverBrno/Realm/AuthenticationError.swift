//
//  AuthenticationError.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 11.01.2023.
//

import Foundation

enum AuthenticationError: Error{
    case loginFailed
    case registrationFailed
    case logoutFailed
}
