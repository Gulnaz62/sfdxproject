@isTest
public class TATDateTimeUpdateTest {
    @isTest static void testTATDateTimeInsertAndUpdate(){  
        Account acc = TestDataFactory.createAccount(false,'RSI Limited');
        insert acc;
        Contact con = TestDataFactory.createContact(false, 'Gaurav','Kumar',acc.Id);
        insert con;
        User crmUser = TestDataFactory.createUser(false,'CRM',1);
        insert crmUser;
        User opsUser = TestDataFactory.createUser(false,'Operation',2);
        insert opsUser;
        User invoiceUser = TestDataFactory.createUser(false,'CRM',3);
        insert invoiceUser;
        Enquiry__c enq = TestDataFactory.createEnquiry(false, acc.Id, con.Id,crmUser.Id, 'Domestic Enquiry', opsUser.Id, invoiceUser.Id);
        insert enq;
        Quote__c quo = TestDataFactory.createQuote(false, enq.Id);   
        insert quo;   
        Enquiry__c enqToUpdate = [Select Id,Stage__c,Survey_Date_Time__c,Survey_Acknowledgement__c,Survey_Type__c From Enquiry__c where Id =: enq.Id];
        enqToUpdate.Stage__c = 'Quote Submission';
        enqToUpdate.Survey_Date_Time__c = system.now();  
        update enqToUpdate;
    } 
    @isTest static void testTATDateTimeUpdate(){
    Account acc = TestDataFactory.createAccount(false,'RSI Limited');
        insert acc;
        Contact con = TestDataFactory.createContact(false, 'Gaurav','Kumar',acc.Id);
        insert con;
        User crmUser = TestDataFactory.createUser(false,'CRM',4);
        insert crmUser;
        User opsUser = TestDataFactory.createUser(false,'Operation',5);
        insert opsUser;
        User invoiceUser = TestDataFactory.createUser(false,'CRM',6);
        insert invoiceUser;
        Enquiry__c enq = TestDataFactory.createEnquiry(false, acc.Id, con.Id,crmUser.Id, 'Domestic Enquiry', opsUser.Id, invoiceUser.Id);
        insert enq;
        Quote__c quo = TestDataFactory.createQuote(false, enq.Id);   
        insert quo;  
        Enquiry__c enqToUpdate = [Select Id,Stage__c,Survey_Date_Time__c,Survey_Acknowledgement__c,Survey_Type__c From Enquiry__c where Id =: enq.Id];
        enqToUpdate.Stage__c = 'Estimate Costing';
        enqToUpdate.Survey_Date_Time__c = system.now();  
        update enqToUpdate;    
    }
}