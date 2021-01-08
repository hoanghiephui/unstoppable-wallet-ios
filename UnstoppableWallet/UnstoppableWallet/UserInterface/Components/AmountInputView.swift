import UIKit
import ThemeKit
import SnapKit

class AmountInputView: UIView {
    let viewHeight: CGFloat = 85

    private let inputStackView = InputStackView()
    private let separatorView = UIView()
    private let secondaryButton = UIButton()

    private let prefixView = InputPrefixWrapperView()
    private let maxView = InputButtonWrapperView(style: .secondaryDefault)

    var onChangeText: ((String?) -> ())?
    var onTapMax: (() -> ())?
    var onTapSecondary: (() -> ())?

    init() {
        super.init(frame: .zero)

        backgroundColor = .clear

        addSubview(inputStackView)
        inputStackView.snp.makeConstraints { maker in
            maker.leading.top.trailing.equalToSuperview()
        }

        addSubview(separatorView)
        separatorView.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview().inset(CGFloat.margin8)
            maker.top.equalTo(inputStackView.snp.bottom)
            maker.height.equalTo(CGFloat.heightOnePixel)
        }

        separatorView.backgroundColor = .themeSteel20

        addSubview(secondaryButton)
        secondaryButton.snp.makeConstraints { maker in
            maker.leading.trailing.bottom.equalToSuperview()
            maker.top.equalTo(separatorView.snp.bottom)
        }

        secondaryButton.titleLabel?.font = .subhead2
        secondaryButton.contentHorizontalAlignment = .leading
        secondaryButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: .margin12, bottom: 0, right: .margin12)
        secondaryButton.setTitleColor(.themeBran, for: .normal)
        secondaryButton.setTitleColor(.themeGray50, for: .disabled)
        secondaryButton.addTarget(self, action: #selector(onTapSecondaryButton), for: .touchUpInside)

        prefixView.isHidden = true

        maxView.button.setTitle("send.max_button".localized, for: .normal)
        maxView.onTapButton = { [weak self] in self?.onTapMax?() }

        inputStackView.prependSubview(prefixView, customSpacing: 0)
        inputStackView.appendSubview(maxView)

        inputStackView.placeholder = "0"
        inputStackView.keyboardType = .decimalPad
        inputStackView.maximumNumberOfLines = 1
        inputStackView.onChangeText = { [weak self] text in
            self?.handleChange(text: text)
        }

        syncButtonStates()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func onTapSecondaryButton() {
        onTapSecondary?()
    }

    private func handleChange(text: String?) {
        onChangeText?(text)
        syncButtonStates()
    }

    private func syncButtonStates() {
        if let text = inputStackView.text, !text.isEmpty {
            maxView.isHidden = true
        } else {
            maxView.isHidden = onTapMax == nil
        }
    }

}

extension AmountInputView {

    var inputPlaceholder: String? {
        get { inputStackView.placeholder }
        set { inputStackView.placeholder = newValue }
    }

    var inputText: String? {
        get { inputStackView.text }
        set { inputStackView.text = newValue }
    }

    var prefix: String? {
        get { prefixView.label.text }
        set {
            prefixView.label.text = newValue
            prefixView.isHidden = newValue == nil
        }
    }

    var secondaryButtonText: String? {
        get { secondaryButton.title(for: .normal) }
        set { secondaryButton.setTitle(newValue, for: .normal) }
    }

    var secondaryButtonEnabled: Bool {
        get { secondaryButton.isEnabled }
        set { secondaryButton.isEnabled = newValue }
    }

    var isValidText: ((String) -> Bool)? {
        get { inputStackView.isValidText }
        set { inputStackView.isValidText = newValue }
    }

}
