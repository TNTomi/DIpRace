//
//  ViewController.swift
//  VikingRace
//
//  Created by Артём Горовой on 27.11.24.
//

import UIKit


class ViewController: UIViewController {
    
    enum buttonAction {
        case first, second, third
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundImage()
        addButton()
        
    }
    
    private func setBackgroundImage() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "VikingLS")
        backgroundImage.contentMode = .scaleAspectFill
        view.addSubview(backgroundImage)
    }
    
    
    private func addButton () {
        Methods.setFrame(
            Buttons.startButton,
            top: Constants.screenHeight/2 + 100,
            sides: Constants.screenWidth/2 - 150/2  ,
            width: 150,
            height: 50
        )
        Buttons.startButton.addAction(UIAction{ _ in self.someButtonPress(action: .first)}, for: .touchUpInside)
        Buttons.settingsButton.addAction(UIAction{ _ in self.someButtonPress(action: .second)}, for: .touchUpInside)
        Buttons.achievementsButton.addAction(UIAction{ _ in self.someButtonPress(action: .third)}, for: .touchUpInside)
        view.addSubview(Buttons.startButton)
        Methods.setFrame(
            Buttons.settingsButton,
            top: Constants.screenHeight/2 + 150,
            sides: Constants.screenWidth/2 - 250/2,
            width: 250,
            height: 50
        )
        view.addSubview(Buttons.settingsButton)
        Methods.setFrame(
            Buttons.achievementsButton,
            top: Constants.screenHeight/2 + 200,
            sides: Constants.screenWidth/2 - 300/2,
            width: 300,
            height: 50
        )
        view.addSubview(Buttons.achievementsButton)
    }
    
    private  func someButtonPress(action: buttonAction) {
        switch  action{
        case .first:
            let controller = GameController ()
            navigationController?.pushViewController(controller, animated: true)
        case .second:
            let controller = SettingsController()
            navigationController?.pushViewController(controller, animated: true)
        case .third:
            let controller = AchievementsController()
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}


