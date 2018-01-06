//
//  CreateAccountStudent2ViewController.swift
//  QuikFix
//
//  Created by Thomas Threlkeld on 10/31/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseDatabase



class CreateAccountStudent2ViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var gradYearTF: UITextField!
    var crypt = String()
    var profPic = UIImage()
    var gradData = ["2018", "2019", "2020", "2021","2022","2023","2024"]
    @IBAction func continuePressed(_ sender: Any) {
        if schoolDropDownTF.hasText && majorDropDownTF.hasText && gradYearTF.hasText{
            let date = Date()
            let calendar = Calendar.current
            
            let year = calendar.component(.year, from: date)
            
            if Int(gradYearTF.text!)! < year{
                let alert = UIAlertController(title: "You are not a student!", message: "You cannot sign up for a student account if you have already graduated.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
           
                student.major = majorDropDownTF.text
                student.school = schoolDropDownTF.text
                student.gradYear = gradYearTF.text
                performSegue(withIdentifier: "CreateStudentStep2ToStep3", sender: self)
            
        } else {
            let alert = UIAlertController(title: "Missing Field", message: "Make sure that you did not leave one of the options blank.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    @IBOutlet weak var selectButton: UIButton!
    var currentPicked = String()
    @IBAction func selectButtonPressed(_ sender: Any) {
        if curPicker == "school"{
            schoolDropDownTF.text = self.currentPicked
            
        } else if curPicker == "major"{
            majorDropDownTF.text = self.currentPicked
        } else {
            gradYearTF.text = self.currentPicked
        }
        
    }
    @IBOutlet weak var schoolAndMajorPicker: UIPickerView!
    var majorData = ["Accounting","Actuarial Science","Advertising","Agriculture","Agricultural and Biological Engineering","Agricultural Business Management","Agriculture Economics","Animal Bioscience","Animal Sciences","Anthropology","Applied Mathematics","Archaeology","Architectural Engineering","Architecture","Art History","Studio Art","Art Education","Biobehavioral Health","Biochemistry","Bioengineering","Biology","Biophysics","Biotechnology","Business Administration and Management","Business Logistics","Chemical Engineering","Chemistry","Children","Civil Engineering","Computer Engineering","Computer Science","Crime, Law, and Justice","Dance","Earth Sciences","Economics","Electrical Engineering","Elementary and Kindergarten Education","Engineering Science","English","Environmental Systems Engineering","Environmental Sciences","Environmental Resource Management","Film and Video","Finance","Food Science","Forest Science","Forest Technology","General Science","Geography","Geosciences","Graphic Design and Photography","Health and Physical Education","Health Policy and Administration","History","Horticulture","Hotel, Restaurant, and Institutional Management","Human Development and Family Studies","Individual and Family Studies","Industrial Engineering","Information Sciences and Technology","Journalism","Kinesiology","Landscape Architecture","Law Enforcement and Correction","Marine Biology","Marketing","Mathematics","Mechanical Engineering","Media Studies","Meteorology","Microbiology","Mineral Economics","Modern Languages","Music Education","Nuclear Engineering","Nursing","Nutrition","Philosophy","Physics","Physiology","Political Science","Pre-medicine","Psychology","Public Relations","Real Estate","Recreation and Parks","Rehabilitation Services","Religious Studies","Secondary Education","Secondary Education","Sociology","Social Work","Special Education","Speech Communication","Statistics","Telecommunications","Theater","Wildlife and Fishery Science","Wildlife Technology","Women's Studies"]
    var schoolDataArray = ["Rhodes College","Birmingham Southern College",
                           "Huntingdon College",
                           "Judson College",
                           "Miles College",
                           "Southeastern Bible College",
                           "Stillman College",
                           "Talladega College",
                           "Arizona Christian University",
                           "Lyon College",
                           "Central Baptist College",
                           "Crowley's Ridge College",
                           "Ouachita Baptist University",
                           "University of the Ozarks",
                           "Philander Smith College",
                           "Williams Baptist College",
                           "Columbia College-Hollywood",
                           "Design Institute of San Diego",
                           "Harvey Mudd College",
                           "Argosy University-The Art Institute of California-San Diego",
                           "Menlo College",
                           "Pitzer College",
                           "Pomona College",
                           "Scripps College",
                           "Thomas Aquinas College",
                           "Westmont College",
                           "Yeshiva Ohr Elchonon Chabad West Coast Talmudical Seminary",
                           "The Art Institute of Colorado",
                           "Nazarene Bible College",
                           "United States Air Force Academy",
                           "Mitchell College",
                           "Paier College of Art Inc",
                           "United States Coast Guard Academy",
                           "Johnson University Florida",
                           "Eckerd College",
                           "Edward Waters College",
                           "Hobe Sound Bible College",
                           "Ringling College of Art and Design",
                           "Saint John Vianney College Seminary",
                           "Trinity College of Florida",
                           "Agnes Scott College",
                           "The Art Institute of Atlanta",
                           "Brewton-Parker College",
                           "Emmanuel College",
                           "Morehouse College",
                           "Oglethorpe University",
                           "Paine College",
                           "Spelman College",
                           "Toccoa Falls College",
                           "Young Harris College",
                           "University of Hawaii-West Oahu",
                           "Boise Bible College",
                           "Lewis-Clark State College",
                           "Brigham Young University-Idaho",
                           "American Academy of Art",
                           "Augustana College",
                           "Blackburn College",
                           "East-West University",
                           "Eureka College",
                           "Illinois Wesleyan University",
                           "Kendall College",
                           "Knox College",
                           "MacMurray College",
                           "Monmouth College",
                           "The Illinois Institute of Art-Chicago",
                           "Shimer College",
                           "DePauw University",
                           "Hanover College",
                           "Holy Cross College",
                           "Wabash College",
                           "Central College",
                           "Coe College",
                           "Cornell College",
                           "Divine Word College",
                           "Grinnell College",
                           "Iowa Wesleyan University",
                           "Luther College",
                           "Wartburg College",
                           "Bethany College",
                           "Bethel College-North Newton",
                           "Central Christian College of Kansas",
                           "Kansas Christian College",
                           "Manhattan Christian College",
                           "Sterling College",
                           "Alice Lloyd College",
                           "Berea College",
                           "Centre College",
                           "Clear Creek Baptist Bible College",
                           "Kentucky Wesleyan College",
                           "Transylvania University",
                           "Dillard University",
                           "Louisiana State University-Alexandria",
                           "Saint Joseph Seminary College",
                           "Bates College",
                           "Bowdoin College",
                           "Colby College",
                           "University of Maine at Augusta",
                           "University of Maine at Fort Kent",
                           "University of Maine at Machias",
                           "University of Maine at Presque Isle",
                           "United States Naval Academy",
                           "Washington College",
                           "Amherst College",
                           "Boston Baptist College",
                           "Hampshire College",
                           "College of the Holy Cross",
                           "Montserrat College of Art",
                           "Newbury College",
                           "Stonehill College",
                           "Wellesley College",
                           "Wheaton College",
                           "Albion College",
                           "Alma College",
                           "Great Lakes Christian College",
                           "Hope College",
                           "Kalamazoo College",
                           "Lake Superior State University",
                           "Kuyper College",
                           "Finlandia University",
                           "Bethany Lutheran College",
                           "Carleton College",
                           "Gustavus Adolphus College",
                           "Macalester College",
                           "University of Minnesota-Crookston",
                           "University of Minnesota-Morris",
                           "Oak Hills Christian College",
                           "College of Saint Benedict",
                           "St Olaf College",
                           "Rust College",
                           "Central Christian College of the Bible",
                           "Central Methodist University-College of Liberal Arts and Sciences",
                           "Conception Seminary College",
                           "Harris-Stowe State University",
                           "Kansas City Art Institute",
                           "Ozark Christian College",
                           "College of the Ozarks",
                           "Stevens-The Institute of Business & Arts",
                           "Saint Louis Christian College",
                           "Westminster College",
                           "Carroll College",
                           "The University of Montana-Western",
                           "Doane University-Arts & Sciences",
                           "Nebraska Christian College of Hope International University",
                           "Summit Christian College",
                           "The Art Institute of Las Vegas",
                           "Northeast Catholic College",
                           "University of New Hampshire at Manchester",
                           "Saint Anselm College",
                           "Thomas More College of Liberal Arts",
                           "Rabbinical College of America",
                           "Talmudical Academy-New Jersey",
                           "Santa Fe University of Art and Design",
                           "Barnard College",
                           "Berkeley College-New York",
                           "Beth Hatalmud Rabbinical College",
                           "Beth Hamedrash Shaarei Yosher Institute",
                           "Cazenovia College",
                           "CUNY Medgar Evers College",
                           "CUNY New York City College of Technology",
                           "Yeshiva of Far Rockaway Derech Ayson Rabbinical Seminary",
                           "Hamilton College",
                           "Hartwick College",
                           "Kehilath Yakov Rabbinical Seminary",
                           "Machzikei Hadath Rabbinical College",
                           "Marymount Manhattan College",
                           "Mesivta Torah Vodaath Rabbinical Seminary",
                           "Ohr Hameir Theological Seminary",
                           "Paul Smiths College of Arts and Science",
                           "Davis College",
                           "Rabbinical College Beth Shraga",
                           "Rabbinical College of Long Island",
                           "SUNY College of Agriculture and Technology at Cobleskill",
                           "Farmingdale State College",
                           "Talmudical Seminary Oholei Torah",
                           "Torah Temimah Talmudical Seminary",
                           "Union College",
                           "United States Military Academy",
                           "Webb Institute",
                           "Wells College",
                           "Yeshiva Karlin Stolin",
                           "Belmont Abbey College",
                           "Bennett College",
                           "Brevard College",
                           "Davidson College",
                           "Guilford College",
                           "Heritage Bible College",
                           "Lees-McRae College",
                           "Livingstone College",
                           "North Carolina Wesleyan College",
                           "William Peace University",
                           "Mid-Atlantic Christian University",
                           "Saint Augustine's University",
                           "Dickinson State University",
                           "The Art Institute of Cincinnati-AIC College of Design",
                           "Cleveland Institute of Art",
                           "Denison University",
                           "Kenyon College",
                           "Ohio State University-Marion Campus",
                           "Ohio Wesleyan University",
                           "Wilmington College",
                           "The College of Wooster",
                           "Bacone College",
                           "Oklahoma Panhandle State University",
                           "University of Science and Arts of Oklahoma",
                           "The Art Institute of Portland",
                           "Linfield College-McMinnville Campus",
                           "Allegheny College",
                           "The Art Institute of Pittsburgh",
                           "Dickinson College",
                           "Franklin and Marshall College",
                           "Gettysburg College",
                           "Haverford College",
                           "Hussian College School of Art",
                           "Lafayette College",
                           "Lycoming College",
                           "Muhlenberg College", 
                           "Pennsylvania State University-Penn State New Kensington", 
                           "Pennsylvania State University-Penn State Shenango", 
                           "Pennsylvania State University-Penn State Wilkes-Barre", 
                           "Pennsylvania State University-Penn State Worthington Scranton", 
                           "Pennsylvania State University-Penn State Lehigh Valley", 
                           "Pennsylvania State University-Penn State Altoona", 
                           "Pennsylvania State University-Penn State Beaver", 
                           "Pennsylvania State University-Penn State Berks", 
                           "Pennsylvania State University-Penn State Brandywine", 
                           "Pennsylvania State University-Penn State Hazleton", 
                           "Pennsylvania State University-Penn State Abington", 
                           "Pennsylvania State University-Penn State Schuylkill", 
                           "Pennsylvania College of Art and Design", 
                           "University of Pittsburgh-Bradford", 
                           "University of Pittsburgh-Greensburg", 
                           "University of Pittsburgh-Johnstown", 
                           "Susquehanna University", 
                           "Swarthmore College", 
                           "Talmudical Yeshiva of Philadelphia", 
                           "Thiel College", 
                           "Ursinus College", 
                           "Allen University", 
                           "Benedict College", 
                           "Morris College", 
                           "Newberry College", 
                           "University of South Carolina-Beaufort", 
                           "Voorhees College", 
                           "Wofford College", 
                           "Presentation College", 
                           "American Baptist College", 
                           "Baptist Memorial College of Health Sciences", 
                           "Lane College", 
                           "Le Moyne-Owen College", 
                           "Maryville College", 
                           "O'More College of Design", 
                           "The Art Institute of Houston", 
                           "Dallas Christian College", 
                           "Jarvis Christian College", 
                           "Paul Quinn College", 
                           "Southwestern University", 
                           "Texas College", 
                           "Wiley College", 
                           "Brigham Young University-Hawaii", 
                           "Southern Vermont College", 
                           "Sterling College", 
                           "Bridgewater College", 
                           "Ferrum College", 
                           "Hampden-Sydney College", 
                           "Randolph-Macon College", 
                           "Roanoke College", 
                           "Southern Virginia University", 
                           "The University of Virginia's College at Wise", 
                           "Virginia Military Institute", 
                           "Virginia Wesleyan College", 
                           "The Art Institute of Seattle", 
                           "Cornish College of the Arts", 
                           "Whitman College", 
                           "Bluefield State College", 
                           "Davis & Elkins College", 
                           "Glenville State College", 
                           "West Virginia University Institute of Technology", 
                           "Beloit College", 
                           "Lawrence University", 
                           "Milwaukee Institute of Art & Design", 
                           "Northland College", 
                           "Ripon College", 
                           "National American University-Albuquerque", 
                           "Platt College-Aurora", 
                           "Christian Life College", 
                           "Nossi College of Art", 
                           "Yeshiva Gedolah Imrei Yosef D'spinka", 
                           "Northwest College of Art & Design", 
                           "Beacon College", 
                           "Rabbi Jacob Joseph School", 
                           "College of Biblical Studies-Houston", 
                           "Watkins College of Art Design & Film", 
                           "Mt Sierra College", 
                           "Yeshivas Novominsk", 
                           "Rabbinical College of Ohr Shimon Yisroel", 
                           "Argosy University-The Art Institute of California-Hollywood", 
                           "Johnson & Wales University-North Miami", 
                           "The Illinois Institute of Art-Schaumburg", 
                           "The Art Institute of Phoenix", 
                           "Yeshiva of the Telshe Alumni", 
                           "Yeshiva College of the Nations Capital", 
                           "National American University-Bloomington", 
                           "University of Connecticut-Tri-Campus", 
                           "University of Connecticut-Avery Point", 
                           "University of Connecticut-Stamford", 
                           "Crossroads Bible College", 
                           "The Art Institute of Washington", 
                           "National American University-Ellsworth AFB Extension", 
                           "National American University-Albuquerque West", 
                           "Pillar College", 
                           "Yeshiva Shaarei Torah of Rockland", 
                           "Nevada State College", 
                           "Argosy University-The Art Institute of California-Orange County", 
                           "Franklin W Olin College of Engineering", 
                           "National American University-Overland Park", 
                           "West Coast University-Los Angeles", 
                           "Baptist University of the Americas", 
                           "University of Phoenix-New Jersey", 
                           "Uta Mesivta of Kiryas Joel", 
                           "SAE Expression College", 
                           "Georgia Gwinnett College", 
                           "CollegeAmerica-Fort Collins", 
                           "The Art Institute of Tennessee-Nashville", 
                           "Bais Medrash Toras Chesed", 
                           "Visible Music College", 
                           "The Art Institute of Charleston", 
                           "Argosy University-The Art Institute of California-Sacramento", 
                           "Yeshivas Be'er Yitzchok", 
                           "Yeshiva Toras Chaim", 
                           "Talmudical Seminary of Bobov", 
                           "The Art Institute of Austin", 
                           "The Art Institute of Raleigh-Durham", 
                           "The King’s College", 
                           "Chamberlain College of Nursing-Ohio", 
                           "Chamberlain College of Nursing-Arizona", 
                           "Yeshiva of Machzikai Hadas", 
                           "Providence Christian College", 
                           "University of Minnesota-Rochester", 
                           "Chamberlain College of Nursing-Florida", 
                           "Horizon University", 
                           "West Coast University-Ontario", 
                           "The Art Institute of Virginia Beach", 
                           "The Art Institute of San Antonio", 
                           "Remington College-Heathrow Campus", 
                           "Chamberlain College of Nursing-Virginia", 
                           "Chamberlain College of Nursing-Missouri", 
                           "Chamberlain College of Nursing-Texas", 
                           "Chamberlain College of Nursing-Georgia", 
                           "Chamberlain College of Nursing-Indiana", 
                           "Bais HaMedrash and Mesivta of Baltimore", 
                           "Yeshiva Gedolah Zichron Leyma", 
                           "Be'er Yaakov Talmudic Seminary", 
                           "Gemini School of Visual Arts & Communication", 
                           "Mid-South Christian College", 
                           "Yeshiva Gedolah Kesser Torah", 
                           "Yeshiva Yesodei Hatorah", 
                           "National American University-Wichita West", 
                           "Antioch College", 
                           "Morthland College", 
                           "University of Florida-Online", 
                           "Rabbinical College Ohr Yisroel", 
                           "West Coast University-Miami", 
                           "Bet Medrash Gadol Ateret Torah", 
                           "Yeshiva Gedola Ohr Yisrael", 
                           "Yeshiva Sholom Shachna", 
                           "Beth Medrash Meor Yitzchok", 
                           "California Jazz Conservatory", 
                           "Chamberlain College of Nursing-Nevada", 
                           "Chamberlain College of Nursing-Michigan", 
                           "Chamberlain College of Nursing-New Jersey", 
                           "Hussian College-Relativity Campus California", 
                           "Arizona College-Las Vegas", 
                           "Yeshiva Zichron Aryeh", 
                           "Central Yeshiva Beth Joseph", 
                           "Beth Medrash of Asbury Park", 
                           "Yeshiva Gedolah Shaarei Shmuel", 
                           "Chamberlain College of Nursing-North Carolina", 
                           "Chamberlain College of Nursing-California"]
    
   
    @IBOutlet weak var majorDropDownTF: UITextField!
    @IBOutlet weak var schoolDropDownTF: UITextField!
    var student = Student()
    var promoData = [String:Any]()
    var promoSuccess = Bool()
    var promoSenderID = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentPicked = "Rhodes College"
        /*var tempData = SchoolData()
        for val in tempData.schoolDict as! [[String:Any]]{
            for (key, val2) in val as! [String: String]{
            if key == "FIELD2" {
                print("\"\(val2)\", ")
                //schoolDataArray.append(val2 as! String)
            }
            }
        }*/
        self.curPicker = "school"
        selectButton.isHidden = true
        selectButton.layer.cornerRadius = 7
        schoolAndMajorPicker.delegate = self
        schoolAndMajorPicker.dataSource = self
        
        // The view to which the drop down will appear on
        //dropDown.anchorView = view // UIView or UIBarButtonItem
        
        //dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        
        // The list of items to display. Can be changed dynamically
        //dropDown.dataSource = ["Computer Science", "Communications", "Government/Political Science", "Business", "Economics", "English", "Psychology", "Nursing","Chemistry","Biology","Physics","Art","Engineering"]
        /*dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.student.major = item
            self.majorDropDownTF.text = item
            self.dropDown.hide()
        }
        
        // Will set a custom width instead of the anchor view width
        //DropDownCell.width = 200
        
       
        
        // The view to which the drop down will appear on
        dropDown2.anchorView = view // UIView or UIBarButtonItem
        dropDown2.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        
        // The list of items to display. Can be changed dynamically
        dropDown2.dataSource = ["Rhodes College", "Hendrix", "Sewanee", "CBU", "University of Memphis", "Southwest Community College"]
        
        dropDown2.selectionAction = { [unowned self] (index: Int, item: String) in
            self.student.school = item
            self.schoolDropDownTF.text = item
            self.dropDown2.hide()
        }*/
        schoolDropDownTF.delegate = self
        majorDropDownTF.delegate = self
        gradYearTF.delegate = self
        

        // Do any additional setup after loading the view.
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if curPicker == "school"{
            return schoolDataArray.count
            
        } else if curPicker == "major" {
            return majorData.count
        } else {
            return gradData.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if curPicker == "school"{
            return schoolDataArray[row]
            
        } else if curPicker == "major" {
            return majorData[row]
        } else {
            return gradData[row]
        }
        
        
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if curPicker == "school"{
            self.currentPicked = schoolDataArray[row]
            
        } else if curPicker == "major"{
            self.currentPicked = majorData[row]
        } else {
            self.currentPicked = gradData[row]
        }
        //pickerView.isHidden = true
    }

    
    
   var curPicker = String()
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) {
        self.currentPicked = ""
        if textField == schoolDropDownTF{
            self.currentPicked = "Rhodes College"
            self.curPicker = "school"
            schoolAndMajorPicker.reloadAllComponents()
            //dropDown2.show()
        }
        if textField == majorDropDownTF {
            self.currentPicked = "Accounting"
            self.curPicker = "major"
           schoolAndMajorPicker.reloadAllComponents()
            //dropDown.show()
        }
            if textField == gradYearTF{
                self.currentPicked = "2018"
                self.curPicker = "grad"
                schoolAndMajorPicker.reloadAllComponents()
            }
        
        schoolAndMajorPicker.isHidden = false
        selectButton.isHidden = false
        //return false
        
        
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(false)
        
        return true
    }
    
    

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    var promoSender = [String: String]()
    var promoType = String()
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let vc = segue.destination as? CreateStudentAccountFinalViewController{
            vc.student = self.student
            vc.profPic = self.profPic
            vc.crypt = self.crypt
            /*vc.promoSenderID = self.promoSenderID
            vc.promoType = self.promoType
            vc.promoData = self.promoData
            vc.promoSuccess = self.promoSuccess
            vc.promoSender = self.promoSender*/
            
        }
    }
    

}
