//
//  GoalDetailsView.swift
//  WorkoutsForABetterTomorrow
//
//  Created by ElioHanna on 26/09/2021.
//

import SwiftUI
import Combine

struct GoalDetailsView: View {
	
	@StateObject var viewModel: GoalDetailsViewModel
	
	var body: some View {
		List {
			GoalDetailsSection(viewModel: viewModel)
			GoalProgressSection(viewModel: viewModel)
		}
		.listStyle(InsetGroupedListStyle())
		.onAppear(perform: {
			viewModel.viewDidAppear()
		})
		.navigationTitle("Goal Details")
	}
}

fileprivate struct GoalDetailsSection: View {
	
	@ObservedObject var viewModel: GoalDetailsViewModel
	
	var body: some View {
		Section {
			if let image = viewModel.currentGoal.reward.trophy.image {
				Image(uiImage: image)
					.resizable()
					.scaledToFit()
			}
			Text("Title: \(viewModel.currentGoal.title)")
			Text("Description: \(viewModel.currentGoal.description)")
			Text("Goal: \(viewModel.goalDescription)")
		}
	}
}


fileprivate struct GoalProgressSection: View {

	@ObservedObject var viewModel: GoalDetailsViewModel

	var body: some View {
		Section {
			Text("you have achieved \(viewModel.goalCompletionPercentage)% of this goal")
		}
	}
}

struct GoalDetailsView_Previews: PreviewProvider {
	static var goal = Goal(id: 1000,
						   goal: 3000,
						   description: "Description", title: "Title",
						   type: .step,
						   reward: .init(trophy: .zombieHand,
										 points: 5))
	
	static var previews: some View {
		GoalDetailsView(viewModel: .init(healthSummaryUseCase: DefaultHealthSummaryUseCase(), currentGoal: goal))
	}
}
