//
//  PresentationsCollectionViewController.m
//  Presentations
//
//  Created by Visceglia Anthony on 12/2/14.
//  Copyright (c) 2014 FXI, Inc. All rights reserved.
//

#import "PresentationsCollectionViewController.h"
#import "FXIPresentation.h"
#import "PresentationsCollectionViewCell.h"

@interface PresentationsCollectionViewController()

#pragma mark - Private Properties

// Array of the objects to represent in the table
@property (copy, nonatomic) NSMutableArray *presentations;

@end


#pragma mark

@implementation PresentationsCollectionViewController

static NSString * const reuseIdentifier = @"Presentation Cell";

#pragma mark - Getters

// Getter for the faqs array
- (NSMutableArray *)presentations
{
    // Lazy array instantiation
    if (!_presentations)
    {
        _presentations = [[NSMutableArray alloc] init];
    }
    
    return _presentations;
}

#pragma mark - Delegation

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    [layout setItemSize:CGSizeMake(180.0f, 200.0f)];
    [layout setSectionInset:UIEdgeInsetsMake(20.0f, 20.0f, 0.0f, 20.0f)];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [layout setMinimumLineSpacing:0.0f];
    [layout setMinimumInteritemSpacing:10.0f];
    //    [layout setHeaderReferenceSize:CGSizeMake(0.0f, 40.0f)];
    
    [[self collectionView] setCollectionViewLayout:layout];
    
    // array
    
    FXIPresentation *presentation = nil;
    
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"AppleTV_setup"
                                             withExtension:@"pdf"];
    if (fileURL)
    {
        presentation = [[FXIPresentation alloc] initWithURL:fileURL];
        [[self presentations] addObject:presentation];
    }
    
    fileURL = [[NSBundle mainBundle] URLForResource:@"01 Corporate Overview"
                                      withExtension:@"pdf"];
    if (fileURL)
    {
        presentation = [[FXIPresentation alloc] initWithURL:fileURL];
        [[self presentations] addObject:presentation];
    }
    
    fileURL = [[NSBundle mainBundle] URLForResource:@"06 Cores Collection with Script"
                                      withExtension:@"pdf"];
    if (fileURL)
    {
        presentation = [[FXIPresentation alloc] initWithURL:fileURL];
        [[self presentations] addObject:presentation];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[self presentations] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PresentationsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier
                                                                                      forIndexPath:indexPath];
    
    // Configure the cell
    
    FXIPresentation *presentation = nil;
    presentation = [[self presentations] objectAtIndex:[indexPath row]];
    
    // Set cells
    
    [[cell presentationThumbnailButton] setBackgroundImage:[UIDocumentInteractionController interactionControllerWithURL:[presentation presentationURL]].icons[1]
                                                  forState:UIControlStateNormal];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setHyphenationFactor:1.0f];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[presentation title]
                                                                                         attributes:@{
                                                                                                      NSParagraphStyleAttributeName : paragraphStyle
                                                                                                      }];
    
    [[cell presentationTitleLabel] setAttributedText:attributedString];
    [[cell presentationTitleLabel] setTextColor:[UIColor colorWithRed:(18.0/255.0)
                                                                green:(52.0/255.0)
                                                                 blue:(88.0/255.0)
                                                                alpha:1.0f]];
    
    return cell;
}
/**
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    
    VideosCollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                withReuseIdentifier:@"Header View"
                                                                                       forIndexPath:indexPath];
    NSString *sectionTitle = nil;
    if ([indexPath section] == 1)
    {
        sectionTitle = @"PRESSURE MAPPING VIDEOS";
        
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:sectionTitle
                                                                               attributes:@{ NSKernAttributeName : @(0.25f),
                                                                                             NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline] }];
        
        [[headerView sectionTitleLabel] setAttributedText:attributedString];
    }
    else
    {
        [[headerView sectionTitleLabel] setText:sectionTitle];
    }
    
    //    [[headerView sectionTitleLabel] setText:sectionTitle];
    
    reusableView = headerView;
    
    
    return reusableView;
}**/

- (IBAction)displayPDF:(UIButton *)sender
{
    if ([[[sender superview] superview] isKindOfClass:[PresentationsCollectionViewCell class]])
    {
        PresentationsCollectionViewCell *cell = (PresentationsCollectionViewCell *)[[sender superview] superview];
        NSIndexPath *indexPath = [[self collectionView] indexPathForCell:cell];
        FXIPresentation *presentation = nil;
        
        presentation = [[self presentations] objectAtIndex:[indexPath row]];
        
        NSURL *url = [presentation presentationURL];
        UIDocumentInteractionController *controller = [UIDocumentInteractionController interactionControllerWithURL:url];
        [controller setDelegate:self];

        BOOL previewDidPresent = [controller presentPreviewAnimated:YES];
        if (!previewDidPresent)
        {
            // error
        }
    }
}

#pragma mark - Document Interaction Delegate

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return [self navigationController];
}

- (void)documentInteractionControllerWillBeginPreview:(UIDocumentInteractionController *)controller
{
//    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

- (void)documentInteractionControllerDidEndPreview:(UIDocumentInteractionController *)controller
{
//    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}


#pragma mark <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        return CGSizeMake(0.0f, 50.0f);
    }
    else
    {
        return CGSizeZero;
    }
}

/*
 // Uncomment this method to specify if the specified item should be highlighted during tracking
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
 }
 */

/*
 // Uncomment this method to specify if the specified item should be selected
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 */

/*
 // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
 }
 
 - (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
 }
 
 - (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
 }
 */

@end
