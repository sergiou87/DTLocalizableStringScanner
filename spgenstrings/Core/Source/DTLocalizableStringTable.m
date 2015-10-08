//
//  DTLocalizableStringTable.m
//  genstrings2
//
//  Created by Oliver Drobnik on 1/12/12.
//  Copyright (c) 2012 Drobnik KG. All rights reserved.
//  Copyright (c) 2014 Sergio Padrino All rights reserved.
//

#import "DTLocalizableStringTable.h"

#import "DTLocalizableStringEntry.h"
#import "NSString+DTLocalizableStringScanner.h"

@implementation DTLocalizableStringTable
{
	NSString *_name;
	NSMutableArray *_entries;
	NSMutableDictionary *_entryIndexByKey;

	DTLocalizableStringEntryWriteCallback _entryWriteCallback;
}

- (id)initWithName:(NSString *)name
{
	self = [super init];
	if (self)
	{
		_name = [name copy];
	}

	return self;
}

- (void)mergeWithOriginalTable:(DTLocalizableStringTable *)originalTable deleteUnusedEntries:(BOOL)deleteUnusedEntries
{
	NSAssert([originalTable.name isEqualToString:_name], @"You should only be merging tables with the same name: %@ != %@", originalTable.name, _name);
    
    NSMutableDictionary *unusedOriginalEntries = [originalTable.entryIndexByKey mutableCopy];
    
    for (DTLocalizableStringEntry *entry in self.entries)
    {
        DTLocalizableStringEntry *originalEntry = originalTable.entryIndexByKey[entry.key];
        
        if (originalEntry)
        {
            entry.rawValue = originalEntry.rawValue;
            [unusedOriginalEntries removeObjectForKey:originalEntry.key];
        }
    }
    
    if (!deleteUnusedEntries)
    {
        for (DTLocalizableStringEntry *entry in [unusedOriginalEntries allValues])
        {
            [self addEntry:entry];
        }
    }
}

- (void)addEntry:(DTLocalizableStringEntry *)entry
{
	NSAssert([entry.tableName isEqualToString:_name], @"Entry does not belong in this table: %@ != %@", entry.tableName, _name);

	NSString *key = entry.key;

	NSParameterAssert(key);

	if (!_entries)
	{
		_entries = [[NSMutableArray alloc] init];
	}

	if (!_entryIndexByKey)
	{
		_entryIndexByKey = [[NSMutableDictionary alloc] init];
	}

	// check if we already have such an entry
	DTLocalizableStringEntry *existingEntry = [_entryIndexByKey objectForKey:key];

	if (existingEntry)
	{
		if (![existingEntry.rawValue isEqualToString:entry.rawValue])
		{
			printf("Key \"%s\" used with multiple values. Value \"%s\" kept. Value \"%s\" ignored.\n",
				   [key UTF8String], [existingEntry.rawValue UTF8String], [entry.rawValue UTF8String]);
		}

		return;
	}

	// add entry to table and key index
	[_entries addObject:entry];
	[_entryIndexByKey setObject:entry forKey:entry.key];
}

- (NSString*)stringRepresentationWithEncoding:(NSStringEncoding)encoding error:(NSError **)error entryWriteCallback:(DTLocalizableStringEntryWriteCallback)entryWriteCallback
{
    NSArray *sortedEntries = [_entries sortedArrayUsingSelector:@selector(compare:)];
	
	NSMutableString *tmpString = [NSMutableString string];

	for (DTLocalizableStringEntry *entry in sortedEntries)
	{
		NSString *key = [entry rawKey];
		NSString *value = [entry rawValue];

        if (entryWriteCallback)
        {
            entryWriteCallback(entry);
        }

        if (_shouldDecodeUnicodeSequences)
		{
			// strip the quotes
			if ([value hasPrefix:@"\""] && [value hasSuffix:@"\""])
			{
				value = [value substringWithRange:NSMakeRange(1, [value length]-2)];
			}

			// value is what we scanned from file, so we first need to decode
			value = [value stringByReplacingSlashEscapes];

			// decode the unicode sequences
            value = [value stringByDecodingUnicodeSequences];

			// re-add the slash escapes
			value = [value stringByAddingSlashEscapes];

			// re-add quotes
			value = [NSString stringWithFormat:@"\"%@\"", value];
        }

        // output line
        [tmpString appendFormat:@"\"%@\" = \"%@\";\n", key, value];

        [tmpString appendString:@"\n"];
	}
    
    return [NSString stringWithString:tmpString];
}

- (BOOL)writeToFolderAtURL:(NSURL *)url encoding:(NSStringEncoding)encoding error:(NSError **)error  entryWriteCallback:(DTLocalizableStringEntryWriteCallback)entryWriteCallback;
{
	NSString *fileName = [_name stringByAppendingPathExtension:@"strings"];
	NSString *tablePath = [[url path] stringByAppendingPathComponent:fileName];
	NSURL *tableURL = [NSURL fileURLWithPath:tablePath];
	
	if (!tableURL)
	{
		// this must be junk
		return NO;
	}
	
    NSString *tmpString = [self stringRepresentationWithEncoding:encoding error:error entryWriteCallback:entryWriteCallback];
	
	return [tmpString writeToURL:tableURL
					  atomically:YES
						encoding:encoding
						   error:error];
}

#pragma mark Properties

@synthesize name = _name;
@synthesize entries = _entries;
@synthesize shouldDecodeUnicodeSequences = _shouldDecodeUnicodeSequences;

@end
