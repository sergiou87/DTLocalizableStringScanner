//
//  main.m
//  genstrings2
//
//  Created by Oliver Drobnik on 29.12.11.
//  Copyright (c) 2011 Drobnik KG. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DTLocalizableStringsParser.h"
#import "DTLocalizableStringScanner.h"
#import "DTLocalizableStringAggregator.h"
#import "DTLocalizableStringEntry.h"
#import "DTLocalizableStringTable.h"

void showUsage(void);
NSArray *stringsFilesInDirectory(NSURL *directory);

int main (int argc, const char *argv[])
{
    @autoreleasepool
    {
		// default output folder = current working dir
        NSURL *outputFolderURL = nil;

        // default output encoding
        NSStringEncoding outputStringEncoding = NSUTF16StringEncoding;

        BOOL wantsPositionalParameters = YES;
        BOOL wantsDecodedUnicodeSequences = NO;
        NSMutableSet *tablesToSkip = [NSMutableSet set];
        NSString *customMacroPrefix = nil;
        NSString *defaultTableName = nil;
        BOOL deleteUnusedEntries = NO;
        BOOL deleteUnusedTables = NO;

        // analyze options
        BOOL optionsInvalid = NO;
        NSUInteger i = 1;
        NSMutableArray *files = [NSMutableArray array];
        NSStringEncoding inputStringEncoding = NSUTF8StringEncoding;

        while (i<argc)
        {
            if (argv[i][0]!='-')
            {
                // not a parameter, treat as file name
                NSString *fileName = [NSString stringWithUTF8String:argv[i]];

                // standardize path
                fileName = [fileName stringByStandardizingPath];

                NSURL *url = [NSURL fileURLWithPath:fileName];

                if (!url)
                {
                    optionsInvalid = YES;
                    break;
                }

                [files addObject:url];
            }
            else if (!strcmp("-noPositionalParameters", argv[i]))
            {
                // do not add positions to parameters
                wantsPositionalParameters = NO;
            }
            else if (!strcmp("-o", argv[i]))
            {
                // output folder name
                i++;

                if (i>=argc)
                {
                    // output folder name is missing
                    optionsInvalid = YES;
                    break;
                }

                // output folder
                NSString *fileName = [NSString stringWithUTF8String:argv[i]];

                // standardize path
                fileName = [fileName stringByStandardizingPath];

                // check if output folder exists
                if (![[NSFileManager defaultManager] isWritableFileAtPath:fileName])
                {
                    printf("Unable to write to %s\n", [fileName UTF8String]);
                    exit(1);
                }

                outputFolderURL = [NSURL fileURLWithPath:fileName];
            }
            else if (!strcmp("-s", argv[i]))
            {
                // custom macro prefix
                i++;

                if (i>=argc)
                {
                    // prefix is missing
                    optionsInvalid = YES;
                    break;
                }

                customMacroPrefix = [NSString stringWithUTF8String:argv[i]];
            }
            else if (!strcmp("-u", argv[i]))
            {
                wantsDecodedUnicodeSequences = YES;
            }
            else if (!strcmp("-deleteUnusedEntries", argv[i]))
            {
                deleteUnusedEntries = YES;
            }
            else if (!strcmp("-deleteUnusedTables", argv[i]))
            {
                deleteUnusedTables = YES;
            }
            else if (!strcmp("-skipTable", argv[i]))
            {
                // tables to be ignored
                i++;

                if (i>=argc)
                {
                    // table name is missing
                    optionsInvalid = YES;
                    break;
                }

                NSString *tableName = [NSString stringWithUTF8String:argv[i]];
                [tablesToSkip addObject:tableName];
            }
            else if (!strcmp("-littleEndian", argv[i]))
            {
                outputStringEncoding = NSUTF16LittleEndianStringEncoding;
            }
            else if (!strcmp("-bigEndian", argv[i]))
            {
                outputStringEncoding = NSUTF16BigEndianStringEncoding;
            }
            else if (!strcmp("-utf8", argv[i]))
            {
                outputStringEncoding = NSUTF8StringEncoding;
            }
            else if (!strcmp("-macRoman", argv[i]))
            {
                inputStringEncoding = NSMacOSRomanStringEncoding;
            }
            else if (!strcmp("-defaultTable", argv[i]))
            {
                i++;
                
                if (i>=argc)
                {
                    // table name is missing
                    optionsInvalid = YES;
                    break;
                }
                
                defaultTableName = [NSString stringWithUTF8String:argv[i]];
            }
            
            i++;
        }

        // something is wrong
        if (optionsInvalid || ![files count])
        {
            showUsage();
            exit(1);
        }

        NSFileManager *fileManager = [NSFileManager defaultManager];
		// set output dir to current working dir if not set
		if (!outputFolderURL) {
			NSString *cwd = [fileManager currentDirectoryPath];
			outputFolderURL = [NSURL fileURLWithPath:cwd];
		}

        // Parse existing files
        NSArray *stringsFiles = stringsFilesInDirectory(outputFolderURL);
        NSMutableDictionary *originalTables = [NSMutableDictionary dictionary];
        
        for (NSURL *file in stringsFiles)
        {
            DTLocalizableStringsParser *parser = [[DTLocalizableStringsParser alloc] initWithFileURL:file];
            DTLocalizableStringTable *table = [parser parse];
            
            if (!table)
            {
                printf("Error parsing %s: %s", [[file lastPathComponent] UTF8String], [[parser.parseError localizedDescription] UTF8String]);
                exit(1);
            }
            
            [originalTables setObject:table forKey:table.name];
        }
        
        // create the aggregator
        DTLocalizableStringAggregator *aggregator = [[DTLocalizableStringAggregator alloc] init];
        
        // set the parameters
        aggregator.wantsPositionalParameters = wantsPositionalParameters;
        aggregator.inputEncoding = inputStringEncoding;
        aggregator.customMacroPrefix = customMacroPrefix;
        aggregator.tablesToSkip = tablesToSkip;
        aggregator.defaultTableName = defaultTableName;

        // go, go, go!
        for (NSURL *file in files) {
            [aggregator beginProcessingFile:file];
        }

        NSArray *aggregatedTables = [aggregator aggregatedStringTables];
        NSMutableDictionary *unusedOriginalTables = [originalTables mutableCopy];
        
        // Merge the aggregated tables with the original
        for (DTLocalizableStringTable *table in aggregatedTables)
        {
            DTLocalizableStringTable *originalTable = unusedOriginalTables[table.name];
            
            if (!originalTable) continue;
            
            [table mergeWithOriginalTable:originalTable deleteUnusedEntries:deleteUnusedEntries];
            [unusedOriginalTables removeObjectForKey:originalTable.name];
        }
        
        DTLocalizableStringEntryWriteCallback writeCallback = nil;

        // Delete the unused original tables
        if (deleteUnusedTables)
        {
            for (DTLocalizableStringTable *unusedTable in [unusedOriginalTables allValues])
            {
                NSString *filePath = [[[outputFolderURL path]
                                       stringByAppendingPathComponent:unusedTable.name]
                                      stringByAppendingPathExtension:@"strings"];
                [fileManager removeItemAtPath:filePath error:nil];
            }
        }
        
		// output the tables
		NSError *error = nil;

        for (DTLocalizableStringTable *table in aggregatedTables) {
            [table setShouldDecodeUnicodeSequences:wantsDecodedUnicodeSequences];

            if (![table writeToFolderAtURL:outputFolderURL encoding:outputStringEncoding error:&error entryWriteCallback:writeCallback]) {

                printf("%s\n", [[error localizedDescription] UTF8String]);
                exit(1); // exit due to error
            }
        }
    }

    return 0;
}

