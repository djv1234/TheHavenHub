//
//  SingUpView.swift
//  MiniMate
//
//  Created by Garrett Butchko on 2/6/25.
//


import SwiftUI
import CoreLocation

struct SignUpViewShelter: View {
    @StateObject var authViewModel: AuthViewModel
    @StateObject var viewManager: ViewManager
    
    @State private var coordinates: CLLocationCoordinate2D?
    
    @State private var errorMessage: String?
    
    @State private var shelter = ShelterModel(name: "", contact: Contact(phone: "", email: ""), location: Location(address: "", city: "", state: "", zip: "", latitude: 0, longitude: 0), info: ShelterInfo(subtitle: "", description: "", capacity: 0, subType: ""), verified: false, password: "")
    
    var body: some View {
        VStack(spacing: 20) {
            
            TextField("Name", text: $shelter.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
            
            TextField("Subtype", text: $shelter.info.subType)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
            
            TextField("Address", text: $shelter.location.address)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
            
            TextField("City", text: $shelter.location.city)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
            
            TextField("State", text: $shelter.location.state)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
            
            TextField("Zip", text: $shelter.location.zip)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
            
            TextField("Phone Number", text: $shelter.contact.phone)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .keyboardType(.phonePad)
            
            TextField("Email", text: $shelter.contact.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
            
            SecureField("Password", text: $shelter.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            Button("Sign Up") {
                
                authViewModel.createUser(email: shelter.contact.email, password: shelter.password) { result in
                    switch result {
                    case .success(_):
                        errorMessage = nil
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // Slight delay to ensure user is set
                            saveShelterData()
                        }
                    case .failure(let error):
                        errorMessage = error.localizedDescription
                    }
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        
        // Close button
        Button(action: {
            // Close the emergency view with animation
            withAnimation {
                viewManager.navigateToLogin()
            }
        }) {
            ZStack {
                Circle()
                    .fill(.ultraThinMaterial) // Semi-transparent circular background
                    .frame(width: 70, height: 70) // Size of the button
                
                Text("X")
                    .font(.system(size: 25)) // Font size for the close symbol
                    .foregroundStyle(Color.primary) // Color for the text
            }
        }
        .padding()
    }
    
    private func saveShelterData() {
        geocodeAddress(address: "\(shelter.location.address), \(shelter.location.city), \(shelter.location.state), \(shelter.location.zip)") { cords in
            if let cords = cords {
                shelter.location.latitude = cords.latitude
                shelter.location.longitude = cords.longitude
            }
            
            authViewModel.saveShelterData(user: shelter) { success in
                if success {
                    withAnimation {
                        viewManager.navigateText()
                    }
                } else {
                    errorMessage = "Failed to save user data."
                }
            }
        }
    }

    func geocodeAddress(address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, error in
            if let placemark = placemarks?.first, let location = placemark.location {
                completion(location.coordinate)
            } else {
                print("Error geocoding address: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
            }
        }
    }
}
