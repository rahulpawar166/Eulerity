//
//  FiltersCollectionCell.swift
//  Eulerity
//
//  Created by Rahul Pawar on 2/6/22.
//

import UIKit

class FiltersCollectionCell: UICollectionViewCell {
    @IBOutlet weak var imageBackView: UIView!
    @IBOutlet weak var filterNameLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageBackView.layer.cornerRadius = 10.0
        imageBackView.clipsToBounds = true
        
    }

}
