//
//  ProfileView.swift
//  Yonder
//
//  Created by Felix Wong on 2023-05-30.

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var tripForms: [TripForm] = []
    var body: some View {
        if let user = viewModel.currentUser{
            NavigationStack{
                List {
                    Section {
                        HStack {
                            Text(user.initials)
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(width: 72, height: 72)
                                .background(Color(.systemTeal))
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(user.fullName)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .padding(.top, 4)
                                Text(user.email)
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    Section(header: Text("Trips").background(Color.clear)) { // Specify the header for the section
                        TripFormListView(tripForms: $tripForms)
                        
                        NavigationLink {
                            AddTripView()
                                .navigationBarBackButtonHidden(false)
                        } label: {
                            SettingsRowView(imageName: "plus.circle.fill", title: "Add Trip", tintColor: Color(.systemGreen))
                        }
                        .navigationBarTitleDisplayMode(.inline)
                    }
                    
                    Section ("Account") {
                        Button {
                            viewModel.signOut()
                        } label: {
                            SettingsRowView(imageName: "arrow.left.circle.fill", title: "Sign Out", tintColor: .red)
                        }
                        Button {
                            viewModel.deleteAccount()
                        } label: {
                            SettingsRowView(imageName: "person.fill.xmark", title: "Delete Account", tintColor: .red)
                        }
                    }

                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
