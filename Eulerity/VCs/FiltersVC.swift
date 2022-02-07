//
//  FiltersVC.swift
//  Eulerity
//
//  Created by Rahul Pawar on 2/7/22.
//

import UIKit


class FiltersVC: UIViewController {
    struct Filter {
        let filterName : String
        var filterEffectValue: Any?
        var filterEffectValueName: String?
        
        init(filterName: String, filterEffectValue: Any?, filterEffectValueName: String?){
            self.filterName = filterName
            self.filterEffectValue = filterEffectValue
            self.filterEffectValueName = filterEffectValueName
        }
        
        
    }
    var effectsArray = ["Normal","Vivid", "Vibrance", "Vignette", "Sepia", "Bnw1", "Bnw2", "Postcard", "Musty", "Hue", "RGB Tune", "Crazy", "Invert"]
    
    var effectsImageArray = [UIImage(named: "None")!,UIImage(named: "Vivid")!,UIImage(named: "Vibrance")!,UIImage(named: "Vignette")!,UIImage(named: "Sepia")!,UIImage(named: "Bnw1")!,UIImage(named: "Bnw2")!,UIImage(named: "Postcard")!,UIImage(named: "Musty")!,UIImage(named: "Hue")!,UIImage(named: "RGBTune")!,UIImage(named: "Crazy")!,UIImage(named: "Invert")!]

    //var sharedImage: UIImage?
    
    let userDefaults = UserDefaults.standard
    
    let myImageURL = UserDefaults.standard.value(forKey: "imageURL") as! String
    
    private var originalImage: UIImage?
    
    let uploadURL = UserDefaults.standard.value(forKey: "uploadURL") as! String
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var filterNameLabel: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var imageBackView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //imageView.image = sharedImage
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "FiltersCollectionCell", bundle: nil), forCellWithReuseIdentifier: "filterCell")
        
        imageView.sd_setImage(with: URL(string: myImageURL), completed: nil)
        originalImage = imageView.image
        
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
    
    
    
    private func applyFilter(image: UIImage, filterEffect: Filter) -> UIImage?{
        guard let cgImage = image.cgImage, let openGLContext = EAGLContext(api: .openGLES3) else {return nil}
        let context = CIContext(eaglContext: openGLContext)
        let ciImage = CIImage(cgImage: cgImage)
        let filter = CIFilter(name: filterEffect.filterName)
        
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        if let filteEffectValue = filterEffect.filterEffectValue,
           let filterEffectValueName = filterEffect.filterEffectValueName{
            filter?.setValue(filteEffectValue, forKey: filterEffectValueName)
        }
        
        var filteredImage: UIImage?
        
        if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage,
           let cgiImageResult = context.createCGImage(output, from: output.extent){
            filteredImage = UIImage(cgImage: cgiImageResult)
        }
        
        
        return filteredImage
    }
    
    //MARK:- Filter Functions
    func none(){
        guard let image = imageView.image else {return}
        imageView.image = originalImage
        
    }
    func vivid(){
        guard let image = imageView.image else {return}
        imageView.image = applyFilter(image: image, filterEffect: Filter(filterName: "CIPhotoEffectChrome", filterEffectValue: nil, filterEffectValueName: nil))
    }
    
    func vibrance(){
        
        guard let image = imageView.image else {return}
        imageView.image = applyFilter(image: image, filterEffect: Filter(filterName: "CIVibrance", filterEffectValue: 1, filterEffectValueName: kCIInputAmountKey))
    }
    
    func vignette(){
        
        guard let image = imageView.image else {return}
        imageView.image = applyFilter(image: image, filterEffect: Filter(filterName: "CIVignette", filterEffectValue: 3, filterEffectValueName: kCIInputIntensityKey))
    }
    
    func sepia(){
        guard let image = imageView.image else {return}
        imageView.image = applyFilter(image: image, filterEffect: Filter(filterName: "CISepiaTone", filterEffectValue: 0.7, filterEffectValueName: kCIInputIntensityKey))
    }
    
    func bnW1(){
        guard let image = imageView.image else {return}
        imageView.image = applyFilter(image: image, filterEffect: Filter(filterName: "CIPhotoEffectNoir", filterEffectValue: nil, filterEffectValueName: nil))
    }
    
    func bnW2(){
        guard let image = imageView.image else {return}
        imageView.image = applyFilter(image: image, filterEffect: Filter(filterName: "CIPhotoEffectMono", filterEffectValue: nil, filterEffectValueName: nil))
    }
    
    func postcard(){
        guard let image = imageView.image else {return}
        
        imageView.image = applyFilter(image: image, filterEffect: Filter(filterName: "CIPhotoEffectProcess", filterEffectValue: nil, filterEffectValueName: nil))
    }
    
    func musty(){
        guard let image = imageView.image else {return}
        imageView.image = applyFilter(image: image, filterEffect: Filter(filterName: "CISepiaTone", filterEffectValue: 1, filterEffectValueName: kCIInputIntensityKey))
    }
    
    func hue(){
        guard let image = imageView.image else {return}
        imageView.image = applyFilter(image: image, filterEffect: Filter(filterName: "CIHueAdjust", filterEffectValue: 1, filterEffectValueName: kCIInputAngleKey))
    }
    
    func rgbTune(){
        guard let image = imageView.image else {return}
        imageView.image = applyFilter(image: image, filterEffect: Filter(filterName: "CISRGBToneCurveToLinear", filterEffectValue: nil, filterEffectValueName: nil))
    }
    
    func crazy(){
        guard let image = imageView.image else {return}
        imageView.image = applyFilter(image: image, filterEffect: Filter(filterName: "CISepiaTone", filterEffectValue: 5, filterEffectValueName: kCIInputIntensityKey))
    }
    
    func invert(){
        guard let image = imageView.image else {return}
        imageView.image = applyFilter(image: image, filterEffect: Filter(filterName: "CIColorInvert", filterEffectValue: nil, filterEffectValueName: nil))
    }
   
    @IBAction func nextBtnPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToEffectsVC", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let image = imageView.image

        if segue.identifier == "goToEffectsVC"{
            let destinationVC = segue.destination as! EffectsVC

            destinationVC.sharedImage = image

        }
        
    }

}

