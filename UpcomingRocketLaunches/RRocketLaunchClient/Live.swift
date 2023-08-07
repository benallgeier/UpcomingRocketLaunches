//
//  Live.swift
//  UpcomingRocketLaunches
//
//  Created by Benjamin Allgeier on 8/7/23.
//

import Combine
import Foundation

extension RocketLaunchClient {
    static let live = Self(
        launches: { filterInfo in
            var components = URLComponents(
                // Use ll or lldev
                url: URL(string: "https://lldev.thespacedevs.com/2.2.0/launch/upcoming/")!,
                resolvingAgainstBaseURL: false
            )!
            components.queryItems = [
                modeQueryItem, limitQueryItem, orderingQueryItem
            ]
            
            switch filterInfo.filterType {
            case .rocket:
                components.queryItems?.append(getRocketQueryItem(value: filterInfo.query))
            case .lsp:
                components.queryItems?.append(getLSPQueryItem(value: filterInfo.query))
            case .location:
                break
            case .none:
                break
            }
            
            let url = components.url!
            
            return URLSession.shared.dataTaskPublisher(for: url)
                .map { data, _ in data }
                .decode(type: ListResponse.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
    )
}


extension RocketLaunchClient {
    // Static Queries
    static let modeQueryItem = URLQueryItem(name: "mode", value: "list")
    static let limitQueryItem = URLQueryItem(name: "limit", value: "41")
    // Ordering with `window_start` did not seem to work. So using `net` which does work with sorting. Note the values for `net` and `window_start` are sometimes the same and sometimes not the same.
    static let orderingQueryItem = URLQueryItem(name: "ordering", value: "net")
    
    // Dynamic Queries
    static func getLSPQueryItem(value: String) -> URLQueryItem {
        URLQueryItem(name: "lsp__name", value: value)
    }
    static func getRocketQueryItem(value: String) -> URLQueryItem {
        URLQueryItem(name: "rocket__configuration__full_name__icontains", value: value)
    }
    
    // Temp:
    //  static let lspQueryItem = URLQueryItem(name: "lsp__name", value: "Russian Federal Space Agency (ROSCOSMOS)")
    static let lspQueryItem = URLQueryItem(name: "lsp__name", value: "Russia")
    
    static let locationQueryItem = URLQueryItem(name: "location__ids", value: "12,27")
    
    static let rocketConfigurationFullNameQueryItem = URLQueryItem(name: "rocket__configuration__full_name__icontains", value: "Space")
}
