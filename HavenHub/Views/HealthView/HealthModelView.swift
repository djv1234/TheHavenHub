//
//  HealthModelView.swift
//  HavenHub
//
//  Created by Dmitry Volf on 2/2/25.
//

import SwiftUI
struct HealthModelView: View {
    @StateObject var viewManager: ViewManager
    
    @State var healthModel: HealthModel
    
    var body: some View {
        
        HStack{
            Button(action: {
                withAnimation{
                    viewManager.navigateToHealth()
                }
            }) {
                ZStack {
                    //Circle()
                    HStack {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.blue)
                        Text("Back")
                            .foregroundColor(.blue)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading)
            
            Spacer()
        }
        ScrollView {
            Text(healthModel.info.title)
                .font(.headline)
                .padding(.bottom, 10)
            
            Image(healthModel.image) // Load image from Assets.xcassets
                               .resizable()
                               .scaledToFit()
                               .frame(width: 300, height: 200) // Adjust size as needed
                               .cornerRadius(10)
                               .padding(.bottom, 10)
            
            Text(healthModel.info.overview)
                .padding()
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
            
                .font(.headline)
                .padding(.bottom, 10)
            Text("Symptoms of " + healthModel.info.title)
                .font(.headline)
                .padding(10)
            if healthModel.type == "Mental Health" && !healthModel.info.symptoms!.isEmpty{
                
                VStack(alignment: .leading, spacing: 5) {
                    ForEach(healthModel.info.symptoms!, id: \.self) { symptom in
                        Text(symptom)
                            .padding(.leading, 10)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .padding(.horizontal)
            } else {
                Text("No specific symptoms listed.")
                    .foregroundColor(.gray)
                    .padding(.top, 10)
            }
            
            
            Text("Resources for managing " + healthModel.info.title)
                .font(.headline)
                .padding(10)
            Text("Let us help you get better - all one click away!")
                .padding()
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
            
            
            Button(action: {
                withAnimation {
                    // Your action code here
                }
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(LinearGradient(
                            colors: [Color.mint, Color.blue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                        .scaleEffect(1.0)
                    
                    VStack(spacing: 8) {
                        Image(systemName: "person.line.dotted.person.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.white)
                            .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)
                        
                        Text("Resources")
                            .foregroundColor(.white)
                            .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)
                    }
                    .padding(8)
                }
            }
            .buttonStyle(PlainButtonStyle())
            .scaleEffect(0.93)
            .onHover { hovering in
                withAnimation(.easeInOut(duration: 0.2)) {
                    if hovering {
                        // Optional hover effect
                    }
                }
            }
            .padding()
        }
    }
}

