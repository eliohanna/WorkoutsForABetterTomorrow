//
//  GoalTableViewCell.swift
//  WorkoutsForABetterTomorrow
//
//  Created by ElioHanna on 26/09/2021.
//

import UIKit

class GoalTableViewCell: UITableViewCell {
	@IBOutlet private weak var typeImageView: UIImageView!
	@IBOutlet private weak var cardView: ProgressView!
	@IBOutlet private weak var titleLabel: UILabel!
	@IBOutlet private weak var descriptionLabel: UILabel!
	@IBOutlet private weak var trophyImageView: UIImageView!
	
	override func prepareForReuse() {
		super.prepareForReuse()
		cardView.progress = 0
	}
	
	func configure(for viewModel: GoalViewModel) {
		typeImageView.image = viewModel.goal.type.image
		titleLabel.text = viewModel.goal.title
		descriptionLabel.text = viewModel.goal.description
		trophyImageView.image = viewModel.goal.reward.trophy.image
		
		cardView.progressColor = UIColor(named: "mainColor")?.withAlphaComponent(0.5) ?? .clear
		cardView.progress = viewModel.progress
	}
}
