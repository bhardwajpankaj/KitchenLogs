//
//  CustomTableView.swift
//  KitchenLogs
//
//  Created by Pankaj Bhardwaj on 19/07/17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit
protocol CustomTableViewDelegate
{
    func cellDidSelectWithIndexAndtitle(index: NSInteger,title: String)
}
class CustomTableView: UIView,UITableViewDataSource,UITableViewDelegate {
     var myTableView: UITableView?
    var delegate : CustomTableViewDelegate?
    fileprivate let titlesArray = ["Food",
                                   "Appliances",
                                   "Pest Control",
                                   "Injury Log",
                                   "Probe Check"]
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override init(frame: CGRect) {
        super.init(frame: frame)
        myTableView = UITableView(frame: CGRect(x: 50, y: 15, width: 200, height: (titlesArray.count * 43)))
        myTableView?.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        myTableView?.dataSource = self
        myTableView?.delegate = self
        self.addSubview(myTableView ?? UITableView())
        myTableView?.backgroundColor = UIColor.clear;
        //call function

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    class func instanceFromNib() -> CustomTableView {

        return (UINib(nibName: "CustomTableView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? CustomTableView)!
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titlesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        cell.backgroundColor = .clear
        cell.textLabel?.text = titlesArray[indexPath.row]
        cell.textLabel?.font = UIFont(name: "Montserrat-Light", size: 16)
        cell.selectionStyle = .none
        cell.textLabel?.textColor = .white
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 43
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.cellDidSelectWithIndexAndtitle(index: indexPath.row, title: titlesArray[indexPath.row])
    }


}
//extension UIView {
//    class func fromNib<T : UIView>() -> T {
//        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
//    }
//}
