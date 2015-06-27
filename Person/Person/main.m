//
//  main.m
//  Person
//
//  Created by Michael Kavouras on 6/21/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person: NSObject

- (void)setName:(NSString *)name;
- (NSString *)name;

- (void)setCity:(NSString *)city;
- (NSString *)city;

- (void)setPhoneNumber:(NSString *)phoneNumber;
- (NSString *)phoneNumber;

- (BOOL)checkSameCity:(Person *)person;
- (BOOL)checkSamePhoneNumber:(Person *)person;

- (Person *)registerChild:(NSString *)name;
- (void)changePersonName:(Person *)aPerson
                  toName:(NSString *)newName;
- (void)claimChild:(Person *)childToClaim;

@end

@implementation Person {
    NSString *_name;
    NSString *_phoneNumber;
    NSString *_city;
    NSMutableArray *_children;
}

- (void)setName:(NSString *)name {
    _name = name;
}

- (NSString *)name {
    return _name;
}

- (void)setCity:(NSString *)city {
    _city = city;
}

- (NSString *)city {
    return _city;
}

- (void)setPhoneNumber:(NSString *)phoneNumber {
    _phoneNumber = phoneNumber;
}

- (NSString *)phoneNumber {
    return _phoneNumber;
}

- (BOOL)checkSameCity:(Person *)person {
    if ([[self city] isEqualToString:[person city]]) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)checkSamePhoneNumber:(Person *)person {
    if ([[self phoneNumber] isEqualToString:[person phoneNumber]]) {
        return YES;
    } else {
        return NO;
    }
}

- (Person *)registerChild:(NSString *)name {
    Person *abc = [[Person alloc] init];
    [abc setName:name];
    [abc setCity:[self city]];
    [abc setPhoneNumber:[self phoneNumber]];
    
    return abc;
}

- (void)changePersonName:(Person *)aPerson
                  toName:(NSString *)newName {
    [aPerson setName:newName];
}

- (void)claimChild:(Person *)childToClaim {
    if (_children == nil) {
        _children = [[NSMutableArray alloc] init];
    }
    [_children addObject:childToClaim];
}

@end


int main(int argc, const char * argv[]) {
    @autoreleasepool {

        Person *james = [[Person alloc] init];
        [james setName:@"James"];
        [james setCity:@"New York"];
        [james setPhoneNumber:@"212-333-4444"];
        
        Person *clara = [[Person alloc] init];
        [clara setName:@"Clara"];
        [clara setCity:@"New York"];
        [clara setPhoneNumber:@"347-555-7777"];
        
        Person *kim = [[Person alloc] init];
        [kim setName:@"Kim"];
        [kim setCity:@"San Francisco"];
        [kim setPhoneNumber:@"444-555-666"];
        
        NSLog(@"Does %@ live in the same city as %@? %@.", [clara name],
              [james name], [clara checkSameCity:james] ? @"Yes" : @"No");
        
        NSLog(@"Does %@ live in the same city as %@? %@.", [clara name],
              [kim name], [clara checkSameCity:kim] ? @"Yes" : @"No");
        
        Person *carl = [clara registerChild:@"Carl"];
        
        NSLog(@"Does %@ live in the same city as %@? %@.", [clara name],
              [carl name], [clara checkSameCity:carl] ? @"Yes" : @"No");

        NSLog(@"Does %@ have the same phone number as %@? %@.", [clara name],
              [carl name], [clara checkSamePhoneNumber:carl] ? @"Yes" : @"No");
        
        [kim changePersonName:carl toName:@"Biff"];
        [kim claimChild:carl];
        
    }
    return 0;
}