extension FiltersVC: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        print(effectsArray[indexPath.row])
        
        
        if indexPath.row == 0 {
            none()
            filterNameLabel.text = effectsArray[0]
        } else if indexPath.row == 1{
            vivid()
            filterNameLabel.text = effectsArray[1]
        } else if indexPath.row == 2{
            vibrance()
            filterNameLabel.text = effectsArray[2]
        } else if indexPath.row == 3{
            vignette()
            filterNameLabel.text = effectsArray[3]
        } else if indexPath.row == 4{
            sepia()
            filterNameLabel.text = effectsArray[4]
        } else if indexPath.row == 5{
            bnW1()
            filterNameLabel.text = effectsArray[5]
        } else if indexPath.row == 6{
            bnW2()
            filterNameLabel.text = effectsArray[6]
        } else if indexPath.row == 7{
            postcard()
            filterNameLabel.text = effectsArray[7]
        } else if indexPath.row == 8{
            musty()
            filterNameLabel.text = effectsArray[8]
        } else if indexPath.row == 9{
            hue()
            filterNameLabel.text = effectsArray[9]
        } else if indexPath.row == 10{
            rgbTune()
            filterNameLabel.text = effectsArray[10]
        } else if indexPath.row == 11{
            crazy()
            filterNameLabel.text = effectsArray[11]
        } else if indexPath.row == 12{
            invert()
            filterNameLabel.text = effectsArray[12]
        } else {
            imageView.image = originalImage
        }
        
    }
    
}

extension FiltersVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return effectsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterCell", for: indexPath) as! FiltersCollectionCell
        
        cell.imageView.image = effectsImageArray[indexPath.row]
        cell.filterNameLabel.text = effectsArray[indexPath.row]
//        cell.col.text = effectsArray[indexPath.row]
//        cell.imageView.image = effectsImageArray[indexPath.row]
       // self.filterNameLabel.text = effectsArray[indexPath.row]
        
        
        return cell
    }
    
    
    
    
}
