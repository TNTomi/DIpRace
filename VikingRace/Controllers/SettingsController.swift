import UIKit
import SnapKit

final class SettingsController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - UI Elements
    private let backgroundImage = UIImageView()
    private let avatarImage = UIImageView()
    private var avatarCollectionView: UICollectionView!
    
    private let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your name"
        textField.borderStyle = .roundedRect
        textField.font = Constants.font
        textField.textColor = .black
        textField.backgroundColor = .orange.withAlphaComponent(0.7)
        textField.textAlignment = .center
        textField.layer.cornerRadius = 10
        return textField
    }()
    
    private let shipSegmentedControl = UISegmentedControl(items: ["BlackShip", "GreenShip", "PurpleShip"])
    private let obstacleSegmentedControl = UISegmentedControl(items: ["Iceberg", "Barrel"])
    private let difficultySegmentedControl = UISegmentedControl(items: ["Easy", "Medium", "Hard"])
    
    private let avatarImages = ["viking1", "viking2", "viking3","viking5","viking6"]
    private var selectedAvatarName: String?
    private let backButton: UIButton = {
        let button = UIButton()
        button.setTitle("Back", for: .normal)
        button.setTitleColor(Constants.iceColor, for: .normal)
        button.titleLabel?.font = Constants.font
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setActions()
        loadSettings()
        navigationItem.hidesBackButton = true
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        setupBackground()
        setupControls()
        setupAvatarView()
        setupCollectionView()
        setupConstraints()
    }
    
    private func setupBackground() {
        backgroundImage.image = Constants.settingsBackgroundImage
        backgroundImage.contentMode = .scaleAspectFill
        view.addSubview(backgroundImage)
    }
    
    private func setupAvatarView() {
        avatarImage.contentMode = .scaleAspectFill
        avatarImage.clipsToBounds = true
        avatarImage.layer.cornerRadius = 50
        avatarImage.layer.borderWidth = 2
        avatarImage.layer.borderColor = UIColor.white.cgColor
        avatarImage.image = UIImage(named: "defaultAvatar")
        view.addSubview(avatarImage)
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 60, height: 60)
        layout.minimumLineSpacing = 10
        
        avatarCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        avatarCollectionView.delegate = self
        avatarCollectionView.dataSource = self
        avatarCollectionView.backgroundColor = .clear
        avatarCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "AvatarCell")
        view.addSubview(avatarCollectionView)
    }
    
    private func setupControls() {
        [shipSegmentedControl, obstacleSegmentedControl, difficultySegmentedControl].forEach {
            $0.selectedSegmentIndex = 0
            $0.backgroundColor = .orange.withAlphaComponent(0.7)
            $0.layer.cornerRadius = 10
        }
        view.addSubview(usernameTextField)
        view.addSubview(shipSegmentedControl)
        view.addSubview(obstacleSegmentedControl)
        view.addSubview(difficultySegmentedControl)
    }
    
    private func setupConstraints() {
        backgroundImage.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        usernameTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        
        avatarImage.snp.makeConstraints { make in
            make.top.equalTo(usernameTextField.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        avatarCollectionView.snp.makeConstraints { make in
            make.top.equalTo(avatarImage.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(80)
        }
        
        shipSegmentedControl.snp.makeConstraints { make in
            make.top.equalTo(avatarCollectionView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        
        obstacleSegmentedControl.snp.makeConstraints { make in
            make.top.equalTo(shipSegmentedControl.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        
        difficultySegmentedControl.snp.makeConstraints { make in
            make.top.equalTo(obstacleSegmentedControl.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(80)
            make.left.equalToSuperview().offset(10)
            make.height.equalTo(50)
            make.width.equalTo(100)
        }
    }
    
    // MARK: - Actions
    private func setActions() {
        let action = UIAction { _ in self.saveSettings() }
        backButton.addAction(action, for: .touchUpInside)
    }
    
    @objc private func saveSettings() {
        guard let username = usernameTextField.text, !username.isEmpty else { return }
        let shipColor = shipSegmentedControl.titleForSegment(at: shipSegmentedControl.selectedSegmentIndex) ?? "BlackShip"
        let obstacleType = obstacleSegmentedControl.titleForSegment(at: obstacleSegmentedControl.selectedSegmentIndex) ?? "Iceberg"
        let difficulty = difficultySegmentedControl.titleForSegment(at: difficultySegmentedControl.selectedSegmentIndex) ?? "Medium"
        
        let spawnInterval: Float = {
            switch difficulty {
            case "Easy": return 8.0
            case "Medium": return 4.0
            case "Hard": return 1.0
            default: return 5.0
            }
        }()
        
        let settings = GamesSettings(shipColor: shipColor, obstacleType: obstacleType, userName: username, spawnInterval: spawnInterval, avatarName: selectedAvatarName ?? "defaultAvatar")
        SettingsManager.shared.saveSettings(settings)
        navigationController?.popViewController(animated: true)
    }
    
    private func loadSettings() {
        if let settings = SettingsManager.shared.loadSettings() {
            usernameTextField.text = settings.userName
            shipSegmentedControl.selectedSegmentIndex = ["BlackShip", "GreenShip", "PurpleShip"].firstIndex(of: settings.shipColor) ?? 0
            obstacleSegmentedControl.selectedSegmentIndex = ["Iceberg", "Barrel"].firstIndex(of: settings.obstacleType) ?? 0
            difficultySegmentedControl.selectedSegmentIndex = settings.spawnInterval == 8.0 ? 0 : settings.spawnInterval == 4.0 ? 1 : 2
            
            if let avatar = settings.avatarName {
                avatarImage.image = UIImage(named: avatar)
                selectedAvatarName = avatar
            }
        }
    }
    
    // MARK: - CollectionView Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return avatarImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AvatarCell", for: indexPath)
        
        let imageView = UIImageView(image: UIImage(named: avatarImages[indexPath.item]))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 30
        imageView.frame = cell.contentView.bounds
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        cell.contentView.addSubview(imageView)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedAvatarName = avatarImages[indexPath.item]
        avatarImage.image = UIImage(named: selectedAvatarName!)
    }
}

