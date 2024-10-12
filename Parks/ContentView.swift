//
//  ContentView.swift
//  Parks
//
//  Created by Lou-Michael Salvant on 10/12/24.
//

import SwiftUI

struct ContentView: View {
    @State private var parks: [Park] = []

    var body: some View {
            VStack {
                ScrollView {
                    LazyVStack {
                        ForEach(parks) { park in
                            ParkRow(park: park)
                        }
                    }
                }
            }
            .padding()
            .onAppear(perform: {
                Task {
                    await fetchParks()
                }
            })
        }

    private func fetchParks() async {
        // URL for the API endpoint
        // 👋👋👋 Make sure to replace {YOUR_API_KEY} in the URL with your actual NPS API Key
        let url = URL(string: "https://developer.nps.gov/api/v1/parks?stateCode=ca&api_key=bR7zIpJn8cfXHzsMKIEcnxn0Q1RxdGtlU3PK52q4")!
        do {

            // Perform an asynchronous data request
            let (data, _) = try await URLSession.shared.data(from: url)

            // Decode json data into ParksResponse type
            let parksResponse = try JSONDecoder().decode(ParksResponse.self, from: data)

            // Get the array of parks from the response
            let parks = parksResponse.data

            // Print the full name of each park in the array
            for park in parks {
                print(park.fullName)
            }

            // Set the parks state property
            self.parks = parks

        } catch {
            print(error.localizedDescription)
        }
    }
}

#Preview {
    ContentView()
}
