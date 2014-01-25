//
//  DTLocalizableStringsParser.h
//  genstrings2
//
//  Created by Stefan Gugarel on 2/27/13.
//  Copyright (c) 2013 Drobnik KG. All rights reserved.
//  Copyright (c) 2014 Sergio Padrino All rights reserved.
//


@class DTLocalizableStringTable;

/**
 Parser for strings files. You initialize it with a file URL, set a delegate and execute parsing with parse.
 */
@interface DTLocalizableStringsParser : NSObject

/**
 @name Creating a Parser
 */

/**
 Instantiates a strings file parser
 @param url The file URL for the file to parse
 */
- (id)initWithFileURL:(NSURL *)url;

/**
 @name Parsing File Contents
 */

/**
 Parses the file.
 @returns `
 */
- (DTLocalizableStringTable *)parse;

/**
 The last reported parse error
 */
@property (nonatomic, readonly) NSError *parseError;

@end
