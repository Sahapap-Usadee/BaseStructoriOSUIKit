import UIKit

// Note: TodayCard is in the same module so no need for additional imports

// ✅ TodayCardCell - เอา TestSimpleCell มาใช้แทน เพราะมันทำงานได้
class TodayCardCell: UICollectionViewCell {
    static let identifier = "TodayCardCell"
    
    private let backgroundColorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Today Card"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // ✅ Clear backgrounds
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        clipsToBounds = false
        contentView.clipsToBounds = false
        
        // ✅ iOS 14+ background configuration
        var config = UIBackgroundConfiguration.clear()
        backgroundConfiguration = config
        
        // Method 4: Override layer properties
        layer.masksToBounds = false
        contentView.layer.masksToBounds = false
        
        // Add views
        contentView.addSubview(backgroundColorView)
        backgroundColorView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            backgroundColorView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            backgroundColorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            backgroundColorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            backgroundColorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            titleLabel.centerXAnchor.constraint(equalTo: backgroundColorView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: backgroundColorView.centerYAnchor)
        ])
        
        // ✅ App Store style shadow
        setupShadow()
        setupHoverEffect()
    }
    
    private func setupShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 10
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.masksToBounds = false
    }
    
    private func setupHoverEffect() {
        print("🔍 TodayCardCell: Setting up hover effect")
        let hoverGesture = UIHoverGestureRecognizer(target: self, action: #selector(handleHover(_:)))
        addGestureRecognizer(hoverGesture)
        print("🔍 TodayCardCell: Hover gesture added")
    }
    
    @objc private func handleHover(_ gesture: UIHoverGestureRecognizer) {
        print("🔍 TodayCardCell: handleHover called with state: \(gesture.state.rawValue)")
        
        switch gesture.state {
        case .began, .changed:
            print("🔍 TodayCardCell: Hover BEGAN - starting animation")
            // ✅ App Store style hover animation
            UIView.animate(
                withDuration: 0.4,
                delay: 0,
                usingSpringWithDamping: 0.7,
                initialSpringVelocity: 0.5,
                options: [.allowUserInteraction, .beginFromCurrentState]
            ) {
                self.transform = CGAffineTransform(scaleX: 1.02, y: 1.02)
                self.layer.shadowOpacity = 0.25
                self.layer.shadowRadius = 15
                self.layer.shadowOffset = CGSize(width: 0, height: 8)
            }
        case .ended, .cancelled:
            print("🔍 TodayCardCell: Hover ENDED - returning to normal")
            // ✅ Return to normal animation
            UIView.animate(
                withDuration: 0.4,
                delay: 0,
                usingSpringWithDamping: 0.7,
                initialSpringVelocity: 0.5,
                options: [.allowUserInteraction, .beginFromCurrentState]
            ) {
                self.transform = .identity
                self.layer.shadowOpacity = 0.1
                self.layer.shadowRadius = 10
                self.layer.shadowOffset = CGSize(width: 0, height: 4)
            }
        default:
            print("🔍 TodayCardCell: Hover OTHER state: \(gesture.state.rawValue)")
            break
        }
    }
    
    // ✅ App Store style tap animation
    override var isHighlighted: Bool {
        didSet {
            print("🔍 TodayCardCell: isHighlighted = \(isHighlighted)")
            
            if isHighlighted != oldValue {
                if isHighlighted {
                    // ✅ Tap down animation - เหมือน App Store
                    print("🔍 TodayCardCell: Starting tap down animation")
                    UIView.animate(
                        withDuration: 0.1,
                        delay: 0,
                        options: [.allowUserInteraction, .beginFromCurrentState]
                    ) {
                        self.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
                        self.alpha = 0.9
                    }
                } else {
                    // ✅ Tap up animation - spring back
                    print("🔍 TodayCardCell: Starting tap up animation")
                    UIView.animate(
                        withDuration: 0.3,
                        delay: 0,
                        usingSpringWithDamping: 0.6,
                        initialSpringVelocity: 0.4,
                        options: [.allowUserInteraction, .beginFromCurrentState]
                    ) {
                        self.transform = .identity
                        self.alpha = 1.0
                    }
                }
            }
        }
    }
    
    override var isSelected: Bool {
        didSet {
            print("🔍 TodayCardCell: isSelected = \(isSelected)")
            // ไม่ทำอะไรเลย เพราะ deselect ทันที
        }
    }
    
    // ✅ เพิ่ม debug เพื่อดูว่า touches ถูกจัดการไหม
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        print("🔍 TodayCardCell: touchesBegan called")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        print("🔍 TodayCardCell: touchesEnded called")
    }
    
    // ✅ เพิ่ม configure method สำหรับ TodayCard
    func configure(with card: TodayCard) {
        titleLabel.text = card.title
        backgroundColorView.backgroundColor = card.backgroundColor
    }
}