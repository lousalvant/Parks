//
//  ParkDetailView.swift
//  Parks
//
//  Created by Lou-Michael Salvant on 10/12/24.
//

import SwiftUI

struct ParkDetailView: View {
    
    let park: Park // <-- park property to allow for passing in a park when the detail is presented

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) { // Aligns vertical views to the leading edge with 16pt spacing between views
                Text(park.fullName)
                    .font(.largeTitle)
                Text(park.description)
            }
            .padding()

            // TODO: Add horizontal scrolling images

        }
    }
}

#Preview {
    ParkDetailView(park: Park.mocked)
} 
