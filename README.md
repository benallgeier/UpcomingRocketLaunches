# UpcomingRocketLaunches
Upon launch of the app, the spacedevs API (https://ll.thespacedevs.com/2.2.0/launch/upcoming/) is used to fetch up to 25 of the most recent rocket launches. Each item shows the launch name, location, an image if available, and the window start time. Each item can be tapped to go to a detail screen which adds the mission and pad information.

There are four segments at the top and a filter search bar that the user can use to fetch a different batch of launches based on the criteria they enter. To kick off the filter, select a tab other than `None`, type a string in the search bar, and then hit enter. Note that `LSP` stands for `launch service provider`. Rocket searches are based on the rocket configuration that is available in the API. The location filter is the most interesting. It uses the `location` API to fetch locationIDs matching the query and then fetches launches matching the locationIDs.

The user will see a spinner while the service calls are in flight and then see the launches or an error message. The SwiftUI preview shows 3 mock launches so you can see the UI without building.

To see more documentation for the spacedevs API, see https://ll.thespacedevs.com/docs/
