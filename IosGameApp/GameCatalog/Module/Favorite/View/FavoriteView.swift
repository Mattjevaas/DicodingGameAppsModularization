//
//  FavoriteView.swift
//  GameCatalog
//
//  Created by admin on 07/11/22.
//

import UIKit
import Kingfisher
import GameMod
import Core

class FavoriteView: UIViewController {
    
    var presenter: FavoriteGamePresenter<Interactor<
        Any,
        [FavoriteGameModel],
        GetGameDataFromLocalRepository<GameLocaleDataSource>>>
    
    init(presenter: FavoriteGamePresenter<Interactor<
         Any,
         [FavoriteGameModel],
         GetGameDataFromLocalRepository<GameLocaleDataSource>>>) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("Missing favorite presenter.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initilizeController()
        self.view.addSubview(presenter.tableView)
        
        setupTableView()
        setTableViewConstraints()
        
        presenter.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter.loadData()
        checkDataEmpty()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkDataEmpty()
    }
    
    func checkDataEmpty() {
        if presenter.favGames.count == 0 {
            let label = UILabel()
            label.text = "You have no favorite game"
            label.textColor = .systemGray
            label.textAlignment = .center
            
            presenter.tableView.backgroundView = label
        } else {
            presenter.tableView.backgroundView = nil
        }
    }
}

// MARK: - Init Setup
extension FavoriteView {
    func initilizeController() {
        view.backgroundColor = .white
        
        presenter.delegate = self
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Favorite Games"
    }
    
    func setupTableView() {
        presenter.tableView.delegate = self
        presenter.tableView.dataSource = self

        presenter.tableView.register(GameTableViewCell.self, forCellReuseIdentifier: "GameCell")
        presenter.tableView.rowHeight = 150
    }
    
    func setTableViewConstraints() {
        presenter.tableView.translatesAutoresizingMaskIntoConstraints = false
        presenter.tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        presenter.tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        presenter.tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        presenter.tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
}

// MARK: - Table Delegate & Data Source
extension FavoriteView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let data = presenter.favGames[indexPath.row]
        
        let gameDetailView = FavoriteRouter().makeGameDetailView()
        gameDetailView.presenter.gameId = data.gameId
        gameDetailView.presenter.navTitle = data.gameTitle
        
        
        self.navigationController?.pushViewController(gameDetailView, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.favGames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as? GameTableViewCell else { return UITableViewCell() }
        
        let data = presenter.favGames[indexPath.row]
        
        cell.gameImage.image = UIImage(data: data.gameImage)
        cell.gameTitle.text = data.gameTitle
        cell.gameRating.text = String(data.gameRating)
        cell.releasedDate.text = data.gameReleasedDate
        
        return cell
    }
}

// MARK: - Error Delegate
extension FavoriteView: ErrorDelegate {
    func showError(msg: String) {
        let alert = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alert, animated: true)
    }
}
