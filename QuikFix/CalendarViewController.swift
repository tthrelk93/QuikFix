//
//  CalendarViewController.swift
//  QuikFix
//
//  Created by Thomas Threlkeld on 10/5/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Koyomi

class CalendarViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate, KoyomiDelegate, UITabBarDelegate {
    
    
    @IBAction func backPressed(_ sender: Any) {
        if self.senderScreen == "poster"{
            performSegue(withIdentifier: "CalendarToPosterMenu", sender: self)
        
        } else {
        performSegue(withIdentifier: "BackFromCalendar", sender: self)
        }
    }
    
    @IBOutlet weak var tabBarCalendarButton: UITabBarItem!
    @IBOutlet weak var tabBarProfileButton: UITabBarItem!
    @IBOutlet weak var tabBarHistoryButton: UITabBarItem!
    @IBOutlet weak var tabBar: UITabBar!
    
    @IBOutlet weak var tabBarJobsButton: UITabBarItem!
    var collectData = [[String:Any]]()
    @objc func koyomi(_ koyomi: Koyomi, didSelect date: Date?, forItemAt indexPath: IndexPath){
        collectData.removeAll()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM-dd-yyyy"
        //let argDate = dateFormatter.date(from:date)!
        var dateString = dateFormatter.string(from: date!)
         dayLabel.text = dateString
        
        

        if self.senderScreen == "poster"{
            for (key, val) in self.jobDict{
                var tempDict = [String:Any]()
                tempDict = val as! [String:Any]
                var tempDate = tempDict["date"] as! String
                
                let dateForm = dateFormatter.date(from:tempDate)!
                
                
                if date == dateForm{
                    
                    collectData.append(val as! [String:Any])
                }
                
                
            }
            for (key, val) in self.currentListingsDict{
                var tempDict = [String:Any]()
                tempDict = val as! [String:Any]
                var tempDate = tempDict["date"] as! String
                
                let dateForm = dateFormatter.date(from:tempDate)!
                
                
                if date == dateForm{
                    
                    collectData.append(val as! [String:Any])
                }
                
                
            }

        } else {
        for (key, val) in self.jobDict{
            var tempDict = [String:Any]()
            tempDict = val as! [String:Any]
            var tempDate = tempDict["date"] as! String
            
            let dateForm = dateFormatter.date(from:tempDate)!
            
            
            if date == dateForm{
               
                collectData.append(val as! [String:Any])
            }
            
            
        }
        }
        /*if self.collectData.count == 0{
            self.dayEventsCollect.isHidden = true
        }*/
        DispatchQueue.main.async{
            
                self.dayEventsCollect.isHidden = false
                self.dayEventsCollect.delegate = self
                self.dayEventsCollect.dataSource = self
                self.dayEventsCollect.reloadData()
            
        }
    }
    @IBAction func rightMonthButtonPressed(_ sender: Any) {
        calendar.display(in: .next)
        self.monthLabel.text = self.calendar.currentDateString(withFormat: "MMMM")
        
        
        
    }

    @IBAction func leftMonthButtonPressed(_ sender: Any) {
        calendar.display(in: .previous)
        self.monthLabel.text = self.calendar.currentDateString(withFormat: "MMMM")
    }
    @IBOutlet weak var monthLabel: UILabel!
    
    @IBOutlet weak var backButton: UIButton!
    let qfGreen = UIColor(colorLiteralRed: 49/255, green: 74/255, blue: 82/255, alpha: 1.0)
    @IBOutlet weak var calendar: Koyomi!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dayEventsCollect: UICollectionView!
    var currentListings = [String]()
    var upcomingJobs = [String]()
    var jobDict = [String:Any]()
    var currentListingsDict = [String:Any]()
     var dateArray = [Date]()
    var senderScreen = String()
    var currentListingsDateArray = [Date]()
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.senderScreen == "poster"{
            print("tabBarHidden")
            tabBar.isHidden = true
            backButton.isHidden = false
        } else {
            backButton.isHidden = true
        tabBar.delegate = self
            tabBar.isHidden = false
        
        tabBar.selectedItem = tabBarCalendarButton
        }
        self.calendar.calendarDelegate = self
        self.calendar.selectionMode = .single(style: .circle)
        
        
        
        
        self.monthLabel.text = self.calendar.currentDateString(withFormat: "MMMM")
        for cell in calendar.visibleCells{
            cell.layer.cornerRadius = cell.frame.width/2
        }
        
