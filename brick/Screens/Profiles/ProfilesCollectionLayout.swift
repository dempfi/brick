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
    let collectionInset = collectionView.adjustedContentInset
    let collectionSize = collectionView.frame.size
    let yInsets = (collectionSize.height - collectionInset.top - collectionInset.bottom - itemSize.height) / 2
    let xInsets = (collectionSize.width - collectionInset.right - collectionInset.left - itemSize.width) / 2
    sectionInset = UIEdgeInsets(top: yInsets, left: xInsets, bottom: yInsets, right: xInsets)
    super.prepare()
  }

  override func targetContentOffset(
    forProposedContentOffset proposedContentOffset: CGPoint,
    withScrollingVelocity velocity: CGPoint
  ) -> CGPoint {
    guard let collectionView = collectionView else { return .zero }

    // Add some snapping behaviour so that the zoomed cell is always centered
    let targetRect = CGRect(origin: CGPoint(x: proposedContentOffset.x, y: 0), size: collectionView.frame.size)
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
    let superContext = super.invalidationContext(forBoundsChange: newBounds)
    guard let context = superContext as? UICollectionViewFlowLayoutInvalidationContext else { return superContext }
    context.invalidateFlowLayoutDelegateMetrics = newBounds.size != collectionView?.bounds.size
    return context
  }
}
