//
//  ArtistTableCell.swift
//  Vibez
//
//  Created by Benjamin Simpson on 12/9/20.
//

import Foundation
import UIKit
import Kingfisher

class ArtistTableCell: UITableViewCell {
    
    let artistImage = UIImageView()
    let artistLabel = UILabel()
    let songLabel = UILabel()
    var vibezRecord: VibezSoundz!
    
    lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(favoriteSelected), for: .touchUpInside)
        return button
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2))
    }
    
    @objc func favoriteSelected(){
        guard var favoriteSongsID = UserDefaults.standard.stringArray(forKey: "favoriteSongs") else {
            var favoriteSongsID = [String]()
            favoriteSongsID.append(vibezRecord.id)
            UserDefaults.standard.set(favoriteSongsID, forKey: "favoriteSongs")
            let star = UIImage(named: "favorite.fill")
            let blueStar = star?.withTintColor(UIColor(.blue), renderingMode: .alwaysOriginal)
            favoriteButton.setImage(blueStar, for: .normal)
            return
        }
        
        if !favoriteSongsID.contains(vibezRecord.id) {
            let star = UIImage(named: "favorite.fill")
            let blueStar = star?.withTintColor(UIColor(.blue), renderingMode: .alwaysOriginal)
            favoriteButton.setImage(blueStar, for: .normal)
            favoriteSongsID.append(vibezRecord.id)
        } else {
            favoriteSongsID = favoriteSongsID.filter(){$0 != vibezRecord.id}
            let star = UIImage(named: "favorite")
            let blueStar = star?.withTintColor(UIColor(.blue), renderingMode: .alwaysOriginal)
            favoriteButton.setImage(blueStar, for: .normal)
            
        }
        
        UserDefaults.standard.set(favoriteSongsID, forKey: "favoriteSongs")
    }
    
    fileprivate func configureCell(starButtonHidden: Bool?){
        
        self.contentView.addSubview(artistLabel)
        artistLabel.font = UIFont.systemFont(ofSize: 12)
        artistLabel.textColor = .systemBackground
        artistLabel.translatesAutoresizingMaskIntoConstraints = false
        artistLabel.leadingAnchor.constraint(equalTo: artistImage.trailingAnchor, constant: 4).isActive = true
        artistLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,constant:2).isActive = true
        
        self.contentView.addSubview(artistImage)
        artistImage.translatesAutoresizingMaskIntoConstraints = false
        artistImage.heightAnchor.constraint(equalTo: self.contentView.heightAnchor).isActive = true
        artistImage.widthAnchor.constraint(equalTo: self.contentView.widthAnchor).isActive = true
        
        self.contentView.addSubview(songLabel)
        songLabel.translatesAutoresizingMaskIntoConstraints = false
        songLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        songLabel.leadingAnchor.constraint(equalTo: artistImage.trailingAnchor, constant: 10).isActive = true
        songLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -30).isActive = true
        
        if starButtonHidden! {
            favoriteButton.isHidden = true
            artistImage.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10).isActive = true
        } else {
            artistImage.leadingAnchor.constraint(equalTo: favoriteButton.trailingAnchor, constant: -3).isActive = true
        }
        
    }
    
    internal func setArtist(artist: ArtistObject) {
        configureCell(starButtonHidden: true)
        
        artistImage.kf.setImage(with: artist.images.first?.url, options: [], completionHandler:  { result in
            switch result {
            case .success(let value):
                DispatchQueue.main.async {
                    self.songLabel.text = artist.name
                    self.artistImage.image = value.image
                }
            case .failure(let error):
                print(error)
            }
        })
    }
    
    internal func setSong(song: VibezSoundz, starButtonHidden: Bool?) {
        configureCell(starButtonHidden: starButtonHidden)
        
        for image in song.images {
            if image.height == 300 {
                artistImage.kf.setImage(with: image.url, completionHandler:  { result in
                    switch result {
                    case .success(let value):
                        
                        DispatchQueue.main.async {
                            self.artistImage.image = value.image
                            self.songLabel.text = song.title
                            self.artistLabel.text = song.artist
                            
                        }
                    case .failure(let error):
                        print(error)
                    }
                    
                })
            }
        }
    }
    
}
