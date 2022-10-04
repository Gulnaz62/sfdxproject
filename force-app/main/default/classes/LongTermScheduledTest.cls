@isTest
public class LongTermScheduledTest {
    @isTest static void testLongTermScheduled(){
        Test.StartTest();
        Account acc = TestDataFactory.createAccount(false,'RSI Limited');
        insert acc;
        Contact con = TestDataFactory.createContact(false, 'Gaurav','Kumar',acc.Id);
        insert con;
        User crmUser = TestDataFactory.createUser(false,'CRM',19);
        insert crmUser;
        User invoiceUser = TestDataFactory.createUser(false,'CRM',20);
        insert invoiceUser;
        User opsUser = TestDataFactory.createUser(false,'Operation',21);
        insert opsUser;
        Enquiry__c enq = TestDataFactory.createEnquiry(false, acc.Id, con.Id, crmUser.Id, 'Domestic Enquiry', opsUser.Id, invoiceUser.Id);
        insert enq;
        Job_Process__c job = TestDataFactory.createStorageJobProcess(false,acc.Id, enq.Id, opsUser.Id);
        insert job;
        
        LongTermScheduled testsch = new LongTermScheduled();        
        String sch = '0 0 23 * * ?'; 
        system.schedule('TestLongTermScheduledClass', sch, testsch); 
        Test.stopTest(); 
    
}

}