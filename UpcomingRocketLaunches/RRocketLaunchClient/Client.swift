//
//  Client.swift
//  UpcomingRocketLaunches
//
//  Created by Benjamin Allgeier on 8/7/23.
//

import Combine
import Foundation

struct RocketLaunchClient {
    enum FilterType {
        case rocket, lsp, location
    }
    
    struct FilterInfo {
        var filterType: FilterType?
        var query: String
    }
    
    var launches: (FilterInfo) -> AnyPublisher<ListResponse, Error>
}
