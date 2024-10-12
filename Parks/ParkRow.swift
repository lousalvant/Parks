//
//  ParkRow.swift
//  Parks
//
//  Created by Lou-Michael Salvant on 10/12/24.
//

import SwiftUI

struct ParkRow: View {
    let park: Park

    var body: some View {
        // Park row
        Rectangle()
            .aspectRatio(4/3, contentMode: .fit)
            .overlay {
                let image = park.images.first
                let urlString = image?.url
                let url = urlString.flatMap { string in
                    URL(string: string)
                }

                // Use AsyncImage to fetch the park image
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color(.systemGray4) // Placeholder while loading
                }
            }
            .overlay(alignment: .bottomLeading) {
                Text(park.name)
                    .font(.title)
                    .bold()
                    .foregroundStyle(.white)
                    .padding()
            }
            .cornerRadius(16)
            .padding(.horizontal)
    }
}
