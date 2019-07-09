//
//  SatelliteTableViewCell.swift
//  CityGNSS
//
//  Created by Tiago Maia on 27/06/2019.
//  Copyright © 2019 Tiago Maia. All rights reserved.
//

import UIKit

class SatelliteTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var lb_sat_name: UILabel!
    @IBOutlet weak var lb_sat_id: UILabel!
    @IBOutlet weak var lb_sat_azimuth: UILabel!
    @IBOutlet weak var lb_sat_elevation: UILabel!
    
    
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
