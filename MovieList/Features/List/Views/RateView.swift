import Foundation
import UIKit

final class RateView: UIView {
    private let fillView = UIView()
    private var widthFillViewConstraint: NSLayoutConstraint?
    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setRateValue(rate: Double) {
        if let widthFillViewConstraint = widthFillViewConstraint {
            NSLayoutConstraint.deactivate([widthFillViewConstraint])
        }
        widthFillViewConstraint = fillView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: rate / 10)
        widthFillViewConstraint?.isActive = true
    }

    private func setup() {
        fillView.backgroundColor = .orange
        fillView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(fillView)
        NSLayoutConstraint.activate([
            fillView.topAnchor.constraint(equalTo: topAnchor),
            fillView.bottomAnchor.constraint(equalTo: bottomAnchor),
            fillView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }
}
