import UIKit

// MARK: Path 아직 미구현, 기획단 수정 요망.
class AddPathViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        setnavigationController()
    }
    @objc func addpostButtonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func backPostButtonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func setnavigationController() {
        self.navigationItem.title = "경로 추가"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                                 target: self,
                                                                 action: #selector(self.addpostButtonAction(_:)) )
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                                target: self,
                                                                action: #selector(self.backPostButtonAction(_:)))
    }
}
