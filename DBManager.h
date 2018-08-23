//
//  DBManager.h
//  SQLDB
//
//  Created by afzal on 1/17/16.
//  Copyright (c) 2016 afzal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBManager : NSObject
{
    NSString *databasePath;
}

+(DBManager*)getSharedInstance;

-(BOOL)createDB;

- (BOOL) saveUserData:(NSString*)uId name:(NSString*)name
           nationalid:(NSString*)nationalid address:(NSString*)address phone:(NSString*)phone email:(NSString*)email profession:(NSString*)profession city:(NSString*)city;

- (BOOL) updateUserData:(NSString*)uId name:(NSString*)name
             nationalid:(NSString*)nationalid address:(NSString*)address phone:(NSString*)phone email:(NSString*)email profession:(NSString*)profession city:(NSString*)city;

- (BOOL) saveMedicineData:(NSString*)mId name:(NSString*)name
                     type:(NSString*)type generic_name:(NSString*)generic_name manufacturer_name:(NSString*)manufacturer_name medicine_image_path:(NSString*)medicine_image_path presentation:(NSString*)presentation descriptions:(NSString*)descriptions indications:(NSString*)indications dosage_administration:(NSString*)dosage_administration side_effects:(NSString*)side_effects precaution:(NSString*)precaution;

-(NSArray*) getUserData;
-(NSArray*) getDataByUserId:(NSString*)userId;
-(NSArray*) getDataByMedicineId:(NSString*)medicineId;

- (NSMutableArray*) getAllFavourite;

- (BOOL) deleteMedicineId:(NSString*)medicineId;

@end
