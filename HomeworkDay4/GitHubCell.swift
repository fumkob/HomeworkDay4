//
//  GitHubCell.swift
//  HomeworkDay4
//
//  Created by Fumiaki Kobayashi on 2020/05/22.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import UIKit

class GitHubCell: UITableViewCell {

    @IBOutlet weak var repositoryNameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var forksLabel: UILabel!
    @IBOutlet weak var watchersLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var updatedDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
