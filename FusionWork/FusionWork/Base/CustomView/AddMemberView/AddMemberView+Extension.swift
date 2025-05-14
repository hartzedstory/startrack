//
//  AddMemberView+Extension.swift
//  FusionWork
//
//  Created by HartzedStory on 5/13/25.
//

import Foundation
import UIKit

extension AddMemberView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.viewModel.memberList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MemberCell
        cell.bindingData(item: self.viewModel.memberList[indexPath.item])
        cell.onDelete = { [weak self] in
            guard let self = self else { return }
            self.viewModel.memberIDSelected.remove(at: indexPath.item)
            self.viewModel.memberList.remove(at: indexPath.item)
            self.collectionView.reloadData()
        }
        return cell
    }
    
    
}

