//
//  dropdownview.swift
//  Aomtung
//
//  Created by Karnnapat Kamolwisutthipong on 12/2/2567 BE.
//

import UIKit

class dropdownview: UIView {

    var optionSelected: ((String) -> Void)?

        override init(frame: CGRect) {
            super.init(frame: frame)
            setupUI()
        }

    private let label: UILabel = {
            let label = UILabel()
            label.textColor = .black // กำหนดสีของ Text เป็นดำ
            label.textAlignment = .center
            return label
        }()
    
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setupUI()
        }

        private func setupUI() {
            // ปรับแต่ง UI ตามความต้องการของคุณ
            backgroundColor = UIColor.white
            layer.cornerRadius = 8
            clipsToBounds = true

            label.translatesAutoresizingMaskIntoConstraints = false
                   addSubview(label)
            
            let options = ["ทั้งหมด", "ทุกวัน", "สัปดาห์", "ทุกเดือน", "ทุก 3 เดือน"]
            var topAnchor = self.topAnchor

            options.forEach { option in
                let button = UIButton(type: .system)
                button.setTitle(option, for: .normal)
                button.addTarget(self, action: #selector(optionButtonTapped(_:)), for: .touchUpInside)
                button.translatesAutoresizingMaskIntoConstraints = false
                addSubview(button)

                NSLayoutConstraint.activate([
                    button.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                    button.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                    button.topAnchor.constraint(equalTo: topAnchor),
                    button.heightAnchor.constraint(equalToConstant: 40)
                ])

                topAnchor = button.bottomAnchor
            }
        }

        @objc private func optionButtonTapped(_ sender: UIButton) {
            guard let option = sender.currentTitle else { return }
            optionSelected?(option)
        }
    func setLabelText(_ text: String) {
            label.text = text
        }
}
