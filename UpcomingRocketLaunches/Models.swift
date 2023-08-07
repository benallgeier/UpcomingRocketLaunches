//
//  Models.swift
//  UpcomingRocketLaunches
//
//  Created by Benjamin Allgeier on 8/6/23.
//

import Foundation

struct ListResponse: Decodable {
    var next: String? // Use for pagination
    var results: [Result]
    
    struct Result: Decodable, Identifiable, Hashable {
        private enum CodingKeys: String, CodingKey {
            case name, image, location
            case windowStart = "window_start"
            case lspName = "lsp_name" // for filtering - remove when done
        }
        
        var name: String
        var image: String?
        var location: String
        var windowStart: String
        var windowStartFormatted: String {
            guard let date = iso8601DateFormatter.date(from: windowStart) else { return "No launch date available" }
            return userVisibleDateFormatter.string(from: date)
        }
        var lspName: String
        
        var id: String { name }
        
        private let iso8601DateFormatter = ISO8601DateFormatter()
        private let userVisibleDateFormatter = {
            let formatter = DateFormatter()
            formatter.locale = Locale.init(identifier: "en_US_POSIX")
            formatter.dateStyle = .full
            formatter.timeStyle = .long
            return formatter
        }()
    }
}

extension ListResponse {
    static var empty: Self {
        Self(results: [])
    }
    
    static var mock: Self {
        Self(
            results: [
                .init(
                    name: "Falcon 9 Block 5 | Starlink Group 6-8",
                    image: "https://spacelaunchnow-prod-east.nyc3.digitaloceanspaces.com/media/launch_images/falcon2520925_image_20230522082133.png",
                    location: "Cape Canaveral, FL, USA",
                    windowStart: "2023-08-07T01:00:00Z",
                    lspName: "SpaceX"
                ),
                .init(
                    name: "Soyuz 2.1b/Fregat-M | Glonass-K2 No. 13",
                    image: "https://spacelaunchnow-prod-east.nyc3.digitaloceanspaces.com/media/launcher_images/soyuz_2.1b2ffr_image_20230802085359.jpg",
                    location: "Plesetsk Cosmodrome, Russian Federation",
                    windowStart: "2023-08-07T12:00:00Z",
                    lspName: "Russian Space Forces"
                ),
                .init(
                    name: "Falcon 9 Block 5 | Starlink Group 6-20",
                    image: "https://spacelaunchnow-prod-east.nyc3.digitaloceanspaces.com/media/launch_images/falcon2520925_image_20230522092711.png",
                    location: "Vandenberg SFB, CA, USA",
                    windowStart: "2023-08-08T03:57:00Z",
                    lspName: "SpaceX"
                )
            ]
        )
    }
}