NSArray *stringsFilesInDirectory(NSURL *directory)
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *dirContents = [fm contentsOfDirectoryAtURL:directory
                             includingPropertiesForKeys:@[]
                                                options:NSDirectoryEnumerationSkipsHiddenFiles
                                                  error:nil];
    NSPredicate *fltr = [NSPredicate predicateWithFormat:@"pathExtension='strings'"];
    return [dirContents filteredArrayUsingPredicate:fltr];
}


void showUsage(void)
{
    printf("Usage: spgenstrings [OPTIONS] file...\n\n");
    printf("    Options\n");
    printf("    -s substring             substitute 'substring' for SPLocalizedString.\n");
    printf("    -skipTable tablename     skip over the file for 'tablename'.\n");
    printf("    -noPositionalParameters  turns off positional parameter support.\n");
    printf("    -deleteUnusedEntries     deletes the entries that are not used anymore.\n");
    printf("    -deleteUnusedTables      deletes the tables that are not used anymore.\n");
    printf("    -u                       allow unicode characters in the values of strings files.\n");
    printf("    -macRoman                read files as MacRoman not UTF-8.\n");
    printf("    -q                       turns off multiple key/value pairs warning.\n");
    printf("    -bigEndian               output generated with big endian byte order.\n");
    printf("    -littleEndian            output generated with little endian byte order.\n");
    printf("    -utf8                    output generated as UTF-8 not UTF-16.\n");
    printf("    -o dir                   place output files in 'dir'.\n\n");
    printf("    -defaultTable tablename  use 'tablename' instead of 'Localizable' as default table name.\n");
}


