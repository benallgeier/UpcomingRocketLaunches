//
//  UpcomingRocketLaunchesApp.swift
//  UpcomingRocketLaunches
//
//  Created by Benjamin Allgeier on 8/5/23.
//

import SwiftUI

@main
struct UpcomingRocketLaunchesApp: App {
    var body: some Scene {
        WindowGroup {
          ContentView(
            viewModel: .init(
              rocketLaunchClient: .live
            )
          )
        }
    }
}
