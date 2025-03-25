import UIKit
import SnapKit

final class AchievementsController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var results: [ResultManager]
    private let tableView = UITableView()
    private let globalResultLabel = UILabel()
    
    init() {
        self.results = (ResultManager.loadResults() ?? []).sorted { $0.raceScore > $1.raceScore }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setBackgroundImage()
        navigationItem.hidesBackButton = true
        setActions()
    }
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setTitle("Back", for: .normal)
        button.setTitleColor(Constants.iceColor, for: .normal)
        button.titleLabel?.font = Constants.font
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private func setBackgroundImage() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "records")
        backgroundImage.contentMode = .scaleAspectFill
        view.addSubview(backgroundImage)
        view.sendSubviewToBack(backgroundImage)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        globalResultLabel.text = "Global Result"
        globalResultLabel.font = Constants.font
        globalResultLabel.textColor = Constants.iceColor
        globalResultLabel.textAlignment = .center
        view.addSubview(globalResultLabel)
        
        globalResultLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(150)
            make.centerX.equalToSuperview()
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(globalResultLabel.snp.bottom).offset(20)
            make.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(80)
            make.left.equalToSuperview().offset(10)
            make.height.equalTo(50)
            make.width.equalTo(100)
        }
    }
    
    private func setActions() {
        let action = UIAction { _ in self.backButtonTapped() }
        backButton.addAction(action, for: .touchUpInside)
    }
    
    private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let result = results[indexPath.row]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let dateString = dateFormatter.string(from: result.raceDate)
        
        cell.textLabel?.text = "\(result.playerName): \(result.raceScore) points (\(dateString))"
        cell.textLabel?.font = Constants.font?.withSize(CGFloat(25))
        cell.textLabel?.textColor = Constants.iceColor
        cell.backgroundColor = .clear
        
        if let avatarImage = UIImage(named: result.avatarName) {
            cell.imageView?.image = avatarImage
        } else {
            cell.imageView?.image = UIImage(named: "defaultAvatar") 
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
