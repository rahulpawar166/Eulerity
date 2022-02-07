//
//  EffectsVC.swift
//  Eulerity
//
//  Created by Rahul Pawar on 2/5/22.
//

import UIKit
import SDWebImage
import Alamofire
import Mantis
import Sketch
import PhotoRoomKit
import NVActivityIndicatorView




class EffectsVC: UIViewController, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var sketchView: SketchView!
    let imageURL = UserDefaults.standard.value(forKey: "imageURL") as! String
    
    var sharedImage: UIImage?
    
   
    
    var isDrawing: Bool = false
    
    let myImageURL = UserDefaults.standard.value(forKey: "imageURL") as! String
    
    
    
    
    @IBOutlet weak var colorSelectorBtn: UIButton!
    
   
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageBackView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textOverlayBtn: UIButton!
    @IBOutlet weak var drawBtn: UIButton!
    @IBOutlet weak var cropBtn: UIButton!
   
    
    @IBOutlet weak var saveSketchBtn: UIButton!
    @IBOutlet weak var undoBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet weak var undo_clear_stack: UIStackView!
    @IBOutlet weak var clearBtn: UIButton!
    
    @IBOutlet weak var bgRemoverBtn: UIButton!
    var color = UIColor.red
    
    let userDefaults = UserDefaults.standard
    
    private var originalImage: UIImage?
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        
        hideKeyboardWhenTappedAround()
        
        sketchView.isHidden = true
        undo_clear_stack.alpha = 0
        scrollView.delegate = self
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 3.0
        
        imageView.image = sharedImage
        
        
        
        originalImage = sharedImage
        
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    @objc func handlePan(sender: UIPanGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            let translate = sender.translation(in: sender.view)
            let changeX = (sender.view?.center.x)! + translate.x
            let changeY = (sender.view?.center.y)! + translate.y
            
            sender.view?.center = CGPoint(x: changeX, y: changeY)
            sender.setTranslation(CGPoint.zero, in: sender.view)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        UINavigationBarAppearance().backgroundColor = .clear
        UITabBarAppearance().backgroundColor = .clear
        
        
        self.navigationController?.navigationBar.barTintColor = UIColor.white
    }
    
    
    
   
    
    
    @IBAction func colorSelectorBtnPressed(_ sender: UIButton) {
        let colorPickerVC = UIColorPickerViewController()
        colorPickerVC.delegate = self
        present(colorPickerVC, animated: true, completion: nil)
        undo_clear_stack.alpha = 0
        sketchView.isHidden = true

    }
    
    
    @IBAction func textOverlayBtnPressed(_ sender: Any) {
        sketchView.isHidden = true
        createTextView()
        
        undo_clear_stack.alpha = 0
    }
    
    func createTextView(){
        
        
        let textField = UITextField(frame: CGRect(x: 20, y: 30, width: 200, height: 50))
        textField.font = UIFont(name: "Arial", size: 20)
        textField.font = UIFont.systemFont(ofSize: 20.0, weight: .bold)
        
        
        //textView.translatesAutoresizingMaskIntoConstraints = false
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.textColor = color
        textField.tintColor = color
        textField.backgroundColor = .clear
        //textField.isScrollEnabled = false
        textField.becomeFirstResponder()
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(sender:)))
        textField.addGestureRecognizer(pan)
        imageView.addSubview(textField)
    }
   
    
    @IBAction func cropBtnPressed(_ sender: UIButton) {
        guard let image = imageView.image else {return}
        let cropViewController = Mantis.cropViewController(image: image)
        cropViewController.view.backgroundColor = UIColor(named: "darkBlueC")
            cropViewController.delegate = self
        self.present(cropViewController, animated: true)
        undo_clear_stack.alpha = 0
        sketchView.isHidden = true
    }
    
    @IBAction func drawBtnPressed(_ sender: UIButton) {
        
        isDrawing.toggle()

        if isDrawing{
            sketchView.isHidden = false
            undo_clear_stack.alpha = 1
            
        } else{
            sketchView.isHidden = true
            undo_clear_stack.alpha = 0
        }
        sketchView.tintColor = color
        sketchView.lineColor = color
       
        
        
    }
    @IBAction func undoBtnPressed(_ sender: UIButton) {
        sketchView.undo()
    }
    
    @IBAction func clearSketchBtnPressed(_ sender: UIButton) {
        sketchView.clear()
    }
    
    @IBAction func saveSketchBtnPressed(_ sender: UIButton) {
      let newSketchedImage = createImage(view: imageBackView)
        imageView.image = newSketchedImage
        undo_clear_stack.alpha = 0
    }
    
    
    @IBAction func bgRemoverBtnPressed(_ sender: UIButton) {
        guard let image = imageView.image else {return}
        
        removeBackground(image as! UIImage)
    }
    
    func removeBackground(_ originalImage: UIImage) {
        let controller = PhotoRoomViewController(image: originalImage,
                                                           apiKey: "4b53d330c6d24a3e6fd022986fa94110eba322a0") { [weak self] image in
            self?.onImageEdited(image)

        }
        present(controller, animated: true)
    }
    
    func onImageEdited(_ editedImage: UIImage) {
        // Handle your segmented image
        imageView.image = editedImage
    }
    
    @IBAction func nextBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToShareVC", sender: self)
        
 
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let image = createImage(view: imageBackView)

        if segue.identifier == "goToShareVC"{
            let destinationVC = segue.destination as! ShareVC

            destinationVC.shareImage = image

        }
        
    }
    
    func createImage(view: UIView) -> UIImage {

            let rect: CGRect = view.frame
            
            UIGraphicsBeginImageContext(rect.size)
            let context: CGContext = UIGraphicsGetCurrentContext()!
            view.layer.render(in: context)
            let img = UIGraphicsGetImageFromCurrentImageContext() as! UIImage
            UIGraphicsEndImageContext()
            
            return img

        }
    
    @IBAction func revertBtnPressed(_ sender: UIButton) {
        imageView.image = originalImage
       
    }
    

    
    
}

extension EffectsVC: UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
}

extension EffectsVC: UIColorPickerViewControllerDelegate, UITextViewDelegate{
    
    
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        let color = viewController.selectedColor
        self.colorSelectorBtn.tintColor = color
        self.color = color
        
        //self.createTextView()

    }
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        let color  = viewController.selectedColor
        
    }
    
}

extension EffectsVC: CropViewControllerDelegate{
    func cropViewControllerDidCrop(_ cropViewController: CropViewController, cropped: UIImage, transformation: Transformation, cropInfo: CropInfo){
        self.imageView.image = cropped
        self.dismiss(animated: true)
    }
    func cropViewControllerDidCancel(_ cropViewController: CropViewController, original: UIImage){
        self.dismiss(animated: true)
    }
        
      
        
}



