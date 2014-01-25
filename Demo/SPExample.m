//
//  SPExample.m
//  spgenstrings
//
//  Created by Sergio Padrino on 25/01/14.
//  Copyright (c) 2014 Sergio Padrino All rights reserved.
//

#import "SPExample.h"

#import "SPLocalizedString.h"

@implementation SPExample

- (void)doSomething
{
    SPLocalizedStringFromTable(@"Test", @"Test title in some context", @"Mytable");
    SPLocalizedString(@"Test", @"Test title in other context");
    SPLocalizedString(@"Test", @"Third test title");
    
    SPLocalizedStringPlural(@"%d people is following you", @"Followers label description", 7);
}

@end
