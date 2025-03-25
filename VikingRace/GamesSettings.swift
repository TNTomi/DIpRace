//
//  GamesSettings.swift
//  VikingRace
//
//  Created by Артём Горовой on 19.12.24.
//
import Foundation

class GamesSettings: Codable {
    var shipColor: String
    var obstacleType: String
    var userName: String
    var spawnInterval: Float
    var avatarName: String?

    init(shipColor: String, obstacleType: String, userName: String, spawnInterval: Float, avatarName: String) {
        self.shipColor = shipColor
        self.obstacleType = obstacleType
        self.userName = userName
        self.spawnInterval = spawnInterval
        self.avatarName = avatarName
    }
}


