//
//  ViewController.swift
//  RXSwiftTrainProject
//
//  Created by Евгений Тимофеев on 22.05.2022.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    
    var names = BehaviorRelay(value: ["Name"])
    
    var bag = DisposeBag() //позволяет избежать Retain cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        names.asObservable()
            .throttle(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .filter({ value in
                value.count > 1 // вот тут смотреть!!!
            })
            .map({ value in
                value.joined(separator: ",")
            })
            .subscribe(onNext: { [weak self] value in
            self?.label.text = value
        }).disposed(by: bag)
        

        names.accept(["Alex", "Maria", "Bob"])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute:  { [weak self] in
            self?.names.accept(["Anatoliy"]) //данный блок кода выполнен не будет, тк мы подписаны на условие, которое описывает обновление лейбла в том случае, если мы имеем более одного элемента в массиве (смотреть выше)
        })
        
    }
}

