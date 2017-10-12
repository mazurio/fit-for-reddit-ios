import SnapKit

class TitleLabel: UILabel {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    func commonInit() {
        self.textAlignment = .left
        self.font = UIFont(name: "System", size: 20)
        self.textColor = UIColor.black
    }
}

class DescriptionTextView: UITextView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.commonInit()
    }
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        self.commonInit()

    }
    
    func commonInit() {
        self.textAlignment = .left
        self.font = UIFont(name: "System Font Regular", size: 17)
        self.textColor = UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1.00)
        self.isEditable = false
        self.isSelectable = false
    }
}

class WorkoutLogGeneralSnapKitViewController: UIViewController {
    lazy var card = CardView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.darkGray
        
        self.view.addSubview(card)
        
        card.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(view).offset(20)
            make.left.equalTo(view).offset(20)
            make.bottom.equalTo(view).offset(-20)
            make.right.equalTo(view).offset(-20)
        }
        
        let label = TitleLabel()
        label.text = "Title"
        
        card.addSubview(label)
        label.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(card).offset(20)
            make.left.equalTo(card).offset(16)
            make.right.equalTo(card).offset(-16)
            
            make.height.equalTo(24)
        }
        
        let textView = DescriptionTextView()
        textView.text = "Many people want to improve overall flexibility, but do not know where to begin. This routine should serve as a general jumping-off point for beginners."
        card.addSubview(textView)
        textView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(label.snp.bottom).offset(8)
            make.left.equalTo(card).offset(12)
            make.right.equalTo(card).offset(-12)
            make.bottom.equalTo(card).offset(-8)
        }
        
    }
}