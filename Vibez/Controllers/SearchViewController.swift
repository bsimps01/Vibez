//
//  SearchViewController.swift
//  Vibez
//
//  Created by Benjamin Simpson on 1/10/21.
//

import Foundation
import UIKit

class SearchViewController: UITableViewController {
    
    private var vibezSoundz = [VibezSoundz]()
    private let apiClient = APIClient(configuration: .default)
    private var artists: [ArtistItem] = []
    var searchDescription: String!
    var searchCaseType: SpotifyCaseTypes!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = searchDescription.capitalized
        
        let searchButton = UIBarButtonItem()
        searchButton.title = "Search"
        
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = searchButton
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.systemBlue]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        fetchSearchResults()
    }
    
    private func fetchSearchResults() {
        
        let token = (UserDefaults.standard.string(forKey: "token"))
        tableView.register(ArtistTableCell.self, forCellReuseIdentifier: "ArtistTableCell")
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.backgroundColor = .black
        apiClient.call(request: .search(token: token!, q: searchDescription, type: searchCaseType) { result in
            switch self.searchCaseType {
            
            case .artist:
                let artists = result as? Result<SearchArtists, Error>
                switch artists {
                case .success(let music):
                    self.artists = music.artists.items
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                case .none:
                    print("error in processing")
                }
                
            case .track:
                let tracks = result as? Result<SearchTracks, Error>
                switch tracks {
                case .success(let song):
                    for track in song.tracks.items {
                        let newTrack = VibezSoundz(artistName: track.album.artists.first?.name,
                                                   id: track.id,
                                                   title: track.name,
                                                   previewURL: track.previewUrl,
                                                   images: track.album.images!)
                        self.vibezSoundz.append(newTrack)
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                case .none:
                    print("error in processing")
                }
            default:
                print("empty search")
            }
        })
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch searchCaseType {
        case .artist:
            return artists.count
        case .track:
            return vibezSoundz.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistTableCell") as! ArtistTableCell
        cell.backgroundColor = .black
        switch searchCaseType {
        case .artist:
            cell.accessoryType = .disclosureIndicator
            cell.setArtist(artist: artists[indexPath.row])
        case .track:
            cell.setSong(song: vibezSoundz[indexPath.row], starButtonHidden: false)
            cell.vibezRecord = vibezSoundz[indexPath.row]
        default:
            print("no info")
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchCaseType == .artist {
            let artist = artists[indexPath.row]
            let destinationVC = TopArtistSongsViewController()
            destinationVC.artist = artist
            self.navigationController?.pushViewController(destinationVC, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}
