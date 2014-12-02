//
//  PresentationsCollectionViewCell.h
//  Presentations
//
//  Created by Visceglia Anthony on 12/2/14.
//  Copyright (c) 2014 FXI, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PresentationsCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *presentationThumbnailButton;
@property (weak, nonatomic) IBOutlet UILabel *presentationTitleLabel;

@end
