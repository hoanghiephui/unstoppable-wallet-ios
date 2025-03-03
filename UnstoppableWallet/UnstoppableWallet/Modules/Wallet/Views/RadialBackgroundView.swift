import UIKit

class RadialBackgroundView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradients()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradients()
    }
    
    private func setupGradients() {
        // Giả sử 1dp ≈ 1pt trong iOS
        let dpToPt: CGFloat = 1.0
        let radius: CGFloat = 250 * dpToPt // Bán kính 250dp
        
        // Nền cơ bản (giả sử .themeTyler từ ThemeKit, nếu không thì dùng màu mặc định)
        backgroundColor = .themeTyler ?? .gray
        
        // 1. Gradient vàng
        let yellowGradient = CAGradientLayer()
        yellowGradient.type = .radial
        yellowGradient.colors = [
            UIColor(red: 0xED/255, green: 0xD7/255, blue: 0x16/255, alpha: 0x80/255).cgColor, // 0x80EDD716
            UIColor(red: 0xED/255, green: 0xD7/255, blue: 0x16/255, alpha: 0x00/255).cgColor  // 0x00EDD716
        ]
        yellowGradient.startPoint = CGPoint(x: (-50 * dpToPt) / bounds.width, y: (300 * dpToPt) / bounds.height)
        yellowGradient.endPoint = CGPoint(x: 0.5, y: 0.5)
        yellowGradient.radius = radius / min(bounds.width, bounds.height)
        layer.insertSublayer(yellowGradient, at: 0)
        
        // 2. Gradient cam
        let orangeGradient = CAGradientLayer()
        orangeGradient.type = .radial
        orangeGradient.colors = [
            UIColor(red: 0xFF/255, green: 0x9B/255, blue: 0x26/255, alpha: 0x40/255).cgColor, // 0x40FF9B26
            UIColor(red: 0xFF/255, green: 0x9B/255, blue: 0x26/255, alpha: 0x00/255).cgColor  // 0x00FF9B26
        ]
        orangeGradient.startPoint = CGPoint(x: 0.5, y: (400 * dpToPt) / bounds.height)
        orangeGradient.endPoint = CGPoint(x: 0.5, y: 0.5)
        orangeGradient.radius = radius / min(bounds.width, bounds.height)
        layer.insertSublayer(orangeGradient, at: 1)
        
        // 3. Gradient xanh dương
        let blueGradient = CAGradientLayer()
        blueGradient.type = .radial
        blueGradient.colors = [
            UIColor(red: 0x00/255, green: 0x3C/255, blue: 0x74/255, alpha: 0x73/255).cgColor, // 0x73003C74
            UIColor(red: 0x00/255, green: 0x3C/255, blue: 0x74/255, alpha: 0x00/255).cgColor  // 0x00003C74
        ]
        blueGradient.startPoint = CGPoint(x: (bounds.width + 50 * dpToPt) / bounds.width, y: (500 * dpToPt) / bounds.height)
        blueGradient.endPoint = CGPoint(x: 0.5, y: 0.5)
        blueGradient.radius = radius / min(bounds.width, bounds.height)
        layer.insertSublayer(blueGradient, at: 2)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Cập nhật frame cho các gradient khi kích thước thay đổi
        for layer in layer.sublayers ?? [] {
            if layer is CAGradientLayer {
                layer.frame = bounds
            }
        }
        
        // Cập nhật lại startPoint khi bounds thay đổi
        let dpToPt: CGFloat = 1.0
        if let yellowGradient = layer.sublayers?[0] as? CAGradientLayer {
            yellowGradient.startPoint = CGPoint(x: (-50 * dpToPt) / bounds.width, y: (300 * dpToPt) / bounds.height)
            yellowGradient.radius = (250 * dpToPt) / min(bounds.width, bounds.height)
        }
        if let orangeGradient = layer.sublayers?[1] as? CAGradientLayer {
            orangeGradient.startPoint = CGPoint(x: 0.5, y: (400 * dpToPt) / bounds.height)
            orangeGradient.radius = (250 * dpToPt) / min(bounds.width, bounds.height)
        }
        if let blueGradient = layer.sublayers?[2] as? CAGradientLayer {
            blueGradient.startPoint = CGPoint(x: (bounds.width + 50 * dpToPt) / bounds.width, y: (500 * dpToPt) / bounds.height)
            blueGradient.radius = (250 * dpToPt) / min(bounds.width, bounds.height)
        }
    }
}
