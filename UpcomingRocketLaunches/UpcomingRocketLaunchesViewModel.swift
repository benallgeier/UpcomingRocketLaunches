//
//  UpcomingRocketLaunchesViewModel.swift
//  UpcomingRocketLaunches
//
//  Created by Benjamin Allgeier on 8/6/23.
//

import Combine
import Foundation






class UpcomingRocketLaunchesViewModel: ObservableObject {
    private var rocketLaunchesCancellable: AnyCancellable?
    private let rocketLaunchClient: RocketLaunchClient
    @Published var response: ListResponse = .empty
    
    init(rocketLaunchClient: RocketLaunchClient) {
        self.rocketLaunchClient = rocketLaunchClient
    }
    
    func refreshRocketLaunches(for info: RocketLaunchClient.FilterInfo) {
        self.rocketLaunchesCancellable = rocketLaunchClient.launches(info)
            .sink(
                receiveCompletion: { completion in print(completion) },
                receiveValue: { [weak self] response in
                    self?.response = response
                    print("Ben: received \(response.results.count) results")
                }
            )
    }
    
//    init() {
//        let launchesPublisher: AnyPublisher<ListResponse, Error> = URLSession.shared.dataTaskPublisher(for: Network.url)
//            .map { data, _ in data }
//            .decode(type: ListResponse.self, decoder: JSONDecoder())
//            .receive(on: DispatchQueue.main)
//            .eraseToAnyPublisher()
//
//        launchesCancellable = launchesPublisher.sink(
//            receiveCompletion: { completion in print(completion) },
//            receiveValue: { [weak self] response in
//                self?.response = response
//                print(response)
//            }
//        )
//    }
    
//    private func makeServiceCall() {
//        let launchesPublisher: AnyPublisher<ListResponse, Error> = URLSession.shared.dataTaskPublisher(for: Network.url)
//            .map { data, _ in data }
//            .decode(type: ListResponse.self, decoder: JSONDecoder())
//            .receive(on: DispatchQueue.main)
//            .eraseToAnyPublisher()
//
//        launchesCancellable = launchesPublisher.sink(
//            receiveCompletion: { completion in print(completion) },
//            receiveValue: { [weak self] response in
//                self?.response = response
//                print("Ben: New result with \(response.results.count) results")
//                print(response)
//            }
//        )
//    }
    
    func fetch(with filter: FilterOption, query: String) {
        switch filter {
        case .none, .location: return
        case .rocket:
            Network.addRocketQueryItem(value: query)
        case .lsp:
            Network.addLSPQueryItem(value: query)
        }
        makeServiceCall()
    }
}



class Network {
    static var urlComponents = {
        var components = URLComponents(
            url: URL(string: "https://lldev.thespacedevs.com/2.2.0/launch/upcoming/")!,
            resolvingAgainstBaseURL: false
        )!
        components.queryItems = []
        return components
    }()
    
    static var url: URL {
        urlComponents.queryItems?.append(modeQueryItem)
        urlComponents.queryItems?.append(limitQueryItem)
        urlComponents.queryItems?.append(orderingQueryItem)
        //    urlComponents.queryItems?.append(lspQueryItem)
        //    urlComponents.queryItems?.append(locationQueryItem)
        //    urlComponents.queryItems?.append(rocketConfigurationFullNameQueryItem)
        
        return urlComponents.url!
    }
    
    enum Mode: String {
        case list, normal
    }
    static let modeQueryItem = URLQueryItem(name: "mode", value: Mode.list.rawValue)
    
    static let limitQueryItem = URLQueryItem(name: "limit", value: "41")
    
    // Ok - ordering by window_start does not do anything - in the api docs, it is not mentioned. But net is. So maybe we should be using net???
    static let orderingQueryItem = URLQueryItem(name: "ordering", value: "net")
    
    //  static let lspQueryItem = URLQueryItem(name: "lsp__name", value: "Russian Federal Space Agency (ROSCOSMOS)")
    static let lspQueryItem = URLQueryItem(name: "lsp__name", value: "Russia")
    
    static let locationQueryItem = URLQueryItem(name: "location__ids", value: "12,27")
    
    static let rocketConfigurationFullNameQueryItem = URLQueryItem(name: "rocket__configuration__full_name__icontains", value: "Space")
    
   
}

//name__contains=FL // for the locations api - name contains... (FL)
//rocket__configuration__full_name__icontains
// For rocket: could not get any return values for rocket__spacecraftflight__spacecraft__name
