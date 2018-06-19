//
//  AdminListTableViewController.swift
//  RentalApp1
//
//  Created by SWUCOMPUTER on 2018. 5. 23..
//  Copyright © 2018년 SWUCOMPUTER. All rights reserved.
//

import UIKit

class AdminListTableViewController: UITableViewController {
    
    var fetchedArray: [RentalInfoData] = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.type = self.title!
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchedArray = []                 // 배열을 초기화하고 서버에서 자료를 다시 가져옴
        self.downloadDataFromServer()
    }
    
    func downloadDataFromServer() -> Void {
        //let urlString: String = "http://localhost:8888/rental/admin/AdminListTable.php"
        let urlString: String = "http://condi.swu.ac.kr/student/T08iphone/admin/AdminListTable.php"

        guard let requestURL = URL(string: urlString) else { return }
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let restString: String = "type=" + appDelegate.type!
        
        request.httpBody = restString.data(using: .utf8)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (responseData, response, responseError) in guard responseError == nil else {
                print("Error: calling POST");
                return;
            }
            guard let receivedData = responseData else {
                print("Error: not receiving Data");
                return;
            }
            let response = response as! HTTPURLResponse
            
            if !(200...299 ~= response.statusCode) { print("HTTP response Error! \(response.statusCode)"); return }
            do {
                if let jsonData = try JSONSerialization.jsonObject (with: receivedData, options:.allowFragments) as? [[String: Any]] {
                    
                    for i in 0...jsonData.count-1 {
                        let newData: RentalInfoData = RentalInfoData()
                        var jsonElement = jsonData[i]
                        newData.type = jsonElement["type"] as! String
                        newData.number = jsonElement["number"] as! String
                        newData.status = jsonElement["status"] as! String
                        newData.detail = jsonElement["detail"] as! String
                        //newData.rentDate = jsonElement["rentDate"] as! String
                        self.fetchedArray.append(newData)
                    }
                    
                    DispatchQueue.main.async { self.tableView.reloadData() }
                }
            } catch { print("Error:----") }
        }
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    // MARK: - Table view data source

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        //서버에 저장되어 있는 데이터를 type으로 검색하여 출력
        print("fetchedArray.count")
        print(fetchedArray.count)
        print("----")
        return fetchedArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Renting Cell", for: indexPath)

        // Configure the cell...
        let item = fetchedArray[indexPath.row]
        print("indexPath.row")
        print(indexPath.row)
        //cell.textLabel?.text = item.type
        let emptyStr = "  "
        var saveStr = item.type
        saveStr += emptyStr
        saveStr += item.number    //number 정보 더해서 쓰기
        cell.textLabel?.text = saveStr
        cell.detailTextLabel?.text = item.status
        
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "toAdminListDetail" {
            if let destination = segue.destination as? AdminListDetailViewController {
                if let selectedIndex = self.tableView.indexPathsForSelectedRows?.first?.row {
                    
                    let data = fetchedArray[selectedIndex]
                    destination.selectedData = data
                    
                }
            }
        }
    }


    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
