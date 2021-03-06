//
// Copyright © 2019 Optimize Fitness Inc.
// Licensed under the MIT license
// https://github.com/OptimizeFitness/Minerva/blob/master/LICENSE
//

import Foundation
import Minerva
import UIKit

public class MainCoordinator<T: Presenter, U: ViewController>: BaseCoordinator<T, U>, UIViewControllerTransitioningDelegate {

  public typealias DismissBlock = (BaseCoordinatorPresentable) -> Void

  private var dismissBlock: DismissBlock?

  // MARK: - Public

  public final func addCloseButton(dismissBlock: @escaping DismissBlock) {
    self.dismissBlock = dismissBlock
    viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(
      title: "Close",
      style: .plain,
      target: self,
      action: #selector(closeButtonPressed(_:))
    )
  }

  // MARK: - Private

  @objc
  private func closeButtonPressed(_ sender: UIBarButtonItem) {
    dismissBlock?(self)
  }

  // MARK: - ListControllerSizeDelegate
  override public func listController(
    _ listController: ListController,
    sizeFor model: ListCellModel,
    at indexPath: IndexPath,
    constrainedTo sizeConstraints: ListSizeConstraints
  ) -> CGSize? {
    guard model is MarginCellModel else { return nil }
    let collectionViewBounds = sizeConstraints.containerSize
    let minHeight: CGFloat = 20
    let dynamicHeight = listController.listSections.reduce(collectionViewBounds.height) { sum, section -> CGFloat in
      sum - listController.size(of: section, containerSize: collectionViewBounds).height
    }
    let marginCellCount = listController.cellModels
      .compactMap { $0 as? MarginCellModel }
      .filter {
        guard case .relative = $0.cellSize else { return false }
        return true
      }
      .count
    let width = sizeConstraints.adjustedContainerSize.width
    guard marginCellCount > 0 else {
      return CGSize(width: width, height: minHeight)
    }
    let height = max(minHeight, dynamicHeight / CGFloat(marginCellCount))
    return CGSize(width: width, height: height)
  }
}
