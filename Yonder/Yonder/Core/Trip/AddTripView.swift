//
//  AddTripView.swift
//  Yonder
//
//  Created by Felix Wong on 2023-06-02.
//

import SwiftUI

struct AddTripView: View {
    @State private var Trip = ""
    @State private var ArrivalDate = Date()
    @State private var LeavingDate = Date()
    @State private var ListOfActivities = ""
    @State private var ListOfFriends = ""
    
    var body: some View {
        VStack{
            Image("Olever")
                .resizable()
                .scaledToFill()
                .frame(width: 150, height:150)
                .padding(.vertical, 32)
            
            VStack(spacing: 24) {
                InputView(text: $Trip,
                          title: "Where you going?",
                          placeholder: "Italy, Japan, Korea...")
                .autocapitalization(.none)
    
                DatePicker("Arrival date", selection: $ArrivalDate, displayedComponents: [.date])
                
                DatePicker("Leaving date", selection: $LeavingDate, displayedComponents: [.date])
                
                InputView(text: $ListOfActivities,
                          title: "What are you doing?",
                          placeholder: "List out your activities")
            }
            .padding(.horizontal)
            .padding(.top, 12)
            Spacer()
        }
    }
}

struct AddTripView_Previews: PreviewProvider {
    static var previews: some View {
        AddTripView()
    }
}
