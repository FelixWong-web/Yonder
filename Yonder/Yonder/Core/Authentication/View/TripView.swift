//
//  TripView.swift
//  Yonder
//
//  Created by Anthony Porco on 2023-06-29.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct TripView: View {
    let tripForm: TripForm
    @State private var tripDeleted = false
    @State private var showConfirmationAlert = false
    
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
            
            Button {
                showConfirmationAlert = true 
            } label: {
                Text("Delete Trip")
                    .foregroundColor(.red)
            }
        }
        .padding()
        .navigationTitle("Trip Details") // Set the navigation title
        .background(
            NavigationStack {
                NavigationLink(
                    destination: ProfileView(), // Navigate to ProfileView when the trip is deleted
                    isActive: $tripDeleted, // Use tripDeleted to control the navigation
                    label: { EmptyView() }
                )
            }
        )
        .alert(isPresented: $showConfirmationAlert) {
                    Alert(
                        title: Text("Delete Trip"),
                        message: Text("Are you sure you want to delete this trip?"),
                        primaryButton: .cancel(),
                        secondaryButton: .destructive(Text("Delete"), action: deleteTrip)
                    )
                }
    }
    
    private func deleteTrip() {
        // Implement the code to delete the tripForm from Firebase or your data source
        // For example, you can use Firestore to delete the document corresponding to the tripForm
        
        let db = Firestore.firestore()
        db.collection("tripForms").document(tripForm.id).delete { error in
            if let error = error {
                print("Error deleting trip: \(error.localizedDescription)")
            } else {
                // Trip deletion successful
                tripDeleted = true // Set the tripDeleted state to true to navigate back to ProfileView
            }
        }
    }
}
