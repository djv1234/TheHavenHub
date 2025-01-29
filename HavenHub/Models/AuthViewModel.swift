//
//  AuthViewModel.swift
//  HavenHub
//
//  Created by Garrett Butchko on 1/28/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class AuthViewModel: ObservableObject {
    @Published var user: User?

    init() {
        self.user = Auth.auth().currentUser
    }
    
    func fetchUserName(completion: @escaping (String?) -> Void) {
        guard let userId = user?.uid else { return }

            let db = Firestore.firestore()
            db.collection("users").document(userId).getDocument { document, error in
                if let document = document, document.exists {
                    completion(document.data()?["name"] as? String ?? "Unknown User")
                }
            }
        }
    
    func saveName(userId: String, name: String, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userId)
        
        userRef.setData(["name": name], merge: true) { error in
            completion(error == nil)
        }
    }
    
    func createUser(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = result?.user {
                DispatchQueue.main.async {
                    self.user = user
                }
                completion(.success(user))
            }
        }
    }

    func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = result?.user {
                DispatchQueue.main.async {
                    self.user = user
                }
                completion(.success(user))
            }
        }
    }

    func logout() {
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                self.user = nil
            }
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}
