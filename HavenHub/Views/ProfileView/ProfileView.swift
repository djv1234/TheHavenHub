import SwiftUI

struct ProfileView: View {
    @StateObject var viewManager: ViewManager
    @StateObject var authViewModel: AuthViewModel

    @State var editProfile: Bool = false
    
    @State private var user : UserModel = UserModel(name: "", email: "", password: "")
    
    var body: some View {
//        HStack {
//            Capsule()
//                .frame(width: 38, height: 6)
//                .foregroundColor(.gray)
//               .padding(10)
//            Button(
//                action: {
//                withAnimation {
//                    viewManager.navigateToMain()
//                }
//            }) {
//                ZStack {
//                    Circle()
//                        .fill(Color.red)
//                        .frame(width: 36, height: 36)
//                    Image(systemName: "arrow.left")
//                        .foregroundColor(.white)
//                        .font(.system(size: 16, weight: .bold))
//                }
//            }
//            
//            Text("Profile")
//                .frame(width: 250, height: 40)
//                .font(.title)
//                .foregroundColor(.primary)
//                .fontWeight(.bold)
//        }
        
        ZStack{
            // Background overlay
            Rectangle()
                .fill(.ultraThinMaterial) // Semi-transparent background for focus
                .ignoresSafeArea() // Extend the background to the edges of the screen
                .frame(maxWidth: .infinity, maxHeight: .infinity) // Full screen coverage
            
            VStack {
                ZStack{
                    HStack{
                        Button(
                            action: {
                                withAnimation {
                                    viewManager.navigateToMain()
                                }
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(Color.red)
                                    // .frame(width: 36, height: 36)
                                    Image(systemName: "arrow.left")
                                        .foregroundColor(.white)
                                        .font(.system(size: 16, weight: .bold))
                                }
                            }
                            .frame(width: 40, height: 40)
                            .padding(.leading)
                            .padding(.top)
                        Spacer()
                    }
                    
                    Text("Profile")
                                            .font(.title)
                                            .fontWeight(.bold)
                                            .foregroundColor(.primary)
                                            .frame(maxWidth: .infinity)
                                            .multilineTextAlignment(.center)
                                            .padding(.top)
                    Spacer()

                                        // Invisible view to balance the back button
                                        // Keeps "Profile" centered
                                        Color.clear
                                            .frame(width: 40, height: 40)
                                            .padding(.trailing)
                                            .padding(.top)
                }
              //  Spacer()
                Spacer()
                
                            Text("Coming soon!")
                                .fontWeight(.bold)
                                .font(.largeTitle)
                                .padding()
                                .foregroundColor(.primary)
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                Spacer()

                        }

        }
        
//        List {
//            HStack {
//                Text("Name:")
//                if !editProfile {
//                    Text(user.name) // Use @State variable
//                } else {
//                    TextField("Name", text: $user.name) // Bind to @State variable
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                        .background(.ultraThinMaterial)
//                }
//            }
//            
//            Text("Email: \(user.email)") // Show email from @State
//            
//            if authViewModel.user != nil {
//                if !editProfile {
//                    Button("Edit Profile") {
//                        editProfile = true
//                    }
//                } else {
//                    Button("Save") {
//                        editProfile = false
//                        authViewModel.saveUserData(user: user) { _ in }
//                    }
//                }
//                
//                Button("Logout") {
//                    withAnimation {
//                        viewManager.navigateToLogin()
//                    }
//                    authViewModel.logout()
//                }
//            } else {
//                Button(action: {
//                    withAnimation {
//                        viewManager.navigateToLogin()
//                    }
//                }) {
//                    Text("Login")
//                }
//            }
//        }
//        .onAppear {
//            authViewModel.fetchUserData() { user in
//                if let newUser = user {
//                    self.user = newUser
//                }
//            }
//        }
//        .frame(maxWidth: .infinity, alignment: .leading)
//        .padding(.leading)
    }
}
