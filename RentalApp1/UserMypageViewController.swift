//
//  UserMypageViewController.swift
//  RentalApp1
//
//  Created by SWUCOMPUTER on 2018. 5. 31..
//  Copyright © 2018년 SWUCOMPUTER. All rights reserved.
//

import UIKit
import CoreLocation

class UserMypageViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var placeLabel: UILabel!
    @IBOutlet var latitude: UILabel!
    @IBOutlet var longitude: UILabel!
  

    
    let locationManager: CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let myDate = formatter.string(from: Date())
        dateLabel.text = myDate
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.title = "사용자 " + appDelegate.ID! +  " 마이페이지"
        
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 가장 최근의 위치 값
        let location: CLLocation = locations[locations.count-1]
        let latitudeVal = Double(String(format: "%.6f", location.coordinate.latitude))
        let longitudeVal = Double(String(format: "%.6f", location.coordinate.longitude))
        latitude.text = String(describing: latitudeVal)
        longitude.text = String(describing: longitudeVal)
    }
    
    func getAddressFromCoordinate(pdblLatitude: String, withLongitude pdblLongitude: String){
        var center: CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        let long: Double = Double("\(pdblLongitude)")!
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = long
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude:center.longitude)
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil) {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    
                    let pm = placemarks![0]
                    print(pm.country!)
                    print(pm.locality!)
                    print(pm.subLocality!)
                    
                    var addressString : String = ""
                    
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    print(addressString)
                    //streetAddress.text = addressString
                    
                }
        })
    }
    
    
    //로그아웃 버튼
    @IBAction func buttonLogout(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title:"로그아웃 하시겠습니까?",message: "",preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in let urlString: String = "http://condi.swu.ac.kr/student/T08iphone/login/logout.php"

            guard let requestURL = URL(string: urlString) else { return }
            var request = URLRequest(url: requestURL)
            request.httpMethod = "POST"
            let session = URLSession.shared
            let task = session.dataTask(with: request) { (responseData, response, responseError) in
                guard responseError == nil else { return } }
            task.resume()
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginView = storyboard.instantiateViewController(withIdentifier: "Login")
            self.present(loginView, animated: true, completion: nil)
            
            
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true)
        
    }
    
//확인하기 버튼 누르면, 해당 주소의 위치를 맵으로 확인 가능 
//    @IBAction func checkPlace(_ sender: UIButton) {
//
//
//
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
