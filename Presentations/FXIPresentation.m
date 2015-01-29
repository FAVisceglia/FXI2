//
//  FXIPresentation.m
//  Presentations
//
//  Created by Visceglia Anthony on 12/2/14.
//  Copyright (c) 2014 FXI, Inc. All rights reserved.
//

#import "FXIPresentation.h"

@interface FXIPresentation()


#pragma mark - Private Properties

// Read & write extension of the public title
@property (copy, nonatomic, readwrite) NSString *title;

@end


#pragma mark

@implementation FXIPresentation


#pragma mark - Setters

// Setter for the video URL property
- (void)setPresentationURL:(NSURL *)presentationURL
{
    NSArray *validExtensions = @[@"pdf", @"PDF"]; // Array of valid PDF file extensions
    NSString *fileExtension = [presentationURL pathExtension]; // The file extenstion of the presentation
    
    // Check if the file has a valid extension
    if ([validExtensions containsObject:fileExtension])
    {
        // Local variable assignment
        _presentationURL = presentationURL;
        
        NSString *filePath = [presentationURL path]; // The path of the presentation
        NSString *fileName = [[filePath lastPathComponent] stringByDeletingPathExtension]; // The file name (no extension) of the presentation
        
        // Set the presentation title
        [self setTitle:fileName];
    }
}


#pragma mark - Initializers

- (instancetype)initWithURL:(NSURL *)urlOfPresentation
{
    self = [super init];
    
    if (self)
    {
        [self setPresentationURL:urlOfPresentation];
    }
    
    return self;
}

- (instancetype)initWithURL:(NSURL *)urlOfPresentation withThumbnail:(NSURL *)urlOfThumbnail
{
    self = [super init];
    
    if (self)
    {
        [self setPresentationURL:urlOfPresentation];
        [self setThumbnailURL:urlOfThumbnail];
    }
    
    return self;
}


#pragma mark - Private Methods


@end
