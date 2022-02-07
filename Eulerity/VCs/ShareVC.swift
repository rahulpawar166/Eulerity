//
//  ShareVC.swift
//  Eulerity
//
//  Created by Rahul Pawar on 2/6/22.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView

class ShareVC: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var saveBtn: UIButton!
    let userDefaults = UserDefaults.standard
    
    var shareImage : UIImage!
    
    let imageURL = UserDefaults.standard.value(forKey: "imageURL") as! String
    let uploadURL = UserDefaults.standard.value(forKey: "uploadURL") as! String
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var uploadBtn: UIButton!
    
    let loading = NVActivityIndicatorView(frame: .zero, type: .ballTrianglePath, color: UIColor.white, padding: 0)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        imageView.image = shareImage
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        UINavigationBarAppearance().backgroundColor = .clear
        UITabBarAppearance().backgroundColor = .clear
        self.navigationItem.setLeftBarButton(nil, animated: true)
        
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        
    }
    
    @IBAction func sabeBtnPressed(_ sender: UIButton) {
        guard let image = imageView.image else {return}
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:context:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, context: UnsafeRawPointer){
        if let error = error{
            let alert = UIAlertController(title: "Error saving image", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "Try Again!", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        } else{
            let alert = UIAlertController(title: "Saved", message: "Image saved successfully in your photo library", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "Great!", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func uploadBtnPressed(_ sender: UIButton) {
        postData()
        startAnimation()
        
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
    
    @IBAction func homeBtnPressed(_ sender: UIBarButtonItem) {
        
        let destVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GallaryVC") as! GallaryVC
        self.navigationController?.pushViewController(destVC, animated: true)
        
        
    }
    
  
    //MARK:- Post Action for image
    
    func postData(){
        //Set Your URL
        let api_url = uploadURL
        guard let url = URL(string: api_url) else {
            return
        }
//        imageView.image = UIImage.init(view: imageViewContainer)
//        // Simple image object
//        let img =  UIImage.init(view: imageViewContainer)
        var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0 * 1000)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        //Set Your Parameter
        let parameterDict = NSMutableDictionary()
        parameterDict.setValue("com.rahulpawar166.Eulerity", forKey: "appid")
        parameterDict.setValue(imageURL, forKey: "original")
        
        let img = imageView.image as! UIImage
        
        //Set Image Data
        let imgData = img.jpegData(compressionQuality: 0.5)!
        
        // Now Execute
        AF.upload(multipartFormData: { multiPart in
            for (key, value) in parameterDict {
                if let temp = value as? String {
                    multiPart.append(temp.data(using: .utf8)!, withName: key as! String)
                }
                if let temp = value as? Int {
                    multiPart.append("\(temp)".data(using: .utf8)!, withName: key as! String)
                }
                if let temp = value as? NSArray {
                    temp.forEach({ element in
                        let keyObj = key as! String + "[]"
                        if let string = element as? String {
                            multiPart.append(string.data(using: .utf8)!, withName: keyObj)
                        } else
                        if let num = element as? Int {
                            let value = "\(num)"
                            multiPart.append(value.data(using: .utf8)!, withName: keyObj)
                        }
                    })
                }
            }
            multiPart.append(imgData, withName: "file", fileName: "file.png", mimeType: "image/png")
        }, with: urlRequest)
            .uploadProgress(queue: .main, closure: { progress in
                //Current upload progress of file
                print("Upload Progress: \(progress.fractionCompleted)")
            })
            .responseJSON(completionHandler: { data in
                
                switch data.result {
                    
                case .success(_):
                    do {
                        
                        let dictionary = try JSONSerialization.jsonObject(with: data.data!, options: .fragmentsAllowed) as! NSDictionary
                        
                        print("Success!")
                        self.loading.stopAnimating()
                        print(dictionary)
                        let alert = UIAlertController(title: "Success", message: "Your photo successfully uploaded to our server.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction.init(title: "Amazing!", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    catch {
                        // catch error.
                        print("catch error")
                        
                    }
                    break
                    
                case .failure(_):
                    print("failure")
                    let alert = UIAlertController(title: "Error :(", message: "Error while occured while uploading your photo to our server. Please try later.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction.init(title: "Oh No!", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                    break
                    
                }
                
                
            })
    }
    
}
