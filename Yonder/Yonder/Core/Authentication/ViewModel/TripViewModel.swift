//
//  AddTripModel.swift
//  Yonder
//
//  Created by Anthony Porco on 2023-06-27.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

func saveFormData(trip: String, arrivalDate: Date, leavingDate: Date, selectedCountry: String) async throws {
    guard let userId = Auth.auth().currentUser?.uid else {
        return
    }

    let db = Firestore.firestore()

    // Convert arrivalDate and leavingDate to Timestamp
    let arrivalTimestamp = Timestamp(date: arrivalDate)
    let leavingTimestamp = Timestamp(date: leavingDate)

    // Create a document reference for the trip form
    let tripFormRef = db.collection("tripForms").document()

    // Create the form data dictionary
    let formData: [String: Any] = [
        "tripName": trip,
        "arrivalDate": arrivalTimestamp,
        "leavingDate": leavingTimestamp,
        "selectedCountry": selectedCountry // Add the selected country here
    ]

    // Save the form data to Firestore
    do {
        try await tripFormRef.setData([
            "userId": userId,
            "formData": formData,
            "timestamp": FieldValue.serverTimestamp()
        ])
        print("Form data saved successfully")
    } catch {
        print("Error saving form data: (error)")
        throw error
    }
}
func isDateValid(date: Date) -> Bool {
        let currentDate = Date()
        return date >= currentDate
    }

func formatDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter.string(from: date)
}

