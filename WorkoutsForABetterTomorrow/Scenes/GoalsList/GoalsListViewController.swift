//
//  GoalsListViewController.swift
//  WorkoutsForABetterTomorrow
//
//  Created by ElioHanna on 25/09/2021.
//

import UIKit
import Combine

class GoalsListViewController: UIViewController {
	// MARK: - private properties
	private let viewModel: GoalsListViewModelProtocol
	private var cancellableSet: Set<AnyCancellable> = Set()
	private lazy var dataSource = makeDataSource()
	
	@IBOutlet private weak var tableView: UITableView!
	
	// MARK: - initializers
	required init?(coder: NSCoder, viewModel: GoalsListViewModelProtocol) {
		self.viewModel = viewModel
		super.init(coder: coder)
	}
	
	required init?(coder: NSCoder) {
		fatalError("You must call `init(coder:, input:)` to create a `GoalsListViewController` instance.")
	}
	
	static func create(viewModel: GoalsListViewModel) -> Self {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		return storyboard.instantiateViewController(identifier: storyboardIdentity, creator: { coder in
			self.init(coder: coder, viewModel: viewModel)
		})
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupViews()
		bindToViewModel()
		
		viewModel.viewDidLoad()
	}
	
	private func setupViews() {
		tableView.register(cellNib: GoalTableViewCell.self)
		tableView.dataSource = dataSource
		tableView.delegate = self
		tableView.tableFooterView = UIView()
		
		title = "Goals"
		navigationController?.navigationBar.backgroundColor = .systemBackground
		navigationController?.navigationBar.prefersLargeTitles = true
	}
	
	private func bindToViewModel() {
		viewModel.goalListStatePublisher
			.receive(on: DispatchQueue.main)
			.sink(receiveValue: { [weak self] state in
				self?.render(state)
			})
			.store(in: &cancellableSet)
	}
	
	/// this will render the UI according to the current state, there was not enough time to handle all the cases
	private func render(_ state: GoalsListState) {
		switch state {
		case .unauthorized:
			break
		case .loading:
			// should show loading indicator as well
			update(with: [], animate: true)
		case .noResults:
			// should show empty state as well
			update(with: [], animate: true)
		case .failure:
			// should show error as well
			update(with: [], animate: true)
		case .success(let goals):
			update(with: goals, animate: true)
		}
	}
}

extension GoalsListViewController: UITableViewDelegate {
	enum Section: CaseIterable {
		case goals
	}
	
	func makeDataSource() -> UITableViewDiffableDataSource<Section, GoalViewModel> {
		return UITableViewDiffableDataSource(
			tableView: tableView,
			cellProvider: { (tableView, indexPath, goal) in
				guard let cell: GoalTableViewCell = tableView.dequeueCell(for: indexPath) else {
					assertionFailure("Failed to dequeue \(GoalTableViewCell.self)!")
					return UITableViewCell()
				}
				cell.configure(for: goal)
				return cell
			}
		)
	}
	
	func update(with goals: [GoalViewModel], animate: Bool = true) {
		DispatchQueue.main.async {
			var snapshot = NSDiffableDataSourceSnapshot<Section, GoalViewModel>()
			snapshot.appendSections(Section.allCases)
			snapshot.appendItems(goals, toSection: .goals)
			self.dataSource.apply(snapshot, animatingDifferences: animate)
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		let snapshot = dataSource.snapshot()
		let goalViewModel = snapshot.itemIdentifiers[indexPath.row]
		
		viewModel.didSelectGoal(with: goalViewModel.goal)
	}
}
