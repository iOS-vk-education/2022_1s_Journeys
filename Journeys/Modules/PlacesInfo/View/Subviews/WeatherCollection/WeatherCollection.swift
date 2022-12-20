//
//  WeatherCollection.swift
//  Journeys
//
//  Created by Сергей Адольевич on 14.12.2022.
//

import Foundation
import UIKit
import SnapKit

final class WeatherCollection: UICollectionViewCell {
    struct DisplayData {
        let town: String
    }
    
    private let townNameView = WeatherCollectionHeader()
    
    private lazy var collectionView: UICollectionView = {
        let layout = HorizontallyCenteredCollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: .zero,
                                                   left: 10,
                                                   bottom: .zero,
                                                   right: 30)
        return collectionView
   }()

    private var delegate: WeatherCollectionDelegate!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    private func setupView() {
        addSubview(collectionView)
        addSubview(townNameView)

        setupCollectionView()
        setupConstraints()
        collectionView.showsHorizontalScrollIndicator = false
    }

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.register(WeatherCell.self,
                                forCellWithReuseIdentifier: "WeatherCell")
    }

    private func setupConstraints() {
        townNameView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(32)
            make.trailing.equalToSuperview().inset(32)
            make.top.equalToSuperview()
        }

        collectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(townNameView.snp.bottom).offset(16)
            make.bottom.equalToSuperview()
        }
    }
//    private func generateLayout() -> UICollectionViewLayout {
//
//            let spacing: CGFloat = 10
//            let itemSize = NSCollectionLayoutSize(
//                widthDimension: .estimated(62),
//                heightDimension: .fractionalHeight(1.0))
//            let item = NSCollectionLayoutItem(layoutSize: itemSize)
//
//            let groupSize = NSCollectionLayoutSize(
//                widthDimension: .estimated(62),
//                heightDimension: .estimated(46))
//            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//            group.interItemSpacing = .fixed(spacing)
//
//
//            let headerSize = NSCollectionLayoutSize(
//                widthDimension: .fractionalWidth(1.0),
//                heightDimension: .estimated(10))
//            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
//                    layoutSize: headerSize,
//                    elementKind: "WeatherCollectionHeader",
//                    alignment: .top)
//            let section = NSCollectionLayoutSection(group: group)
//            section.boundarySupplementaryItems = [sectionHeader]
//            section.orthogonalScrollingBehavior = .continuous
//            section.interGroupSpacing = spacing
//            section.contentInsets = NSDirectionalEdgeInsets(
//                top: 16,
//                leading: 10,
//                bottom: 18,
//                trailing: 10
//            )
//
//            return UICollectionViewCompositionalLayout(section: section)
//    }
    
    func configure(data: DisplayData, delegate: WeatherCollectionDelegate) {
        townNameView.configure(title: data.town)
        self.delegate = delegate
    }
}

extension WeatherCollection: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Tap")
    }
}

extension WeatherCollection: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        delegate.getNumberOfItemsInWeatherCollection(self)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCell", for: indexPath) as? WeatherCell else {
            return UICollectionViewCell()
        }
        cell.configure(data: delegate.getCellDisplayData(self, for: indexPath))
        return cell
    }
}

private extension WeatherCollection {
    enum Constants {
        enum SectionHeader {
            static let height: CGFloat = 27
            static let horisontalSpacing: CGFloat = 30
        }
        
        enum CollectionView {
            static let verticalSpacingFromHeader: CGFloat = 17
            static let height: CGFloat = 70
        }
    }
}

class HorizontallyCenteredCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }
        guard let collectionView = self.collectionView,
            let rightmostEdge = attributes.map({ $0.frame.maxX }).max() else { return attributes }

        let contentWidth = rightmostEdge + self.sectionInset.right
        let margin = (collectionView.bounds.width - contentWidth) / 2

        if margin > 0 {
            let newAttributes: [UICollectionViewLayoutAttributes]? = attributes
                .compactMap {
                    let newAttribute = $0.copy() as? UICollectionViewLayoutAttributes
                    newAttribute?.frame.origin.x += margin
                    return newAttribute
            }
        }
        return attributes
    }
}

protocol WeatherCollectionDelegate: AnyObject {
    func getNumberOfItemsInWeatherCollection(_ collectionCell: WeatherCollection) -> Int
    func getCellDisplayData(_ collectionCell: WeatherCollection, for indexpath: IndexPath) -> WeatherCell.DisplayData
}