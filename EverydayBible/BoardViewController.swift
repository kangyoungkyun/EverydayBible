//
//  BoardViewController.swift
//  EverydayBible
//
//  Created by MacBookPro on 2018. 3. 4..
//  Copyright © 2018년 MacBookPro. All rights reserved.

import UIKit

class BoardViewController: UIViewController {
    
    var text:Text?{
        didSet{
            //줄 간격 객체
            let paragraphStyle = NSMutableParagraphStyle()
            //줄 높이
            paragraphStyle.lineSpacing = 10
            let attribute = NSMutableAttributedString(string: (text?.contents)!, attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 16),NSAttributedStringKey.foregroundColor:UIColor.black])
            //줄간격 셋팅
            attribute.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range: NSMakeRange(0, attribute.length))
            
            self.textView.attributedText = attribute
            self.textView.textAlignment = .left
            navigationItem.title = text?.title
        }
        
    }
    
    //공지사항 들어갈 글
    let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        return textView
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "이전", style: .plain, target: self, action: #selector(handleCancel))
        view.addSubview(textView)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "back.png")!)
        setLayout()
    }
    
    //바버튼아이템 작동 함수
    @objc func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    
    func setLayout(){
        textView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
        textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
        textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
        textView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 30).isActive = true
    }
    
}
