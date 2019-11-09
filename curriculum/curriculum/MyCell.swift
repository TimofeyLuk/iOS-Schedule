//
//  myCell.swift
//  curriculum
//
//  Created by IvanLyuhtikov on 10/8/19.
//  Copyright © 2019 IvanLyuhtikov. All rights reserved.
//

import UIKit

struct UnitsOfSizeForCell {
    static let space: CGFloat = 5
    static let fontSize: CGFloat = 18
    static let textColor: UIColor = .magenta
    static let backgroundGroupColor: UIColor = .purple
}

class MyCell: UICollectionViewCell {
    
    
    var data: CurriculumDay? {
        didSet {
            guard let good = data else { return }
            pareLabel.text = good?.pare
            teacherLabel.text = good?.teacher
            groupLabel.text = good?.group
            roomLabel.text = good?.room
        }
    }
    
    
    var pareLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false ///: "AAAAAAA"
        label.textAlignment = .left
        label.backgroundColor = .white
        label.textColor = UnitsOfSizeForCell.textColor
        
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 10
        label.font = UIFont.boldSystemFont(ofSize: UnitsOfSizeForCell.fontSize)
        return label
    }()
    
    var teacherLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false ///: "AAAAAAA"
        
        label.textAlignment = .left
        label.numberOfLines = 0
        
        label.backgroundColor = .white
        label.textColor = UnitsOfSizeForCell.textColor
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 10
        label.font = UIFont.systemFont(ofSize: 15) //Edit
        return label
    }()
    
    var groupLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false ///: "AAAAAAA"
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 10
        label.backgroundColor = UnitsOfSizeForCell.backgroundGroupColor
        label.font = UIFont.boldSystemFont(ofSize: UnitsOfSizeForCell.fontSize)
        return label
    }()
    
    var roomLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false ///: "AAAAAAA"
        label.textAlignment = .left
        label.backgroundColor = .white
        label.textColor = UnitsOfSizeForCell.textColor
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 10
        label.font = UIFont.systemFont(ofSize: UnitsOfSizeForCell.fontSize)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(pareLabel)
        contentView.addSubview(teacherLabel)
        contentView.addSubview(groupLabel)
        contentView.addSubview(roomLabel)
        
        pareLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: UnitsOfSizeForCell.space).isActive = true
        pareLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: UnitsOfSizeForCell.space).isActive = true
        pareLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -contentView.frame.width/2-UnitsOfSizeForCell.space/2).isActive = true
        pareLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -contentView.frame.height/2-UnitsOfSizeForCell.space/2).isActive = true

        teacherLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: UnitsOfSizeForCell.space).isActive = true
        teacherLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: contentView.frame.height/2+UnitsOfSizeForCell.space/2).isActive = true
        teacherLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -contentView.frame.width/2-UnitsOfSizeForCell.space/2).isActive = true
        teacherLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -UnitsOfSizeForCell.space).isActive = true

        groupLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: contentView.frame.width/2+UnitsOfSizeForCell.space/2).isActive = true
        groupLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: UnitsOfSizeForCell.space).isActive = true
        groupLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -contentView.frame.width/4).isActive = true
        groupLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -contentView.frame.height/2-UnitsOfSizeForCell.space/2).isActive = true

        roomLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: contentView.frame.width/2+UnitsOfSizeForCell.space/2).isActive = true
        roomLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: contentView.frame.height/2+UnitsOfSizeForCell.space/2).isActive = true
        roomLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -UnitsOfSizeForCell.space).isActive = true
        roomLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -UnitsOfSizeForCell.space).isActive = true
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
