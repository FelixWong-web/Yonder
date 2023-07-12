//
//  TripView.swift
//  Yonder
//
//  Created by Anthony Porco on 2023-06-29.
//

import SwiftUI

struct TripView: View {
    let tripForm: TripForm

    var body: some View {
        VStack(spacing: 16) {
            Text("Trip Details")
                .font(.title)
                .fontWeight(.bold)

            Text("Trip Name: \(tripForm.tripName)")
                .font(.headline)

            Text("Arrival Date: \(formatDate(tripForm.arrivalDate))")
                .font(.subheadline)

            Text("Leaving Date: \(formatDate(tripForm.leavingDate))")
                .font(.subheadline)

            // Additional trip details

            Spacer()
        }
        .padding()
        .navigationTitle("Trip Details") // Set the navigation title
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
