//
//  ViewController.swift
//  RxSwiftSimpleList
//
//  Created by KawaiTakeshi on 2016/01/28.
//  Copyright © 2016年 Takeshi Kawai. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

struct Item {
    let title: String
    let content: String
}

/**
    Model
*/
struct ItemModel {
    let items: Variable<[Item]> = Variable<[Item]>(
        [Item(title: "hoge", content: "hoge content"),
        Item(title: "huga", content: "fuga content")]
    )
}

/**
    ViewModel
*/
struct ItemsViewModel {
    let itemModel = ItemModel()
    let myItems:Observable<[String]>
    
    init() {
        myItems = itemModel.items.asObservable()
            .map({ someArrayOfItems in
                return someArrayOfItems.map {$0.content}
            })
    }
}

/**
     View
*/
class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let itemsViewModel = ItemsViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemsViewModel.myItems
            .bindTo(tableView.rx_itemsWithCellIdentifier("itemListCell")) { ( row, element, cell) in
                
                guard let myCell: UITableViewCell = cell else {
                    return
                }
                
                myCell.textLabel?.text = element
        }.addDisposableTo(disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}