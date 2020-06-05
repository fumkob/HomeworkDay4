//
//  ViewController.swift
//  HomeworkDay4
//
//  Created by Fumiaki Kobayashi on 2020/05/22.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import UIKit

public protocol ViewInterface: class {
    func reload()
    func startIndicator()
    func stopIndicator()
    func presentAlert()
}

class ViewController: UIViewController {
    private var presenter: Presenter!
    private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        //インジケータ設定
        indicatorSetting()
        //テーブル設定
        tableSetting()
        //presenter設定
        presenter = Presenter(client: APIClient(), view: self)
        //APIデータ取得
        presenter.requestData()
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
    //テーブル設定
    private func tableSetting() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "GitHubCell", bundle: nil), forCellReuseIdentifier: "cell")
        //高さ調整
        tableView.estimatedRowHeight = 195
        tableView.rowHeight = UITableView.automaticDimension
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    //テーブルセル数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.gitHubDataArray.count
    }
    //テーブル内データ->GitHubCellを適用
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? GitHubCell else { abort() }
        //表示内容を取得
        cell.displaySetting(data: presenter.gitHubDataArray[indexPath.row])
        return cell
    }
}

extension ViewController: ViewInterface {
    public func reload() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    public func startIndicator() {
        activityIndicator.startAnimating()
    }
    public func stopIndicator() {
        activityIndicator.stopAnimating()
    }
    public func presentAlert() {
        let alert = UIAlertController.apiAlert(title: "Error", message: "The internet connection appeared to be offline.", preferredStyle: .alert, retryHandler: { (_ : UIAlertAction) -> Void in
            self.presenter.requestData()
        })
        self.present(alert, animated: true, completion: nil)
    }
}
