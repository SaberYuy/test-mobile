//
//  NSObject+YUIModel.m
//  YUIAll
//
//  Created by YUI on 2020/11/17.
//

#import "NSObject+YUIModel.h"

@interface NSObject (YUIModel)

@end


@implementation NSObject (YUIModel)

+ (instancetype)sharedInstance{
    
    //Singleton instance
    static NSObject *model;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        model = [[NSObject alloc] init];
    });
    
    return model;
}

+ (instancetype)instanceWithModel:(id)object{
    
    return [[self alloc]initWithModel:object];
}

-(instancetype)initWithModel:(id)object{
    
    self = [self init];
    if (self == nil) return nil;
    
    if(object){
        
        [self setDataWithObject:object];
    }
    
    return self;
}

+ (NSArray *)instanceWithModelArray:(NSArray *)objectArray{
    
    NSMutableArray *result = [NSMutableArray array];
    
    for (__unsafe_unretained id object in objectArray){
        
        id instance = [self instanceWithModel:object];
        if (instance) [result addObject:instance];
    }
    return [result copy];
}


+ (instancetype)instanceWithDictionary:(NSDictionary *)dictionary{
    
     return [[self alloc]initWithDictionary:dictionary];
}

-(instancetype)initWithDictionary:(NSDictionary *)dictionary{
    
    self = [self init];
    if (self == nil) return nil;
    
    if(dictionary){
    
        [self setDataWithDictionary:dictionary];
    }
    
    return self;
}

+ (NSArray *)instanceWithDictionaryArray:(NSArray *)dictionaryArray{
    
    NSMutableArray *tempMA = [NSMutableArray array];
    
    for(NSDictionary *dictionary in dictionaryArray) {
        
        [tempMA addObject:[self instanceWithDictionary:dictionary]];
    }
    
    return [tempMA copy];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    
    return nil;
}

+ (instancetype)instanceWithJSONDictionary:(NSDictionary *)dictionary{
    
    return [self yy_modelWithDictionary:dictionary];
}

//-(instancetype)initWithJSONDictionary:(NSDictionary *)dictionary{
//
////    return [MTLJSONAdapter modelOfClass:[self class] fromJSONDictionary:dictionary error:error];
//
//    return nil;
//}

+ (NSArray *)instanceWithJSONDictionaryArray:(NSArray *)dictionaryArray{
    
    return [NSArray yy_modelArrayWithClass:[self class] json:dictionaryArray];
    
//    NSMutableArray *tempMA = [NSMutableArray array];
//
//    for(NSDictionary *dictionary in dictionaryArray) {
//
//        [tempMA addObject:[self instanceWithJSONDictionary:dictionary]];
//    }
//
//    return [tempMA copy];
}

-(NSDictionary *)dictionaryWithModel{
    
    NSDictionary *dictionary = [[NSDictionary alloc]init];
    
    //override this
    
    return dictionary;
}

+ (NSArray<NSDictionary *> *)dictionaryWithModelArray:(NSArray<NSObject *> *)objectArray{
    
    if (objectArray){
        
        NSMutableArray *tempMA = [NSMutableArray array];
        
        for (NSObject *object in objectArray) {
            
            [tempMA addObject:[object dictionaryWithModel]];
        }
        
        return tempMA;
    }
    
    return nil;
}



-(NSDictionary *)jSONDictionaryWithModel{
    
    return [self yy_modelToJSONObject];
    
//    NSError *error;
//
//    return [MTLJSONAdapter JSONDictionaryFromModel:self error:&error];
}



+ (NSArray<NSDictionary *> *)jSONDictionaryWithModelArray:(NSArray<NSObject *> *)objectArray{
    
    if (objectArray){
        
        NSMutableArray *tempMA = [NSMutableArray array];
        
        for (NSObject *object in objectArray) {
            
            [tempMA addObject:[object jSONDictionaryWithModel]];
        }
        
        return tempMA;
    }
    
    return nil;
}

//+(instancetype)instanceWithCoder:(NSCoder *)decoder{
//
//    if (decoder) {
//        
//        return [[self alloc]initWithCoder:decoder];
//    }
//
//    return nil;
//}

//-(instancetype)initWithCoder:(NSCoder *)decoder{
//    
//    if ((self = [[super class] initWithCoder:decoder])){
//        
//        [self commonInit];
//    }
//    
//    return self;
//}

-(NSArray *)getAllProperties{
    
    u_int count;
    
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i<count; i++){
        
        const char* propertyName =property_getName(properties[i]);
        
        [propertiesArray addObject: [NSString stringWithUTF8String: propertyName]];
    }
    
    free(properties);
    
    return propertiesArray;
}

-(void)setDataWithMatchModelProperty:(NSObject *)object{
    
    u_int count;
    
    objc_property_t *properties = class_copyPropertyList([object class], &count);
    
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i<count; i++){
        
        const char* propertyName =property_getName(properties[i]);
        
        [propertiesArray addObject: [NSString stringWithUTF8String: propertyName]];
    }
    
    free(properties);
    
    NSArray *selfPropertiesArray = [self getAllProperties];
    
    for (NSString *propertyName in selfPropertiesArray) {
        
        BOOL  isExist = NO;
        
        for (NSInteger i = 0; i < propertiesArray.count; i++) {
            
            if ([propertiesArray[i] isEqualToString:propertyName]) {
                
                isExist = YES;
            }
        }
        
        if (isExist) {
            
            [self setValue:[object valueForKey:propertyName] forKey:propertyName];
        }
    }
}



-(void)didInitialize{
    
    //override this
}

-(void)setDataWithDictionary:(NSDictionary *)dictionary{
    
    //override this
}

-(void)setDataWithObject:(id<NSObject>)object{
    
    //override this
}

-(void)processData{
 
    //override this
}

-(void)restoreData{
    
    //override this
}

-(void)releaseData{
    
    //override this
}

@end
