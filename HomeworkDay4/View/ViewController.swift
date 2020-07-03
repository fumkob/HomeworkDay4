//
//  ViewController.swift
//  HomeworkDay4
//
//  Created by Fumiaki Kobayashi on 2020/05/22.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    private var viewModel: ViewModel!
    private var activityIndicator: UIActivityIndicatorView!
    private let disposeBag = DisposeBag()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //ViewModel設定
        viewModelSetting()
        //インジケータ設定
        indicatorSetting()
        //インジケータ表示設定
        indicatorDisplaySetting()
        //テーブル設定
        tableSetting()
        //アラート表示設定
        alertSetting()
        //データやり取り->テーブルに設定
        dataSetting()
    }

    //ViewModel設定
    private func viewModelSetting() {
        self.viewModel = ViewModel(apiClient: APIClient())
    }
    //インジゲータ設定
    private func indicatorSetting() {
        //読み込み用インジケーター表示
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.center = self.view.center
        //非表示設定
        activityIndicator.hidesWhenStopped = true
        //viewに追加
        self.view.addSubview(activityIndicator)
    }
    //インジケータ表示設定
    private func indicatorDisplaySetting() {
        let indicatorStatus = self.viewModel.indicatorStatus
        indicatorStatus
            .drive(self.activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
    }
    //テーブル設定
    private func tableSetting() {
        tableView.register(UINib(nibName: "GitHubCell", bundle: nil), forCellReuseIdentifier: "cell")
        //高さ調整
        tableView.estimatedRowHeight = 195
        tableView.rowHeight = UITableView.automaticDimension
    }
    //アラート表示設定
    private func alertSetting() {
        let alertStatus = self.viewModel.alertStatus
        alertStatus
            .drive(onNext: { [weak self] in
                //trueが流れてきたらアラート表示
                guard $0 else { return }
                let alert
                    = UIAlertController.apiAlert(title: "Error", message: "The internet connection appeared to be offline.", preferredStyle: .alert, retryHandler: { (_ : UIAlertAction) -> Void in
                        self?.viewModel.requestData()
                    })
                self?.present(alert, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    //データやり取り->テーブルに設定
    private func dataSetting() {
        self.viewModel.requestData()
        let gitHubDataArray = self.viewModel.gitHubDataArray
        gitHubDataArray
            .drive(tableView.rx.items) {tableView, _, data in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? GitHubCell else { abort() }
                cell.displaySetting(data: data)
                return cell
            }
            .disposed(by: disposeBag)
    }
}
