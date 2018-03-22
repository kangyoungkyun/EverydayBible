//
//  TableViewController.swift
//  EverydayBible
//
//  Created by MacBookPro on 2018. 3. 4..
//  Copyright © 2018년 MacBookPro. All rights reserved.
//
import Firebase
import UIKit
import MessageUI
class ThirdViewController: UITableViewController ,MFMailComposeViewControllerDelegate{
    var ref: DatabaseReference!
    var titles = [Text]()
    
    //let twoDimenstionArray = ["개발자에게","나가기"]

    
    let uiView : UIView = {
        let uiView = UIView()
        uiView.backgroundColor = .yellow
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callFirebaseData()
        self.navigationController?.navigationBar.barTintColor = UIColor(red:1.00, green:0.60, blue:0.60, alpha:1.0)
        self.navigationController?.navigationBar.isTranslucent = false
        tableView.tableFooterView = uiView
        tableView.register(TextCell.self, forCellReuseIdentifier: "Cell")
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "back.png")!)
        //네비게이션 타이틀
        navBarTitleImag()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    //테이블 행 개수
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return titles.count
    }
    
    //테이블 셀 구성
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TextCell
        
        cell.myLableOne.text = titles[indexPath.row].title
        return cell
    }
    
    
    
    //높이
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    //셀을 클릭했을 때
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (self.titles[indexPath.row].title == "개발자에게"){
                print("개발자에게")
            let mailComposeViewController = configuredMailComposeViewController()
            if MFMailComposeViewController.canSendMail(){
                self.present(mailComposeViewController, animated: true, completion: nil)
            }else{
                self.showSendMailErrorAlert()
            }
        }else{
            
            let boardViewController = BoardViewController()
            let titles = self.titles[indexPath.row]
            boardViewController.text = titles
            let navController = UINavigationController(rootViewController: boardViewController)
            present(navController, animated: true, completion: nil)
        }
        

    }
    
    //네비게이션 타이틀 바
    func navBarTitleImag(){
        self.navigationItem.title = "더보기"
    }
    
    //firebase db 호출
    func callFirebaseData(){
        ref = Database.database().reference().child("board")
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let data = snapshot.value as? [String: Any] {
                
                let keys = Array(data.keys)
                let values = Array(data.values)
                
                for i in 0 ..< keys.count{
                    
                    let value = values[i] as? [String: Any]
                    if let unrappedValue = value{
                        let textOne = Text(title:keys[i], contents:"\(String(describing: unrappedValue["content"]!))")
                        self.titles.append(textOne)
                    }
                }
                
                DispatchQueue.main.async {
                    //반드시 reload 데이터 해줘야함~!!!
                    self.tableView.reloadData()
                    self.ref.removeAllObservers()
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    //커스텀 셀
    class TextCell: UITableViewCell{
        //라벨 1
        let myLableOne : UILabel = {
            let lbo = UILabel()
            //lbo.text = "text1"
            lbo.translatesAutoresizingMaskIntoConstraints = false
            lbo.numberOfLines = 0
            lbo.sizeToFit()
            lbo.font = UIFont.boldSystemFont(ofSize: 15)
            lbo.textAlignment = .center
            return lbo
        }()
        
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: .default, reuseIdentifier: "Cell")
            //계층 구조도에 따라서 cell에 위에서 만든 view 객체들을 넣어주기
            addSubview(myLableOne)
            backgroundColor = UIColor(patternImage: UIImage(named: "back.png")!)
            setupImage()
        }
        
        //제약조건 설정해주기
        func setupImage(){
            myLableOne.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            myLableOne.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            myLableOne.widthAnchor.constraint(equalToConstant: 100).isActive = true
            myLableOne.heightAnchor.constraint(equalToConstant: 20).isActive = true
            
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
    //메일 컨트롤
    func configuredMailComposeViewController() -> MFMailComposeViewController{
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(["abcnt@naver.com"])
        mailComposerVC.setSubject("개발자에게")
        mailComposerVC.setMessageBody("안녕하세요.\n\n\n", isHTML: false)
        return mailComposerVC
    }
    //메일 보내기 에러
    func showSendMailErrorAlert(){
        let sendMailErrorAlert = UIAlertView(title: "알림", message: "메일을 보내지 못했습니다.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    //보내기 버튼 눌렀을때 결과
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:
            
            print("메일 보내기가 취소되었습니다.")
        case MFMailComposeResult.sent.rawValue:
            
            print("메일 보내기 성공")
        default:
            break
        }
        self.dismiss(animated: true, completion: nil)
    }
}
