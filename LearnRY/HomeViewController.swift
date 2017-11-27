//
// HomeViewController.swift
// LearnRY
//
// Created by Mudox on 13/11/2017.
// Copyright © 2017 Mudox. All rights reserved.
//

import UIKit
import iOSKit
import Eureka
import Moya
import JacKit
import RxSwift
import SwiftyJSON

fileprivate let jack = Jack.with(levelOfThisFile: .debug)

class HomeViewController: FormViewController
{
  var disposeBag = DisposeBag()

  override func viewDidLoad()
  {
    super.viewDidLoad()
    setupForm()
  }

  func setupForm()
  {
    form +++ Section(footer: "消息内容可以包含文字，图片，表情")
    <<< ButtonRow() { row in
      row.title = "聊天列表"
      row.onCellSelection { [unowned self] _, _ in
        self.startChat()
      }
    }

    form +++ Section("生成伪聊天记录")
    <<< ButtonRow("fakeChat") { row in
      row.title = "开始"
    }.onCellSelection { _, _ in
      FakeChat.toggle()
    }

    FakeChat.status.asObservable().subscribe(onNext: {
      [weak self] (status: FakeChat.Status) in
      guard let ss = self else { jack.warn("☯"); return }
      guard let row = ss.form.rowBy(tag: "fakeChat") else { return }

      switch status {
      case .notRunning:
        jack.info("not running", from: .custom("FakeChat.status"))
        row.title = "开始"
      case .cancelling:
        jack.info("cancelling", from: .custom("FakeChat.status"))
        row.title = "停止中 ..."
      case .running:
        jack.info("running", from: .custom("FakeChat.status"))
        row.title = "停止"
      }
      
      DispatchQueue.main.async {
         row.updateCell()
      }
     
    }).disposed(by: disposeBag)

  }

  func startChat() {

    if RCIM.shared().getConnectionStatus() == .ConnectionStatus_Connected {
      jack.debug("already connected to server")

      DispatchQueue.main.async { [weak self] in
        guard let ss = self else { jack.warn("☯"); return }
        let vc = TopChatListViewController()
        ss.show(vc, sender: ss)
      }
      return
    }

    jack.debug("connect to server")
    RYManager.shared.currentUserToken
      .asObservable()
      .flatMapLatest { token in
        return RYManager.shared.connectToServer(with: token)
      }
      .asCompletable()
      .subscribe(
        onCompleted: {
          DispatchQueue.main.async { [weak self] in
            guard let ss = self else { jack.warn("☯"); return }
            let vc = TopChatListViewController()
            ss.show(vc, sender: ss)
          }
        },
        onError: { error in
          jack.error("enter chat list failed with:\n\(error)")
        })
      .disposed(by: disposeBag)
  }
}




