//
//  EditTripView.swift
//  Yonder
//
//  Created by Anthony Porco on 2023-07-26.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct EditTripView: View {
    @Binding var tripForm: TripForm
    @State private var editedTripName: String
    @State private var editedArrivalDate: Date
    @State private var editedLeavingDate: Date
    @Environment(\.presentationMode) var presentationMode
    
    init(tripForm: Binding<TripForm>) {
        self._tripForm = tripForm
        self._editedTripName = State(initialValue: tripForm.wrappedValue.tripName)
        self._editedArrivalDate = State(initialValue: tripForm.wrappedValue.arrivalDate)
        self._editedLeavingDate = State(initialValue: tripForm.wrappedValue.leavingDate)
    }
    
    var body: some View {
        Form {
            Section(header: Text("Trip Details")) {
                TextField("Trip Name", text: $editedTripName)
                DatePicker("Arrival Date", selection: $editedArrivalDate, displayedComponents: .date)
                DatePicker("Leaving Date", selection: $editedLeavingDate, displayedComponents: .date)
            }
            
            Section {
                Button("Save") {
                    saveTrip()
                }
            }
        }
        .navigationBarTitle("Edit Trip")
    }
    
    private func saveTrip() {
        tripForm.tripName = editedTripName
        tripForm.arrivalDate = editedArrivalDate
        tripForm.leavingDate = editedLeavingDate
        
        let db = Firestore.firestore()
        let tripFormRef = db.collection("tripForms").document(tripForm.id)
        
        let updatedData: [String: Any] = [
            "formData.tripName": editedTripName,
            "formData.arrivalDate": Timestamp(date: editedArrivalDate),
            "formData.leavingDate": Timestamp(date: editedLeavingDate)
        ]
        
        tripFormRef.updateData(updatedData) { error in
            if let error = error {
                print("Error updating trip: \(error.localizedDescription)")
            } else {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}
