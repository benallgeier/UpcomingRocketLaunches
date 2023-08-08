//
//  UpcomingRocketLaunchesViewModel.swift
//  UpcomingRocketLaunches
//
//  Created by Benjamin Allgeier on 8/6/23.
//

import Combine
import Foundation

class UpcomingRocketLaunchesViewModel: ObservableObject {
    enum State {
        case idle
        case loading
        case failed(Error)
        case loaded(ListResponse)
    }
    
    @Published private(set) var state = State.idle
    
    private var rocketLaunchesCancellable: AnyCancellable?
    private let rocketLaunchClient: RocketLaunchClient
    
    init(rocketLaunchClient: RocketLaunchClient) {
        self.rocketLaunchClient = rocketLaunchClient
    }
    
    func refreshRocketLaunches(for info: RocketLaunchClient.Filter?) {
        self.state = .loading
        self.rocketLaunchesCancellable = rocketLaunchClient.launches(info)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.state = .failed(error)
                    }
                },
                receiveValue: { [weak self] response in
                    self?.state = .loaded(response)
                    print("received \(response.results.count) results")
                }
            )
    }
}
