//
//  LeftViewCell.swift
//  LGSideMenuControllerDemo
//
import UIKit

class LeftViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel?
    @IBOutlet var myImageView: UIImageView?

    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = .clear
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        titleLabel?.alpha = highlighted ? 0.5 : 1.0
    }

}
