//
//  Live.swift
//  UpcomingRocketLaunches
//
//  Created by Benjamin Allgeier on 8/7/23.
//

import Combine
import Foundation

// TODO: Handle forceunwrapping and sending errors
extension RocketLaunchClient {
    static let live = Self(
        launches: { filter in
            guard let url = url(for: filter) else {
                return Fail(outputType: ListResponse.self, failure: URLError(.badURL))
                    .eraseToAnyPublisher()
            }
            if case .location = filter {
                // 1. Make location service for name__contains to get back location ids
                // 2. Make rocket launch service with location__ids with comma separated values of ids
                return URLSession.shared.dataTaskPublisher(for: url)
                    .map { data, _ in data }
                    .decode(type: LocationResponse.self, decoder: JSONDecoder())
                    .flatMap({ locationResponse in
                        let ids = locationResponse.results.map { $0.id }
                        let query = ids.map{String($0)}.joined(separator: ",")
                        guard let url = rocketLaunchUrl(query: .locationIDs(query: query)) else {
                            return Fail(outputType: ListResponse.self, failure: URLError(.badURL))
                                .mapError({ (error: URLError) -> Error in
                                    return error
                                })
                                .eraseToAnyPublisher()
                        }
                        return URLSession.shared.dataTaskPublisher(for: url)
                            .map { data, _ in data }
                            .decode(type: ListResponse.self, decoder: JSONDecoder())
                            .map(Self.sort(listResponse:))
                            .receive(on: DispatchQueue.main)
                            .eraseToAnyPublisher()
                    })
                    .eraseToAnyPublisher()
            } else {
                return URLSession.shared.dataTaskPublisher(for: url)
                    .map { data, _ in data }
                    .decode(type: ListResponse.self, decoder: JSONDecoder())
                    .map(Self.sort(listResponse:))
                    .receive(on: DispatchQueue.main)
                    .eraseToAnyPublisher()
            }
        }
    )
}

// MARK: - API Helpers

// TODO: Handle errors and reduce force unwrapping
extension RocketLaunchClient {
    // These are for filtering rocket launches
    enum Query {
        case rocket(query: String)
        case lsp(query: String)
        case locationIDs(query: String)
        
        var queryItem: URLQueryItem {
            switch self {
            case let .rocket(query):
                return getRocketQueryItem(value: query)
            case let .lsp(query):
                return getLSPQueryItem(value: query)
            case let .locationIDs(query):
                return getLocationIDsQueryItem(value: query)
            }
        }
    }

    // MARK: - URLs
    
    // Returns either a url for rocket launches or for locations
    static func url(for filter: Filter?) -> URL? {
        switch filter {
        case let .rocket(query):
            return rocketLaunchUrl(query: .rocket(query: query))
        case let .lsp(query):
            return rocketLaunchUrl(query: .lsp(query: query))
        case .none:
            return rocketLaunchUrl(query: nil)
        case let .location(query):
            return locationUrl(query: query)
        }
    }

    // Use ll or lldev
    static let baseUrl = URL(string: "https://lldev.thespacedevs.com/2.2.0/")
    
    static func rocketLaunchUrl(query: Query?) -> URL? {
        guard let baseUrl = baseUrl,
              let launchUrl = URL(string: "launch/upcoming", relativeTo: baseUrl),
              var components = URLComponents(url: launchUrl, resolvingAgainstBaseURL: true)
        else { return nil }
        components.queryItems = [
            modeQueryItem, limitQueryItem
        ]
        
        // Add additional queryItems
        if let query {
            components.queryItems?.append(query.queryItem)
        }
        return components.url
    }
    
    static func locationUrl(query value: String) -> URL? {
        guard let baseUrl = baseUrl,
              let locationUrl = URL(string: "location", relativeTo: baseUrl),
              var components = URLComponents(url: locationUrl, resolvingAgainstBaseURL: true)
        else { return nil }
        components.queryItems = [
            getLocationNameContainsQueryItem(value: value),
        ]
        return components.url
    }
    
    // MARK: - Static Queries
    
    static let modeQueryItem = URLQueryItem(name: "mode", value: "list")
    static let limitQueryItem = URLQueryItem(name: "limit", value: "25")
    // Ordering with `window_start` did not seem to work. So maybe could use `net` which does work with sorting. Note the values for `net` and `window_start` are sometimes the same and sometimes not the same. And not sure what net means
    static let orderingQueryItem = URLQueryItem(name: "ordering", value: "net")
    
    // To handle this, we will sort the array we get
    static func sort(listResponse: ListResponse) -> ListResponse {
        var results = listResponse.results
        results.sort(by: { lResult, rResult in
            guard let lDate = lResult.windowStartDate,
                  let rDate = rResult.windowStartDate
            else { return true }
            return lDate.compare(rDate) == .orderedAscending
        })
        return ListResponse(next: listResponse.next, results: results)
    }
    
    // MARK: - Dynamic Queries
    
    static func getLSPQueryItem(value: String) -> URLQueryItem {
        URLQueryItem(name: "lsp__name", value: value)
    }
    
    // For rocket: could not get any return values for rocket__spacecraftflight__spacecraft__name
    // So using rocket configuration instead
    static func getRocketQueryItem(value: String) -> URLQueryItem {
        URLQueryItem(name: "rocket__configuration__full_name__icontains", value: value)
    }
//    static let rocketConfigurationFullNameQueryItem = URLQueryItem(name: "rocket__configuration__full_name__icontains", value: "Space")
    
    // Separate the ids by commas
    static func getLocationIDsQueryItem(value: String) -> URLQueryItem {
        URLQueryItem(name: "location__ids", value: value)
    }
    
    // MARK: - Location API Helpers
    
    static func getLocationNameContainsQueryItem(value: String) -> URLQueryItem {
        URLQueryItem(name: "name__contains", value: value)
    }
    
    struct LocationResponse: Decodable {
      struct Result: Decodable {
        var id: Int
      }
      
      var results: [Result]
    }
}

// Some values that might return results
// lsp__name: "Russian"
// location__ids: "12, 27
