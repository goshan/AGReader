//
//  Utils.m
//  AGReader
//
//  Created by Qiu Han on 9/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Utils.h"

@implementation Utils

const NSString *BOOKFILEEXT = @"txt";
const NSString *PAGEINDEXEXT = @"ind";

const NSString *BOOKID = @"bookId";
const NSString *BOOKNAME = @"bookName";
const NSString *FILENAME = @"fileName";
const NSString *PAGEINDEX = @"pageIndex";
const NSString *IMAGEFILE = @"imageFile";

const NSString *MARKBOOKID = @"markBookId";
const NSString *MARKPAGENUM = @"markPageNum";
const NSString *MARKCONTENT = @"markContent";

+ (const NSString *)BOOKFILEEXT{
    return BOOKFILEEXT;
}

+ (const NSString *)PAGEINDEXEXT{
    return PAGEINDEXEXT;
}


+ (const NSString *)BOOKID{
    return BOOKID;
}

+ (const NSString *)BOOKNAME{
    return BOOKNAME;
}

+ (const NSString *)FILENAME{
    return FILENAME;
}

+ (const NSString *)PAGEINDEX{
    return PAGEINDEX;
}

+ (const NSString *)IMAGEFILE{
    return IMAGEFILE;
}

+ (const NSString *)MARKBOOKID{
    return MARKBOOKID;
}

+ (const NSString *)MARKPAGENUM{
    return MARKPAGENUM;
}

+ (const NSString *)MARKCONTENT{
    return MARKCONTENT;
}

@end
