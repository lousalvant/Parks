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
    @State private var searchText: String = "" // For search bar

    let states = [
        "AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "FL", "GA", "HI", "ID", "IL", "IN", "IA",
        "KS", "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ",
        "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC", "SD", "TN", "TX", "UT", "VT",
        "VA", "WA", "WV", "WI", "WY", "DC", "GU", "MP", "PR", "VI"
    ]

    // Enum for sorting order
    enum SortOrder: String, CaseIterable {
        case ascending = "Ascending"
        case descending = "Descending"
    }

    // Computed property to handle both sorting and searching
    var filteredParks: [Park] {
        var result = parks

        // Filter parks by search text
        if !searchText.isEmpty {
            result = result.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }

        // Sort the parks based on sortOrder
        switch sortOrder {
        case .ascending:
            return result.sorted { $0.name < $1.name }
        case .descending:
            return result.sorted { $0.name > $1.name }
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
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            // Search Bar
            TextField("Search for a park", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            // Parks List with Navigation
            NavigationStack {
                ScrollView {
                    LazyVStack {
                        ForEach(filteredParks) { park in
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
            Spacer() // This pushes everything above upwards, allowing space for your name and Z number at the bottom

                // Name and Z Number at the bottom of the screen
                Text("Lou Salvant Z23637852")
                            .font(.headline)
                            .padding(.bottom)
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
