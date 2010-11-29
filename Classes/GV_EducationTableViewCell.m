//
//  GV_EducationTableViewCell.m
//  griable
//
//  Created by Gabriel Slama on 24/11/10.
//  Copyright 2010 griable. All rights reserved.
//

#import "GV_EducationTableViewCell.h"
#import "ASIHTTPRequest.h"

@implementation GV_EducationTableViewCell

@synthesize educationRow;

@synthesize logoImageView, activityIndicator;
@synthesize titleLabel, placeLabel, dateLabel;

#pragma mark -
#pragma mark Data Management

- (void)setEducationRow:(NSMutableDictionary *)value {
  if (value == educationRow) {
    return;
  }
  
  [educationRow autorelease];
  educationRow = [value retain];
  
  [self reloadData];
}

- (void)reloadData {
  [titleLabel setText:[educationRow objectForKey:@"title"]];
	[placeLabel setText:[NSString stringWithFormat:@"@%@", [educationRow objectForKey:@"place"]]];
  [dateLabel setText:[(NSNumber *)[educationRow objectForKey:@"year"] stringValue]];
  
  [self titleLabelAlignTop];
  
  if (![[educationRow objectForKey:@"image"] isEqualToString:@""])
    [self downloadLogo];
}

#pragma mark -
#pragma mark DownloadLogo

- (void)downloadLogo {
  [activityIndicator startAnimating];
  
  NSString *logoPath = [SERVER_URL stringByAppendingFormat:@"images/logos/%@", [educationRow objectForKey:@"image"]];
  NSURL *logoURL     = [NSURL URLWithString:logoPath];
  
  ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:logoURL];
  [request setDelegate:self];
  [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
  NSData *responseData = [request responseData];
  [logoImageView setImage:[UIImage imageWithData:responseData]]; 
  
  // ui
  [activityIndicator stopAnimating];
}

- (void)requestFailed:(ASIHTTPRequest *)request {
  [activityIndicator stopAnimating];
}

#pragma mark -
#pragma mark View

- (void)titleLabelAlignTop {
  CGRect oldFrame = [titleLabel frame];
  
  CGSize maximumSize = CGSizeMake(oldFrame.size.width, oldFrame.size.height);
  NSString *titleString = [titleLabel text];
  
  CGSize titleStringSize = [titleString sizeWithFont:[titleLabel font] constrainedToSize:maximumSize lineBreakMode:[titleLabel lineBreakMode]];
  
  CGRect newFrame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, oldFrame.size.width, titleStringSize.height);
  
  [titleLabel setFrame:newFrame];
}

#pragma mark -
#pragma mark Memory Management

- (void)dealloc {
  [educationRow release];
  
  [super dealloc];
}

@end
