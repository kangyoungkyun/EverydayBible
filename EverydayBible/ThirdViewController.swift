//
//  TableViewController.swift
//  EverydayBible
//
//  Created by MacBookPro on 2018. 3. 4..
//  Copyright © 2018년 MacBookPro. All rights reserved.
//
import Firebase
import UIKit

class ThirdViewController: UITableViewController {
    var ref: DatabaseReference!
    var titles = [Text]()
    
    let uiView : UIView = {
        let uiView = UIView()
        uiView.backgroundColor = .yellow
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    override func loadView() {
        super.loadView()
        print("로드뷰")
        callFirebaseData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("뷰디드로드")
        
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
        return 50
    }
    
    //셀을 클릭했을 때
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let boardViewController = BoardViewController()
        let titles = self.titles[indexPath.row]
        boardViewController.text = titles
        let navController = UINavigationController(rootViewController: boardViewController)
        present(navController, animated: true, completion: nil)
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
                        let textOne = Text(title:keys[i], contents:"  \(String(describing: unrappedValue["content"]!))")
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
        //연결 끊어주기?
        
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
}
