//
//  VibezPlayer.swift
//  Vibez
//
//  Created by Benjamin Simpson on 12/5/20.
//

import Foundation
import AVFoundation

class VibezPlayer {
    
    static let shared = VibezPlayer()
    var player: AVAudioPlayer!
    
    func downloadFileFromURL(url: URL){
        URLSession.shared.downloadTask(with: url, completionHandler: { [weak self] (URL, response, error) in
            if let url = URL {
                self?.play(url: url)
            }
        }).resume()
    }
    
    func play(url: URL) {
        do {
            player = try AVAudioPlayer(contentsOf: url)
            
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback)
            } catch(let error) {
                print(error.localizedDescription)
            }
            player.play()
            player.volume = 0.75
        }catch let error as NSError {
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }
    }
}
