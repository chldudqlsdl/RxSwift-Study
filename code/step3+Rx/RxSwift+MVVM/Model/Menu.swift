//
//  Menu.swift
//  RxSwift+MVVM
//
//  Created by Youngbin Choi on 5/1/24.
//  Copyright © 2024 iamchiwon. All rights reserved.
//

import Foundation

struct Menu {
    let id: UUID
    let name: String
    let price: Int
    let count: Int
    
    init(id: UUID = UUID(),name: String, price: Int, count: Int) {
        self.id = id
        self.name = name
        self.price = price
        self.count = count
    }
}

extension Menu {
    static func menuItemToMenu(menuItem: MenuItem) -> Menu {
        return Menu(name: menuItem.name, price: menuItem.price, count: 0)
    }
}
