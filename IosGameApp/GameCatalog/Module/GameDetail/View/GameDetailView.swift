//
//  GameDetailView.swift
//  GameCatalog
//
//  Created by admin on 07/11/22.
//

import UIKit
import Kingfisher
import Combine
import Core
import GameMod
import GameDLC

class GameDetailView: UIViewController {
    
    var presenter: GameDetailPresenter<
        Interactor<
            GetGameDetailRequest,
            GameModel,
            GetGameDetailRepository<GetGameDetailRemoteDataSource>>,
        Interactor<
            String,
            Bool,
            DataExistRepository<GameLocaleDataSource>>,
        Interactor<
            GameRealmEntity,
            Bool,
            SaveGameDataRepository<GameLocaleDataSource>>,
        Interactor<
            String,
            Bool,
            DeleteGameDataRepository<GameLocaleDataSource>>,
        Interactor<
            String,
            [GameDLCModel],
            GetAddsRepository<GetAddsRemoteDataSource>>
    >
    
    var spinner = UIActivityIndicatorView(style: .medium)
    var scrollView = UIScrollView()
    var contentView = UIView()
    
    var gameImage = UIImageView()
    var gameTitle = UILabel()
    var gameRating = UILabel()
    var gameDesc = UILabel()
    var gameReleased = UILabel()
    var dlcLabel = UILabel()
    
    var stackView = UIStackView()
    var gameData: GameModel?
    
    var collectionView = UICollectionView(
        frame: CGRect.zero,
        collectionViewLayout: UICollectionViewFlowLayout.init()
    )
    var gameDLC: [GameDLCModel] = []
    
    init(presenter: GameDetailPresenter<
         Interactor<
             GetGameDetailRequest,
             GameModel,
             GetGameDetailRepository<GetGameDetailRemoteDataSource>>,
         Interactor<
             String,
             Bool,
             DataExistRepository<GameLocaleDataSource>>,
         Interactor<
             GameRealmEntity,
             Bool,
             SaveGameDataRepository<GameLocaleDataSource>>,
         Interactor<
             String,
             Bool,
             DeleteGameDataRepository<GameLocaleDataSource>>,
         Interactor<
             String,
             [GameDLCModel],
             GetAddsRepository<GetAddsRemoteDataSource>>
         
     >) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("Missing game detail presenter.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initilizeController()
    }
}

// MARK: - Init Setup
extension GameDetailView {
    
    func initilizeController() {
        
        presenter.errordelegate = self
        presenter.delegate = self
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.backgroundColor = .white
        self.navigationItem.largeTitleDisplayMode = .never
        
        self.navigationItem.title = presenter.navTitle ?? "Game Detail"
        presenter.initFavoriteButton()
        
        view.addSubview(scrollView)
        view.addSubview(spinner)
        scrollView.addSubview(contentView)
        contentView.addSubview(gameImage)
        contentView.addSubview(stackView)
        contentView.addSubview(collectionView)
        
        configureCollectionView()
        configureSpinner()
        configureGameImage()
        configureLabel()
        
        setScrollViewConstraints()
        setContentViewConstraints()
        setStack()
        setGameImageConstraints()
        setStackConstraints()
        setCollectionViewConstraints()
        
        if let id = presenter.gameId {
            presenter.loadData(id: id)
            presenter.loadGameDLC(id: String(id))
        }
        
    }
    
    func configureCollectionView() {
        collectionView.register(GameDLCCollectionViewCell.self, forCellWithReuseIdentifier: "GameDLCCellIdentifier")
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize(width: 200, height: 140)
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        layout.sectionInset.top = 0
        layout.sectionInset.bottom = 0
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.isScrollEnabled = true
    }
    
    func configureSpinner() {
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func configureGameImage() {
        gameImage.image = UIImage(named: "placeholder")
        gameImage.layer.cornerRadius = Constants.cellImageCorner
        gameImage.clipsToBounds = true
        gameImage.contentMode = .scaleAspectFill
    }
    
    func configureLabel() {
        
        gameTitle.text = "Title: "
        gameTitle.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        
        gameRating.text = "Rating: "
        gameRating.font = UIFont.systemFont(ofSize: 14)
        
        gameDesc.text = "Description: "
        gameDesc.font = UIFont.systemFont(ofSize: 14)
        gameDesc.numberOfLines = 0
        gameDesc.textAlignment = .justified
        
        gameReleased.text = "Released date: "
        gameReleased.font = UIFont.systemFont(ofSize: 14)
        gameReleased.textColor = .systemGray
        
        dlcLabel.text = "Additional Content"
        dlcLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    }
    
    func setStack() {
        stackView.addArrangedSubview(gameTitle)
        stackView.addArrangedSubview(gameRating)
        stackView.addArrangedSubview(gameDesc)
        stackView.addArrangedSubview(gameReleased)
        stackView.addArrangedSubview(dlcLabel)
        
        stackView.spacing = 8
        stackView.axis = .vertical
        stackView.alignment = .fill
    }
    
    func setScrollViewConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
    
    func setContentViewConstraints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }
    
