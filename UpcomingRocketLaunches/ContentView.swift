//
//  ContentView.swift
//  ChaseInterview
//
//  Created by Benjamin Allgeier on 8/5/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: UpcomingRocketLaunchesViewModel
    
    private enum FilterOption: String, CaseIterable, Identifiable {
        case none = "None"
        case rocket = "Rocket"
        case lsp = "LSP"
        case location = "Location"
        
        var id: Self { self }
    }
    
    @State private var filterOption = FilterOption.none
    @State private var filterString = ""
    
    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state {
                case .idle:
                    Color.clear.onAppear {
                        viewModel.refreshRocketLaunches(for: nil)
                    }
                case .loading:
                    ProgressView()
                case .failed(let error):
                    Text("Error occurred: \(error.localizedDescription)")
                case .loaded(let listResponse):
                    loadedView(listResponse: listResponse)
                    .searchable(text: $filterString, prompt: "Filter")
                    .onSubmit(of: .search) {
                        let filterInfo: RocketLaunchClient.Filter?
                        switch filterOption {
                        case .none:
                            filterInfo = nil
                        case .rocket:
                            filterInfo = .rocket(query: filterString)
                        case .lsp:
                            filterInfo = .lsp(query: filterString)
                        case .location:
                            filterInfo = .location(query: filterString)
                        }
                        
                        viewModel.refreshRocketLaunches(for: filterInfo)
                    }

                }
            }
            .navigationTitle("Rocket Launches")
        }
    }
    
    @ViewBuilder func loadedView(listResponse: ListResponse) -> some View {
        VStack {
            Picker("Choose a filter", selection: $filterOption) {
                ForEach(FilterOption.allCases) { filter in
                    Text("\(filter.rawValue)").tag(filter)
                }
            }
            .pickerStyle(.segmented)
            
            List(listResponse.results) { result in
                NavigationLink(value: result, label: {
                    itemView(result: result)
                })
            }
            .listStyle(.plain)
            .navigationDestination(for: ListResponse.Result.self) { result in
                detailView(result: result)
            }
        }
    }
    
    @ViewBuilder func itemView(result: ListResponse.Result) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(result.name)
                .font(.title)
            Text(result.location)
                .font(.title2)
                .foregroundColor(Color.blue)
            
            asyncImage(for: result.image)
            
            Text(result.windowStartFormatted)
                .bold()
                .foregroundColor(Color.red)
        }
    }
    
    @ViewBuilder func detailView(result: ListResponse.Result) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            itemView(result: result)
            Group {
                if let mission = result.mission {
                    Text("Mission: \(mission)")
                }
                if let pad = result.pad {
                    Text("Pad: \(pad)")
                }
            }
            .font(.headline)
        }
        .padding()
    }
    
    @ViewBuilder func asyncImage(for url: String?) -> some View {
        if let urlString = url,
           let url = URL(string: urlString) {
            AsyncImage(
                url: url,
                content: { image in
                    image.resizable().aspectRatio(contentMode: .fit)
                },
                placeholder: { imagePlaceHolder }
            )
        } else {
            imagePlaceHolder
        }
    }
    
    var imagePlaceHolder: some View {
        Color.gray.opacity(0.5)
            .frame(height: 128)
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .overlay {
                Text("No image available")
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            viewModel: .init(
                rocketLaunchClient: .mock
            )
        )
    }
}
