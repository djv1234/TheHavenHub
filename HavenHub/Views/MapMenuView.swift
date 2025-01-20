//
//  MapMenuView.swift
//  HavenHub
//
//  Created by Garrett Butchko on 1/20/25.
//

import SwiftUI
import MapKit

public struct MapMenuView: View {
    
    @Binding var mapItem: MKMapItem?
    @Binding var showingMenu: Bool
    
    public var body: some View {
        VStack{
            HStack{
                Text(mapItem!.name ?? "No Name")
                    .font(.headline)
                
                Spacer()
                
                Button {
                    withAnimation{
                        showingMenu = false
                    }
                } label: {
                    ZStack{
                        Circle()
                            .fill(.ultraThinMaterial) // Translucent circular background
                            .frame(width: 40, height: 40)
                        Text("X")
                            .fontWeight(.bold)
                            .foregroundStyle(.mainOpp)
                    }
                }

            }
        }
        .padding([.horizontal, .bottom])
    }
}
