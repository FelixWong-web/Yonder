//
//  AuthViewModel.swift
//  Yonder
//
//  Created by Felix Wong on 2023-05-30.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

protocol AuthenticationFormProtocol {
    var formIsValid: Bool { get }
}

@MainActor
class AuthViewModel: ObservableObject{
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    //Ensures that the current user stays logged in unless he manually signs out. just checking to see if there is a current user logged in
    init() {
        self.userSession = Auth.auth().currentUser
        
        // if there is already a logged in user it will automatically fetch all the user information if not it will hit the first guard statement and stop right there.
        Task {
            await fetchUser()
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch {
            print("DEBUG: Failed to login in with error \(error.localizedDescription)")
        }
    }
    
    //Asynchonous function that can potentially throw an error in the catch block if anything goes wrong
    
    func createUser(withEmail email: String, password: String, fullname: String) async throws {
        do{
            let result = try await Auth.auth().createUser(withEmail: email, password: password) //with the firebase package we installed we try to create a user with the firebase caode. we are going to await the result and store it in result
            self.userSession = result.user  //If we get a successful result back we will isntantiate the variable user that we created in the model folder
            let user = User(id: result.user.uid, fullName: fullname, email: email)  //instantiation of the a User
            let encodedUser = try Firestore.Encoder().encode(user)  //we will the encode that object user we just created inside an encoded protocol of firestore. so it will manipulate it on its own so we can use it in firestore
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)  //upload data in firestore which is our databases
            await fetchUser()   //we do this because once we create our user we are going to set the user to the usersession property. so we just create a user and fetch all of his information that we just uploaded to firebase so it can properly be displayed.
        //if anything goes wrong it will be caught in the catch block.
        } catch {
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
        }

    }
    
    func signOut(){
        do {
            try Auth.auth().signOut()   //signs user out on backend
            self.userSession = nil  //wipes out user session and takes us back tot he user login screen
            self.currentUser = nil  //wipes out current user data model
        } catch {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    func deleteAccount() {
        guard let currentUser = Auth.auth().currentUser else { return }
        
        // Delete user document from Firestore
        Firestore.firestore().collection("users").document(currentUser.uid).delete { error in
            if let error = error {
                print("DEBUG: Failed to delete user data from Firestore with error \(error.localizedDescription)")
            } else {
                // User data deletion successful
                
                // Delete user account and authentication credentials
                currentUser.delete { error in
                    if let error = error {
                        print("DEBUG: Failed to delete user with error \(error.localizedDescription)")
                    } else {
                        // User deletion successful
                        self.userSession = nil
                        self.currentUser = nil
                    }
                }
            }
        }
    }

    
    //in this function we want to reach out to firebase find the user id and get all the information stored in the databases so we can display it on the screen
    func fetchUser() async{
        guard let uid = Auth.auth().currentUser?.uid else { return }
        // the ? is just an optional statement
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        self.currentUser = try? snapshot.data(as: User.self)
        
        print("DEBUG: Current user is  \(self.currentUser)")
    }
        
}
