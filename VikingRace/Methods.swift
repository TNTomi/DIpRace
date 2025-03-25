//
//  Methods.swift
//  VikingRace
//
//  Created by Артём Горовой on 27.11.24.
//
import UIKit
final class Methods {
    
    static func madebutton(title: String,color: UIColor) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(color, for: .normal)
        button.titleLabel?.font = Constants.font
        button.titleLabel?.textAlignment = .center
        return button
    }
    static func setFrame ( _ view:UIView, top:CGFloat, sides:CGFloat, width:CGFloat, height: CGFloat) -> UIView {
        view.frame = CGRect(
            x: sides,
            y: top,
            width: width,
            height: height
        )
        return view
    }
    static func animateIcebergMove() {
        UIView.animate(withDuration: 25, animations: {
            Labels.iceberg.frame.origin.y 
        }) { _ in
            self.resetIceberg()
            self.animateIcebergMove()
        }
    }
    
    static func resetIceberg() {
        Labels.iceberg.frame.origin.y = -200
    }
    
    static func animateWave() {
        UIView.animate(withDuration: 2, animations: {
            Labels.waves.alpha -= 0.4
        }) { _ in
            self.reset()
            self.animateWave()
        }
    }
    static func reset() {
        Labels.waves.alpha = 0.8
    }

}
