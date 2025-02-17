//
//  AnxietyView.swift
//  HavenHub
//
//  Created by Dmitry Volf on 2/2/25.
//

import SwiftUI
//add a scroller
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
        Text(healthModel.info.title)
            .font(.headline)
            .padding(.bottom, 10)
        
        Text(healthModel.info.overview)
        .padding()
        .lineLimit(nil)
        .fixedSize(horizontal: false, vertical: true)
        //Text(healthModel.info.symptoms)
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


