//
//  main.m
//  Election
//
//  Created by Michael Kavouras on 6/21/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

#import <Foundation/Foundation.h>

// forward declarations
@class Contender;
@class Election;

//*************************** Contender class **********************************

@interface Contender : NSObject

- (instancetype)initWithName:(NSString *)name;
    
- (void)addVote;
- (NSInteger)votesReceived;
- (NSString *)name;

@end

@implementation Contender {
    NSInteger _votesReceived;
    NSString *_name;
}

- (instancetype)initWithName:(NSString *)name {
    if (self = [super init]) {
        _votesReceived = 0;
        _name = name;
        return self;
    }
    return nil;
}

- (void)addVote {
    _votesReceived++;
}

- (NSInteger)votesReceived {
    return _votesReceived;
}

- (NSString *)name {
    return _name;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ received %ld votes", _name,
            _votesReceived];
}

@end
//************************** End Contender class *******************************


//*************************** Election class ***********************************

@interface Election : NSObject

- (instancetype)initWithElectionName:(NSString *)name;

- (void)setElectionName:(NSString *)name;
- (NSString *)electionName;

- (void)addContender:(Contender *)contender;
- (void)voteIsSimulated:(BOOL)simulated;
- (void)vote:(NSInteger)index;
- (void)displayCandidates;
- (void)displayResults;

@end

@implementation Election {
    NSString *_electionName;
    
    // Cool! a mutable array!
    NSMutableArray *_listOfContenders;
}

- (instancetype)initWithElectionName:(NSString *)name {
    if (self = [super init]) {
        _electionName = name;
        return self;
    }
    return nil;
}

- (void)addContender:(Contender *)contender {
   if (_listOfContenders == nil) {
       _listOfContenders = [[NSMutableArray alloc] init];
   }
    
    // addObject: an NSMutableArray method
    [_listOfContenders addObject:contender];
}

- (void)setElectionName:(NSString *)name {
    _electionName = name;
}

- (NSString *)electionName {
    return _electionName;
}

- (void)vote:(NSInteger)index {
    Contender *contender = (Contender *)[_listOfContenders objectAtIndex:index];
    [contender addVote];
}

- (void)displayCandidates {
    for (Contender *c in _listOfContenders) {
        NSLog(@"%@", [c name]);
    }
}


- (void)displayResults {
    printf("\n%s\n", [_electionName UTF8String]);
    for (Contender *c in _listOfContenders) {
        printf("%s\n", [[c description] UTF8String]);
    }
}

- (void)voteIsSimulated:(BOOL)simulated {
    NSInteger i = 1;
    
    for (Contender *c in _listOfContenders) {
        printf("\nIndex = %ld, Contender = %s", i, [[c name] UTF8String]);
        i++;
    }
    
    printf("\n");
    
    BOOL voted = NO;
    
    while (!voted) {
        printf("\nEnter the index of the Contender you want to vote for: ");
        int vote;
        
        if(simulated == YES) {
            vote = arc4random_uniform((int)[_listOfContenders count]) + 1;
        } else {
            scanf("%d", &vote);
        }
        
        int index = vote - 1;
        
        if (index >= 0 && index < _listOfContenders.count) {
            [self vote:index];
            voted = true;
        } else {
            printf("Contender does not exist...\n");
        }
    }
        
}

@end
//************************** End Election class ********************************


//************************* ElectionManager class ******************************

@interface ElectionManager : NSObject

- (void)manage:(Election *)race;
- (void)initiatePolling;
- (void)initiateSimulatedPolling:(NSInteger)voterTurnout;
- (void)displayResults;
- (BOOL)pollsOpen;

@end

@implementation ElectionManager {
    NSMutableArray *_races;
}

- (void)manage:(Election *)race {
    if (_races == nil) {
        _races = [[NSMutableArray alloc] init];
    }
    [_races addObject:race];
}

- (void)initiatePolling {
    while ([self pollsOpen]) {
        for (Election *race in _races) {
            printf("\nVOTE FOR ONE! \n");
            [race voteIsSimulated:NO];
        }
    }
}

- (void)initiateSimulatedPolling:(NSInteger)voterTurnout {
    for (NSInteger count = 0; count < voterTurnout; count++) {
        for (Election *race in _races) {
            //usleep(2e5);
            printf("\nVOTE FOR ONE! \n");
            [race voteIsSimulated:YES];
        }
    }
}

- (void)displayResults {
    printf("\nResults of voting...\n");
    for (Election *race in _races) {
        [race displayResults];
    }
}

- (BOOL)pollsOpen {
    printf("\nType 0 to close polls otherwise enter 1 to continue: ");
    int answer;
    scanf("%d", &answer);
    fpurge(stdin);
    
    return answer != 0;
}


@end
//*********************** End ElectionManager class ****************************


//************************ ElectionSimulator class *****************************

@interface ElectionSimulator : NSObject

- (void)setElectionManager:(ElectionManager *)em;

@end

@implementation ElectionSimulator {
    ElectionManager *_em;
    NSInteger _vt;
}

- (id)initWithElectionManager:(ElectionManager *)em {
    if (self = [super init]) {
        _em = em;
    }
    return self;
}

- (void)setElectionManager:(ElectionManager *)em {
    _em = em;
}

- (void)run {
    if (_em != nil) {
        
        printf("\nPlease input the number of voters who turned out for the election: ");
        int voterTurnout;
        scanf("%d", &voterTurnout);
        fpurge(stdin);
        [_em initiateSimulatedPolling:voterTurnout];
        [_em displayResults];
        
    } else {
        
        NSLog(@"\n");
        NSLog(@"Please run setElectionManager method with a valid ElectionManager.");
        
    }
}

@end
//********************** End ElectionSimulator class ***************************


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        Contender *bernie = [[Contender alloc] initWithName:@"Bernie Sanders"];
        Contender *hillary = [[Contender alloc] initWithName:@"Hillary Clinton"];
        Contender *ann = [[Contender alloc] initWithName:@"Ann Coulter"];
        Contender *donald = [[Contender alloc] initWithName:@"Donald Trump"];
        Contender *jeb = [[Contender alloc] initWithName:@"Jeb Bush"];
        Contender *chris = [[Contender alloc] initWithName:@"Chris Christie"];
        
        Election *president = [[Election alloc] initWithElectionName:@"President"];
        [president addContender:bernie];
        [president addContender:hillary];
        [president addContender:jeb];
        [president addContender:chris];
        NSLog(@"\n");
        NSLog(@"Candidates for %@:", [president electionName]);
        [president displayCandidates];
        
        Election *asshole = [[Election alloc] initWithElectionName:@"Asshole"];
        [asshole addContender:ann];
        [asshole addContender:donald];
        NSLog(@"\n");
        NSLog(@"Candidates for %@:", [asshole electionName]);
        [asshole displayCandidates];
        
        ElectionManager *em = [[ElectionManager alloc] init];
        [em manage:president];
        [em manage:asshole];
        [em initiatePolling];
        [em displayResults];
        
        ElectionSimulator *es = [[ElectionSimulator alloc] initWithElectionManager:em];
        [es run];
        
        
    }
    return 0;
}
