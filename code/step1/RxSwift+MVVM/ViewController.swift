//
//  ViewController.swift
//  RxSwift+MVVM
//
//  Created by iamchiwon on 05/08/2019.
//  Copyright © 2019 iamchiwon. All rights reserved.
//

import RxSwift
import SwiftyJSON
import UIKit

let MEMBER_LIST_URL = "https://my.api.mockaroo.com/members_with_avatar.json?key=44ce18f0"

class ViewController: UIViewController {
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var editView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.timerLabel.text = "\(Date().timeIntervalSince1970)"
        }
    }

    private func setVisibleWithAnimation(_ v: UIView?, _ s: Bool) {
        guard let v = v else { return }
        UIView.animate(withDuration: 0.3, animations: { [weak v] in
            v?.isHidden = !s
        }, completion: { [weak self] _ in
            self?.view.layoutIfNeeded()
        })
    }

    // MARK: SYNC
    
    func downloadJson(_ url: String) -> Observable<String?> {
        
        Observable.create { emitter in
            let url = URL(string: MEMBER_LIST_URL)!
            let task = URLSession.shared.dataTask(with: url) { data, response, err in
                guard err == nil else {
                    emitter.onError(err!)
                    return
                }
                if let data = data {
                    let json = String(data: data, encoding: .utf8)
                    emitter.onNext(json)
                }
                // 위에 리턴이 없으니 얘는 무조건 불림
//                emitter.onCompleted()
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }

    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    @IBAction func onLoad() {
        editView.text = ""
        setVisibleWithAnimation(activityIndicator, true)

        let observable: Observable<String?> = downloadJson(MEMBER_LIST_URL)

        let disposable = observable
            .debug()
            .subscribe { event in
            switch event {
            case .next(let json):
                DispatchQueue.main.async {
                    self.editView.text = json
                    self.setVisibleWithAnimation(self.activityIndicator, false)
                }
            case .error(let err):
                print(err.localizedDescription)
            case .completed: break
            }
        }
    }
}
