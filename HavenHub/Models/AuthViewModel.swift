//
//  AuthViewModel.swift
//  MiniMate
//
//  Created by Garrett Butchko on 2/3/25.
//


import Foundation
import FirebaseAuth
import FirebaseDatabase
import GoogleSignIn
import FirebaseCore


class AuthViewModel: ObservableObject {
    @Published var user: User?

    init() {
        self.user = Auth.auth().currentUser
    }
    
    func signInWithGoogle(completion: @escaping (Result<User, Error>) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let rootViewController = UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.windows.first?.rootViewController })
            .first else {
            print("❌ Error: Could not find rootViewController")
            return
        }
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [unowned self] result, error in
            if let error = error {
                print("❌ Google Sign-In Error:", error.localizedDescription)
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                print("❌ Error: Failed to retrieve Google ID token.")
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            Auth.auth().signIn(with: credential) { result, error in
                if let error = error {
                    completion(.failure(error))
                } else if let user = result?.user {
                    DispatchQueue.main.async {
                        self.user = user
                        self.saveUserData(user: UserModel(name: user.displayName!, email: user.email!, password: "google")) { _ in }
                    }
                    completion(.success(user))
                }
            }
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
    
    func saveUserData(user: UserModel, completion: @escaping (Bool) -> Void) {
        let ref = Database.database().reference()
        
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(false)
            return
        }

        do {
            let data = try JSONEncoder().encode(user)
            let dictionary = try JSONSerialization.jsonObject(with: data) as? [String: Any]

            ref.child(userId).setValue(dictionary) { error, _ in
                completion(error == nil)
            }
        } catch {
            print("Error encoding user data: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    func fetchUserData(completion: @escaping (UserModel?) -> Void) {
        let ref = Database.database().reference()
        
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }

        ref.child(userId).observeSingleEvent(of: .value) { snapshot, arg  in
            guard let data = snapshot.value as? [String: Any] else {
                completion(nil)
                return
            }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: data)
                let user = try JSONDecoder().decode(UserModel.self, from: jsonData)
                completion(user)
            } catch {
                print("Error decoding user data: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
    
    func saveShelterData(user: ShelterModel, completion: @escaping (Bool) -> Void) {
        let ref = Database.database().reference()
        
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(false)
            return
        }

        do {
            var user = user // Make a mutable copy if ShelterModel is immutable
            let data = try JSONEncoder().encode(user)
            guard var dictionary = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                completion(false)
                return
            }
            
            // Check if shelter already has an ID; if not, create one
            if user.id.isEmpty {
                let newRef = ref.child("shelters").childByAutoId()
                user.id = newRef.key ?? UUID().uuidString // Assign the generated key
            }
            
            dictionary["id"] = user.id // Ensure the dictionary has the ID

            // Save data under the user's ID
            ref.child(userId).setValue(dictionary) { error, _ in
                completion(error == nil)
            }
            
            // Save or update data in "shelters" using the shelter's unique ID
            ref.child("shelters").child(user.id).setValue(dictionary) { error, _ in
                completion(error == nil)
            }
        } catch {
            print("Error encoding user data: \(error.localizedDescription)")
            completion(false)
        }
    }

    
    func fetchShelterData(completion: @escaping (ShelterModel?) -> Void) {
        let ref = Database.database().reference()
        
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }

        ref.child(userId).observeSingleEvent(of: .value) { snapshot, arg  in
            guard let data = snapshot.value as? [String: Any] else {
                completion(nil)
                return
            }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: data)
                let user = try JSONDecoder().decode(ShelterModel.self, from: jsonData)
                completion(user)
            } catch {
                print("Error decoding user data: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
    
    func fetchGlobalShelters(completion: @escaping ([ShelterModel]?) -> Void) {
        let ref = Database.database().reference().child("shelters")
        
        ref.observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [String: Any] else {
                completion(nil)
                return
            }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: Array(value.values))
                let shelters = try JSONDecoder().decode([ShelterModel].self, from: jsonData)
                completion(shelters)
            } catch {
                print("Error decoding shelters: \(error.localizedDescription)")
                completion(nil)
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
