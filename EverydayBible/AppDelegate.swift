//
//  AppDelegate.swift
//  EverydayBible
//
//  Created by MacBookPro on 2018. 3. 3..
//  Copyright © 2018년 MacBookPro. All rights reserved.
//

//***********************************남은 작업***********************************************
//1.오늘 날짜 시간표시 및 레이아웃 (완료)
//2.날짜에 맞게 성경 구절 뿌려주기(완료)
//3.firebase 구조 조정(완료 )
//번외.firebase 연결 종료해주기(완료)
//4.공지사항 부분 firebase 구조 조정하기(완료)
//5.공지사항 글 내용 넣기 맟 글꼴 및 문단 조정(완료)
//6.웹으로 관리자 페이지 만들어서 파이어베이스에 삽입 삭제 수정 하기(완료)
//7.커스텀 인디케이터 만들기(다시 확인)
//8.앱 아이콘 및 초기 진입화면 만들기


//9.데이터 피커 이용해서 성경구절 firebase에 삽입하기 + ios 해당날짜가 없을때 처리 해주기
//10.코드 정리 및 print문 삭제
//11.개발자 등록 및 배포


//포스팅
//문단간격
//시간 처리 함수(완료)

//파이어베이스 조회할때 tavleview나 collectionview일때
//반드시 reload 데이터 해줘야함~!!!
//self.tableView.reloadData()
//

import UIKit
import Firebase
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    //인디케이터 객체
    var actIdc = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    var container: UIView!
    
    class func instance() -> AppDelegate{
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    //인디케이터 시작
    func showActivityIndicator(){
        if let window = window{
             print("showActivityIndicator 인디케이터 호출")
            container = UIView()
            container.frame = window.frame
            container.center = window.center
            container.backgroundColor = UIColor(white:0, alpha:0.2)
            actIdc.color = UIColor.black
            actIdc.frame = CGRect(x: 0 , y: 0, width:40, height:40)
            actIdc.hidesWhenStopped = true
            actIdc.center = CGPoint(x: container.frame.size.width / 2, y: container.frame.size.height / 2)
            container.addSubview(actIdc)
            window.addSubview(container)
            actIdc.startAnimating()
        }
    }
    
    //인디케이터 삭제
    func dissmissActivityIndicator(){
        if let _ = window{
            print("dissmiss 인디케이터 호출")
            container.removeFromSuperview()
        }
    }
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        //1 탭바 컨트롤러를 생성하고 배경을 흰색으로 한다.
        let tbC = UITabBarController()
        tbC.view.backgroundColor = .white
        tbC.view.tintColor = UIColor.white
        tbC.tabBar.barTintColor = UIColor(red:1.00, green:0.60, blue:0.60, alpha:1.0)
        
        //스토리보드 없이 code로 ui 제작
        window = UIWindow()
        window?.makeKeyAndVisible()
        
        //2 생성된 탭바 뷰 컨트롤러를 루트 뷰 컨트롤러로 등록한다.: 윈도우 객체가 참조하는 뷰가 루트 뷰 컨트롤러다
        self.window?.rootViewController = tbC
        
        
        // 각 탭바 아이템에 연결될 뷰 컨트롤러 객체를 생성한다.
        let vv1 = FirstController()
        let vv2 = SecondViewController()
        let vv3 = ThirdViewController()
        
        //각 UIViewController를 UINavigationController로 만들어주려면 UIViewController를 루트뷰로 설정.
        let v1 = UINavigationController(rootViewController: vv1)
        let v2 = UINavigationController(rootViewController: vv2)
        let v3 = UINavigationController(rootViewController: vv3)
        
        // 생성된 뷰 컨트롤러 객체들을 탭바 뷰 컨트롤러 에 등록한다.
        tbC.setViewControllers([v1,v2,v3], animated: false)
        
        //직접 커스텀 하기
        v1.tabBarItem.image = UIImage(named:"ic_spellcheck")?.withRenderingMode(.alwaysOriginal)
        v2.tabBarItem.image = UIImage(named:"ic_translate")?.withRenderingMode(.alwaysOriginal)
        v3.tabBarItem.image = UIImage(named:"ic_view_headline")?.withRenderingMode(.alwaysOriginal)
        
        //선택되었을 때
        //let image =
        v1.tabBarItem.selectedImage = UIImage(named:"ic_spellcheck_white")?.withRenderingMode(.alwaysOriginal)
        v2.tabBarItem.selectedImage = UIImage(named:"ic_translate_white")?.withRenderingMode(.alwaysOriginal)
        v3.tabBarItem.selectedImage = UIImage(named:"ic_view_headline_white")?.withRenderingMode(.alwaysOriginal)
        
        //제목
        v1.tabBarItem.title = "영어"
        v2.tabBarItem.title = "한글"
        v3.tabBarItem.title = "더보기"
        
        return true
    }



    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

