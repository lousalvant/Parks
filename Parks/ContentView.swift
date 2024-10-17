//
//  ContentView.swift
//  Parks
//
//  Created by Lou-Michael Salvant on 10/12/24.
//

import SwiftUI

struct ContentView: View {
    @State private var parks: [Park] = []
    @State private var selectedState = "CA" // Default to California
    @State private var sortOrder: SortOrder = .ascending // Default sorting order

    let states = ["CA", "FL", "NY", "WA", "TX", "NV", "AZ", "CO", "OR", "MT"] // List of states

    // Enum for sorting order
    enum SortOrder: String, CaseIterable {
        case ascending = "Ascending"
        case descending = "Descending"
    }

    var sortedParks: [Park] {
        switch sortOrder {
        case .ascending:
            return parks.sorted { $0.name < $1.name }
        case .descending:
            return parks.sorted { $0.name > $1.name }
        }
    }

    var body: some View {
        VStack {
            // State Picker
            Picker("Select State", selection: $selectedState) {
                ForEach(states, id: \.self) { state in
                    Text(state)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()

            // Sorting Picker
            Picker("Sort by", selection: $sortOrder) {
                ForEach(SortOrder.allCases, id: \.self) { order in
                    Text(order.rawValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle()) // Segmented control for sorting
            .padding()

            // Parks List with Navigation
            NavigationStack {
                ScrollView {
                    LazyVStack {
                        ForEach(sortedParks) { park in
                            NavigationLink(value: park) {
                                ParkRow(park: park)
                            }
                        }
                    }
                }
                .navigationDestination(for: Park.self) { park in
                    ParkDetailView(park: park)
                }
                .navigationTitle("National Parks")
            }
        }
        .padding()
        .onAppear(perform: {
            Task {
                await fetchParks(for: selectedState) // Fetch parks initially for default state
            }
        })
        .onChange(of: selectedState) {
            Task {
                await fetchParks(for: selectedState)
            }
        }
    }

    // Fetch parks from the API based on the selected state
    private func fetchParks(for stateCode: String = "CA") async {
        let apiKey = "bR7zIpJn8cfXHzsMKIEcnxn0Q1RxdGtlU3PK52q4" // Your actual NPS API Key
        let url = URL(string: "https://developer.nps.gov/api/v1/parks?stateCode=\(stateCode)&api_key=\(apiKey)")!
        
        do {
            // Perform an asynchronous data request
            let (data, _) = try await URLSession.shared.data(from: url)

            // Decode json data into ParksResponse type
            let parksResponse = try JSONDecoder().decode(ParksResponse.self, from: data)

            // Set the parks state property
            self.parks = parksResponse.data
        } catch {
            print(error.localizedDescription)
        }
    }
}

#Preview {
    ContentView()
}
