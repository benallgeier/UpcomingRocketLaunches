//
//  UpcomingRocketLaunchesViewModel.swift
//  UpcomingRocketLaunches
//
//  Created by Benjamin Allgeier on 8/6/23.
//

import Combine
import Foundation

class UpcomingRocketLaunchesViewModel: ObservableObject {
    @Published var response: ListResponse = .empty
    
    private var rocketLaunchesCancellable: AnyCancellable?
    private let rocketLaunchClient: RocketLaunchClient
    
    init(rocketLaunchClient: RocketLaunchClient) {
        self.rocketLaunchClient = rocketLaunchClient
    }
    
    func refreshRocketLaunches(for info: RocketLaunchClient.Filter?) {
        self.rocketLaunchesCancellable = rocketLaunchClient.launches(info)
            .sink(
                receiveCompletion: { completion in print(completion) },
                receiveValue: { [weak self] response in
                    self?.response = response
                    print("Ben: received \(response.results.count) results")
                }
            )
    }
}
