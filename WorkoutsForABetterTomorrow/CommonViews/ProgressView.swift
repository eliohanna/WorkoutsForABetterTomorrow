//
//  ProgressView.swift
//  WorkoutsForABetterTomorrow
//
//  Created by ElioHanna on 26/09/2021.
//

import UIKit

class ProgressView: UIView {
	var progressColor: UIColor = .clear { didSet { setNeedsDisplay() } }
	var progress: Double = 0 { didSet { setNeedsDisplay() } }
	
	private let progressLayer = CALayer()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		layer.insertSublayer(progressLayer, at: 0)
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		layer.insertSublayer(progressLayer, at: 0)
	}
	
	override func draw(_ rect: CGRect) {
		let backgroundMask = CAShapeLayer()
		backgroundMask.path = UIBezierPath(roundedRect: rect, cornerRadius: rect.height * 0.1).cgPath
		layer.mask = backgroundMask
		
		let progressRect = CGRect(origin: .zero, size: CGSize(width: rect.width * CGFloat(progress), height: rect.height))
		progressLayer.frame = progressRect
		progressLayer.backgroundColor = progressColor.cgColor
	}
}
