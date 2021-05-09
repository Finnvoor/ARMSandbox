//
//  LessonsCollectionViewController.swift
//  ARMSandbox
//
//  Created by Finn Voorhees on 10/03/2021.
//

import UIKit

class LessonsCollectionViewController: UICollectionViewController {
    private let reuseIdentifier = "LessonCell"
    private let itemsPerRow = 4
    private let sectionInsets = UIEdgeInsets(
      top: 30.0,
      left: 30.0,
      bottom: 30.0,
      right: 30.0
    )
    
    var lessons = Lesson.allLessons
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nav = segue.destination as? UINavigationController,
           let addVC = nav.topViewController as? AddViewController {
            addVC.lessonsVC = self
        }
    }
}

// MARK: - UICollectionViewDelegate
extension LessonsCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mainViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        mainViewController.modalPresentationStyle = .fullScreen
        mainViewController.lesson = self.lessons[indexPath.row]
        self.present(mainViewController, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension LessonsCollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.lessons.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseIdentifier, for: indexPath) as! LessonCollectionViewCell
        cell.lesson = self.lessons[indexPath.row]
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension LessonsCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = self.sectionInsets.left * CGFloat(self.itemsPerRow + 1)
        let availableWidth = self.view.frame.width - paddingSpace
        let widthPerItem = availableWidth / CGFloat(self.itemsPerRow)
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return self.sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.sectionInsets.left
    }
}
