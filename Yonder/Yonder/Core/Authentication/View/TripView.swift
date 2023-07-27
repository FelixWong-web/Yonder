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
    @State private var tripForm: TripForm
    @State private var tripDeleted = false
    @State private var showConfirmationAlert = false
    @State private var isEditing = false
    
    init(tripForm: TripForm) {
        self._tripForm = State(initialValue: tripForm)
    }
    
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
        .navigationTitle("Trip Details")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: {
                    isEditing = true
                }) {
                    Text("Edit")
                }
            }
        }
        .background(
            NavigationStack {
                NavigationLink(
                    destination: ProfileView(),
                    isActive: $tripDeleted,
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
        .sheet(isPresented: $isEditing) {
            EditTripView(tripForm: $tripForm)
        }
    }
    
    private func deleteTrip() {
        let db = Firestore.firestore()
        db.collection("tripForms").document(tripForm.id).delete { error in
            if let error = error {
                print("Error deleting trip: \(error.localizedDescription)")
            } else {
                // Trip deletion successful
                tripDeleted = true
            }
        }
    }
}
