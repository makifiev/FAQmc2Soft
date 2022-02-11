//
//  MTableViewCell.swift
//  FAQmc2Soft
//
//  Created by Акифьев Максим  on 09.02.2022.
//

//import Foundation
import UIKit
class MTableViewCell: UITableViewCell
{
        lazy var questionLabel: UILabel =
        {
            let label = UILabel()
            label.textColor = .black
            label.numberOfLines = 0
            label.font = UIFont.systemFont(ofSize: 20)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        lazy var answerLabel: UILabel =
        {
            let label = UILabel()
            label.textColor = .gray
            label.numberOfLines = 0
            label.font = UIFont.systemFont(ofSize: 18)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.isHidden = true
            return label
        }()
    lazy var chevron: UIImageView =
    {
        let image = UIImageView(image: UIImage(named: "chevron-right"))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let stackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setCellView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setCellView()
    }
    
    func setCellView() {
        
        selectionStyle = .none
        self.contentView.backgroundColor = .white
        
        
        
        
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 5
        stackView.alignment = .fill
//        stackView.backgroundColor = .red
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(stackView)
         
        questionLabel.numberOfLines = 0
        questionLabel.lineBreakMode = .byWordWrapping
        stackView.addArrangedSubview(questionLabel)
         
        answerLabel.numberOfLines = 0
        answerLabel.lineBreakMode = .byWordWrapping
        stackView.addArrangedSubview(answerLabel)
        
        self.contentView.addSubview(chevron)
        
        questionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 30).isActive = true
        questionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12).isActive = true
        questionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -60).isActive = true
          
        answerLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 30).isActive = true
        answerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12).isActive = true
        answerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        
        stackView.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor,constant: 10).isActive = true
        stackView.topAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.topAnchor,constant: 10).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor,constant: 10).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.bottomAnchor,constant: -10).isActive = true
        
 
        chevron.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -10).isActive = true
        chevron.centerYAnchor.constraint(equalTo: questionLabel.centerYAnchor).isActive = true
    }
    
    func configureCell(questionText: String, answerText: String)
    {
        questionLabel.text = questionText
        answerLabel.text = answerText
    }
}
