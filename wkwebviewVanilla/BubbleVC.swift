import UIKit

class BubbleVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    lazy var bubbleView: BubbleView = {
        let bubbleView = BubbleView(frame: CGRect(x: 80, y: 0, width: 160, height: 160))
        bubbleView.backgroundColor = .blue
        bubbleView.layer.cornerRadius = 80
        bubbleView.delegate = self
        return bubbleView
    }()
    override func loadView() {
        super.loadView()
        view.addSubview(bubbleView)
    }
}
extension BubbleVC: BubbleViewDelegate {
    func userDidTap(into bubbleView: BubbleView) {
        let currentBounds = view.bounds
        UIView.animate(withDuration: 1.5) {
            var frame = bubbleView.frame
            frame.origin.y = currentBounds.height
            bubbleView.frame = frame
        }
    }
}


