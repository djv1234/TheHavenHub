//
//  HealthView.swift
//  HavenHub
//
//  Created by Dmitry Volf on 1/25/25.
//

import SwiftUI

struct HealthView: View {
    var showTitle = true
    
    let healthResources: [HealthModel] = Bundle.main.decode("HealthData.json")
    @ObservedObject var viewManager: ViewManager
    
    let rows1 = [
            GridItem(.fixed(50)),
            GridItem(.fixed(50)),
            GridItem(.fixed(50))
        ]
    let rows2 = [
            GridItem(.fixed(50))
        ]

    var body: some View {
        ScrollView {
            
            HStack{
                Button(action: {
                    withAnimation{
                        viewManager.navigateToMain()
                    }
                }) {
                    ZStack {
                        Circle()
                        VStack {
                            Image(systemName: "arrow.left")
                                .foregroundColor(.white)
                        }
                    }
                }
                .frame(width: 30, height: 30)
                .padding(.horizontal)
                Spacer()
            }
            
            
            VStack(spacing: 20) {
                if showTitle {
                    Text("Health Resources")
                        .frame(width: 250, height: 40)
                        .font(.title)
                        .foregroundColor(.primary)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .fontWeight(.bold)
                        .padding(.top)
                }

                Text("MENTAL HEALTH & WELL-BEING")
                    .font(.headline)
                    .padding(.bottom, 10)

                
                LazyHGrid(rows: rows1, alignment: .center) {
                    ForEach(healthResources, id: \.self) { item in
                        if item.type == "Mental Health"{
                            Button(action: {
                                
                            }){
                                ZStack {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.fromString(item.color))
                                        .shadow(radius: 4)
                                    VStack {
                                        Image(systemName: item.icon)
                                            .foregroundColor(.white)
                                        Text(item.info.title)
                                            .foregroundColor(.white)
                                            .font(.footnote)
                                    }
                                    NavigationLink(destination: AnxietyView()) {
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(Color.clear)
                                            .frame(width: 120, height: 50)
                                            .contentShape(Rectangle())
                                    }
                                }
                            }
                            .frame(width: 120, height: 50)
                        }
                    }
                }
                

                Text("PHYSICAL HEALTH")
                    .font(.headline)
                    .padding(.top, 20)

                LazyHGrid(rows: rows2, alignment: .center) {
                    ForEach(healthResources, id: \.self) { item in
                        if item.type == "Physical Health"{
                            Button(action: {
                                
                            }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.fromString(item.color))
                                        .shadow(radius: 4)
                                    VStack {
                                        Image(systemName: item.icon)
                                            .foregroundColor(.white)
                                        Text(item.info.title)
                                            .foregroundColor(.white)
                                            .font(.footnote)
                                    }
                                }
                            }
                            .frame(width: 120, height: 50)
                        }
                    }
                }
                Text("MISCELLANEOUS")
                    .font(.headline)
                    .padding(.top, 20)
                
                LazyHGrid(rows: rows2, alignment: .center) {
                    ForEach(healthResources, id: \.self) { item in
                        if item.type == "Miscellaneous"{
                            Button(action: {
                                
                            }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.fromString(item.color))
                                        .shadow(radius: 4)
                                    VStack {
                                        Image(systemName: item.icon)
                                            .foregroundColor(.white)
                                        Text(item.info.title)
                                            .foregroundColor(.white)
                                            .font(.footnote)
                                    }
                                }
                            }
                            .frame(width: 120, height: 50)
                        }
                    }
                }
                
            }
            .padding()
        }
    }
}



