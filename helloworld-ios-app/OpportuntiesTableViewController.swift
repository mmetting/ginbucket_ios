/*
* Copyright Red Hat, Inc., and individual contributors
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import UIKit
import FeedHenry
import Foundation

class OpportuntiesTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        // Initialized cloud connection
        FH.init {(resp: Response, error: NSError?) -> Void in
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            if let error = error {
                print("FH init failed. Error = \(error)")
                if FH.isOnline == false {
                    print("Make sure you're online.")
                } else {
                    if error.code == 0 {
                        print("Please fill in fhconfig.plist file.")
                    } else {
                        print("FH init failed. \(error.localizedDescription)")
                    }
                }
                return
            }
            print("initialized OK")
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            //load opportunities
            FH.cloud(path: "opportunities", method: HTTPMethod.GET,
                     args: nil,
                     completionHandler: {(resp: Response, error: NSError?) -> Void in
                        
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        
                        if let error = error {
                            print("Cloud Call Failed, \(error)")
                            print("Error during Cloud call: \(error.userInfo[NSLocalizedDescriptionKey]!)")
                            return
                        }
                        
                        if let responseData = resp.rawResponse as Data? {
                            
                            do {
                                if let jsonDataArray = try JSONSerialization.jsonObject(with: responseData, options: []) as? [[String: Any]] {
                                    for eachData in jsonDataArray {
                                        let opp = Opportunity.init(data:eachData)
                                        self.opportunities.append(opp)
                                    }
                                    
                                    self.tableView.reloadData()
                                }
                            } catch {
                                print(error)
                            }
                        }
            })
        }
    }
    
    var opportunities: [Opportunity] = [];
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.opportunities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:OpportunityCellTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! OpportunityCellTableViewCell!
        cell.configureCell(self.opportunities[indexPath.row])
        
        return cell
    }
    
    // method to run when table view cell is tapped
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        
        let detail = self.storyboard?.instantiateViewController(withIdentifier: "Detail") as! OpportunityDetailViewController
        detail.opp = self.opportunities[indexPath.row];
        
        self.navigationController?.pushViewController(detail, animated: true)
    }
}
