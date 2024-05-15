import Foundation
import UIKit

//UICollectionView自动换行

/// 对齐方向的枚举,
enum AlignDirection: Int {
    case left = 0,       //左对齐
         rightFlow,  //右对齐  左起显示
         rightData,  //右对齐  右起显示
         center      //中间对齐
}

class CollectionViewAlignFlowLayout: UICollectionViewFlowLayout {
    //默认向左对齐
    var alignDirection: AlignDirection = .left
    //所有cell的布局属性
    var layoutAttributes: [UICollectionViewLayoutAttributes] = []
    //计算出总高度
    var caculateTotalHeight:((_ height:CGFloat)->())?
    
    //collectionViewContentSize collectionView的实际大小
    private var contentSize: CGSize = CGSize.zero
    
    override var collectionViewContentSize: CGSize {
        if self.scrollDirection == .vertical {
            return CGSize.init(width: self.collectionView!.frame.width, height: contentSize.height)
        }
        return CGSize.init(width: contentSize.width, height: self.collectionView!.frame.height)
    }
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //预加载布局属性
    override func prepare() {
        super.prepare()
        contentSize = CGSize.zero
        //目前只考虑单个分组的实现
        let itemNum: Int = self.collectionView!.numberOfItems(inSection: 0)
        //清空旧布局
        layoutAttributes.removeAll()
        for i in 0..<itemNum {
            //计算布局属性
            let layoutAttr = layoutAttributesForItem(at: IndexPath.init(row: i, section: 0))
            layoutAttributes.append(layoutAttr!)
            if i == itemNum - 1 {
                caculateTotalHeight?(layoutAttr!.frame.maxY)
            }
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        //size默认为itemSize
        var size = self.itemSize
        //从代理方法获取item的size
        if self.collectionView!.delegate != nil && self.collectionView!.delegate!.conforms(to: UICollectionViewDelegateFlowLayout.self) && self.collectionView!.delegate!.responds(to: #selector(UICollectionViewDelegateFlowLayout.collectionView(_:layout:sizeForItemAt:)))  {
            //转换对象
            let flowLayoutDelegate = self.collectionView!.delegate as! UICollectionViewDelegateFlowLayout
            size = flowLayoutDelegate.collectionView!(self.collectionView!, layout: self, sizeForItemAt: indexPath)
        }
        //初始化每个item的frame
        var frame = CGRect.zero
        //初始化x, y
        var x: CGFloat = 0
        var y: CGFloat = 0
        //从layoutAttributes中获取上一个item 如果获取不到 设置现在的item为第一个item
        //判断collectionView的滑动方向
        if self.scrollDirection == .vertical {
            //获取collectionView的宽度
            let collectionViewWidth: CGFloat = self.collectionView!.bounds.width
            //根据对齐方向设置坐标的初始值
            if alignDirection == .left {
                //左对齐
                x = self.sectionInset.left
                y = self.sectionInset.top
                //判断是否上一个item
                if layoutAttributes.count>0 {
                    //获取上一个item
                    let lastLayoutAttr = layoutAttributes.last!
                    //判断当前行的宽度是否足够插入新的item
                    if lastLayoutAttr.frame.maxX+self.minimumInteritemSpacing+size.width+self.sectionInset.right>collectionViewWidth {
                        //如果宽度总和超过总宽度, 改变y坐标, 当前的item在下一行显示
                        y = lastLayoutAttr.frame.maxY+self.minimumLineSpacing
                    }else{
                        //如果宽度可以插入item, 修改坐标点, y轴与上一个item平齐, x轴则为上一个item的最右边加上行间距
                        x = lastLayoutAttr.frame.maxX+self.minimumInteritemSpacing
                        y = lastLayoutAttr.frame.minY
                    }
                }
            }
        }else {
            //水平方向滑动
            let layoutAttr = super.layoutAttributesForItem(at: indexPath)!
            x = layoutAttr.frame.origin.x
            y = layoutAttr.frame.origin.y
        }
        frame = CGRect(x: x, y: y, width: size.width, height: size.height)
        //更新contentSize, 此处赋值有时候不是最大值, 如果需要用到collectionViewContentSize这个属性, 需要判断新的值是否比原值大
        contentSize.width = frame.maxX+self.sectionInset.right
        contentSize.height = frame.maxY+self.sectionInset.bottom
        //创建每个item对应的布局属性
        let layoutAttr = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
        layoutAttr.frame = frame
        return layoutAttr
    }
    //返回所有布局
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return layoutAttributes
    }
}

