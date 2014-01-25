//
//  DTLocalizableStringEntry.m
//  genstrings2
//
//  Created by Oliver Drobnik on 10.01.12.
//  Copyright (c) 2011 Drobnik KG. All rights reserved.
//

#import "DTLocalizableStringEntry.h"
#import "NSString+DTLocalizableStringScanner.h"

@implementation DTLocalizableStringEntry
{
    NSString *_cleanedKey;
}

@synthesize rawKey=_rawKey;
@synthesize rawValue=_rawValue;
@synthesize tableName=_tableName;
@synthesize bundle=_bundle;
@synthesize keyIncludesComments=_keyIncludesComments;

- (NSString *)description
{
	NSMutableString *tmpString = [NSMutableString stringWithFormat:@"<%@ key='%@'", NSStringFromClass([self class]), self.rawKey];

	if (_rawValue)
	{
		[tmpString appendFormat:@" value='%@'", _rawValue];
	}

	if ([_tableName length])
	{
		[tmpString appendFormat:@" table='%@'", _tableName];
	}

    [tmpString appendFormat:@" comment='%@'", _comment];

	[tmpString appendString:@">"];

	return tmpString;
}

#pragma mark NSCopying
- (id)copyWithZone:(NSZone *)zone
{
	DTLocalizableStringEntry *newEntry = [[DTLocalizableStringEntry allocWithZone:zone] init];
	newEntry.rawKey = _rawKey;
	newEntry.rawValue = _rawValue;
	newEntry.tableName = _tableName;
	newEntry.bundle = _bundle;
    newEntry.comment = _comment;
    
	return newEntry;
}

- (NSComparisonResult)compare:(DTLocalizableStringEntry *)otherEntry
{
    return [self.key localizedStandardCompare:otherEntry.key];
}

- (NSString *)_stringByRecognizingNil:(NSString *)string
{
    NSString *tmp = [string lowercaseString];
    if ([tmp isEqualToString:@"nil"] || [tmp isEqualToString:@"null"] || [tmp isEqualToString:@"0"])
    {
        string = nil;
    }
    return string;
}

#pragma mark Properties

- (void)setTableName:(NSString *)tableName
{
    tableName = [tableName stringByReplacingSlashEscapes];
    tableName = [self _stringByRecognizingNil:tableName];

	// remove the quotes
	tableName = [tableName stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\""]];

	// keep "Localizable" if the tableName is nil or @"";
	if ([tableName length])
	{
		_tableName = [tableName copy];
	}
}

- (void) setRawKey:(NSString *)rawKey {
    if (rawKey != _rawKey) {
        _rawKey = rawKey;
        _cleanedKey = nil;
    }
}

- (void)setKeyIncludesComments:(BOOL)keyIncludesComments {
  if (keyIncludesComments != _keyIncludesComments) {
    _keyIncludesComments = keyIncludesComments;
    _cleanedKey = nil;
  }
}

- (NSString *)key
{
    if (_keyIncludesComments && _comment) {
        NSString *trimmedKey = [_rawKey stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\""]];
        return [NSString stringWithFormat:@"(%@)%@", _comment, trimmedKey];
    } else {
        return _rawKey;
    }
}

- (NSString *)cleanedKey
{
    if (_cleanedKey == nil && [self key] != nil) {
        _cleanedKey = [[self key] stringByReplacingSlashEscapes];
    }
    return _cleanedKey;
}

- (NSString *)cleanedValue
{
    return [[self rawValue] stringByReplacingSlashEscapes];
}

@end
