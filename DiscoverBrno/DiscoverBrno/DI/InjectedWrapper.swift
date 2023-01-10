//
//  InjectedWrapper.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 05.01.2023.
//

import Foundation

@propertyWrapper
struct Injected<T> {
    let wrappedValue: T

    init() {
        wrappedValue = DIContainer.shared.resolve()
    }
}
