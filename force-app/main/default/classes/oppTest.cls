@isTest(SeeAllData = true)

public class oppTest {
    
    @isTest static void oppTester(){
        Opportunity opptTest = createOpportunity();
    }
    public static Opportunity createOpportunity(){
        List<Opportunity> newOpp = [SELECT AccountId, Name From Opportunity];
        Opportunity theOpp = new Opportunity();
        theOpp.name='Default Residential Opp';
        theOpp.AccountId = '0013h000006Vh4BAAS';
        theOpp.StageName='Prospecting';
        theOpp.CloseDate=system.today();           
        insert theOpp;
       	return theOpp;
        
        
    }
    }