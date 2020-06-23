//
//  ViewModel.swift
//  HomeworkDay4
//
//  Created by Fumiaki Kobayashi on 2020/06/08.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public class ViewModel {
    private let apiClient: APIClient
    //データ用
    private let dataEventSubject = PublishSubject<[GitHubData]>()
    public var gitHubDataArray: Driver<[GitHubData]> {return dataEventSubject.asDriver(onErrorJustReturn: [])}
    //くるくる用
    private let indicatorEventSubject = PublishSubject<Bool>()
    public var indicatorStatus: Driver<Bool> {return indicatorEventSubject.asDriver(onErrorDriveWith: .empty())}
    //アラート用
    private let alertEventSubject = PublishSubject<Bool>()
    public var alertStatus: Driver<Bool> {return alertEventSubject.asDriver(onErrorDriveWith: .empty())}
    //disposeBag
    private var disposeBag = DisposeBag()
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    func requestData() {
        //くるくるさせる
        indicatorEventSubject.onNext(true)
        //Retryを押された時に一旦falseにする
        alertEventSubject.onNext(false)
        //URL定義
        guard let url = URL(string: "https://api.github.com/search/repositories?q=language%3Aswift&sort=stars")
            else {
                fatalError("url is nil")
        }
        disposeBag = DisposeBag()
        //API通信 
        apiClient.getData(url: url)
            .subscribe(onSuccess: { [weak self] data in
                self?.indicatorEventSubject.onNext(false)
                self?.dataEventSubject.onNext(data)
                }, onError: { [weak self] error in
                    self?.indicatorEventSubject.onNext(false)
                    self?.alertEventSubject.onNext(true)
                    print(error)
            })
            .disposed(by: disposeBag)
    }
}
