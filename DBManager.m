//
//  DBManager.m
//  SQLDB
//
//  Created by afzal on 1/17/16.
//  Copyright (c) 2016 afzal. All rights reserved.
//

#import "DBManager.h"
static DBManager *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;

@implementation DBManager

+(DBManager*)getSharedInstance{
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
        [sharedInstance createDB];
    }
    return sharedInstance;
}

-(BOOL)createDB{
    NSString *docsDir;
    NSArray *dirPaths;
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString:
                    [docsDir stringByAppendingPathComponent: @"dgda.db"]];
    BOOL isSuccess = YES;
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath: databasePath ] == NO)
    {
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt =
            "create table if not exists userDetail (id integer primary key, name text, nationalid text, address text, phone text, email text, profession text, city text)";
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to create table");
            }
            sqlite3_close(database);
            //return  isSuccess;
        }
        else {
            isSuccess = NO;
            NSLog(@"Failed to open/create database");
        }
        
        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt2 =
            "create table if not exists medicineDetails (id integer primary key, name text, type text, generic_name text, manufacturer_name text, medicine_image_path text, presentation text, descriptions text, indications text, dosage_administration text, side_effects text, precaution text)";
            if (sqlite3_exec(database, sql_stmt2, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to create table");
            }
            sqlite3_close(database);
            //return  isSuccess;
        }
        else {
            isSuccess = NO;
            NSLog(@"Failed to open/create database");
        }
    }
    return isSuccess;
}

- (BOOL) saveUserData:(NSString*)uId name:(NSString*)name
       nationalid:(NSString*)nationalid address:(NSString*)address phone:(NSString*)phone email:(NSString*)email profession:(NSString*)profession city:(NSString*)city;
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"insert into                               userDetail (id, name, nationalid, address, phone, email, profession, city) values (\"%d\",\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", [uId integerValue], name, nationalid, address, phone, email, profession, city];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            return YES;
        }
        else {
            sqlite3_reset(statement);
            return NO;
        }
    }
    return NO;
}


- (BOOL) updateUserData:(NSString*)uId name:(NSString*)name
           nationalid:(NSString*)nationalid address:(NSString*)address phone:(NSString*)phone email:(NSString*)email profession:(NSString*)profession city:(NSString*)city;
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"update userDetail Set name=\"%@\", nationalid=\"%@\", address=\"%@\", phone=\"%@\", email=\"%@\", profession=\"%@\", city=\"%@\" Where id=\"%d\"", name, nationalid, address, phone, email, profession, city, [uId integerValue]];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            return YES;
        }
        else {
            sqlite3_reset(statement);
            return NO;
        }
    }
    return NO;
}


- (BOOL) saveMedicineData:(NSString*)mId name:(NSString*)name
       type:(NSString*)type generic_name:(NSString*)generic_name manufacturer_name:(NSString*)manufacturer_name medicine_image_path:(NSString*)medicine_image_path presentation:(NSString*)presentation descriptions:(NSString*)descriptions indications:(NSString*)indications dosage_administration:(NSString*)dosage_administration side_effects:(NSString*)side_effects precaution:(NSString*)precaution;
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"insert into                               medicineDetails (id, name, type, generic_name, manufacturer_name, medicine_image_path, presentation, descriptions, indications, dosage_administration, side_effects, precaution) values (\"%d\",\"%@\", \"%@\", \"%@\",\"%@\", \"%@\", \"%@\",\"%@\", \"%@\", \"%@\",\"%@\", \"%@\")",[mId integerValue], name, type, generic_name, manufacturer_name, medicine_image_path, presentation, descriptions, indications, dosage_administration, side_effects, precaution];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            return YES;
        }
        else {
            sqlite3_reset(statement);
            return NO;
        }
    }
    return NO;
}


- (NSArray*) getUserData
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"select * from userDetail"];
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *uid = [[NSString alloc] initWithUTF8String:
                                 (const char *) sqlite3_column_text(statement, 0)];
                [resultArray addObject:uid];
                
                NSString *name = [[NSString alloc] initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 1)];
                [resultArray addObject:name];
                
                NSString *nid = [[NSString alloc]initWithUTF8String:
                                 (const char *) sqlite3_column_text(statement, 2)];
                [resultArray addObject:nid];
                
                NSString *address = [[NSString alloc]initWithUTF8String:
                                     (const char *) sqlite3_column_text(statement, 3)];
                [resultArray addObject:address];
                
                NSString *phone = [[NSString alloc]initWithUTF8String:
                                   (const char *) sqlite3_column_text(statement, 4)];
                [resultArray addObject:phone];
                
                NSString *email = [[NSString alloc]initWithUTF8String:
                                   (const char *) sqlite3_column_text(statement, 5)];
                [resultArray addObject:email];
                
                NSString *profession = [[NSString alloc]initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 6)];
                [resultArray addObject:profession];
                
                NSString *city = [[NSString alloc]initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 7)];
                [resultArray addObject:city];
                
                sqlite3_reset(statement);
                return resultArray;
            }
            else{
                NSLog(@"Not found");
                sqlite3_reset(statement);
                return nil;
            }
        }
    }
    return nil;
}


