//
//  BrowseTableViewController.swift
//  Video
//
//  Created by Alexander Supe on 12.03.20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import UIKit
import AVFoundation

class BrowseTableViewController: UITableViewController {
    
    var urls: [String] { UserDefaults.standard.array(forKey: "Videos") as? [String] ?? [] }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        urls.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let browseCell = cell as? BrowseCell else { return cell }
        browseCell.playMovie(url: createNewPath(urls[indexPath.row]))
        return browseCell
    }
    
    private func createNewPath(_ path: String) -> URL {
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let destination = URL(fileURLWithPath: String(format: "%@/%@", documentsDirectory,path))
        return destination
    }
}

class BrowseCell: UITableViewCell {
    
    var player: AVPlayer!
    
    func playMovie(url: URL) {
        print("it's: \(url)")
        player = AVPlayer(url: url)
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player.currentItem, queue: .main) { _ in
            self.player?.seek(to: CMTime.zero)
            self.player?.play()
        }
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = bounds
        layer.addSublayer(playerLayer)
        playerLayer.videoGravity = .resizeAspectFill
        player.play()
    }
    
    func replayMovie() {
        guard let player = player else { return }
        player.seek(to: CMTime.zero)
        player.play()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        player = nil
    }
    
    
}
