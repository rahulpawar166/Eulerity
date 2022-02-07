//
//  GallaryVC.swift
//  Eulerity
//
//  Created by Rahul Pawar on 2/5/22.
//

import UIKit
import SDWebImage
import Alamofire
import SwiftyJSON
import FirebaseAuth
import NVActivityIndicatorView

class GallaryVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    
    @IBOutlet weak var signoutBtn: UIBarButtonItem!
    let userDefaults = UserDefaults.standard
    var uploadURL: String = ""
    
    
    // @IBOutlet weak var imageView1: UIImageView!
    var imageData = [ImageData]()
    let loading = NVActivityIndicatorView(frame: .zero, type: .ballTrianglePath, color: UIColor.white, padding: 0)
    override func viewDidLoad()  {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        // Do any additional setup after loading the view.
        getData()
        getURL()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "MyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "myCollectionViewCell")
        
        
        startAnimation()
        
 
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    
    
    private func startAnimation(){
        
        loading.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loading)
        NSLayoutConstraint.activate([
            loading.widthAnchor.constraint(equalToConstant: 50),
            loading.heightAnchor.constraint(equalToConstant: 50),
            loading.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loading.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        loading.startAnimating()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//            self.loading.stopAnimating()
//        }
    }
    
    //MARK:- Get Data method to get data from URL
    
    private func getData() {
        let url = "http://eulerity-hackathon.appspot.com/image"
        let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            
            if error == nil{
                do{
                    self.imageData = try JSONDecoder().decode([ImageData].self, from: data!)
                }
                catch{
                    print("JSON error")
                }
                
                
            }
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
        }
        task.resume()
    }
    
    //MARK:- Get URL method to get URL for upload
    
    
    func getURL(){
        let sURL = "http://eulerity-hackathon.appspot.com/upload"
        
        AF.request(sURL, method: .get).responseJSON { response in
            if case .success(let value) = response.result {
                print("Got the URL")
                
                if let alamResponse = response.value{
                    //print("JSON: \(alamResponse)" )
                    let alamJSON: JSON = JSON(alamResponse)
                    self.uploadURL = alamJSON["url"].stringValue
                    print(self.uploadURL)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self.loading.stopAnimating()
                    }
                    
                    
                    self.userDefaults.set(self.uploadURL, forKey: "uploadURL")
                }
            }else {
                print("Alamofire Error: \(response.error)")
                
            }
        }
        
    }
    
    @IBAction func signOutBtnPressed(_ sender: UIBarButtonItem) {
        
        let startVC = self.storyboard?.instantiateViewController(withIdentifier: "StartVC") as! StartVC
        
        
        let alert = UIAlertController(title: "Confirm exit/ sign out", message: "Do you want to exit/ sign-out from Eulerity?", preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "Yes", style: .destructive, handler: { action in
            let firebaseAuth = Auth.auth()
           do {
             try firebaseAuth.signOut()
               self.userDefaults.removeObject(forKey: "userSignedIn")
               self.navigationController?.pushViewController(startVC, animated: true)
           } catch let signOutError as NSError {
             print("Error signing out: %@", signOutError)
           }
        }))
        alert.addAction(UIAlertAction.init(title: "No", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}


//MARK:- Collection view extension


extension GallaryVC : UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        
        let imageURL = imageData[indexPath.row].url
        userDefaults.set(imageURL, forKey: "imageURL")
        
        performSegue(withIdentifier: "goToFiltersVC", sender: self)
        print("Image tapped")
        
        
    }
    
    
}

extension GallaryVC : UICollectionViewDataSource{
    
   
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCollectionViewCell", for: indexPath) as! MyCollectionViewCell
        
        //        print(imageURL)
        DispatchQueue.main.async {
            let imageURL = self.imageData[indexPath.row].url
            cell.myImageView.sd_setImage(with: URL(string: imageURL), completed: nil)
            cell.myImageView.clipsToBounds = true
            
           
        }

        return cell
    }
    
    
    
    
}

extension GallaryVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.size.width / 3) - 3,
                      height: (view.frame.size.width / 3) - 3)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
    }
}
