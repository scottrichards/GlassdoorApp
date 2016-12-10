//
//  CompanyCell.swift
//  GlassdoorApp
//
//  Created by Scott Richards on 11/19/16.
//  Copyright © 2016 Scott Richards. All rights reserved.
//

import UIKit

class CompanyCell: UITableViewCell {
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
