//
//  ViewController.swift
//  LinkShortenerApp
//
//  Created by Mahmut MERCAN on 5.08.2021.
//

import UIKit
import Lottie
import Alamofire
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var headerContainer: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var subContainer: UIView!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var shortenButton: UIButton!
    
    let animationView = AnimationView()
    let loadingAnimationView = AnimationView()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var linkText: String?
    var loadingView: UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubContainer()
        setupAnimation()
        // Do any additional setup after loading the view.
        
    }
    
    private func setupAnimation() {
        animationView.animation = Animation.named("47289-digital-marketing")
        animationView.frame = CGRect (x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.width - 100)
        animationView.center = headerContainer.center
        animationView.backgroundColor = .white
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        headerContainer.addSubview(animationView)
    }
    private func setupLoadingAnimation(name: String) {
        loadingAnimationView.animation = Animation.named(name)
        loadingAnimationView.frame = CGRect (x: 0, y: 0, width: 300, height: 300)
        loadingAnimationView.center = view.center
        loadingAnimationView.backgroundColor = .white
        loadingAnimationView.contentMode = .scaleAspectFit
        loadingAnimationView.loopMode = .loop
        loadingAnimationView.play()
    }
    
    func addingAnimationView(animationName: String){
        self.view.addSubview(loadingView)
        loadingView.frame = self.view.bounds
        self.view.layoutSubviews()
        loadingView.backgroundColor = UIColor.white
        setupLoadingAnimation(name: animationName)
        loadingView.addSubview(loadingAnimationView)
    }

    func postUrlItem() {
        linkText = linkTextField.text
        addingAnimationView(animationName: "14906-loading-amimation")
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            AF.request("https://api.shrtco.de/v2/shorten?url=" + self.linkText!)
                .validate()
                .responseDecodable(of: ShortLinkModel.self) { (response) in
                    print(response)
                    guard let item = response.value?.result else {
                        print("An error has occurred. Something went wrong. Please try again later.")
                        self.setupLoadingAnimation(name: "38213-error")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            self.loadingView.removeFromSuperview()
                        }
                        return
                    }
                    self.createItem(full_short_link: item.originalLink, short_link: item.fullShortLink)
                    self.performSegue(withIdentifier: "toDetailVC", sender: nil)
                }
        }
    }
    
    func createItem(full_short_link: String, short_link: String) {
        let newItem = LinkListItem(context: context)
        newItem.archived = false
        newItem.createdAt = Date()
        newItem.id = UUID()
        newItem.long_url = full_short_link
        newItem.shortener_url = short_link
        newItem.updatedAt = nil
        do {
            try context.save()
        }
        catch {

        }
    }

    func setupSubContainer() {
        shortenButton.layer.cornerRadius = 4
    }

    @IBAction func shortenButtonTapped(_ sender: Any) {
        postUrlItem()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DetailViewController {
        }
    }
}

extension ViewController {
    func openNextVC(storyboardName: String, vcName: String){
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: vcName)
        self.present(vc, animated: true)
    }
}
