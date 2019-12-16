import UIKit

class BubbleView: UIView {
    
    weak var delegate: BubbleViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    private func setup() {
        self.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BubbleView.didTapIntoButton))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    

    
    @objc func didTapIntoButton(_ sender: UITapGestureRecognizer) {
        delegate?.userDidTap(into: self)
    }
}

protocol BubbleViewDelegate: class {
    func userDidTap(into bubbleView: BubbleView)
}
