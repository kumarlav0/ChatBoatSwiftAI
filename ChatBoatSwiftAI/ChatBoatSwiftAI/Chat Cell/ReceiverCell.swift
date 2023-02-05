//
//  ReceiverCell.swift
//  ChatBoatSwiftAI
//
//  Created by mac on 04/02/23.
//

import UIKit

protocol ReceiverCellDelegate: AnyObject {
    func copyAnswer(text: String)
}

class ReceiverCell: UITableViewCell {
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var copyContentBtn: UIButton!

    weak var delegate: ReceiverCellDelegate?


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
        DispatchQueue.main.async {
            self.copyContentBtn.isHidden = message.hideCopyButton
        }
    }

    @IBAction func copyContent(_ sender: UIButton) {
        delegate?.copyAnswer(text: messageLbl.text!)
    }
    
}
