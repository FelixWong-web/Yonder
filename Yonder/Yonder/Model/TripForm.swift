//
//  TripForm.swift
//  Yonder
//
//  Created by Anthony Porco on 2023-06-29.
//

import Foundation

struct TripForm: Identifiable, Codable {
    var id: String // Unique identifier for the trip form
    var tripName: String // Name of the trip
    var arrivalDate: Date // Date of arrival
    var leavingDate: Date // Date of departure
}
