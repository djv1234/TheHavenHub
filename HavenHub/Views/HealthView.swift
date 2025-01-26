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

    var body: some View {
        ScrollView {
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

                VStack(spacing: 16) {
                    HStack(spacing: 12) {
                        Button(action: {}) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.blue)
                                    .shadow(radius: 4)
                                VStack {
                                    Image(systemName: "person.and.arrow.left.and.arrow.right")
                                        .foregroundColor(.white)
                                    Text("Anxiety")
                                        .foregroundColor(.white)
                                        .font(.footnote)
                                }
                            }
                        }

                        Button(action: {}) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.purple)
                                    .shadow(radius: 4)
                                VStack {
                                    Image(systemName: "cloud.rain.fill")
                                        .foregroundColor(.white)
                                    Text("Depression")
                                        .foregroundColor(.white)
                                        .font(.footnote)
                                }
                            }
                        }

                        Button(action: {}) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.pink)
                                    .shadow(radius: 4)
                                VStack {
                                    Image(systemName: "person.badge.shield.exclamationmark")
                                        .foregroundColor(.white)
                                    Text("Trauma")
                                        .foregroundColor(.white)
                                        .font(.footnote)
                                }
                            }
                        }
                    }

                    HStack(spacing: 12) {
                        Button(action: {}) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.red)
                                    .shadow(radius: 4)
                                VStack {
                                    Image(systemName: "pills")
                                        .foregroundColor(.white)
                                    Text("Drug Abuse")
                                        .foregroundColor(.white)
                                        .font(.footnote)
                                }
                            }
                        }

                        Button(action: {}) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.orange)
                                    .shadow(radius: 4)
                                VStack {
                                    Image(systemName: "waterbottle.fill")
                                        .foregroundColor(.white)
                                    Text("Alcohol")
                                        .foregroundColor(.white)
                                        .font(.footnote)
                                }
                            }
                        }

                        Button(action: {}) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.green)
                                    .shadow(radius: 4)
                                VStack {
                                    Image(systemName: "bolt.heart")
                                        .foregroundColor(.white)
                                    Text("Grief & Loss")
                                        .foregroundColor(.white)
                                        .font(.footnote)
                                }
                            }
                        }
                    }

                    HStack(spacing: 12) {
                        Button(action: {}) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.teal)
                                    .shadow(radius: 4)
                                VStack {
                                    Image(systemName: "person.crop.circle.badge.exclamationmark.fill")
                                        .foregroundColor(.white)
                                    Text("PTSD")
                                        .foregroundColor(.white)
                                        .font(.footnote)
                                }
                            }
                        }

                        Button(action: {}) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.yellow)
                                    .shadow(radius: 4)
                                VStack {
                                    Image(systemName: "person.2")
                                        .foregroundColor(.white)
                                    Text("Bipolar Disorder")
                                        .foregroundColor(.white)
                                        .font(.footnote)
                                }
                            }
                        }

                        Button(action: {}) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.gray)
                                    .shadow(radius: 4)
                                VStack {
                                    Image(systemName: "person.fill.questionmark")
                                        .foregroundColor(.white)
                                    Text("Schizophrenia")
                                        .foregroundColor(.white)
                                        .font(.footnote)
                                }
                            }
                        }
                    }
                }

                Text("PHYSICAL HEALTH")
                    .font(.headline)
                    .padding(.top, 20)

                VStack(spacing: 16) {
                    HStack(spacing: 12) {
                        Button(action: {}) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.green)
                                    .shadow(radius: 4)
                                VStack {
                                    Image(systemName: "leaf.fill")
                                        .foregroundColor(.white)
                                    Text("Nutrition")
                                        .foregroundColor(.white)
                                        .font(.footnote)
                                }
                            }
                        }

                        Button(action: {}) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.blue)
                                    .shadow(radius: 4)
                                VStack {
                                    Image(systemName: "figure.walk")
                                        .foregroundColor(.white)
                                    Text("Exercise")
                                        .foregroundColor(.white)
                                        .font(.footnote)
                                }
                            }
                        }

                        Button(action: {}) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.red)
                                    .shadow(radius: 4)
                                VStack {
                                    Image(systemName: "bandage.fill")
                                        .foregroundColor(.white)
                                    Text("First Aid")
                                        .foregroundColor(.white)
                                        .font(.footnote)
                                }
                            }
                        }
                    }
                }
            }
            .padding()
        }
    }
}
