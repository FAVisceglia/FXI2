//
//  FXIPresentation.h
//  Presentations
//
//  Created by Visceglia Anthony on 12/2/14.
//  Copyright (c) 2014 FXI, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FXIPresentation : NSObject

#pragma mark - Public Properties

// The URL of the locally-stored presentation (read & write)
@property (strong, nonatomic) NSURL *presentationURL;

// The title of the presentation (read only)
@property (copy, nonatomic, readonly) NSString *title;

#pragma mark - Public Methods

// Designated initializer; create a new presentation from a file stored at the given URL
- (instancetype)initWithURL:(NSURL *)urlOfPresentation;

@end
