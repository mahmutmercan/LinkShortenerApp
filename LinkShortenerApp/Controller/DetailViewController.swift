//
//  DetailViewController.swift
//  LinkShortenerApp
//
//  Created by Mahmut MERCAN on 5.08.2021.
//

import UIKit
import CoreData
import Alamofire


class DetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let error: String = "Url items could not load."
    var urlList = [LinkListItem]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedUrlListItem: LinkListItem?
    var selectedItem: Result?
    var linkText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllUrlItems()
        setupCollectionView()
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
    
    
    @IBAction func shortenButtonTapped(_ sender: Any) {
        postUrlItem()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urlList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let urlItem = urlList[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LinkListCVC.identifier, for: indexPath) as! LinkListCVC
        cell.cellConfigure(normalLink: urlItem.long_url!, shortenLink: urlItem.shortener_url!)
        cell.trashAction = { (cell) in
            let id = indexPath.row
            self.selectedUrlListItem = self.urlList[id]
            self.removeSelectedItem(index: id)
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
