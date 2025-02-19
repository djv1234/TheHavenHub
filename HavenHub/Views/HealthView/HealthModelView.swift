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
        ScrollView {
            VStack {
                HStack {
                    Button {
                        withAnimation {
                            viewManager.navigateToHealth()
                        }
                    } label: {
                        HStack {
                            Image(systemName: "arrow.left")
                                .foregroundColor(.blue)
                            Text("Back")
                                .foregroundColor(.blue)
                        }
                    }
                    .padding()
                    Spacer() // Pushes the button to the left
                }
                .frame(maxWidth: .infinity, alignment: .leading) // Aligns to the left
                Spacer() // Pushes content below
            }
            
            
            Text(healthModel.info.title)
                .font(.headline)
                .padding(.bottom, 10)
            
            Image(healthModel.info.image) // Load image from Assets.xcassets
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
            if !healthModel.info.symptoms.isEmpty {
                
                VStack(alignment: .leading, spacing: 5) {
                    ForEach(healthModel.info.symptoms, id: \.self) { symptom in
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
        }
    }
}

