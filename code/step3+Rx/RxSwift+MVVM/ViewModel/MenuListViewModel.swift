//
//  MenuListViewModel.swift
//  RxSwift+MVVM
//
//  Created by Youngbin Choi on 5/1/24.
//  Copyright © 2024 iamchiwon. All rights reserved.
//

import Foundation
import RxSwift

class MenuListViewModel {
    
    let menus: [Menu] = [
        Menu(name: "고구마튀김", price: 500, count: 1),
        Menu(name: "야채튀김", price: 500, count: 1),
        Menu(name: "오징어튀김", price: 500, count: 1),
        Menu(name: "감자튀김", price: 500, count: 1),
        Menu(name: "새우튀김", price: 500, count: 1)
    ]
    
    lazy var menuObeservable = BehaviorSubject(value: menus)
    
    lazy var totalPrice = menuObeservable.map { menus in
        menus.map {$0.price * $0.count}.reduce(0, +)
    }
    lazy var itemCount = menuObeservable.map { menus in
        menus.map {$0.count}.reduce(0, +)
    }
    
    func clearAllItemsSelection() {
       menuObeservable
            .map { menus in
                menus.map { menu in
                    Menu(name: menu.name, price: menu.price, count: 0)
                }
            }
            .take(1)
            .subscribe(onNext: { self.menuObeservable.onNext($0) })
        

    }
    
}
