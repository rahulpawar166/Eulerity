//
//  MyCollectionViewCell.swift
//  Eulerity
//
//  Created by Rahul Pawar on 2/5/22.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var cellView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        cellView.layer.cornerRadius = 10
//        cellView.clipsToBounds =  true
    }

}
