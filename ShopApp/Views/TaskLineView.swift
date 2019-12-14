//
//  TaskLineView.swift
//  ShopApp
//
//  Created by Nguyễn Đức Huy on 12/13/19.
//  Copyright © 2019 Nguyễn Đức Huy. All rights reserved.
//

import UIKit

class TaskLineView: UIView {
    let containerStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.gray
        view.axis = .horizontal
        view.alignment = UIStackView.Alignment.center
        view.distribution = UIStackView.Distribution.equalSpacing
        return view
    }()
    
    let label1 = TransactionLabel(style: TransactionLabel.Style.default)
    let label2 = TransactionLabel(style: TransactionLabel.Style.default)
    
    
    
    
    var transactionLabels: [TransactionLabel] = [TransactionLabel]()
    var lineViews: [UIView] = [UIView]()
    
    init(taskQuantity: Int) {
//        transactionLabel = Array(repeating: TransactionLabel(style: TransactionLabel.Style.default), count: taskQuantity)
        assert(taskQuantity >= 1, "task quantity must be greater than 1")
        
        for _ in 0..<taskQuantity {
            transactionLabels.append(TransactionLabel(style: TransactionLabel.Style.default))
            
            let view = UIView()
            view.backgroundColor = UIColor.black
            view.translatesAutoresizingMaskIntoConstraints = false
            view.layer.cornerRadius = 2
            view.layer.masksToBounds = true
            lineViews.append(view)
        }
        
        lineViews.removeLast()
        
        super.init(frame: CGRect.zero)
        
        setupViews()
    }
    
    private func setupViews() {
//        addSubview(containerView)
        addSubview(containerStackView)
        
        containerStackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        containerStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        containerStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        containerStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        
        
        print("trans", containerStackView)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        DispatchQueue.main.async {
            self.setNeedsDisplay()
            self.setNeedsLayout()
            self.containerStackView.setNeedsDisplay()
            self.containerStackView.setNeedsLayout()
            
            var tempIndex1 = 0
            var tempIndex2 = 0
            let transtactionLabelLength: CGFloat = self.containerStackView.frame.height
            
            let lineViewWidth: CGFloat = (self.frame.width - (transtactionLabelLength * CGFloat(self.transactionLabels.count)) - (4 * CGFloat(self.lineViews.count)) ) / CGFloat(self.lineViews.count)
            // (total self width - (total label width in self view) - (leading and trailing spacing of lineView) ) / (the quantity of lineViews) -> the width of line view
            
            
            print("lineViewWidth", lineViewWidth)
            
            for i in 0..<self.transactionLabels.count + self.lineViews.count {
                
                if i % 2 == 0 {
                    let label = self.transactionLabels[tempIndex1]
                    label.translatesAutoresizingMaskIntoConstraints = false
                    label.text = "\(tempIndex1 + 1)"
                    
                    label.heightAnchor.constraint(equalToConstant: transtactionLabelLength).isActive = true
                    label.widthAnchor.constraint(equalToConstant: transtactionLabelLength).isActive = true
                    
                    self.containerStackView.addArrangedSubview(label)
                    
                    tempIndex1 += 1
                } else {
                    let view = self.lineViews[tempIndex2]
                    
                    view.heightAnchor.constraint(equalToConstant: 1).isActive = true
                    view.widthAnchor.constraint(equalToConstant: lineViewWidth).isActive = true
                    
                    self.containerStackView.addArrangedSubview(view)
                    
                    tempIndex2 += 1
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
