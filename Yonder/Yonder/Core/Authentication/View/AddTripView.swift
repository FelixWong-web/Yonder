//
//  AddTripView.swift
//  Yonder
//
//  Created by Felix Wong on 2023-06-02.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift




struct AddTripView: View {
    @State private var Trip = ""
    @State private var ArrivalDate = Date()
    @State private var LeavingDate = Date()
    @State private var selectedCountry = ""
    @State private var tripAdded = false
    
    var body: some View {
        Spacer()
        VStack(spacing: 24) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Select a country")
                        .font(.headline)
                    Spacer()
                    Text(selectedCountry) // Display the selected country here
                }
                .padding(.horizontal)
                VStack {
                    Picker(selection: $selectedCountry, label: Text("Country")) {
                        ForEach(allCountries, id: \.self) { country in
                            Text(country)
                        }
                    }
                    .pickerStyle(MenuPickerStyle()) // Use MenuPickerStyle for a less square appearance
                    .frame(maxWidth: 300) // Adjust the width to your preference
                    .padding(.horizontal)
                    .foregroundColor(.black) // Change the text color to black
                }
            }
            
            Image("Travel")
                .resizable()
                .scaledToFill()
                .frame(width: 150, height: 150)
                .padding(.vertical, 32)
            
            VStack(spacing: 24) {
                InputView(text: $Trip, title: "Name your trip", placeholder: "Italy, Japan, Korea...")
                    .autocapitalization(.none)
                
                // Date Pickers
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text("Arrival date")
                            .font(.headline)
                        DatePicker("", selection: $ArrivalDate, displayedComponents: [.date])
                            .datePickerStyle(.compact)
                            .padding(.horizontal)
                    }
                    .padding(.horizontal)
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text("Leaving date")
                            .font(.headline)
                        DatePicker("", selection: $LeavingDate, displayedComponents: [.date])
                            .datePickerStyle(.compact)
                            .padding(.horizontal)
                    }
                    .padding(.horizontal)
                }
                Spacer()
                
                Button {
                    Task {
                        try await saveFormData(trip: Trip, arrivalDate: ArrivalDate, leavingDate: LeavingDate, selectedCountry: selectedCountry)
                        tripAdded = true
                    }
                } label: {
                    HStack {
                        Text("Submit")
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                    .background(Color.blue)
                    .cornerRadius(8)
                    .padding(.horizontal)
                }
                .background(
                    NavigationLink(
                        destination: ProfileView(), // Navigate to ProfileView
                        isActive: $tripAdded, // Use tripAdded to control the navigation
                        label: { EmptyView() }
                    )
                )
            }
            .padding(.horizontal)
            .padding(.top, 12)
        }
    }
}


extension AddTripView : AuthenticationFormProtocol{
    var formIsValid: Bool {
        return !Trip.isEmpty
        && isDateValid(date: ArrivalDate)
        && isDateValid(date: ArrivalDate)    }
}

struct AddTripView_Previews: PreviewProvider {
    static var previews: some View {
        AddTripView()
    }
}
