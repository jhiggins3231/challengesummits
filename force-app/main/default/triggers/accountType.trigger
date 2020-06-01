trigger accountType on Account (after update, after insert) {    
	List<Account> accountsWithOpps = [SELECT Id, Name, User_Email__c, (SELECT Id, Name, AccountId 
                                                        FROM Opportunities WHERE Name = 'Default Residential Opp' OR Name = 'Default Commercial Opp') FROM Account 
                                      					WHERE Type = 'Prospect'];
	List<Opportunity> oppList = new List<Opportunity>();
    List<Opportunity> commList = new List<Opportunity>();
	List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();

    
	String resOpp = 'Default Residential Opp';
	String comOpp = 'Default Commercial Opp';

    for(Account a : Trigger.New){
        for (Account acc : accountsWithOpps){
        for(Opportunity opp : acc.Opportunities){
        
                if(acc.Opportunities.size()<2 || acc.Opportunities.size()==0){
                    system.debug('Missing accounts ' + acc.Name);
                    if(opp.Name == resOpp){
                        system.debug('Missing Commercial Opp on ' + acc.Name);
                        Opportunity objCom = new Opportunity();
                    	objCom.Name = 'Default Commercial Opp';
                    	objCom.CloseDate = Date.TODAY().addDays(7);
                    	objCom.StageName = 'Prospecting';
                		objCom.AccountId = opp.AccountId;
                        commList.add(objCom);
                        
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        List<String> sendTo = new List<String>();
                        sendTo.add(acc.User_Email__c);
                        mail.setToAddresses(sendTo);
                        mail.setReplyTo('jhiggins3231@gmail.com');
                        mail.setSubject('Opportunity Creation');
                        String body = 'A Required Opportunity named Default Commercial Opp was created due to deletion or Account creation.';
                        mail.setHtmlBody(body);
                        mails.add(mail);
                        continue;
                    }else if(opp.Name == comOpp) {
                        system.debug('Missing Residential Opp on ' + acc.Name);
                        Opportunity objRes = new Opportunity();
                    	objRes.Name = 'Default Residential Opp';
                    	objRes.CloseDate = Date.TODAY().addDays(7);
                    	objRes.StageName = 'Prospecting';
                		objRes.AccountId = opp.AccountId;
                        oppList.add(objRes);
                        
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        List<String> sendTo = new List<String>();
                        sendTo.add(acc.User_Email__c);
                        mail.setToAddresses(sendTo);
                        mail.setReplyTo('jhiggins3231@gmail.com');
                        mail.setSubject('Opportunity Creation');
                        String body = 'A Required Opportunity named Default Residential Opp was created due to deletion or Account creation.';
                        mail.setHtmlBody(body);
                        mails.add(mail);
                    } else {
                        system.debug('Account has required Opportunities');
                    }
                }
            }
		}
    insert oppList;
    insert commList;
    Messaging.sendEmail(mails);
	}
}