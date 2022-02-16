//
//  MTableViewCell.swift
//  FAQmc2Soft
//
//  Created by Акифьев Максим  on 09.02.2022.
//

//import Foundation
import UIKit

final class CustomTableViewCell: UITableViewCell {
    
    lazy var chevron: UIImageView =
    {
        let image = UIImageView(image: UIImage(named: "chevron-right"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let containerView = UIStackView()
    private let questionView = CustomTableCellView()
    private let answerView = CustomTableDetailView()
    
    func setUI(text1: String, text2: String) {
        questionView.setUI(with: text1)
        answerView.setUI(with: text2)
    }
    
    func commonInit() {
        selectionStyle = .none
        addSubview(chevron)
        answerView.isHidden = true

        
        containerView.axis = .vertical

        contentView.addSubview(containerView)
        containerView.addArrangedSubview(questionView)
        containerView.addArrangedSubview(answerView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        questionView.translatesAutoresizingMaskIntoConstraints = false
        answerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
         
        chevron.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        chevron.centerYAnchor.constraint(equalTo: questionView.centerYAnchor).isActive = true
    }
}

extension CustomTableViewCell {
    var isDetailViewHidden: Bool {
        return answerView.isHidden
    }

    func showDetailView() {
        answerView.isHidden = false
        chevron.transform = CGAffineTransform(rotationAngle: -CGFloat(Double.pi/2))
    }

    func hideDetailView() {
        answerView.isHidden = true
        chevron.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
    }
 
}

final class CustomTableCellView: UIView {
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let title = UILabel()
    
    func setUI(with string: String) {
        title.text = string
    }
    
    func commonInit() {
        addSubview(title)
        title.textColor = .black
        title.numberOfLines = 0
        title.font = UIFont.systemFont(ofSize: 20)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        title.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        title.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -60).isActive = true
    }
}

final class CustomTableDetailView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let title = UILabel()

    func setUI(with string: String) {
        title.text = string
    }
    
    func commonInit() {
        addSubview(title)
        
        title.textColor = .darkGray
        title.numberOfLines = 0
        title.font = UIFont.systemFont(ofSize: 18)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        title.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30).isActive = true
        title.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
    }
}
