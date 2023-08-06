//
//  ContentView.swift
//  ChaseInterview
//
//  Created by Benjamin Allgeier on 8/5/23.
//

//# Upcoming Rocket Launches - iOS Application
//
//## PROJECT DESCRIPTION
//You are to create an iOS Application that utilizes the Space Devs API to provide users with information about upcoming Rocket Launches.


//### API Information
//* API Endpoint: https://ll.thespacedevs.com/2.2.0/launch/upcoming/
//* API Documentation: https://ll.thespacedevs.com/docs/
//
//## REQUIREMENTS
//1. The app should have a home screen that displays a list of upcoming launches retrieved from the Launch Library 2 API.
//    - Each list item should show the name, location, launch window start time, and a thumbnail image (if available).
//2. On the home screen launches should be sorted by launch window start time
//3. Tapping on a launch in the list should lead to a detail screen that displays more inofmration about the selected launch
//4. Users should have the ability to filter the launches based on the rocket name, launch service provider, and launch location.
//
//### TECHNICAL REQUIREMENTS
//1. Use Swift as the primary programming language for the app.
//2. Use UIKit or SwiftUI to build the UI for the app.
//3. Extract only the necessary data from the API response.
//4. Apply proper error handling to manage potential API errors and connectivity issues.

//## SUBMISSION
//* Create a public GitHub repository and commit your code regularly during development.
//* Include a README file detailing the steps to run the app and any additional notes or explanations.
//* Submit the link to your GitHub repository and any additional asses(e.g., screenshots, video demo) you would like to share.


import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

