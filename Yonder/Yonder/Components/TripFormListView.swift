import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift


struct TripFormListView: View {
    @Binding var tripForms: [TripForm]
    private var userId: String?
    
    init(tripForms: Binding<[TripForm]>) {
        self._tripForms = tripForms
        self.userId = Auth.auth().currentUser?.uid
    }
    
    var body: some View {
        Group {
            if tripForms.isEmpty {
                Text("No trip forms found")
                    .foregroundColor(.gray)
            } else {
                ForEach(tripForms) { tripForm in
                    NavigationLink(destination: TripView(tripForm: tripForm)) {
                            Text(tripForm.tripName)
                        }
                }
                .listStyle(PlainListStyle())
            }
        }
        .onAppear {
            fetchTripForms()
        }
    }
    
    private func fetchTripForms() {
        guard let userId = self.userId else {
            return
        }
        
        let db = Firestore.firestore()
        let tripFormsRef = db.collection("tripForms").whereField("userId", isEqualTo: userId)
        
        tripFormsRef.getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching trip forms: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No trip forms found")
                return
            }
            
            print("Retrieved (documents.count) trip forms")
            
            let fetchedTripForms: [TripForm] = documents.compactMap { document in
                let data = document.data()
                print("Document data: (data)")
                
                guard let formData = data["formData"] as? [String: Any] else {
                    print("Invalid formData")
                    return nil
                }
                
                let tripName = formData["tripName"] as? String
                let arrivalTimestamp = formData["arrivalDate"] as? Timestamp
                let leavingTimestamp = formData["leavingDate"] as? Timestamp
                
                let arrivalDate = arrivalTimestamp?.dateValue()
                let leavingDate = leavingTimestamp?.dateValue()
                
                // Create a TripForm object if all necessary data is available
                if let tripName = tripName, let arrivalDate = arrivalDate, let leavingDate = leavingDate {
                    return TripForm(id: document.documentID, tripName: tripName, arrivalDate: arrivalDate, leavingDate: leavingDate)
                } else {
                    return nil
                }
            }
            
            print("Parsed trip forms: \(fetchedTripForms)")
            
            DispatchQueue.main.async {
                // Update tripForms property on the main thread
                self.tripForms = fetchedTripForms
            }
        }
    }
}
