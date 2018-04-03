//
//  SecondViewController.swift
//  EverydayBible
//
//  Created by MacBookPro on 2018. 3. 3..
//  Copyright © 2018년 MacBookPro. All rights reserved.
//
import Firebase
import UIKit

class SecondViewController: UIViewController {
    var ref: DatabaseReference!
    var activityIndicatorView: UIActivityIndicatorView!
    var dateCheck: String?
    let lable: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.font = UIFont.systemFont(ofSize: 10)
        lable.adjustsFontSizeToFitWidth=true
        lable.minimumScaleFactor=0.5;
        return lable
    }()
    
    //가운데 이미지 객체
    let imageView: UIImageView = {
        let image = UIImageView(image:#imageLiteral(resourceName: "two.png"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
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
        //인디케이터1
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: 0).isActive = true
        activityIndicatorView.bringSubview(toFront: self.view)
        activityIndicatorView.startAnimating()
        
        //인디케이터2
        DispatchQueue.main.async {
            OperationQueue.main.addOperation() {
                Thread.sleep(forTimeInterval: 0.7)
                self.activityIndicatorView.stopAnimating()
                
            }
        }
        getSingle()
        callFirebaseData()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "back.png")!)
        self.navigationController?.navigationBar.barTintColor = UIColor(red:1.00, green:0.60, blue:0.60, alpha:1.0)
        self.navigationController?.navigationBar.isTranslucent = false
        setupLayout()
        navBarTitleImag()
        
    }
    
    //네비게이션 타이틀 바
    func navBarTitleImag(){
        self.navigationItem.title = "매일 성경"
    }
    //레이아웃 설정 함수
    func setupLayout(){
        
        let containerView = UIView()
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/3).isActive = true
        
        //부모뷰에 라벨, 이미지 넣기
        containerView.addSubview(lable)
        containerView.addSubview(imageView)
        
        //라벨 제약조건 설정
        lable.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10).isActive = true
        lable.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -25).isActive = true
        
        
        //이미지 제약조건 지정
        imageView.topAnchor.constraint(equalTo: lable.bottomAnchor, constant: 10).isActive = true
        imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,constant: -40).isActive = true
        
        let containerBottomView = UIView()
        view.addSubview(containerBottomView)
        containerBottomView.translatesAutoresizingMaskIntoConstraints = false
        
        containerBottomView.topAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        containerBottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerBottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        containerBottomView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        containerBottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        
        containerBottomView.addSubview(textView)
        
        textView.topAnchor.constraint(equalTo: containerBottomView.topAnchor).isActive = true
        textView.leadingAnchor.constraint(equalTo: containerBottomView.leadingAnchor, constant: 25).isActive = true
        textView.trailingAnchor.constraint(equalTo: containerBottomView.trailingAnchor, constant: -25).isActive = true
        textView.heightAnchor.constraint(equalTo: containerBottomView.heightAnchor).isActive = true
    }
    
    
    //현재 날짜
    func getSingle(){
        let date = Date()
        let calendar = Calendar.current //켈린더 객체 생성
        let year = calendar.component(.year, from: date)    //년
        let month = calendar.component(.month, from: date)  //월
        let day = calendar.component(.day, from: date)      //일
        lable.text = "\(year)-\(month)-\(day)"
        dateCheck = "\(year)\(month)\(day)"
        //print(dateCheck!)
    }
    
    //firebase db 호출
    func callFirebaseData(){
       
         ref = Database.database().reference().child("bible").child(dateCheck!)
        ref.child("ko").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let head = value?["head"] as? String ?? ""
            let body = value?["body"] as? String ?? ""
            let para = value?["para"] as? String ?? ""
            
            //줄간격 객체
            let paragraphStyle = NSMutableParagraphStyle()
            //높이 설정
            paragraphStyle.lineSpacing = 9
            
            let attribute = NSMutableAttributedString(string: head, attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 18),NSAttributedStringKey.foregroundColor:UIColor.black])
            
            attribute.append(NSAttributedString(string: "\n\n \(body)", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 16),NSAttributedStringKey.foregroundColor:UIColor.black]))
            
            attribute.append(NSAttributedString(string: "\n\n\(para)", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 12),NSAttributedStringKey.foregroundColor:UIColor.black]))
            
            //줄간격설정
            attribute.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range: NSMakeRange(0, attribute.length))
            
            self.textView.attributedText = attribute
            self.textView.textAlignment = .center
            
        }) { (error) in
            print(error.localizedDescription)
        
        }
    
        //연결 끊어주기
        ref.removeAllObservers()
    }
}
