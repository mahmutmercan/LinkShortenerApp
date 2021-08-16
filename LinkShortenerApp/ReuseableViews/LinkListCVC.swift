//
//  LinkListCVC.swift
//  LinkShortenerApp
//
//  Created by Mahmut MERCAN on 5.08.2021.
//

import UIKit

class LinkListCVC: UICollectionViewCell {

    static let identifier: String = "LinkListCVC"
    
    var trashAction: ((UICollectionViewCell) -> Void)?

    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var copyButton: UIButton!
    @IBOutlet weak var shortenLinkLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func trashButtonTapped(_ sender: Any) {
        trashAction?(self)
    }
    
    @IBAction func copyButtonTapped(_ sender: Any) {
        UIPasteboard.general.string = shortenLinkLabel.text
    }
    
    static func nib()-> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    func cellConfigure(normalLink: String, shortenLink: String) {
        self.backgroundColor = .red
        self.layer.cornerRadius = 4
        linkLabel.text = normalLink
        shortenLinkLabel.text = shortenLink
    }
    
}
