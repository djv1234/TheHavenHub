//
//  AnxietyView.swift
//  HavenHub
//
//  Created by Dmitry Volf on 2/2/25.
//

import SwiftUI

struct HealthModelView: View {
    @StateObject var viewManager: ViewManager
    
    @State var healthModel: HealthModel
    
    var body: some View {
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
        Text("Overview")
            .font(.headline)
            .padding(.bottom, 10)
        
        Text("Anxiety can feel overwhelming, especially when facing the stress of homelessness or otherwise difficult circumstances. It’s important to take small steps to manage it. Try deep breathing—inhale slowly through your nose, hold for a few seconds, and exhale through your mouth. If possible, find a quiet space, like a park or shelter, to rest and clear your mind. Talking to someone, whether a friend, a support worker, or a hotline, can help ease worries. Focus on one thing at a time—securing food, finding a safe place, or just getting through the day. You’re not alone, and help is available through shelters and community programs.")
        .padding()
        .lineLimit(nil)
        .fixedSize(horizontal: false, vertical: true)
        Text("Common Symptoms")
            .font(.headline)
            .padding(.bottom, 10)
        Text("- Accelerated heart rate")
        Text("- Impending feeling of doom")
        Text("- Physical pain or tension")
        Text("- Hard time sleeping")
        Text("- Irritability")
        
        Text("Resources for managing anxiety")
            .font(.headline)
            .padding(10)
    }
}


