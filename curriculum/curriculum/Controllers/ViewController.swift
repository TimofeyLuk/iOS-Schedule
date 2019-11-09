//
//  ViewController.swift
//  curriculum
//
//  Created by IvanLyuhtikov on 10/6/19.
//  Copyright © 2019 IvanLyuhtikov. All rights reserved.
//

import UIKit
import AudioToolbox
import Kanna

typealias CurriculumDay = (pare: String, teacher: String, room: String, group: String)?

let arrayOfDays = ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Cуббота"]
let link = "https://kbp.by/rasp/timetable/view_beta_kbp/?cat=group&id=89"
let fontDefault: CGFloat = 17
let fontDayOfWeek: CGFloat = 50
var switcherWeek = "lw"
var numOfWeek = 0




class ViewController: UIViewController {
    
    let nonePareStr = "Пара снята"
    var segment: UISegmentedControl!
    
    var currentDay: Int = {
        return Calendar.current.dayOfWeek()
    }()
    
    
    var indicator: UIActivityIndicatorView!
    
    var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(MyCell.self, forCellWithReuseIdentifier: StringIdentifierCell.defCell)
        cv.register(MyNilCollectionViewCell.self, forCellWithReuseIdentifier: StringIdentifierCell.nilCell)
        cv.register(DayOfWeekCell.self, forCellWithReuseIdentifier: StringIdentifierCell.dayCell)
        return cv
    }()
    
    var final = [[CurriculumDay]]()
    
    override func loadView() {
        
        super.loadView()
        var arr: [String] = []

        RequestKBP.getData(stringURL: link,
                           format: ["p[class='today'] "], closure: {
                            arr.append($0 as! String)
                   })

        RequestKBP.dispGroup.notify(queue: .main)
        {
            print(arr[0])
            numOfWeek = arr[0].contains("первая неделяОзнакомление") ? 1 : 2
            print(numOfWeek)
        }

       RequestKBP.dispGroup.wait()
    }
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        
        RequestKBP.dispGroup.wait()
    
        RequestKBP.dispGroup.notify(queue: .main) {
            
            self.view.backgroundColor = #colorLiteral(red: 0.5810584426, green: 0.1285524964, blue: 0.5745313764, alpha: 1)
            
            self.setSegmentControl()
            self.setIcon()
            
            self.collectionView.isPagingEnabled = true
            
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
            
            self.view.addSubview(self.collectionView)
            self.setCollectionViewConstraints()
            
            self.setLoading()
            
            
            //MARK: - Work with HTML
            
            var strAll = String()
        
            RequestKBP.getData(stringURL: link,
                               format: ["td[class='number'], div[class='pair \(switcherWeek)_1'] ,div[class='pair \(switcherWeek)_1 added'], div[class='pair \(switcherWeek)_1 week week\(numOfWeek)']",
                                        "td[class='number'], div[class='pair \(switcherWeek)_2'] ,div[class='pair \(switcherWeek)_2 added'], div[class='pair \(switcherWeek)_2 week week\(numOfWeek)']",
                                        "td[class='number'], div[class='pair \(switcherWeek)_3'] ,div[class='pair \(switcherWeek)_3 added'], div[class='pair \(switcherWeek)_3 week week\(numOfWeek)']",
                                        "td[class='number'], div[class='pair \(switcherWeek)_4'] ,div[class='pair \(switcherWeek)_4 added'], div[class='pair \(switcherWeek)_4 week week\(numOfWeek)']",
                                        "td[class='number'], div[class='pair \(switcherWeek)_5'] ,div[class='pair \(switcherWeek)_5 added'], div[class='pair \(switcherWeek)_5 week week\(numOfWeek)']",
                                        "td[class='number'], div[class='pair \(switcherWeek)_6'] ,div[class='pair \(switcherWeek)_6 added'], div[class='pair \(switcherWeek)_6 week week\(numOfWeek)']"
                                        ],
                               closure: {
                                strAll.append($0 as! String)
                                self.final.append(curriculumDayFinal($0 as! String))

            })

            RequestKBP.dispGroup.notify(queue: .main) {
                print("It's end of loading HTML data")
                self.indicator.stopAnimating()
                self.collectionView.reloadData()
                self.collectionView.scrollToItem(at: IndexPath(item: 0, section: self.currentDay), at: .centeredHorizontally, animated: true)
                
                
                print(self.final)
            }
        }
    }
    
    
    //MARK: - Setting funcs
    
    fileprivate func setLoading() {
        indicator = UIActivityIndicatorView(frame: CGRect(x: view.frame.midX-10, y: view.frame.midY-10, width: 20, height: 20))
        collectionView.addSubview(indicator)
        indicator.startAnimating()
    }
    
    fileprivate func setCollectionViewConstraints() {
//        let blurEffect = UIBlurEffect(style: .light)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = view.bounds
//        let image = UIImage(named: "jakeTheDog.jpg")
//        let imageView = UIImageView(frame: view.bounds)
//        imageView.image = image
//        imageView.addSubview(blurEffectView)

//        collectionView.backgroundView = imageView
        
        collectionView.backgroundColor = #colorLiteral(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 1)
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    
    fileprivate func setSegmentControl() {
        segment = UISegmentedControl(items: ["Сейчас", "Следующая"])
        segment.addTarget(self, action: #selector(segmentChange), for: .valueChanged)
        segment.selectedSegmentIndex = 0
        segment.frame.size = CGSize(width: view.frame.width/2, height: view.frame.height/17)
        segment.center = CGPoint(x: view.frame.midX, y: segment.frame.height/2+40)
        view.addSubview(segment)
    }
    
    @objc fileprivate func segmentChange() {
        
        switcherWeek = switcherWeek == "rw" ? "lw" : "rw"
        numOfWeek = numOfWeek == 1 ? 2 : 1
        var copyFinal = [[CurriculumDay]]()
        
        RequestKBP.getData(stringURL: link,
                           format: ["td[class='number'], div[class='pair \(switcherWeek)_1'] ,div[class='pair \(switcherWeek)_1 added'], div[class='pair \(switcherWeek)_1 week week\(numOfWeek)']",
                                    "td[class='number'], div[class='pair \(switcherWeek)_2'] ,div[class='pair \(switcherWeek)_2 added'], div[class='pair \(switcherWeek)_2 week week\(numOfWeek)']",
                                    "td[class='number'], div[class='pair \(switcherWeek)_3'] ,div[class='pair \(switcherWeek)_3 added'], div[class='pair \(switcherWeek)_3 week week\(numOfWeek)']",
                                    "td[class='number'], div[class='pair \(switcherWeek)_4'] ,div[class='pair \(switcherWeek)_4 added'], div[class='pair \(switcherWeek)_4 week week\(numOfWeek)']",
                                    "td[class='number'], div[class='pair \(switcherWeek)_5'] ,div[class='pair \(switcherWeek)_5 added'], div[class='pair \(switcherWeek)_5 week week\(numOfWeek)']",
                                    "td[class='number'], div[class='pair \(switcherWeek)_6'] ,div[class='pair \(switcherWeek)_6 added'], div[class='pair \(switcherWeek)_6 week week\(numOfWeek)']"
                                    ],
                           closure: {
//                            strAll.append($0 as! String)
                            copyFinal.append(curriculumDayFinal($0 as! String))
                            

        })
        
        
        RequestKBP.dispGroup.notify(queue: .main) {
            self.final = copyFinal
            self.collectionView.reloadData()
            
            if self.segment.selectedSegmentIndex == 1 {
                self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: true)
            } else {
                self.collectionView.scrollToItem(at: IndexPath(item: 0, section: self.currentDay), at: .centeredHorizontally, animated: true)
            }
        }
        
        copyFinal = []
    }
    
    
    fileprivate func setIcon() {
        let imageV = UIImageView(image: #imageLiteral(resourceName: "kbp"))
        imageV.contentMode = .scaleAspectFit
        navigationItem.titleView = imageV
    }
    
    

    override func viewSafeAreaInsetsDidChange() {
        print("safe area")
    }
    
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        print(currentDay)
        AudioServicesPlaySystemSound(1521)
        collectionView.scrollToItem(at: IndexPath(item: 0, section: currentDay), at: .centeredHorizontally, animated: true)
    }
    

}
