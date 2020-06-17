//
//  InsuranceBeans.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 13/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "InsuranceItensBeans.h"

@implementation InsuranceStatus
@synthesize dataEndPolicy,dataStartPolicy,licensePlate,status, totalDuration, daysRemaining;
- (id)initWithDictionary:(NSDictionary*) dic
{
    self = [super init];
    if (self) {
        
        dataEndPolicy = [dic objectForKey:@"dataEndPolicy"];
        dataStartPolicy = [dic objectForKey:@"dataStartPolicy"];
        licensePlate = [dic objectForKey:@"licensePlate"];
        if([dic objectForKey:@"licensePlate"] != [NSNull null]){
            licensePlate = [dic objectForKey:@"licensePlate"];
        }else{
            licensePlate = @"";
        }
        
        status= [[dic objectForKey:@"status"] intValue];
    }
    return self;
}


@end

@implementation InsuranceItensBeans
@synthesize broker,claim,ciaCode, contract,desc, insuranceStatus,issuance,issuingAgency,policy, policyBranch, payment, ipvaRemaining,branchName,branchImageName, licensingRemaining, cifCode, itemCode, insuranceCoverages, coveragesArray;

- (id)initWithDictionary:(NSDictionary*) dic
{
    self = [super init];
    if (self) {
        if([dic objectForKey:@"broker"] != [NSNull null]){
            broker = [[BrokerBeans alloc] initWithDictionary:[dic objectForKey:@"broker"]];
        }else{
            broker = [[BrokerBeans alloc] init];
        }
        if([dic objectForKey:@"claim"] != [NSNull null]){
            claim = [[ClaimBeans alloc] initWithDictionary:[dic objectForKey:@"claim"]];
        }else{
            claim = [[ClaimBeans alloc] init];
        }
        desc = [dic objectForKey:@"description"];
        ciaCode = [[dic objectForKey:@"ciaCode"] intValue];
        contract = [[dic objectForKey:@"contract"] longValue];
        cifCode = [[dic objectForKey:@"cliCode"] longValue];
        insuranceCoverages = @"";
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
            //            CoverageBeans *beansAssist = [[CoverageBeans alloc] init];
            //            [beansAssist setCoverageDescription:@"Descrição de teste"];
            //            [beansAssist setDetail:@"Detalhe detalhe detalhe"];
            //            [beansAssist setType:CT_ASSIST];
            //            [beansAssist setValue:@"14.00"];
            //            [arrayAssyst addObject:beansAssist];
            //            int counter = 0;
            //            NSArray *arrayCoverages = [dic objectForKey:@"insuranceCoverages"];
            //            NSString *tempString = @"";
            //            for (NSDictionary *coverageDic in arrayCoverages) {
            //                NSString *coverage = [coverageDic objectForKey:@"description"];
            //
            //                NSMutableString *result = [NSMutableString stringWithFormat:@"%@", [coverage lowercaseString]];
            //                [result replaceCharactersInRange:NSMakeRange(0, 1) withString:[[result substringToIndex:1] capitalizedString]];
            //
            //                NSRange rng = [result rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: [result stringByReplacingOccurrencesOfString: @" " withString: @""]] options: NSBackwardsSearch];
            //                NSString *finalResult = [result substringToIndex: rng.location+1];
            //
            //                if(counter == 0){
            //                    tempString = finalResult;
            //                }else{
            //                    tempString = [tempString stringByAppendingString:[NSString stringWithFormat:@" • %@",finalResult]];
            //                }
            //                counter++;
            //            }
            //
            //
            //            NSRange lastComma = [tempString rangeOfString:@"," options:NSBackwardsSearch];
            //
            //            if(lastComma.location != NSNotFound) {
            //                insuranceCoverages = [tempString stringByReplacingCharactersInRange:lastComma
            //                                                   withString: @" e"];
            //            }else{
            //                insuranceCoverages = tempString;
            //            }
            //
            //            insuranceCoverages = [insuranceCoverages  stringByAppendingString:@"."];
        }
        if([arrayAssyst count] > 0){
            [arrayFinal addObject:NSLocalizedString(@"SERVICOSSEGURO",@"")];
            [arrayFinal addObjectsFromArray:arrayAssyst];
        }
        coveragesArray = arrayFinal;
        insuranceStatus = [[InsuranceStatus alloc] initWithDictionary:[dic objectForKey:@"insuranceStatus"]];
        if([dic objectForKey:@"payment"] != [NSNull null]){
            payment = [[PaymentBeans alloc] initWithDictionary:[dic objectForKey:@"payment"]];
        }else{
            payment = [[PaymentBeans alloc] init];
        }
        if([dic objectForKey:@"itemCode"] != [NSNull null]){
            itemCode = [[dic objectForKey:@"itemCode"] intValue];
        }else{
            itemCode = 0;
        }
        issuance = [[dic objectForKey:@"issuance"] intValue];
        issuingAgency = [[dic objectForKey:@"issuingAgency"] intValue];
        policy = [dic objectForKey:@"policy"];
        policyBranch = [dic objectForKey:@"branch"];
        
        [self setPolicyBranchs];
        [self calcDates];
        
    }
    return self;
}
- (id)initWithHomeDictionary:(NSDictionary*) dic{
    self = [super init];
    if (self) {
        broker = [[BrokerBeans alloc] init];
        
        if([dic objectForKey:@"claim"] != [NSNull null]){
            claim = [[ClaimBeans alloc] initWithHomeDictionary:[dic objectForKey:@"claim"]];
        }else{
            claim = [[ClaimBeans alloc] init];
        }
        if([dic objectForKey:@"payment"] != [NSNull null]){
            payment = [[PaymentBeans alloc] initWithDictionary:[dic objectForKey:@"payment"]];
        }else{
            payment = [[PaymentBeans alloc] init];
        }
        desc = [dic objectForKey:@"description"];
        ciaCode = [[dic objectForKey:@"ciaCode"] intValue];
        contract = [[dic objectForKey:@"contract"] longValue];
        cifCode = [[dic objectForKey:@"cliCode"] longValue];
        insuranceStatus = [[InsuranceStatus alloc] init];
        [insuranceStatus setDataEndPolicy:[dic objectForKey:@"dataEndPolicy"]];
        [insuranceStatus setDataStartPolicy:[dic objectForKey:@"dataStartPolicy"]];
        [insuranceStatus setLicensePlate:[dic objectForKey:@"licensePlate"]];
        insuranceCoverages = @"";
        issuance = [[dic objectForKey:@"issuance"] intValue];
        issuingAgency = [[dic objectForKey:@"issuingAgency"] intValue];
        
        policy = [dic objectForKey:@"policy"];
        policyBranch = [dic objectForKey:@"branch"];
        
        [self setPolicyBranchs];
        [self calcDates];
        
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
    NSDate *dataEndPolicy = [dateformat dateFromString:insuranceStatus.dataEndPolicy];
    NSDate *dataStartPolicy = [dateformat dateFromString:insuranceStatus.dataStartPolicy];
    
    NSDateComponents *components = [cal components:NSCalendarUnitDay
                                          fromDate:dataStartPolicy
                                            toDate:dataEndPolicy
                                           options:0];
    
    
    NSTimeInterval timeInterval = [dataEndPolicy timeIntervalSinceNow];
    double diff = timeInterval/(24 * 60 * 60);
    
    insuranceStatus.totalDuration = (int)[components day];
    insuranceStatus.daysRemaining = ceil(diff);
    if(insuranceStatus.daysRemaining < 0 ){
        insuranceStatus.daysRemaining  = 0;
    }
    
    if(insuranceStatus.licensePlate != nil && ![insuranceStatus.licensePlate isEqualToString:@""]){
        
        NSString *lastNumber = [insuranceStatus.licensePlate substringFromIndex:[insuranceStatus.licensePlate length]-1];
        
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
