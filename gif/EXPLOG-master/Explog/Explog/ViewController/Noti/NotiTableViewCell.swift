
import UIKit

class NotiTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var profileOfWidth: NSLayoutConstraint!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var statusMessageLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layoutIfNeeded()
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        let profileHeight: CGFloat = self.profileImage.bounds.size.height
        profileOfWidth.constant = profileHeight - 140
        profileImage.layer.cornerRadius = profileOfWidth.constant * 0.5
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
