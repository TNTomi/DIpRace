//
//  SettingsManager.swift
//  VikingRace
//
//  Created by Артём Горовой on 19.12.24.
//
import Foundation

class SettingsManager {
    static let shared = SettingsManager()
    
    private let settingsKey = "GamesSettings"
    
    func saveSettings(_ settings: GamesSettings) {
        if let data = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.set(data, forKey: settingsKey)
        }
    }
    
    func loadSettings() -> GamesSettings? {
        if let data = UserDefaults.standard.data(forKey: settingsKey) {
            let settings = try? JSONDecoder().decode(GamesSettings.self, from: data)
            return settings
        }
        return nil
    }
}