    func setGameImageConstraints() {
        gameImage.translatesAutoresizingMaskIntoConstraints = false
        gameImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        gameImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
        gameImage.widthAnchor.constraint(equalToConstant: Constants.detailImageWidth).isActive = true
        gameImage.heightAnchor.constraint(equalToConstant: Constants.detailImageHeight).isActive = true
    }
    
    func setStackConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: gameImage.bottomAnchor, constant: 50).isActive = true
        stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9).isActive = true
    }
    
    func setCollectionViewConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 5).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -50).isActive = true
        collectionView.heightAnchor.constraint(greaterThanOrEqualToConstant: 180).isActive = true
        collectionView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.95).isActive = true
    }
}

extension GameDetailView {
    
    @objc func onClickFavorite() {
        
        if !presenter.isFavorite {
            
            if let game = gameData {
                let gameFavData = GameRealmEntity()
                
                gameFavData.gameId = game.gameId
                gameFavData.gameTitle = game.gameTitle
                gameFavData.gameRating = String(game.gameRating)
                gameFavData.gameImage = gameImage.image!.pngData()!
                gameFavData.gameReleasedDate = game.gameReleasedDate
                gameFavData.gameDesc = game.gameDesc
                
                presenter.saveGameData(gameData: gameFavData)
            }
            
        } else {
            presenter.deleteGameData()
        }
    }
    
    func showAnimation() {
        spinner.startAnimating()
        
        [gameImage, gameTitle, gameRating, gameDesc, gameReleased, collectionView, dlcLabel].forEach {
            $0.isHidden = true
        }
    }
    
    func hideAnimation() {
        spinner.stopAnimating()
        
        [gameImage, gameTitle, gameRating, gameDesc, gameReleased, collectionView, dlcLabel].forEach {
            $0.isHidden = false
        }
    }
}

// MARK: - Error Delegate
extension GameDetailView: ErrorDelegate {
    
    func showError(msg: String) {
        let alert = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))

        self.present(alert, animated: true)
    }
}

// MARK: - Error Delegate
extension GameDetailView: GameDetailDelegate {
    
    func changeButton(buttonName: String) {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: buttonName),
            style: .plain,
            target: self,
            action: #selector(onClickFavorite)
        )
    }
    
    func showCustomAnimation() {
        showAnimation()
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    func hideCustomAnimation() {
        self.hideAnimation()
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    func loadDataFromResult(result: GameModel) {
        
        gameData = result
        
        let processor = ResizingImageProcessor(referenceSize: CGSize(width: Constants.cellImageWidth, height: Constants.cellImageHeight), mode: .aspectFill) |> RoundCornerImageProcessor(cornerRadius: Constants.cellImageCorner)
        
        self.gameImage.kf.indicatorType = .activity
        self.gameImage.kf.setImage(
            with: URL(string: result.gameImage),
            options: [
                .processor(processor),
                .transition(.fade(1)),
                .cacheOriginalImage
            ]
        )
        
        self.gameTitle.text = "Title: \(result.gameTitle)"
        self.gameRating.text = "Rating: \(result.gameRating)"
        self.gameDesc.text = "Description: \n\n\(result.gameDesc)"
        self.gameReleased.text = "Released date: \(result.gameReleasedDate)"
    }
    
    func loadDLCDataFromResult(result: [GameDLCModel]) {
        gameDLC = result
        collectionView.reloadData()
    }
}

// MARK: - Collection Delegate
extension GameDetailView: UICollectionViewDelegate {
    
}

// MARK: - Collection Datasource
extension GameDetailView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gameDLC.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameDLCCellIdentifier", for: indexPath) as? GameDLCCollectionViewCell else {
            fatalError("Unable to dequeue CustomCollectionViewCell")
        }
        
        let data = gameDLC[indexPath.row]
        
        let processor = ResizingImageProcessor(referenceSize: CGSize(width: 200, height: 100), mode: .aspectFill) |> RoundCornerImageProcessor(cornerRadius: Constants.cellDLCImageCorner)

        if !data.gameImage.isEmpty {
            cell.gameDLCImage.kf.indicatorType = .activity
            cell.gameDLCImage.kf.setImage(
                with: URL(string: data.gameImage),
                options: [
                    .processor(processor),
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ]
            )
        }
        
        cell.gameTitle.text = data.gameTitle
        
        return cell
    }
}
