//
//  ContentView.swift
//  ChaseInterview
//
//  Created by Benjamin Allgeier on 8/5/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: UpcomingRocketLaunchesViewModel
    
    
    enum FilterOption: String, CaseIterable, Identifiable {
        var id: Self { self }
        
        case none = "None"
        case rocket = "Rocket"
        case lsp = "LSP"
        case location = "Location"
    }
    
    @State private var filterOption = FilterOption.none
    
    @State private var filterString = ""

    var body: some View {
        NavigationStack {
            VStack {
                Picker("Choose a filter", selection: $filterOption) {
                    ForEach(FilterOption.allCases) { filter in
                        Text("\(filter.rawValue)").tag(filter)
                    }
                }
                .pickerStyle(.segmented)
                
                List(viewModel.response.results) { result in
                    NavigationLink(value: result, label: {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(result.name)
                                .font(.title)
                            Text(result.location)
                                .font(.title2)
                                .foregroundColor(Color.blue)
                            Text(result.lspName)
                                .foregroundColor(Color.green)
                            
                            asyncImage(for: result.image)
                            
                            Text(result.windowStartFormatted)
                                .bold()
                                .foregroundColor(Color.red)
                        }
                    })
                }
                .listStyle(.plain)
                .navigationDestination(for: ListResponse.Result.self) { result in
                    Text(result.name)
                }
            }
            .navigationTitle("Rocket Launches")
            .searchable(text: $filterString, prompt: "Filter")
            .onSubmit(of: .search) {
                print("Ben: Submitted")
//                viewModel.fetch(with: filterOption, query: filterString)
            }
        }
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
