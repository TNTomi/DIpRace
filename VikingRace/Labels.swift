//
//  Labels.swift
//  VikingRace
//
//  Created by Артём Горовой on 28.11.24.
//

import UIKit

final class Labels {
    
    static var ship: UIImageView = {
        guard let settings = SettingsManager.shared.loadSettings() else {
            return UIImageView(image: UIImage(named: "BlackShip"))
        }
        let shipName = settings.shipColor
        guard let shipImage = UIImage(named: shipName) else {
            return UIImageView(image: UIImage(named: "BlackShip"))
        }
        
        let shipImageView = UIImageView(image: shipImage)
        shipImageView.contentMode = .scaleAspectFit
        return shipImageView
    }()

    static let waves: UIImageView = {
        let waves = UIImageView(image: UIImage(named: "waves"))
        waves.contentMode = .scaleAspectFit
        return waves
    }()
    static let iceberg: UIImageView = {
        let iceberg = UIImageView(image: UIImage(named: "iceberg1"))
        iceberg.contentMode = .scaleAspectFit
        return iceberg
    }()
    static let secondIceberg: UIImageView = {
        let iceberg = UIImageView(image: UIImage(named: "iceberg1"))
        iceberg.contentMode = .scaleAspectFit
        return iceberg
    }()

    static let log: UIImageView = {
        let log = UIImageView(image: UIImage(named: "wood"))
        log.contentMode = .scaleAspectFit
        return log
    }()
    
    
}

