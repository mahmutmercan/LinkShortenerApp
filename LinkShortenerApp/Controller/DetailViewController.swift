//
//  DetailViewController.swift
//  LinkShortenerApp
//
//  Created by Mahmut MERCAN on 5.08.2021.
//

import UIKit
import CoreData
import Alamofire
import Lottie


class DetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    
    let error: String = "Url items could not load."
    var urlList = [LinkListItem]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedUrlListItem: LinkListItem?
    var selectedItem: Result?
    var linkText: String?
    let errorAnimationView = AnimationView()

    override func viewDidLoad() {
        super.viewDidLoad()
        getAllUrlItems()
        setupCollectionView()
    }
    
    private func setupLoadingAnimation(name: String) {
        errorAnimationView.animation = Animation.named(name)
        errorAnimationView.frame = CGRect (x: 0, y: 0, width: 300, height: 300)
        errorAnimationView.center = view.center
        errorAnimationView.backgroundColor = .white
        errorAnimationView.contentMode = .scaleAspectFit
        errorAnimationView.loopMode = .loop
        errorAnimationView.play()
    }

    
    func removeSelectedItem(index: Int) {
        urlList.remove(at: index)
        deleteItem(item: self.selectedUrlListItem!)
        let indexPath = IndexPath(row: index, section: 0)
        collectionView.performBatchUpdates({
            self.collectionView.deleteItems(at: [indexPath])
        }, completion: {
            (finished: Bool) in
            self.collectionView.reloadItems(at: self.collectionView.indexPathsForVisibleItems)
        })
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ViewController")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    @IBAction func shortenButtonTapped(_ sender: Any) {
        postUrlItem()
        collectionView.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urlList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let urlItem = urlList[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LinkListCVC.identifier, for: indexPath) as! LinkListCVC
        cell.cellConfigure(normalLink: urlItem.long_url!, shortenLink: urlItem.shortener_url!)
        let id = indexPath.row
        let deneme = self.urlList[id].shortener_url
        cell.shortenLinkButton.setTitle(deneme, for: .normal)
        cell.trashAction = { (cell) in
            let id = indexPath.row
            self.selectedUrlListItem = self.urlList[id]
            self.removeSelectedItem(index: id)
        }
        cell.shortenLinkAction = { (cell) in
            let id = indexPath.row
            let deneme = self.urlList[id].shortener_url
            UIApplication.shared.openURL(NSURL(string: deneme!)! as URL)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 700, height: 200)
    }
    
}

extension DetailViewController {
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(LinkListCVC.nib(), forCellWithReuseIdentifier: LinkListCVC.identifier)
    }
}

// Core Data Functions
extension DetailViewController {
    func postUrlItem() {
        linkText = linkTextField.text
        print(linkText)
        AF.request("https://api.shrtco.de/v2/shorten?url=" + self.linkText!)
            .validate()
            .responseDecodable(of: ShortLinkModel.self) { (response) in
                guard let item = response.value?.result else {
                    print("An error has occurred. Something went wrong. Please try again later.")
                    self.setupLoadingAnimation(name: "38213-error")
                    return
                }
                self.selectedItem = item
                self.createItem(normalUrl: item.originalLink, shortenerUrl: item.fullShortLink)
                self.getAllUrlItems()
            }
    }
    
    func getAllUrlItems(){
        do {
            urlList = try context.fetch(LinkListItem.fetchRequest())
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            print("All url items fetched")
        } catch  {
            print("Unexpected error: \(self.error)")
        }
    }
    
    func createItem(normalUrl: String, shortenerUrl: String) {
        let newItem = LinkListItem(context: context)
        newItem.archived = false
        newItem.createdAt = Date()
        newItem.id = UUID()
        newItem.long_url = normalUrl
        newItem.shortener_url = shortenerUrl
        newItem.updatedAt = nil
        do {
            try context.save()
            getAllUrlItems()
        }
        catch {

        }
    }

    func deleteItem(item: LinkListItem) {
        context.delete(item)
        do {
            try context.save()
            getAllUrlItems()
        }
        catch {

        }
    }
}
