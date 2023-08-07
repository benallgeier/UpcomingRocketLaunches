//
//  Mocks.swift
//  UpcomingRocketLaunches
//
//  Created by Benjamin Allgeier on 8/7/23.
//

import Combine
import Foundation

extension RocketLaunchClient {
    static let mock = Self(
        launches: { _ in
            Just(ListResponse.mock)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    )
}
