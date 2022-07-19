//
//  SideMenuContentData.swift
//  FootballNews
//
//  Created by LAP13606 on 19/07/2022.
//

import Foundation

struct SideMenuContentData {
    
    let contents: [[SideMenuModel]] = [
    
        [
            SideMenuModel(icon: nil, label: "Giải Đấu"),
            SideMenuModel(icon: nil, label: "Lịch thi đấu"),
            SideMenuModel(icon: nil, label: "Bảng xếp hạng"),
            SideMenuModel(icon: nil, label: "Tin nóng"),
            SideMenuModel(icon: nil, label: "Tin mới"),
            SideMenuModel(icon: nil, label: "Quan tâm"),
        ],
        
        [
            SideMenuModel(icon: nil, label: "Tài khoản"),
            SideMenuModel(icon: nil, label: "Chuyên mục quan tâm"),
            SideMenuModel(icon: nil, label: "Cài đặt"),
            SideMenuModel(icon: nil, label: "Góp ý"),
            SideMenuModel(icon: nil, label: "Điều khoản")
        ]
    
    ]
    
    let section: [String] = ["Nội dung", "Tiện ích"]
    
}
