//
//  DataManager.swift
//  HavenHub
//
//  Created by Dmitry Volf on 5/20/25.
//

import Foundation

   func loadStreetCardData() -> [StreetCard] {
       guard let url = Bundle.main.url(forResource: "StreetCard", withExtension: "json") else {
           print("StreetCard.json not found")
           return []
       }
       
       do {
           let data = try Data(contentsOf: url)
           let decoder = JSONDecoder()
           let streetCards = try decoder.decode([StreetCard].self, from: data)
           return streetCards
       } catch {
           print("Error decoding StreetCard.json: \(error)")
           return []
       }
   }
