//
//  Constants.swift
//  VikingRace
//
//  Created by Артём Горовой on 27.11.24.
//
import UIKit
import SnapKit

class GameController: UIViewController {
    
    private let containerView = UIView()
    private let leftRiverSide = UIView()
    private let rightRiverSide = UIView()
    private let river = UIImageView()
    private var ship = UIImageView()
    private var movingObjects: [UIImageView] = []
    private var spawnTimer: Timer?
    private var collisionTimer: Timer?
    private var passedObjectsCount = 0
    private var scoreLabel = UILabel()
    private var RaceScore = 0
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupUI()
        startSpawningObjects()
        startCollisionDetection()
        navigationItem.hidesBackButton = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateShipPositionInView()
    }
    
    // MARK: - Setup UI
    private func setupView() {
        view.backgroundColor = .orange
        view.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerView.addSubview(leftRiverSide)
        containerView.addSubview(rightRiverSide)
        containerView.addSubview(river)
        containerView.addSubview(ship)
        addSwipeGestures()
    }
    
    private func setupUI() {
        leftRiverSide.backgroundColor = Constants.riversideColor
        leftRiverSide.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.15)
        }
        
        rightRiverSide.backgroundColor = Constants.riversideColor
        rightRiverSide.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.15)
        }
        
        river.image = UIImage(named: "shortRiver")
        river.snp.makeConstraints { make in
            make.left.equalTo(leftRiverSide.snp.right)
            make.right.equalTo(rightRiverSide.snp.left)
            make.height.equalToSuperview()
        }
        
        let shipColor = SettingsManager.shared.loadSettings()?.shipColor ?? "BlackShip"
        ship.image = UIImage(named: shipColor)
        ship.isUserInteractionEnabled = true
        ship.contentMode = .scaleAspectFit
        
        // MARK: - ScoreLabel
        scoreLabel = UILabel()
        scoreLabel.text = "0"
        scoreLabel.textColor = Constants.iceColor
        scoreLabel.font = Constants.font
        scoreLabel.textAlignment = .center
        view.addSubview(scoreLabel)
        
        scoreLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.centerX.equalToSuperview()
        }
    }
    
    // MARK: - Swipe Gestures
    private func addSwipeGestures() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipedRight))
        swipeRight.direction = .right
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipedLeft))
        swipeLeft.direction = .left
        containerView.addGestureRecognizer(swipeRight)
        containerView.addGestureRecognizer(swipeLeft)
    }
    
    @objc private func swipedRight() {
        updateShipPosition(offset: Constants.moving)
    }
    
    @objc private func swipedLeft() {
        updateShipPosition(offset: -Constants.moving)
    }
    
    private func updateShipPosition(offset: CGFloat) {
        let newX = ship.frame.origin.x + offset
        let minX = leftRiverSide.frame.width
        let maxX = containerView.bounds.width - rightRiverSide.frame.width - ship.frame.width
        ship.frame.origin.x = min(max(newX, minX), maxX)
    }
    
    private func updateShipPositionInView() {
        let shipWidth: CGFloat = Constants.shipWeight
        let shipHeight: CGFloat = Constants.shipHeight
        if ship.frame.origin.y != containerView.bounds.height - shipHeight - 30 {
            ship.frame = CGRect(
                x: (containerView.bounds.width - shipWidth) / 2,
                y: containerView.bounds.height - shipHeight - 30,
                width: shipWidth,
                height: shipHeight
            )
        }
    }
    
    // MARK: - Spawning Objects
    private func startSpawningObjects() {
        guard let settings = SettingsManager.shared.loadSettings() else {
            return
        }
        spawnTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(settings.spawnInterval), repeats: true) { _ in
            self.spawnRandomObject(on: self.leftRiverSide)
            self.spawnRandomObject(on: self.rightRiverSide)
            self.spawnIceberg()
        }
    }
    
    private func spawnRandomObject(on riverside: UIView) {
        let currentDifficulty = SettingsManager.shared.loadSettings()?.spawnInterval ?? 1.0
        let objectImages = ["fire", "grave", "house", "green", "mushroom", "wood", "secBonfire", "house2"]
        guard let randomObjectName = objectImages.randomElement(),
              let randomImage = UIImage(named: randomObjectName) else {
            return
        }
        let object = UIImageView(image: randomImage)
        object.contentMode = .scaleAspectFit
        object.frame = CGRect(
            x: riverside.frame.midX - 20,
            y: -50,
            width: 50,
            height: 100
        )
        containerView.addSubview(object)
        let animationDuration: TimeInterval = TimeInterval(currentDifficulty)
        UIView.animate(
            withDuration: animationDuration,
            delay: 0,
            options: [.curveLinear],
            animations: {
                object.frame.origin.y = self.containerView.bounds.height
            },
            completion: { _ in
                object.removeFromSuperview()
            }
        )
        movingObjects.append(object)
        
        object.layer.setValue(animationDuration, forKey: "animationDuration")
    }
    
    
    private func spawnIceberg() {
        let iceberg = createRandomObject()
        let riverWidth = containerView.bounds.width - (leftRiverSide.frame.width + rightRiverSide.frame.width)
        let minX = leftRiverSide.frame.width
        let maxX = containerView.bounds.width - rightRiverSide.frame.width - iceberg.frame.width
        
        guard minX < maxX else {
            print("Ошибка: Некорректные границы айсберга")
            return
        }
        
        let spawnX = CGFloat.random(in: minX...maxX)
        iceberg.frame.origin = CGPoint(x: spawnX, y: -iceberg.frame.height)
        containerView.addSubview(iceberg)
        movingObjects.append(iceberg)
        
        animateObject(iceberg)
    }
    
    private func createRandomObject() -> UIImageView {
        
        let objectType = SettingsManager.shared.loadSettings()?.obstacleType ?? "Iceberg"
        let objectImage = objectType == "Iceberg" ? "iceberg1" : "barrel"
        
        let object = UIImageView(image: UIImage(named: objectImage))
        object.contentMode = .scaleAspectFit
        object.frame.size = CGSize(width: 40, height: 80)
        return object
    }
    
    private func animateObject(_ object: UIImageView) {
        let currentDifficulty = SettingsManager.shared.loadSettings()?.spawnInterval ?? 1.0
        let animationDuration: TimeInterval = TimeInterval(currentDifficulty)
        let finalYPosition = containerView.bounds.height + object.frame.height
        UIView.animate(
            withDuration: animationDuration,
            delay: 0,
            options: .curveLinear,
            animations: {
                object.frame.origin.y = finalYPosition
            },
            completion: { _ in
                self.removeObjectIfOutOfBounds(object)
                if object.frame.origin.y >= finalYPosition {
                    self.passedObjectsCount += 1
                    self.updateScoreLabel()
                }
            }
        )
    }
    
    private func removeObjectIfOutOfBounds(_ object: UIImageView) {
        if object.frame.origin.y >= containerView.bounds.height {
            movingObjects.removeAll { $0 == object }
            object.removeFromSuperview()
        }
    }
    
    // MARK: - Collision Detection
    private func startCollisionDetection() {
        collisionTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { _ in
            self.checkCollisions()
        }
    }
    private func checkCollisions() {
        guard !movingObjects.isEmpty else { return }
        
        let shipLayerFrame = ship.layer.presentation()?.frame ?? ship.frame
        
        if shipLayerFrame.origin.x <= leftRiverSide.frame.maxX || shipLayerFrame.origin.x + shipLayerFrame.width >= rightRiverSide.frame.minX {
            handleCollision(with: nil)
            return
        }
        
        for object in movingObjects {
            let objectLayerFrame = object.layer.presentation()?.frame ?? object.frame
            
            if shipLayerFrame.intersects(objectLayerFrame) {
                handleCollision(with: object)
                break
            }
        }
    }
    
    private func handleCollision(with object: UIImageView?) {
        spawnTimer?.invalidate()
        collisionTimer?.invalidate()
        
        movingObjects.forEach { object in
            object.layer.removeAllAnimations()
            object.frame.origin.y = object.layer.presentation()?.frame.origin.y ?? object.frame.origin.y
        }
        
        if let object = object {
            if let index = movingObjects.firstIndex(of: object) {
                movingObjects.remove(at: index)
            }
            object.removeFromSuperview()
        } else {
            print("Столкновение с берегами!")
        }
        
        showGameOverAlert()
    }
    
    
    
    // Обновление счета
    private func updateScoreLabel() {
        scoreLabel.text = "\(passedObjectsCount)"
    }
    
    private func showGameOverAlert() {
        let alert = UIAlertController(
            title: "THE END",
            message: "Ты проиграл",
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "Выход", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        
        alert.addAction(okAction)
        present(alert, animated: true) {
            guard let settings = SettingsManager.shared.loadSettings() else { return }
            let playerName = settings.userName
            let raceScore = self.passedObjectsCount
            let avatarName = settings.avatarName ?? "defaultAvatar"
            let result = ResultManager(playerName: playerName, raceScore: raceScore, avatarName: avatarName)
            var currentResults = ResultManager.loadResults() ?? []
            currentResults.append(result)
            ResultManager.saveResults(currentResults)
        }
    }
    
}
