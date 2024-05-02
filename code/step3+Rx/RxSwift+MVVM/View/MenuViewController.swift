//
//  ViewController.swift
//  RxSwift+MVVM
//
//  Created by iamchiwon on 05/08/2019.
//  Copyright © 2019 iamchiwon. All rights reserved.
//

import RxCocoa
import RxSwift
import RxViewController
import UIKit

private let cellIdentifier = "MenuItemTableViewCell"

class MenuViewController: UIViewController {
    
    // MARK: - Properties
    
    var viewModel = MenuListViewModel()
    var disposeBag = DisposeBag()
    
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.menuObservable
            .bind(to: tableView.rx.items(cellIdentifier: cellIdentifier, cellType: MenuItemTableViewCell.self)) { index, item, cell in
                
                cell.title.text = item.name
                cell.price.text = "\(item.price)"
                cell.count.text = "\(item.count)"
                
                cell.onChange = { [weak self] value in
                    self?.viewModel.changeCount(item: item, value: value)
                }

            }
        
        viewModel.totalPrice
            .map({$0.currencyKR()})
            .observeOn(MainScheduler.asyncInstance)
            .bind(to: totalPrice.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.itemCount
            .map({String($0)})
            .observeOn(MainScheduler.asyncInstance)
            .bind(to: itemCountLabel.rx.text)
            .disposed(by: disposeBag)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier ?? ""
        if identifier == "OrderViewController",
            let orderVC = segue.destination as? OrderViewController {
        }
    }


    func showAlert(_ title: String, _ message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertVC, animated: true, completion: nil)
    }


    // MARK: - InterfaceBuilder Links

    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var itemCountLabel: UILabel!
    @IBOutlet var totalPrice: UILabel!
    
    @IBAction func onClear(_ sender: Any) {
        viewModel.clearAllItemsSelection()
    }
    
    @IBAction func onOrder(_ sender: Any) {
//        performSegue(withIdentifier: "OrderViewController", sender: nil)
//        viewModel.menuObservable.onNext([
//            Menu(name: "고구마튀김", price: 500, count: Int.random(in: 1...5)),
//            Menu(name: "야채튀김", price: 500, count: Int.random(in: 1...5)),
//            Menu(name: "오징어튀김", price: 500, count: Int.random(in: 1...5)),
//            Menu(name: "감자튀김", price: 500, count: Int.random(in: 1...5)),
//            Menu(name: "새우튀김", price: 500, count: Int.random(in: 1...5)),
//        ])
        viewModel.onOrder()
    }
}

// MARK: - UITableViewDataSource

//extension MenuViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 10
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemTableViewCell") as! MenuItemTableViewCell
//
//        cell.title.text = "MENU \(indexPath.row)"
//        cell.price.text = "\(indexPath.row * 100)"
//        cell.count.text = "0"
//
//        return cell
//    }
//}






