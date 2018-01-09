//
//  studentProfile.swift
//  QuikFix
//
//  Created by Thomas Threlkeld on 9/5/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseMessaging
import FirebaseAuth
import FirebaseStorage
import SwiftOverlays
import CoreLocation





class studentProfile: UIViewController, UIScrollViewDelegate, UITextViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, RemoveDelegate, UITabBarDelegate, UITableViewDelegate, UITableViewDataSource, MessagingDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    var curPick = String()
    var schoolData = ["Rhodes College","Birmingham Southern College",
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
    var majorData = ["Accounting","Actuarial Science","Advertising","Agriculture","Agricultural and Biological Engineering","Agricultural Business Management","Agriculture Economics","Animal Bioscience","Animal Sciences","Anthropology","Applied Mathematics","Archaeology","Architectural Engineering","Architecture","Art History","Studio Art","Art Education","Biobehavioral Health","Biochemistry","Bioengineering","Biology","Biophysics","Biotechnology","Business Administration and Management","Business Logistics","Chemical Engineering","Chemistry","Children","Civil Engineering","Computer Engineering","Computer Science","Crime, Law, and Justice","Dance","Earth Sciences","Economics","Electrical Engineering","Elementary and Kindergarten Education","Engineering Science","English","Environmental Systems Engineering","Environmental Sciences","Environmental Resource Management","Film and Video","Finance","Food Science","Forest Science","Forest Technology","General Science","Geography","Geosciences","Graphic Design and Photography","Health and Physical Education","Health Policy and Administration","History","Horticulture","Hotel, Restaurant, and Institutional Management","Human Development and Family Studies","Individual and Family Studies","Industrial Engineering","Information Sciences and Technology","Journalism","Kinesiology","Landscape Architecture","Law Enforcement and Correction","Marine Biology","Marketing","Mathematics","Mechanical Engineering","Media Studies","Meteorology","Microbiology","Mineral Economics","Modern Languages","Music Education","Nuclear Engineering","Nursing","Nutrition","Philosophy","Physics","Physiology","Political Science","Pre-medicine","Psychology","Public Relations","Real Estate","Recreation and Parks","Rehabilitation Services","Religious Studies","Secondary Education","Secondary Education","Sociology","Social Work","Special Education","Speech Communication","Statistics","Telecommunications","Theater","Wildlife and Fishery Science","Wildlife Technology","Women's Studies"]
    var skillsData = ["Mow", "Leaf Blowing", "Gardening", "Gutter Cleaning", "Weed-Wacking", "Hedge Clipping", "Installations(Electronics)", "Installations(Decorations)", "Furniture Assembly","Moving(In-Home)", "Moving(Home-To-Home)", "Hauling Away"]
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if curPick == "school"{
            return schoolData.count
        } else if curPick == "major"{
            return majorData.count
        } else {
            return skillsData.count
        }
    }
    var experience = [String]()
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if curPick == "skills"{
        if experience.contains(skillsData[row]){
            selectRemoveAddButton.setTitle("Remove", for: .normal)
            selectRemoveAddButton.backgroundColor = UIColor.red
        } else {
            selectRemoveAddButton.setTitle("Add", for: .normal)
            selectRemoveAddButton.backgroundColor = qfGreen
            }
        }
        
    }

    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        print("hey")
        var titleData = String()
        if curPick == "major" {
            titleData = majorData[row]
        } else if curPick == "school"{
            titleData = schoolData[row]
        } else {
            titleData = skillsData[row]
        }
    
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 15.0)!,NSForegroundColorAttributeName:UIColor.white])
        return myTitle
    }
    
    
    @IBOutlet weak var editSchoolButton: UIButton!
   
    var schoolToSave = String()
    var nameToSave = String()
    var majorToSave = String()
    var skillsToSave = String()
    @IBAction func editSchoolGBPressed(_ sender: Any) {
        self.curPick = "school"
        self.nameToSave = editNameTF.text!
        editingPicker.reloadAllComponents()
        editNameTF.text = editSchoolButton.titleLabel?.text
        editNameGB.setTitle("Set", for: .normal)
        editSchoolGB.isHidden = true
        editSchoolButton.isHidden = true
        editMajorButton.isHidden = true
        editMajorGB.isHidden = true
        editSkillsButton.isHidden = true
        editSkillsGB.isHidden = true
        saveButton.isHidden = true
        editPicImage.isHidden = true
        editPicGB.isHidden = true
        editingPicker.isHidden = false
        selectRemoveAddButton.isHidden = false
        selectRemoveAddButton.setTitle("Select", for: .normal)
        selectRemoveAddButton.backgroundColor = qfGreen
        editingPicker.delegate = self
        editingPicker.dataSource = self
    }
    @IBOutlet weak var editSchoolGB: UIButton!
    
    @IBAction func mainEditPressed(_ sender: Any) {
        if editMenuView.isHidden == true{
            
        editMenuView.isHidden = false
        } else {
            editMenuView.isHidden = true
            
        }
    }
    
    @IBAction func editNameGBPressed(_ sender: Any) {
        if editingPicker.isHidden == true{
            //
        } else {
            if curPick == "school"{
                self.editSchoolButton.setTitle(schoolData[editingPicker.selectedRow(inComponent: 0)], for: .normal)
                schoolToSave = schoolData[editingPicker.selectedRow(inComponent: 0)]
                
                editNameTF.text = nameToSave
                editNameGB.setTitle("Edit Name", for: .normal)
                editSchoolGB.isHidden = false
                editSchoolButton.isHidden = false
                editMajorButton.isHidden = false
                editMajorGB.isHidden = false
                editSkillsButton.isHidden = false
                editSkillsGB.isHidden = false
                saveButton.isHidden = false
                editPicImage.isHidden = false
                editPicGB.isHidden = false
                editingPicker.isHidden = true
                selectRemoveAddButton.isHidden = true
                selectRemoveAddButton.setTitle("Select", for: .normal)
                selectRemoveAddButton.backgroundColor = qfGreen
                
                
            } else if curPick == "major"{
                self.editMajorButton.setTitle(majorData[editingPicker.selectedRow(inComponent: 0)], for: .normal)
                majorToSave = majorData[editingPicker.selectedRow(inComponent: 0)]
                
                editNameTF.text = nameToSave
                editNameGB.setTitle("Edit Name", for: .normal)
                editSchoolGB.isHidden = false
                editSchoolButton.isHidden = false
                editMajorButton.isHidden = false
                editMajorGB.isHidden = false
                editSkillsButton.isHidden = false
                editSkillsGB.isHidden = false
                saveButton.isHidden = false
                editPicImage.isHidden = false
                editPicGB.isHidden = false
                editingPicker.isHidden = true
                selectRemoveAddButton.isHidden = true
                selectRemoveAddButton.setTitle("Select", for: .normal)
                selectRemoveAddButton.backgroundColor = qfGreen
            } else {
                self.editSkillsButton.setTitle(editNameTF.text, for: .normal)
                skillsToSave = editNameTF.text!
                
                editNameTF.text = nameToSave
                editNameGB.setTitle("Edit Name", for: .normal)
                editSchoolGB.isHidden = false
                editSchoolButton.isHidden = false
                editMajorButton.isHidden = false
                editMajorGB.isHidden = false
                editSkillsButton.isHidden = false
                editSkillsGB.isHidden = false
                saveButton.isHidden = false
                editPicImage.isHidden = false
                editPicGB.isHidden = false
                editingPicker.isHidden = true
                selectRemoveAddButton.isHidden = true
                selectRemoveAddButton.setTitle("Select", for: .normal)
                selectRemoveAddButton.backgroundColor = qfGreen
            }
        }
        
    }
    @IBOutlet weak var editSkillsGB: UIButton!
    
    @IBAction func editSkillsPressed(_ sender: Any) {
        self.curPick = "skills"
        self.nameToSave = editNameTF.text!
        editingPicker.reloadAllComponents()
        editNameTF.text = editSkillsButton.titleLabel?.text
        editNameGB.setTitle("Set", for: .normal)
        editSchoolGB.isHidden = true
        editSchoolButton.isHidden = true
        editMajorButton.isHidden = true
        editMajorGB.isHidden = true
        editSkillsButton.isHidden = true
        editSkillsGB.isHidden = true
        saveButton.isHidden = true
        editPicImage.isHidden = true
        editPicGB.isHidden = true
        editingPicker.isHidden = false
        selectRemoveAddButton.isHidden = false
        //selectRemoveAddButton.setTitle("", for: .normal)
        selectRemoveAddButton.backgroundColor = qfGreen
        editingPicker.delegate = self
        editingPicker.dataSource = self
    }
    @IBOutlet weak var editSkillsButton: UIButton!
    @IBAction func editMajorPressed(_ sender: Any) {
        self.curPick = "major"
        self.nameToSave = editNameTF.text!
        editingPicker.reloadAllComponents()
        editNameTF.text = editMajorButton.titleLabel?.text
        editNameGB.setTitle("Set", for: .normal)
        editSchoolGB.isHidden = true
        editSchoolButton.isHidden = true
        editMajorButton.isHidden = true
        editMajorGB.isHidden = true
        editSkillsButton.isHidden = true
        editSkillsGB.isHidden = true
        saveButton.isHidden = true
        editPicImage.isHidden = true
        editPicGB.isHidden = true
        editingPicker.isHidden = false
        selectRemoveAddButton.isHidden = false
        selectRemoveAddButton.setTitle("Select", for: .normal)
        selectRemoveAddButton.backgroundColor = qfGreen
        editingPicker.delegate = self
        editingPicker.dataSource = self
    }
    @IBOutlet weak var editMajorButton: UIButton!
    @IBOutlet weak var editMajorGB: UIButton!
    
    @IBAction func editNamePressed(_ sender: Any) {
        
        
    }
    
    //@IBOutlet weak var editNameButton: UIButton!
    @IBOutlet weak var editNameGB: UIButton!
    
    @IBOutlet weak var editPicImage: UIButton!
    
    @IBOutlet weak var editMenuView: UIView!
    
    @IBOutlet weak var editPicGB: UIButton!
    
    
    @IBAction func editPicPressed(_ sender: Any) {
        
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
        
    }
    var newPic = false
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        if self.newPic == true{
        let imageName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("profile_images").child(Auth.auth().currentUser!.uid).child("\(imageName).jpg")
        
        
        let uploadData = UIImageJPEGRepresentation(self.picToSave, 0.1)
        storageRef.putData(uploadData!, metadata: nil, completion: { (metadata, error) in
            
            if error != nil {
                print(error as Any)
                return
            }
            
            if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                
                var values = Dictionary<String, Any>()
                
                values["pic"] = profileImageUrl
                
             
        
        
        var uploadDict = [String:Any]()
                uploadDict["experience"] = self.experience
        uploadDict["school"] = self.editSchoolButton.titleLabel?.text
        uploadDict["major"] = self.editMajorButton.titleLabel?.text
        uploadDict["name"] = self.editNameTF.text
        uploadDict["pic"] = profileImageUrl
        //uploadDict["pic"] ==
        Database.database().reference().child("students").child(Auth.auth().currentUser!.uid).updateChildValues(uploadDict)
        self.editMenuView.isHidden = true
        DispatchQueue.main.async{
            self.loadPageData()
        }
            }
        })
        } else {
            var uploadDict = [String:Any]()
            uploadDict["experience"] = self.experience
            uploadDict["school"] = self.editSchoolButton.titleLabel?.text
            uploadDict["major"] = self.editMajorButton.titleLabel?.text
            uploadDict["name"] = self.editNameTF.text
            //uploadDict["pic"] = profileImageUrl
            //uploadDict["pic"] ==
            Database.database().reference().child("students").child(Auth.auth().currentUser!.uid).updateChildValues(uploadDict)
            self.editMenuView.isHidden = true
            DispatchQueue.main.async{
                self.loadPageData()
            }
        }
        
    }
    
    @IBOutlet weak var saveButton: UIButton!
    
    //@IBOutlet weak var availableForWorkLabel: UILabel!
    //@IBAction func availableSwitchActivated(_ sender: Any) {
        //var tempDict = [String:Any]()
        /*if availableSwitch.isOn{
            tempDict["available"] = true
            availableForWorkLabel.text = "Available for work"
        } else {
            tempDict["available"] = false
            availableForWorkLabel.text = "Not available for work"
        }
        Database.database().reference().child("students").child((Auth.auth().currentUser?.uid)!).updateChildValues(tempDict)
        
        
    }*/
    //@IBOutlet weak var availableSwitch: UISwitch!
    var notUsersProfile = false
    var studentIDFromResponse = String()
    var job = JobPost()
    var jobArray = [String]()
    
    @IBOutlet weak var earnedAmount: UILabel!
    @IBOutlet weak var jobsFinished: UILabel!
    @IBOutlet weak var expTableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var starView: CosmosView!
    @IBOutlet weak var experienceLabel: UILabel!
    @IBOutlet weak var gradYearLabel: UILabel!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var educationLabel: UILabel!
    @IBOutlet weak var schoolLabel: UILabel!
   // @IBOutlet weak var studentBioLabel: UILabel!
    @IBOutlet weak var jobCountLabel: UILabel!
    @IBOutlet weak var earnedLabel: UILabel!
  //  @IBOutlet weak var studentBio: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    var jobsFinishedArray = [String]()
    var upcomingJobsArray = [String]()
    var experienceDict = [String:Any]()
    var location = CLLocation()
    //edit profile view
    var selectedImage = UIImage()
   
    
    @IBOutlet weak var menuButton: UIButton!
    var sender = String()
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var backButtonForPoster: UIButton!
    func loadPageData(){
        
        editNameTF.delegate = self
        editMenuView.isHidden = true
        editPicGB.layer.cornerRadius = 7
        editPicImage.layer.cornerRadius = 7
        editPicImage.clipsToBounds = true
        editPicImage.layer.masksToBounds = false
        
        editNameGB.layer.cornerRadius = 7
        //editNameButton.layer.cornerRadius = 7
        editMajorGB.layer.cornerRadius = 7
        editMajorButton.layer.cornerRadius = 7
        editSchoolGB.layer.cornerRadius = 7
        editSchoolButton.layer.cornerRadius = 7
        editSkillsGB.layer.cornerRadius = 7
        editSkillsButton.layer.cornerRadius = 7
        saveButton.layer.cornerRadius = 7
        editMenuView.layer.cornerRadius = 7
        editMenuView.layer.masksToBounds = false
        editMenuView.clipsToBounds = true
        SwiftOverlays.removeAllOverlaysFromView(self.view)
        SwiftOverlays.removeAllBlockingOverlays()
        tabBar.delegate = self
        scrollView.bounces = false
        SwiftOverlays.removeAllBlockingOverlays()
        if sender == "student"{
            print("aboveMessagingDelegateInStudent")
            Messaging.messaging().delegate = self
            self.mToken = Messaging.messaging().fcmToken!
            print("token: \(mToken)")
            //appDelegate.deviceToken
            var tokenDict = [String: Any]()
            tokenDict["deviceToken"] = [mToken: true] as [String:Any]?
            Database.database().reference().child("students").child((Auth.auth().currentUser?.uid)!).updateChildValues(tokenDict)
        }
        if self.notUsersProfile == false{
            //availableForWorkLabel.isHidden = false
            //availableSwitch.isHidden = false
            menuButton.isHidden = false
            backButtonForPoster.isHidden = true
            editButton.isHidden = false
        //self.editProfPicImageView.layer.cornerRadius = 10
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2
        picker.delegate = self
        profileImageView.clipsToBounds = false
        profileImageView.layer.masksToBounds = true
            profileImageView.centerXAnchor.constraint(equalTo: self.cityLabel.centerXAnchor).isActive = true
        /*editGradYearTextField.delegate = self
        editMajorTextField.delegate = self
        editNameTextField.delegate = self
        editBioTextView.delegate = self
        editSchoolTextField.delegate = self*/
        Database.database().reference().child("students").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshots{
                    if snap.key == "name"{
                        self.nameLabel.text = snap.value as? String
                        self.editNameTF.text = snap.value as? String
                        //self.editNameTextField.placeholder = snap.value as! String
                        
                    }
                        /*else if snap.key == "available"{
                        if snap.value as! Bool == true{
                            self.availableSwitch.isOn = true
                        } else {
                            self.availableSwitch.isOn = false
                        }*/
                        
                        
                    //}
                    else if snap.key == "school"{
                        self.schoolLabel.text = snap.value as? String
                        self.editSchoolButton.setTitle(snap.value as! String, for: .normal)
                        //self.editSchoolTextField.placeholder = snap.value as! String
                    }
                    else if snap.key == "major"{
                        self.majorLabel.text = snap.value as? String
                        self.editMajorButton.setTitle(snap.value as! String, for: .normal)
                        //self.editMajorTextField.placeholder = snap.value as! String
                    }
                    else if snap.key == "jobsCompleted"{
                        for job in snap.value as! [String]{
                            self.jobsFinishedArray.append(job)
                        }
                        self.jobsFinished.text = String(describing:self.jobsFinishedArray.count)
                        
                        
                    }
                        else if snap.key == "location"{
                        var tempDict = snap.value as! [String: Any]
                        self.location = CLLocation(latitude: tempDict["lat"] as! CLLocationDegrees, longitude: tempDict["long"] as! CLLocationDegrees)
                        
                        let geoCoder = CLGeocoder()
                        
                        geoCoder.reverseGeocodeLocation(self.location, completionHandler: { (placemarks, error) -> Void in
                            
                            // Place details
                            var placeMark: CLPlacemark!
                            placeMark = placemarks?[0]
                            
                            // Address dictionary
                            print(placeMark.addressDictionary as Any)
                            
                                                        // City
                            if let city = placeMark.addressDictionary!["City"] as? NSString {
                                print(city)
                            
                        
                        
                        
                                self.cityLabel.text = city as String
                            }
                        })
                        
                    
                    
                        //self.editCityTextField.placeholder = snap.value as! String
                        
                        
                    }
                    else if snap.key == "rating"{
                        self.starView.rating = snap.value as! Double
                    }
                    else if snap.key == "totalEarned"{
                        self.earnedAmount.text = ("$\(String(describing:snap.value as! Int))")
                    }
                        
                    else if snap.key == "gradYear"{
                        self.gradYearLabel.text = snap.value as? String
                       // self.editGradYearTextField.placeholder = snap.value as! String
                    }
                        
                    else if snap.key == "experience"{
                        self.expTableData = snap.value as! [String]
                        self.experience = snap.value as! [String]
                        var tempString = ""
                        for str in snap.value as! [String]{
                            tempString = "\(tempString), \(str)"
                        }
                        
                        self.editSkillsButton.setTitle(tempString, for: .normal)
                        
                    }
                        
                        
                        
                    else if snap.key == "pic"{
                        if let messageImageUrl = URL(string: snap.value as! String) {
                            
                            if let imageData: NSData = NSData(contentsOf: messageImageUrl) {
                                self.profileImageView.image = UIImage(data: imageData as Data)
                                self.editPicImage.setBackgroundImage(UIImage(data: imageData as Data), for: .normal)
                                //self.editPicImage.setImage(UIImage(data: imageData as Data), for: .normal)
                                //self.editProfPicImageView.image = UIImage(data: imageData as Data)
                            } }
                        //  loadImageUsingCacheWithUrlString(snap.value as! String)
                    }
                   /* else if snap.key == "bio"{
                        //self.studentBio.text = snap.value as! String
                        //self.editBioTextView.text = snap.value as! String
                    }*/
                }
            }
            self.expTableView.delegate = self
            self.expTableView.dataSource = self
            DispatchQueue.main.async{
                self.expTableView.reloadData()
            }
        })
        } else {
           // availableForWorkLabel.isHidden = true
            //availableSwitch.isHidden = true
            menuButton.isHidden = true
            backButtonForPoster.isHidden = false
            editButton.isHidden = true
            tabBar.isHidden = true
            //self.editProfPicImageView.layer.cornerRadius = 10
            profileImageView.layer.cornerRadius = profileImageView.frame.width/2
            picker.delegate = self
            profileImageView.clipsToBounds = true
            //editGradYearTextField.delegate = self
            //editMajorTextField.delegate = self
            //editNameTextField.delegate = self
            //editBioTextView.delegate = self
            //editSchoolTextField.delegate = self
            Database.database().reference().child("students").child(self.studentIDFromResponse).observeSingleEvent(of: .value, with: { (snapshot) in
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                    for snap in snapshots{
                        if snap.key == "name"{
                            self.nameLabel.text = snap.value as? String
                            //self.editNameTextField.placeholder = snap.value as! String
                            
                        }
                        else if snap.key == "school"{
                            self.schoolLabel.text = snap.value as? String
                            //self.editSchoolTextField.placeholder = snap.value as! String
                        }
                        else if snap.key == "major"{
                            self.majorLabel.text = snap.value as? String
                            //self.editMajorTextField.placeholder = snap.value as! String
                        }
                        else if snap.key == "jobsCompleted"{
                            for job in snap.value as! [String]{
                                self.jobsFinishedArray.append(job)
                            }
                            self.jobsFinished.text = String(describing:self.jobsFinishedArray.count)
                            
                            
                        }
                        else if snap.key == "location"{
                            var tempDict = snap.value as! [String: Any]
                            self.location = CLLocation(latitude: tempDict["lat"] as! CLLocationDegrees, longitude: tempDict["long"] as! CLLocationDegrees)
                            
                            let geoCoder = CLGeocoder()
                            
                            geoCoder.reverseGeocodeLocation(self.location, completionHandler: { (placemarks, error) -> Void in
                                
                                // Place details
                                var placeMark: CLPlacemark!
                                placeMark = placemarks?[0]
                                
                                // Address dictionary
                                print(placeMark.addressDictionary as Any)
                                
                                // City
                                if let city = placeMark.addressDictionary!["City"] as? NSString {
                                    print(city)
                                
                                
                                
                                
                                self.cityLabel.text = city as String
                                }
                            })
                            //self.editCityTextField.placeholder = snap.value as! String
                            
                            
                        }
                        else if snap.key == "rating"{
                            self.starView.rating = Double(snap.value as! Int)
                        }
                        else if snap.key == "totalEarned"{
                            self.earnedAmount.text = ("$\(String(describing:snap.value as! Int))")
                        }
                            
                        else if snap.key == "gradYear"{
                            self.gradYearLabel.text = snap.value as? String
                           // self.editGradYearTextField.placeholder = snap.value as! String
                        }
                            
                        else if snap.key == "experience"{
                            print("yooo")
                            
                            self.expTableData = snap.value as! [String]
                            self.experience = snap.value as! [String]
                            var tempString = ""
                            for str in snap.value as! [String]{
                                tempString = "\(tempString), \(str)"
                            }
                            
                            self.editSkillsButton.setTitle(tempString, for: .normal)
                                                    }
                            
                            
                            
                        else if snap.key == "pic"{
                            if let messageImageUrl = URL(string: snap.value as! String) {
                                
                                if let imageData: NSData = NSData(contentsOf: messageImageUrl) {
                                    self.profileImageView.image = UIImage(data: imageData as Data)
                                    //self.//editProfPicImageView.image = UIImage(data: imageData as Data)
                                } }
                            //  loadImageUsingCacheWithUrlString(snap.value as! String)
                        }
                        /*else if snap.key == "bio"{
                            self.studentBio.text = snap.value as! String
                            //self.editBioTextView.text = snap.value as! String
                        }*/
                    }
                }
                self.expTableView.delegate = self
                self.expTableView.dataSource = self
                DispatchQueue.main.async{
                    self.expTableView.reloadData()
                }
                
            })
        }
        
        
        // Do any additional setup after loading the view, typically from a nib.
        scrollView.delegate = self

    }
    
   // @IBOutlet weak var editProfPicButton: UIButton!
    
   // @IBOutlet weak var editProfPicImageView: UIImageView!
   /* @IBAction func editProfPicPressed(_ sender: Any) {
        handleSelectProfileImageView()
        
        
    }*/
   // @IBOutlet weak var editNameTextField: UITextField!
   // @IBOutlet weak var editCityTextField: UITextField!
    
   // @IBOutlet weak var editSchoolTextField: UITextField!
   // @IBOutlet weak var editMajorTextField: UITextField!
    
    //@IBOutlet weak var editBioTextView: UITextView!
   // @IBOutlet weak var editExpTableView: UITableView!
    let picker = UIImagePickerController()
    
    //@IBOutlet weak var editGradYearTextField: UITextField!
    @IBAction func editProfilePressed(_ sender: Any) {
       /* if self.editProfView.isHidden == true{
            if self.editCityTextField.placeholder == ""{
                self.editCityTextField.placeholder = "City"
            }
            if self.editSchoolTextField.placeholder == ""{
                self.editSchoolTextField.placeholder = "School"
            }
            if editMajorTextField.placeholder == ""{
                editMajorTextField.placeholder = "Major"
            }
            if editGradYearTextField.placeholder == ""{
                editGradYearTextField.text = "Grad Year"
            }
            if editBioTextView.text == ""{
                editBioTextView.text = "Edit Bio"
            }
            self.editProfView.isHidden = false
        } else {
            editProfView.isHidden = true
        }*/
        
    }
    
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        print(expTableData)
        print("expCount: \(expTableData.count)")
        return self.expTableData.count
    }
    
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpTableViewCell",
                                                 for: indexPath) as! ExpTableViewCell
        
        cell.expLabel.text = expTableData[indexPath.row]
        print(expTableData)
        //configureTableViewCell(tableView: tableView, cell: cell, indexPath: indexPath)
        // (cell as! DateTableViewCell).cal.delegate = self
        //(cell as! DateTableViewCell).jobsCollect.dataSource = self
        
        return cell
    }
    let qfGreen = UIColor(colorLiteralRed: 49/255, green: 74/255, blue: 82/255, alpha: 1.0)
    var sizingCell: ExpTableViewCell?
    func configureTableViewCell(tableView: UITableView, cell: ExpTableViewCell, indexPath: IndexPath){
        cell.expLabel.text = expTableData[indexPath.row]
        
            }

    
   // var job = JobPost()
    @IBAction func backButtonPressed(_ sender: Any) {
        if self.sender == "JobLogSingleJobPoster"{
            performSegue(withIdentifier: "StudentProfileBackToJobLogJob", sender: self)
            
        } else {
            performSegue(withIdentifier: "StudentProfileBackToResponse", sender: self)
            
        }
    }
    
    @IBAction func addExpPressed(_ sender: Any) {
        
        
    }
    
    //removeDelegateFunc
    func performRemoveCell(cell: ExperienceTableViewCell) {
        print("remove: \(cell)")
    }
    
    
    @IBOutlet weak var editNameTF: UITextField!
    var mToken = String()
    var expTableData = [String]()
    
    @IBAction func selectRemoveAddButtonPressed(_ sender: Any) {
        if curPick == "school" {
            editNameTF.text = schoolData[editingPicker.selectedRow(inComponent: 0)]
            
        } else if curPick == "major" {
            editNameTF.text = majorData[editingPicker.selectedRow(inComponent: 0)]
        } else {
            var curIndex = editingPicker.selectedRow(inComponent: 0)
            if experience.contains(skillsData[curIndex]) == false {
                experience.append(skillsData[curIndex])
                selectRemoveAddButton.setTitle("Remove", for: .normal)
                selectRemoveAddButton.backgroundColor = UIColor.red
            } else {
                experience.remove(at: experience.index(of: skillsData[ curIndex])!)
                selectRemoveAddButton.setTitle("Add", for: .normal)
                selectRemoveAddButton.backgroundColor = qfGreen
            }
            var tempString = ""
            for str in experience {
                if str == experience.last{
                    tempString = tempString + str
                    
                } else {
                    tempString = tempString + str + ", "
                }
                
            }
            
        
            editNameTF.text = tempString
        }
    }
    @IBOutlet weak var selectRemoveAddButton: UIButton!
    @IBOutlet weak var editingPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // editingPicker.colotabBa
        tabBar.tintColor = qfGreen
        //tabBar.selectedItem
        let picker = UIImagePickerController()
        picker.delegate = self
        //Messaging.messaging().delegate = self
        loadPageData()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        //if textView == editBioTextView{
            
        //}
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.hasText == false {
            textField.text = self.nameLabel.text
        } else {
            nameToSave = textField.text!
            
            
            //textField.text = nil
        }
       // if textView == editBioTextView{
            
        //}
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //self.view.endEditing(true)
        return true
    }
    
    func handleSelectProfileImageView() {
        
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    
    var picToSave = UIImage()
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectedImageFromPicker = editedImage
            
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            self.selectedImage = selectedImageFromPicker!
            //userPic.image = selectedImage
            //userPic.isHidden = true
            //selectProfilePic.setBackgroundImage(selectedImage, for: .normal)
            self.editPicImage.setBackgroundImage(selectedImage, for: .normal)
            print("selectedImage: \(selectedImage)")
            self.picToSave = selectedImage
            self.newPic = true
            
            //self.editProfPicImageView.image = selectedImage
            
            //profileImageViewButton.set
            // profileImageView.image = selectedImage
            
        }
        
        dismiss(animated: true, completion: nil)    }
    
    
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x>0 {
            scrollView.contentOffset.x = 0
        }
    }
    
    @IBOutlet weak var tabBar: UITabBar!
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StudentBackToResponse"{
            if let vc = segue.destination as? SpecificResponseViewController{
                vc.job = self.job
                vc.jobArray = self.jobArray
            }
        
        } else if segue.identifier == "StudentProfileBackToJobLogJob"{
            if let vc = segue.destination as? JobLogJobViewController{
                vc.job = self.job
                vc.senderScreen = "student"
            }
            
        } else if segue.identifier == "StudentProfileTabBarToJobHistory"{
            if let vc = segue.destination as? JobHistoryViewController{
                vc.senderScreen = "student"
                print("profile: senderScreen = student")
            }
        }
    }
    public func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem){
        if item == tabBar.items?[0]{
            performSegue(withIdentifier: "StudentProfileTabBarToJobHistory", sender: self)
        } else if item == tabBar.items?[1]{
            performSegue(withIdentifier: "StudentProfileTabBarToJobFinder", sender: self)
            
        } else if item == tabBar.items?[2]{
            
            
        } else {
            performSegue(withIdentifier: "StudentProfileTabBarToCalendar", sender: self)
            
        }
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        var tokenDict = [String: Any]()
        
        
        tokenDict["deviceToken"] = [fcmToken: true] as [String: Any]?
        Database.database().reference().child("students").child((Auth.auth().currentUser?.uid)!).updateChildValues(tokenDict)
        
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    

    


    
    
}
