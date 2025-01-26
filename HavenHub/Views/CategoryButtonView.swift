//
//  CategoryButtonView.swift
//  HavenHub
//
//  Created by Garrett Butchko on 1/25/25.
//
import SwiftUI

struct CategoryButtonView: View {
    
    var icon: String
    var color: Color
    @Binding var on: Bool
    var action: () -> Void // Closure property for the button's action
    
    var body: some View {
        Button(action: {
            withAnimation{
                on.toggle()
            }
            action()
        }) {
            ZStack {
                if on{
                    Circle()
                        .fill(color)
                        .frame(width: 40, height: 40)
                } else {
                    Circle()
                        .fill(.ultraThinMaterial)
                        .frame(width: 40, height: 40)
                }
                Image(systemName: icon) // Use the icon variable
                    .resizable()
                    .foregroundColor(.primary)
                    .frame(width: 20, height: 20)
            }
        }
    }
}