        if senderScreen == "poster"{
            
            Database.database().reference().child("jobPosters").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                    
                    for snap in snapshots{
                        if snap.key == "currentListings"{
                            self.currentListings = snap.value as! [String]
                        }
                        if snap.key == "upcomingJobs"{
                            self.upcomingJobs = snap.value as! [String]
                            
                            
                        }
                        
                    }
                    
                }
                Database.database().reference().child("jobs").observeSingleEvent(of: .value, with: { (snapshot) in
                    if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                        
                        for snap in snapshots{
                            if self.upcomingJobs.contains(snap.key){
                                self.jobDict[snap.key as! String] = snap.value as! [String:Any]
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "MMMM-dd-yyyy"
                                var tempDate = (snap.value as! [String:Any])["date"] as! String
                                
                                let dateForm = dateFormatter.date(from:tempDate)!
                                print("df = \(dateForm)")
                                self.calendar.setDayBackgrondColor(self.qfGreen, of: dateForm)
                                self.calendar.setDayColor(.white, of: dateForm)
                                self.dateArray.append(dateForm)
                                
                            }
                            if self.currentListings.contains(snap.key){
                                self.currentListingsDict[snap.key as! String] = snap.value as! [String:Any]
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "MMMM-dd-yyyy"
                                var tempDate = (snap.value as! [String:Any])["date"] as! String
                                
                                let dateForm = dateFormatter.date(from:tempDate)!
                                print("df = \(dateForm)")
                                self.calendar.setDayBackgrondColor(UIColor.red, of: dateForm)
                                self.calendar.setDayColor(.white, of: dateForm)
                                self.currentListingsDateArray.append(dateForm)
                                
                            }
                        }
                        
                        //self.calendar.select(dates: self.dateArray)
                        
                        
                        
                    }
                    DispatchQueue.main.async{
                        self.calendar.reloadData()
                        
                    }
                })
                
            })

            
            
        } else {
        Database.database().reference().child("students").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                
                for snap in snapshots{
                   if snap.key == "upcomingJobs"{
                    self.upcomingJobs = snap.value as! [String]
                    
                    
                    }
                    
                }
                
            }
            Database.database().reference().child("jobs").observeSingleEvent(of: .value, with: { (snapshot) in
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                   
                    for snap in snapshots{
                        if self.upcomingJobs.contains(snap.key){
                            self.jobDict[snap.key as! String] = snap.value as! [String:Any]
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "MMMM-dd-yyyy"
                            var tempDate = (snap.value as! [String:Any])["date"] as! String
                            
                            let dateForm = dateFormatter.date(from:tempDate)!
                            print("df = \(dateForm)")
                            self.calendar.setDayBackgrondColor(self.qfGreen, of: dateForm)
                            self.calendar.setDayColor(.white, of: dateForm)
                            self.dateArray.append(dateForm)
                            
                        }
                    }
                   
                    //self.calendar.select(dates: self.dateArray)
                    
                    
                    
                }
                DispatchQueue.main.async{
                    self.calendar.reloadData()
                
                }
            })
            
        })
        }
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return collectData.count
}
var jobID = String()
func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCollectionViewCell", for: indexPath) as! DateCollectionViewCell
    //cell.gestureRecognizers?.first?.cancelsTouchesInView = false
    // cell.gestureRecognizers?.first?.delaysTouchesBegan = false
    print("cd: \(collectData[0])")
    cell.layer.borderColor = UIColor.clear.cgColor
    cell.posterName.text = self.collectData[indexPath.row]["posterName"] as! String
    cell.distLabel.text = ""
    cell.rateLabel.text = self.collectData[indexPath.row]["payment"] as! String
    cell.timeLabel.text = self.collectData[indexPath.row]["date"] as! String
    cell.additInfoLabel.text = self.collectData[indexPath.row]["additInfo"] as? String
    cell.category = self.collectData[indexPath.row]["category2"] as! String
    cell.jobID = self.collectData[indexPath.row]["jobID"] as! String
    var tempJob = JobPost()
    cell.job = tempJob
    
    //cell.delegate = self
    
    
    return cell
}

/* func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
 //let screenSize = UIScreen.main.bounds
 //let screenWidth = screenSize.width
 //let screenHeight = screenSize.height
 
 return CGSize(width: self.frame.width, height: 375.0)
 }*/
    
    public func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem){
        
        if item == tabBar.items?[0]{
            performSegue(withIdentifier: "TabBarCalendarToJobHistory", sender: self)
        } else if item == tabBar.items?[1]{
            performSegue(withIdentifier: "BackFromCalendar", sender: self)
            
        } else if item == tabBar.items?[2]{
            
            performSegue(withIdentifier: "TabBarCalendarToProfile", sender: self)
        } else {
            
        }
        
    }


    //　control date user selected.
    func koyomi(_ koyomi: Koyomi, shouldSelectDates date: Date?, to toDate: Date?, withPeriodLength length: Int) -> Bool {
        
        /*if invalidStartDate <= date && invalidEndDate >= toDate {
            print("Your select day is invalid.")
            return false
        }
        
        if length > 90 {
            print("More than 90 days are invalid period.")
            return false
        }*/
        
        return true
    }




var categoryType = String()
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BackFromCalendar"{
            if let vc = segue.destination as? JobPostViewController{
                vc.categoryType = self.categoryType
            }
            
        }
        else if segue.identifier == "TabBarCalendarToProfile"{
            if let vc = segue.destination as? studentProfile{
                
            }
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
