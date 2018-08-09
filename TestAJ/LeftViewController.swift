//
//  LeftViewController.swift
//  LGSideMenuControllerDemo
//
import UIKit
//import RealmSwift
import SwiftyJSON

let screenSize: CGRect = UIScreen.main.bounds
protocol LeftViewControllerDelegate {
    func cellDidSelectWithIndexAndtitle(index: NSInteger,title: String)
    func timeAndDateDidTap()
}
class LeftViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CustomTableViewDelegate {
    var cellIsSelected: IndexPath?
    var leftViewControllerDelegate : LeftViewControllerDelegate?
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var nameLbl: UILabel?
    var storyBoard : UIStoryboard?
    
    fileprivate let titlesArray = ["Opening Check",
                                   "Cleaning Check",
                                   "Delivery Check",
                                   "Closing Check",
                                   "Add a Check","View Log"]
    let imagesArray = ["icons8FullMoon100-0",
                       "icons8FullMoon100-1",
                       "icons8FullMoon100-2",
                       "icons8FullMoon100-3",
                       "icons8FullMoon100-4","icons8FullMoon100-4"]
    var customTableView : CustomTableView? = nil
    
    @IBAction func logoutButtonClicked(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Logout", message: "Are you sure?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: doSomething))
        alert.addAction(UIAlertAction(title: "NO", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func doSomething(action: UIAlertAction) {
        //Use action.title
        LoadingOverlay.shared.showOverlay(view:self.view, msg: "")
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
//        let defaults = UserDefaults.standard
//        defaults.removeObject(forKey: "jwt_auth_token")
//        defaults.synchronize()
        
        let nextViewController : LoginVC? = storyBoard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
        //self.present(nextViewController ?? UIViewController(), animated:true, completion:nil)
        LoadingOverlay.shared.hideOverlayView()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        storyBoard = UIStoryboard(name: "Main", bundle:nil)

        //        tableView.register(LeftViewCell.self, forCellReuseIdentifier: "cell")
        tableView?.register(UINib(nibName: "LeftViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView?.backgroundColor = UIColor.clear
//        tableView?.contentInset = UIEdgeInsets(top: 14.0, left: 0.0, bottom: 44.0, right: 0.0)
        
        
//        let gradient = CAGradientLayer()
//        gradient.frame = self.view.bounds
//        gradient.colors = [UIColor.init(colorLiteralRed: 16.0/255.0, green: 174.0/255.0, blue: 136.0/255.0, alpha: 1).cgColor, UIColor.init(colorLiteralRed: 0.0/255.0, green: 187.0/255.0, blue: 255.0/255.0, alpha: 1).cgColor]
//        
//        self.view.layer.insertSublayer(gradient, at: 0)
        dump(UIFont.familyNames.flatMap { UIFont.fontNames(forFamilyName: $0) })
        
        let userData : JSON = ItsRequest.sharedInstance.loadJSON(key: "userData")

        
        nameLbl?.text = "Welcome " + (userData["name"].string ?? "")
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titlesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? LeftViewCell
        cell?.titleLabel?.text = titlesArray[indexPath.row]
        cell?.selectionStyle = .none
        cell?.myImageView?.image = UIImage(named : imagesArray[indexPath.row])
        
        if (cell?.titleLabel?.text?.equalsIgnoreCase(string: "Add a check") ?? false) {
            if (customTableView == nil) {
                customTableView = CustomTableView.init(frame: CGRect(x: 0, y: 40, width: screenSize.width, height: screenSize.height))
                customTableView?.delegate = self
//                customTableView?.backgroundColor = UIColor.blue

                //                customTableView = CustomTableView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
                cell?.contentView.addSubview(customTableView ?? UITableView())
            }
        }
        
        return cell ?? UITableViewCell()
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if cellIsSelected == indexPath {
            return 45 * 9
        }
        return 45
    }
    
    func cellDidSelectWithIndexAndtitle(index: NSInteger,title: String)
    {
        self.leftViewControllerDelegate?.cellDidSelectWithIndexAndtitle(index: index, title: title)

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let str : String? = titlesArray[indexPath.row]
        if (str?.equalsIgnoreCase(string: "Add a check") ?? false) {
            cellIsSelected = cellIsSelected == indexPath ? nil : indexPath
            tableView.beginUpdates()
            tableView.endUpdates()
            if ((cellIsSelected) != nil) {
                tableView.scrollToNearestSelectedRow(at: .top, animated: true)
//                tableView.contentSize = CGSize(width:screenSize.width, height: 20)

            }
            
        }else
        {
            self.leftViewControllerDelegate?.cellDidSelectWithIndexAndtitle(index: indexPath.row, title: titlesArray[indexPath.row])

        }
        
    }
    @IBAction func tandcClicked(_ sender: UIButton) {
        let nextViewController : WebPageViewController? = storyBoard?.instantiateViewController(withIdentifier: "webVC") as? WebPageViewController
        nextViewController?.title = "Terms and Conditions"
        nextViewController?.webURL = "https://www.kitchenlo.gs/terms/"
        self.present(nextViewController ?? UIViewController(), animated:true, completion:nil)
        
    }
    @IBAction func privacyPolicyClicked(_ sender: UIButton) {
        let nextViewController : WebPageViewController? = storyBoard?.instantiateViewController(withIdentifier: "webVC") as? WebPageViewController
        nextViewController?.title = "Privacy Policy"
        nextViewController?.webURL = "https://www.kitchenlo.gs/privacy-policy/"
        self.present(nextViewController ?? UIViewController(), animated:true, completion:nil)
    }
    
}
