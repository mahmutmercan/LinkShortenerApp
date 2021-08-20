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
    var shortenLinkAction: ((UICollectionViewCell) -> Void)?

    
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var copyButton: UIButton!
//    @IBOutlet weak var shortenLinkLabel: UILabel!
    
    @IBOutlet weak var shortenLinkButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func trashButtonTapped(_ sender: Any) {
        trashAction?(self)
    }
    
    @IBAction func copyButtonTapped(_ sender: Any) {
//        UIPasteboard.general.string = shortenLinkLabel.text
    }
    
    @IBAction func shortenLinkButtonTapped(_ sender: Any) {
        shortenLinkAction?(self)
    }
    
    static func nib()-> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    func cellConfigure(normalLink: String, shortenLink: String) {
        self.backgroundColor = .red
        self.layer.cornerRadius = 4
        linkLabel.text = normalLink
        shortenLinkButton.setTitle(shortenLink, for: .normal)
        shortenLinkButton.titleLabel?.text = String(shortenLink)
        shortenLinkButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
    }
}
