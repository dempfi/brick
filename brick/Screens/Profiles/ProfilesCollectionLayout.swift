import UIKit

class ProfilesCollectionLayout: UICollectionViewFlowLayout {
  override init() {
    super.init()
    scrollDirection = .horizontal
    itemSize = CGSize(width: 550, height: 280)
    minimumLineSpacing = 20
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepare() {
    guard let collectionView = collectionView else { fatalError() }
    let verticalInsets = (collectionView.frame.height - collectionView.adjustedContentInset.top - collectionView.adjustedContentInset.bottom - itemSize.height) / 2
    let horizontalInsets = (collectionView.frame.width - collectionView.adjustedContentInset.right - collectionView.adjustedContentInset.left - itemSize.width) / 2
    sectionInset = UIEdgeInsets(top: verticalInsets, left: horizontalInsets, bottom: verticalInsets, right: horizontalInsets)
    super.prepare()
  }

  override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
    guard let collectionView = collectionView else { return .zero }

    // Add some snapping behaviour so that the zoomed cell is always centered
    let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView.frame.width, height: collectionView.frame.height)
    guard let rectAttributes = super.layoutAttributesForElements(in: targetRect) else { return .zero }

    var offsetAdjustment = CGFloat.greatestFiniteMagnitude
    let horizontalCenter = proposedContentOffset.x + collectionView.frame.width / 2

    for layoutAttributes in rectAttributes {
      let itemHorizontalCenter = layoutAttributes.center.x
      if (itemHorizontalCenter - horizontalCenter).magnitude < offsetAdjustment.magnitude {
        offsetAdjustment = itemHorizontalCenter - horizontalCenter
      }
    }

    return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
  }

  override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    return true
  }

  override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
    let context = super.invalidationContext(forBoundsChange: newBounds) as! UICollectionViewFlowLayoutInvalidationContext
    context.invalidateFlowLayoutDelegateMetrics = newBounds.size != collectionView?.bounds.size
    return context
  }
}
