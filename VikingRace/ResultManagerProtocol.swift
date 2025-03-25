//
//  ResultManagerProtocol.swift
//  VikingRace
//
//  Created by Артём Горовой on 12.12.24.
//

import Foundation

protocol ResultManagerProtocol {
    var playerName: String { get set }
    var raceScore: Int { get set }
    var avatarName: String { get set }
    
    init(playerName: String, raceScore: Int, avatarName: String) 
}

