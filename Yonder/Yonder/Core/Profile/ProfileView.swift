//
//  ProfileView.swift
//  Yonder
//
//  Created by Felix Wong on 2023-05-30.



import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    var body: some View {
        if let user = viewModel.currentUser{
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
                Section ("Trips") {
                    HStack{
                        SettingsRowView(imageName: "airplane", title: "Europe", tintColor: Color(.systemGray))
                        Spacer()
                        
                        Text("2022")
                            .font(.subheadline)
                            .foregroundColor(.gray)

                    }            }
                Section ("Account") {
                    Button {
                        viewModel.signOut()
                    } label: {
                        SettingsRowView(imageName: "arrow.left.circle.fill", title: "Sign Out", tintColor: .red)
                    }
                    Button {
                        print("Delete account..")
                    } label: {
                        SettingsRowView(imageName: "person.fill.xmark", title: "Delete Account", tintColor: .red)
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
