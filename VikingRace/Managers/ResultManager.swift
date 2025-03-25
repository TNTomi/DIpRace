//
//  ResultManager.swift
//  VikingRace
//
//  Created by Артём Горовой on 19.12.24.
//
import Foundation

class ResultManager: ResultManagerProtocol, Codable {
    var playerName: String
    var raceScore: Int
    var raceDate: Date
    var avatarName: String
    
    required init(playerName: String, raceScore: Int, avatarName: String) {
        self.playerName = playerName
        self.raceScore = raceScore
        self.raceDate = Date()
        self.avatarName = avatarName
    }

    static func saveResults(_ results: [ResultManager]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(results) {
            UserDefaults.standard.set(encoded, forKey: "GameResults")
        }
    }
    
    static func loadResults() -> [ResultManager]? {
        if let savedResults = UserDefaults.standard.data(forKey: "GameResults") {
            let decoder = JSONDecoder()
            if let loadedResults = try? decoder.decode([ResultManager].self, from: savedResults) {
                return loadedResults
            }
        }
        return nil
    }
}



