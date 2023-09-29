//
//  GameDLCCollectionViewCell.swift
//  GameCatalog
//
//  Created by admin on 28/09/23.
//

import UIKit

class GameDLCCollectionViewCell: UICollectionViewCell {
    var gameDLCImage = UIImageView()
    var gameTitle = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(gameDLCImage)
        contentView.addSubview(gameTitle)
        
        configureGameDLCImage()
        configureLabel()
        setGameImageConstraints()
        setGameTitleConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureLabel() {
        gameTitle.text = "Game Title"
        gameTitle.numberOfLines = 2
        gameTitle.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    }
    
    func configureGameDLCImage() {
        gameDLCImage.image = UIImage(named: "placeholder")
        gameDLCImage.layer.cornerRadius = Constants.cellImageCorner
        gameDLCImage.clipsToBounds = true
        gameDLCImage.contentMode = .scaleAspectFill
    }
    
    func setGameImageConstraints() {
        gameDLCImage.translatesAutoresizingMaskIntoConstraints = false
        gameDLCImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        gameDLCImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
        gameDLCImage.widthAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    func setGameTitleConstraints() {
        gameTitle.translatesAutoresizingMaskIntoConstraints = false
        gameTitle.topAnchor.constraint(equalTo: gameDLCImage.bottomAnchor, constant: 5).isActive = true
        gameTitle.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        gameTitle.widthAnchor.constraint(equalToConstant: 200).isActive = true
    }
}
