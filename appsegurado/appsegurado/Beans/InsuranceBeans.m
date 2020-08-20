//
//  InsuranceBeans.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 13/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "InsuranceBeans.h"
@implementation ItemInsurance
@synthesize claim,code,coveragesArray,desc,issuance,licensePlate;

- (id)initWithDictionary:(NSDictionary*) dic{
    self = [super init];
    if (self) {
        
        if([dic objectForKey:@"claim"] != [NSNull null] && [dic objectForKey:@"claim"] != nil){
            claim = [[ClaimBeans alloc] initWithClaimDictionary:[dic objectForKey:@"claim"]];
        }else{
            claim = [[ClaimBeans alloc] init];
        }
        
        code = [[dic objectForKey:@"code"] intValue];
        desc = [dic objectForKey:@"description"];
        licensePlate = [dic objectForKey:@"licensePlate"];
        issuance = [[dic objectForKey:@"issuance"] intValue];
        
        NSMutableArray *arrayAssyst = [[NSMutableArray alloc] init];
        NSMutableArray *arrayFinal = [[NSMutableArray alloc] init];
        [arrayFinal addObject:NSLocalizedString(@"COBERTURASSEGURO",@"")];
        if([dic objectForKey:@"insuranceCoverages"] != [NSNull null] && [dic objectForKey:@"insuranceCoverages"] != nil){
            for (NSDictionary *tempDic in [dic objectForKey:@"insuranceCoverages"] ) {
                CoverageBeans *beans = [[CoverageBeans alloc] initWithDictionary:tempDic];
                if(beans.type == CT_ASSIST){
                    [arrayAssyst addObject:beans];
                }else if(beans.type == CT_COVERAGE){
                    [arrayFinal addObject:beans];
                }
                
            }
        }
        if([arrayAssyst count] > 0){
            [arrayFinal addObject:NSLocalizedString(@"SERVICOSSEGURO",@"")];
            [arrayFinal addObjectsFromArray:arrayAssyst];
        }
        coveragesArray = arrayFinal;
    }
    return self;
}
@end

@implementation InsuranceBeans
@synthesize broker,ciaCode, contract, issuances,issuingAgency,policy, policyBranch, ipvaRemaining,branchName,branchImageName, licensingRemaining, cifCode, insuranceCoverages, dataEndPolicy,dataStartPolicy,daysRemaining,totalDuration, licensePlate, itens, allowPHS;


#pragma mark Parser V2
- (id)initWithDictionaryV2:(NSDictionary*) dic
{
    self = [super init];
    if (self) {
        if([dic objectForKey:@"broker"] != [NSNull null] && [dic objectForKey:@"broker"] != nil){
            broker = [[BrokerBeans alloc] initWithDictionary:[dic objectForKey:@"broker"]];
        }else{
            broker = [[BrokerBeans alloc] init];
        }
        
        if([dic objectForKey:@"allowPHS"] != [NSNull null] && [dic objectForKey:@"allowPHS"] != nil){
            allowPHS = [[dic objectForKey:@"allowPHS"] boolValue];
        }else{
            allowPHS = false;
        }
        
        
        ciaCode = [[dic objectForKey:@"ciaCode"] intValue];
        contract = [[dic objectForKey:@"contract"] longValue];
        cifCode = [[dic objectForKey:@"cliCode"] longValue];
        issuances = [dic objectForKey:@"issuances"];
        insuranceCoverages = @"";
        issuingAgency = [[dic objectForKey:@"issuingAgency"] intValue];
        dataStartPolicy = [dic objectForKey:@"dataStartPolicy"];
        dataEndPolicy = [dic objectForKey:@"dataEndPolicy"];
        
        //        payments = [[NSMutableArray alloc] init];
        //        if([dic objectForKey:@"payments"] != [NSNull null]){
        //            for (NSDictionary *dicItem in [dic objectForKey:@"payments"]) {
        //                [payments addObject:[[PaymentBeans alloc] initWithDictionary:dicItem]];
        //            }
        //        }
        itens = [[NSMutableArray alloc] init];
        
        if([dic objectForKey:@"itens"] != [NSNull null] && [dic objectForKey:@"itens"] != nil){
            for (NSDictionary *dicItem in [dic objectForKey:@"itens"]) {
                [itens addObject:[[ItemInsurance alloc] initWithDictionary:dicItem]];
            }
        }
        
        issuingAgency = [[dic objectForKey:@"issuingAgency"] intValue];
        policy = [dic objectForKey:@"policy"];
        policyBranch = [dic objectForKey:@"branch"];
        licensePlate = nil;
        [self setPolicyBranchs];
        [self calcDates];
        
    }
    return self;
}

