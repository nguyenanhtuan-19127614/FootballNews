//
//  SideMenuViewController.swift
//  FootballNews
//
//  Created by LAP13606 on 16/07/2022.
//

import UIKit

class SideMenuViewController: UIViewController {
    
    let sideMenuData = SideMenuContentData()
    
    var cellNumbers = 0
    var sectionNumbers = 0
    var isShow = false

    let sideMenuLayout = UICollectionViewFlowLayout()
    
    let sideMenuCollection: UICollectionView = {
        
        let sideMenuCollection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        sideMenuCollection.backgroundColor = UIColor.white
        sideMenuCollection.contentInsetAdjustmentBehavior = .always
        //Cell
        sideMenuCollection.register(SideMenuCell.self, forCellWithReuseIdentifier: "SideMenuCell")
        sideMenuCollection.register(AppInfoCell.self, forCellWithReuseIdentifier: "AppInfoCell")
        sideMenuCollection.register(HeaderCell.self, forCellWithReuseIdentifier: "HeaderCell")
        
        //Section
        sideMenuCollection.register(SideMenuCellHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SideMenuCellHeader")
        sideMenuCollection.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "EmptyHeader")
        
        return sideMenuCollection
        
    }()
  
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = .white
       
        //Number of cell
        
        // 2 is Icon Cell and Info Cell
        sectionNumbers = sideMenuData.section.count + 2
        
        //Collection
        sideMenuLayout.sectionInsetReference = .fromSafeArea
        sideMenuLayout.minimumLineSpacing = 0
    
        sideMenuCollection.collectionViewLayout = sideMenuLayout
        sideMenuCollection.delegate = self
        sideMenuCollection.dataSource = self
        
        //Add subview and layout
        addSubviews()
        addLayout()
        
    }

    func addSubviews() {
        
        self.view.addSubview(sideMenuCollection)
       
    }
    
    func addLayout() {
        
        sideMenuCollection.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([

            sideMenuCollection.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            sideMenuCollection.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            sideMenuCollection.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            sideMenuCollection.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
            
        ])
     
    }
    
   
    func show() {
        
        var frame = view.frame
        frame.origin.x = 0
        UIView.animate(withDuration: 0.3,
                       delay: 0.0,
                       options: .transitionFlipFromLeft,
                       animations: {[unowned self] in
            self.view.frame = frame
        }, completion: nil)
       
        isShow = true
 
    }
    
    func hide() {
        
        var frame = view.frame
        frame.origin.x = -frame.size.width
        UIView.animate(withDuration: 0.3,
                       delay: 0.0,
                       options: .transitionFlipFromRight,
                       animations: {[unowned self] in
            self.view.frame = frame
        }, completion: nil)
        
        isShow = false
    }
    
}

extension SideMenuViewController: UICollectionViewDelegate {
    
}

extension SideMenuViewController: UICollectionViewDataSource {
    
    //Section Number
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return sectionNumbers
        
    }
    //Cell for each Section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 || section == sectionNumbers - 1 {
            return 1
        }
        
        return sideMenuData.contents[section - 1].count
        
    }
    
    //Cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            
            guard let headerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeaderCell", for: indexPath) as? HeaderCell else {
                
                return UICollectionViewCell()
                
            }
            
            headerCell.iconApp.image = UIImage(named: "IconApp")
           
            return headerCell
            
        } else if indexPath.section == sectionNumbers - 1 {
            
            guard let infoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AppInfoCell", for: indexPath) as? AppInfoCell else {
                
                return UICollectionViewCell()
                
            }
            
            return infoCell
            
        }
        
        guard let sideMenuCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SideMenuCell", for: indexPath) as? SideMenuCell else {

            return UICollectionViewCell()
            
        }
        
        sideMenuCell.loadData(data: sideMenuData.contents[indexPath.section-1][indexPath.row])
      
        return sideMenuCell
      
    }
    
    //Section
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if indexPath.section == 0 || indexPath.section == sectionNumbers - 1 {
            
            let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "EmptyHeader", for: indexPath)
        
            return sectionHeader
                
        }
        if (kind == UICollectionView.elementKindSectionHeader) {
            
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SideMenuCellHeader", for: indexPath) as? SideMenuCellHeader else {
                
                return UICollectionReusableView()
                
            }
            
            sectionHeader.headerLabel.text = sideMenuData.section[indexPath.section-1]
            
            return sectionHeader
            
        }
        
        return UICollectionReusableView()
        
    }
   
}

extension SideMenuViewController: UICollectionViewDelegateFlowLayout {
    
    //Cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
     
        let totalWidth = collectionView.frame.width
        let totalHeight = collectionView.frame.height
        
        if indexPath.section == 0 {
            
            return CGSize(width: totalWidth,
                          height: totalHeight/8)
            
        } else if indexPath.section == sectionNumbers - 1 {
            
            return CGSize(width: totalWidth,
                          height: totalHeight/5)
            
        }
        
        return CGSize(width: totalWidth - 20,
                      height: totalHeight/15)
        
    }
    
    //Section size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let totalWidth = collectionView.frame.width
        let totalHeight = collectionView.frame.height
        
        if section == 0 || section == sectionNumbers - 1 {
            
            return CGSize(width: 0,
                          height: 0)
            
        }
        
        return CGSize(width: totalWidth,
                      height: totalHeight/15)
        
    }
}
