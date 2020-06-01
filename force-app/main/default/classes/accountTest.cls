@isTest
public class accountTest {
    
    @isTest static void testS(){
        Account accountTest = createAccount();
    }
    public static Account createAccount(){
        List<Account> newAcc = [SELECT Id, Name, (SELECT AccountId, Name From Opportunities) From Account];
        Account theAccount = new Account();
        theAccount.name='Test Account';
        theAccount.Type='Prospect';
        theAccount.Phone='1112223333';
        theAccount.Opp_Test__c = '0063h000006vBTxAAM';
        insert theAccount;
        System.AssertEquals(theAccount.Name, 'Test Account');
       	return theAccount;
    }
}