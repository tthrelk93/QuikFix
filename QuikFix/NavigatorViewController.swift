//
//  NavigatorViewController.swift
//  QuikFix
//
//  Created by Thomas Threlkeld on 9/12/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import UIKit

class NavigatorViewController: UIViewController {

    @IBAction func jobHistoryPressed(_ sender: Any) {
    }
    @IBAction func profilePressed(_ sender: Any) {
        performSegue(withIdentifier: "NavToProfStudent", sender: self)
    }
    @IBAction func findJobsPressed(_ sender: Any) {
        performSegue(withIdentifier: "NavToFindJob", sender: self)
    }
    @IBOutlet weak var findJobsButton: UIButton!
    @IBOutlet weak var backgroundDesign: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //backgroundDesign.clipsToBounds = true
        //backgroundDesign.layer.cornerRadius = backgroundDesign.frame.width/2

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "NavToProfStudent"{
            if let vc = segue.destination as? studentProfile {
               // vc.
            }
        }
    }
    

}
