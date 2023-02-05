//
//  SenderCell.swift
//  ChatBoatSwiftAI
//
//  Created by Kumar Lav on 04/02/23.
//

import UIKit

class SenderCell: UITableViewCell {
    @IBOutlet weak var messageLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(with message: MessageModel) {
        messageLbl.text = message.content
    }
    
}

