//
//  DotAnimationCell.swift
//  ChatBoatSwiftAI
//
//  Created by macmini46 on 30/03/23.
//

import UIKit

class DotAnimationCell: UITableViewCell {
    
    @IBOutlet weak var dotBackgroundView: UIView!
    @IBOutlet weak var dotView3: UIView!
    @IBOutlet weak var dotView2: UIView!
    @IBOutlet weak var dotView1: UIView!
    @IBOutlet weak var stackView: UIStackView!
    
    private lazy var circles = [dotView1, dotView2, dotView3]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dotBackgroundView.layer.cornerRadius = 20
        
        circles.forEach {
            $0?.layer.cornerRadius = 5
            $0?.layer.masksToBounds = true
            $0?.backgroundColor = .black
            stackView.addArrangedSubview($0 ?? UIView())
            $0?.widthAnchor.constraint(equalToConstant: 10).isActive = true
            $0?.heightAnchor.constraint(equalToConstant: 10).isActive = true
        }
        animate()
    }
    
    func animate() {
        let jumpDuration: Double = 0.30
        let delayDuration: Double = 1.25
        let totalDuration: Double = delayDuration + jumpDuration*2

        let jumpRelativeDuration: Double = jumpDuration / totalDuration
        let jumpRelativeTime: Double = delayDuration / totalDuration
        let fallRelativeTime: Double = (delayDuration + jumpDuration) / totalDuration

        for (index, circle) in circles.enumerated() {
            let delay = jumpDuration*2 * TimeInterval(index) / TimeInterval(circles.count)
            UIView.animateKeyframes(withDuration: totalDuration, delay: delay, options: [.repeat], animations: {
                UIView.addKeyframe(withRelativeStartTime: jumpRelativeTime, relativeDuration: jumpRelativeDuration) {
                    circle?.frame.origin.y -= 5
                }
                UIView.addKeyframe(withRelativeStartTime: fallRelativeTime, relativeDuration: jumpRelativeDuration) {
                    circle?.frame.origin.y += 5
                }
            })
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
