//
//  Client.swift
//  UpcomingRocketLaunches
//
//  Created by Benjamin Allgeier on 8/7/23.
//

import Combine
import Foundation

struct RocketLaunchClient {
    enum Filter {
        case rocket(query: String)
        case lsp(query: String) // lsp is launch service provider
        case location(query: String)
    }

    var launches: (Filter?) -> AnyPublisher<ListResponse, Error>
}