- (NSArray*) getDataByUserId:(NSString*)userId
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                                      @"select * from userDetail where id=\"%@\"",userId];
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *uid = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 0)];
                [resultArray addObject:uid];
                
                NSString *name = [[NSString alloc] initWithUTF8String:
                                                (const char *) sqlite3_column_text(statement, 1)];
                [resultArray addObject:name];
                
                NSString *nid = [[NSString alloc]initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 2)];
                [resultArray addObject:nid];
                
                NSString *address = [[NSString alloc]initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 3)];
                [resultArray addObject:address];
                
                NSString *phone = [[NSString alloc]initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 4)];
                [resultArray addObject:phone];
                
                NSString *email = [[NSString alloc]initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 5)];
                [resultArray addObject:email];
                
                NSString *profession = [[NSString alloc]initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 6)];
                [resultArray addObject:profession];
                
                NSString *city = [[NSString alloc]initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 7)];
                [resultArray addObject:city];
                
                sqlite3_reset(statement);
                return resultArray;
            }
            else{
                NSLog(@"Not found");
                sqlite3_reset(statement);
                return nil;
            }
            
        }
    }
    return nil;
}


- (NSArray*) getDataByMedicineId:(NSString*)medicineId
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"select * from medicineDetails where id=\"%@\"",medicineId];
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *uid = [[NSString alloc] initWithUTF8String:
                                 (const char *) sqlite3_column_text(statement, 0)];
                [resultArray addObject:uid];
                
                NSString *name = [[NSString alloc] initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 1)];
                [resultArray addObject:name];
                
                NSString *nid = [[NSString alloc]initWithUTF8String:
                                 (const char *) sqlite3_column_text(statement, 2)];
                [resultArray addObject:nid];
                
                NSString *address = [[NSString alloc]initWithUTF8String:
                                     (const char *) sqlite3_column_text(statement, 3)];
                [resultArray addObject:address];
                
                NSString *phone = [[NSString alloc]initWithUTF8String:
                                   (const char *) sqlite3_column_text(statement, 4)];
                [resultArray addObject:phone];
                
                NSString *email = [[NSString alloc]initWithUTF8String:
                                   (const char *) sqlite3_column_text(statement, 5)];
                [resultArray addObject:email];
                
                NSString *profession = [[NSString alloc]initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 6)];
                [resultArray addObject:profession];
                
                NSString *city = [[NSString alloc]initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 7)];
                [resultArray addObject:city];
                
                sqlite3_reset(statement);
                return resultArray;
            }
            else{
                NSLog(@"Not found");
                sqlite3_reset(statement);
                return nil;
            }
        }
    }
    return nil;
}


- (NSMutableArray *) getAllFavourite
{
    const char *dbpath = [databasePath UTF8String];
    
    //NSArray <NSMutableArray *> *cartProduct;
    NSMutableArray *cartProduct = [[NSMutableArray alloc]init];
    

   
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"select * from medicineDetails"];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    
                
                NSString *uid = [[NSString alloc] initWithUTF8String:
                                 (const char *) sqlite3_column_text(statement, 0)];
                               
                [resultArray addObject:uid];
                
                NSString *name = [[NSString alloc] initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 1)];
                [resultArray addObject:name];
                
                NSString *nid = [[NSString alloc]initWithUTF8String:
                                 (const char *) sqlite3_column_text(statement, 2)];
                [resultArray addObject:nid];
                
                NSString *address = [[NSString alloc]initWithUTF8String:
                                     (const char *) sqlite3_column_text(statement, 3)];
                [resultArray addObject:address];
                
                NSString *phone = [[NSString alloc]initWithUTF8String:
                                   (const char *) sqlite3_column_text(statement, 4)];
                [resultArray addObject:phone];
                
                NSString *email = [[NSString alloc]initWithUTF8String:
                                   (const char *) sqlite3_column_text(statement, 5)];
                [resultArray addObject:email];
                
                NSString *profession = [[NSString alloc]initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 6)];
                [resultArray addObject:profession];
                
                NSString *city = [[NSString alloc]initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 7)];
                [resultArray addObject:city];
                
                [cartProduct addObject:resultArray];
                
            }
            
            sqlite3_reset(statement);
        }
    }
    return cartProduct;
    
}


- (BOOL) deleteMedicineId:(NSString*)medicineId
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        
        NSString *querySQL = [NSString stringWithFormat:
                              @"delete from medicineDetails where id=\"%@\"",medicineId];
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                sqlite3_reset(statement);
                return YES;
            }
            else{
                
                sqlite3_reset(statement);
                return NO;
            }
        }
    }
    return NO;
}

@end
