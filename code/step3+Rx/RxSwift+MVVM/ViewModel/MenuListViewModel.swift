//
//  MenuListViewModel.swift
//  RxSwift+MVVM
//
//  Created by Youngbin Choi on 5/1/24.
//  Copyright © 2024 iamchiwon. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MenuListViewModel {
                
    lazy var menuObservable = BehaviorRelay<[Menu]>(value: [])
    
    lazy var totalPrice = menuObservable
        .debug()
        .map { menus in
        menus.map {$0.price * $0.count}.reduce(0, +)
    }
    lazy var itemCount = menuObservable
        .debug()
        .map { menus in
        menus.map {$0.count}.reduce(0, +)
    }
    
    init() {
        let observable = APIService.fetchAllMenus()
            .debug()
            .map { data in
                struct Response: Decodable {
                    let menus: [MenuItem]
                }
                guard let response = try? JSONDecoder().decode(Response.self, from: data) else {
                    throw NSError(domain: "Decoding error", code: -1, userInfo: nil)
                }
                return response.menus
            }
            .map { menuItems in
                return menuItems.map { Menu.menuItemToMenu(menuItem: $0) }
            }
            .take(1)
            .bind(to: menuObservable)
    }
    
    
    func clearAllItemsSelection() {
       menuObservable
            .map { menus in
                menus.map { menu in
                    return Menu(name: menu.name, price: menu.price, count: 0)
                }
            }
            .take(1)
            .subscribe(onNext: { self.menuObservable.accept($0)})
    }
    
    func changeCount(item: Menu, value: Int) {
        menuObservable
            .debug()
            .map { menus in
                return menus.map { menu in
                    if menu.id == item.id {
                        let newValue = max(menu.count + value, 0)
                        return Menu(id: menu.id, name: menu.name, price: menu.price, count: newValue)
                    } else {
                        return Menu(id: menu.id, name: menu.name, price: menu.price, count: menu.count)
                    }
                }
            }
            .take(1)
            .subscribe(onNext: { self.menuObservable.accept($0)})
    }
    
    func onOrder(){
    }
}