-(id) initWithInsuranceIten:(InsuranceItensBeans*) bean{
    self = [super init];
    if (self) {
        broker = [[BrokerBeans alloc] init];
        
        
        ciaCode = bean.ciaCode;
        contract = bean.contract;
        cifCode = bean.cifCode;
        issuances = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:bean.issuance], nil];
        
        insuranceCoverages = @"";
        issuingAgency = bean.issuingAgency;
        dataStartPolicy = bean.insuranceStatus.dataStartPolicy;
        dataEndPolicy =  bean.insuranceStatus.dataEndPolicy;
        
        itens = [[NSMutableArray alloc] init];
        
        ItemInsurance *item = [[ItemInsurance alloc] init];
        item.desc = bean.desc;
        item.code = bean.itemCode;
        item.issuance = bean.issuance;
        item.claim = bean.claim;
        item.coveragesArray = bean.coveragesArray;
        item.licensePlate = bean.insuranceStatus.licensePlate;
        [itens addObject:item];
        
        policy = bean.policy;
        policyBranch = bean.policyBranch;
        licensePlate = bean.insuranceStatus.licensePlate;
        [self setPolicyBranchs];
        
        totalDuration = bean.insuranceStatus.totalDuration;
        daysRemaining = bean.insuranceStatus.daysRemaining;
        
    }
    return self;
}

-(void) setPolicyBranchs{
    if([[policyBranch uppercaseString] isEqualToString:@"AUTO"]){
        branchName = NSLocalizedString(@"Veiculo", @"");
        branchImageName = @"auto_icon.png";
    }else if([[policyBranch uppercaseString] isEqualToString:@"VIDA"]){
        branchImageName = @"life_icon.png";
        branchName = NSLocalizedString(@"Segurado", @"");
    }else{
        branchImageName = @"home_icon.png";
        branchName = NSLocalizedString(@"Endereco", @"");
    }
    
}

-(BOOL) isAutoPolicy{
    if([[policyBranch uppercaseString] isEqualToString:@"AUTO"]){
        return true;
    }
    return false;
}

-(void) calcDates{
    //Calc Duration
    NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
    NSCalendar *cal = [NSCalendar currentCalendar];
    [dateformat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
      
    NSArray *arrayDataEnd = [dataEndPolicy componentsSeparatedByString:@"T"];
    
    NSDate *dataEndPolicyDate = [dateformat dateFromString:[NSMutableString stringWithFormat:@"%@T23:59:59Z", arrayDataEnd[0]]];
    NSDate *dataStartPolicyDate = [dateformat dateFromString:dataStartPolicy];
    
    NSDateComponents *components = [cal components:NSCalendarUnitDay
                                          fromDate:dataStartPolicyDate
                                            toDate:dataEndPolicyDate
                                           options:0];
    

    totalDuration = (int)[components day];
    
    NSTimeInterval timeInterval = [dataEndPolicyDate timeIntervalSinceNow];
    double diff = timeInterval/(24 * 60 * 60);
    
    daysRemaining = ceil(diff);
    if(daysRemaining < 0 ){
        daysRemaining  = 0;
    }
    
    if(licensePlate != nil && ![licensePlate isEqualToString:@""]){
        
        NSString *lastNumber = [licensePlate substringFromIndex:[licensePlate length]-1];
        
        if (lastNumber.length <= 0 || [lastNumber rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location != NSNotFound) {
            NSLog(@"This is not a positive integer");
            return;
        }
        //Calc Licensing time remaining
        NSArray *array31 = @[@"2",@"4",@"7",@"9"];
        
        NSCalendar *cal = [NSCalendar currentCalendar];
        [dateformat setDateFormat:@"yyyy"];
        NSString *yearString = [dateformat stringFromDate:[NSDate date]];
        [dateformat setDateFormat:@"yyyy-MM-dd"];
        NSDate *dateApril = [dateformat dateFromString:[NSString stringWithFormat:@"%@-04-30",yearString]];
        int sumMonths = ([lastNumber intValue] == 0 ? 10 : [lastNumber intValue]) - 2;
        NSDate *nextLicensing = [cal dateByAddingUnit:NSCalendarUnitMonth value:sumMonths toDate:dateApril options:0];
        NSDateComponents *components3 = [cal components:NSCalendarUnitDay
                                               fromDate:[NSDate date]
                                                 toDate:nextLicensing
                                                options:0];
        licensingRemaining = (int)[components3 day];
        
        if([array31 containsObject:lastNumber]){
            licensingRemaining += 1;
        }
        
        if(licensingRemaining < 0){
            licensingRemaining  = 0;
        }
        
        //Calc IPVA time remaining
        
        
        NSArray *arrayDays = @[@"26",@"13",@"14",@"17",@"18",@"19",@"20",@"21",@"24",@"25"];
        NSDate *dateIPVA = [dateformat dateFromString:[NSString stringWithFormat:@"%@-03-%@",yearString, [arrayDays objectAtIndex:[lastNumber intValue]]]];
        NSDateComponents *components4 = [cal components:NSCalendarUnitDay
                                               fromDate:[NSDate date]
                                                 toDate:dateIPVA
                                                options:0];
        ipvaRemaining = (int)[components4 day];
        if(ipvaRemaining < 0){
            ipvaRemaining  = 0;
        }
        
    }
    
    
}

@end
