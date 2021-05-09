//
//  LessonCollectionViewCell.swift
//  ARMSandbox
//
//  Created by Finn Voorhees on 10/03/2021.
//

import UIKit

class LessonCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var lesson: Lesson? {
        didSet {
            if let lesson = self.lesson {
                self.titleLabel.text = lesson.title
                self.imageView.image = lesson.image
            }
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.contentView.layer.cornerRadius = 15
        self.contentView.layer.masksToBounds = true
        
        self.layer.backgroundColor = UIColor.clear.cgColor
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 3
        self.layer.masksToBounds = false
        self.layer.shadowOpacity = 0.5
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.shadowPath = UIBezierPath(
            roundedRect: self.bounds,
            cornerRadius: self.contentView.layer.cornerRadius
        ).cgPath
    }
}
