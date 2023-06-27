//
//  AddTripModel.swift
//  Yonder
//
//  Created by Anthony Porco on 2023-06-27.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

func saveFormData(trip: String, arrivalDate: Date, leavingDate: Date) async throws {
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
        "leavingDate": leavingTimestamp
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
