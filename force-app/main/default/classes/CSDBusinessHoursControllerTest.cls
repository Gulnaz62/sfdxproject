@isTest
public class CSDBusinessHoursControllerTest {
    @isTest static void testCSDBusinessHours(){  
        Account acc = TestDataFactory.createAccount(false,'RSI Limited');
        insert acc;
        Contact con = TestDataFactory.createContact(false, 'Gaurav','Kumar',acc.Id);
        insert con;
        User crmUser = TestDataFactory.createUser(false,'CRM',7);
        insert crmUser;
        User invoiceUser = TestDataFactory.createUser(false,'CRM',8);
        insert invoiceUser;
        User opsUser = TestDataFactory.createUser(false,'Operation',9);
        insert opsUser;
        User csdUser = TestDataFactory.createUser(false,'CSD',10);
        insert csdUser;
        User destOpsUser = TestDataFactory.createUser(false,'Operation',11);
        insert destOpsUser;                
        User newOpsUser = TestDataFactory.createUser(false,'Operation',22);
        insert newOpsUser;
        User newCsdUser = TestDataFactory.createUser(false,'CSD',23);
        insert newCsdUser;
        User newDestOpsUser = TestDataFactory.createUser(false,'Operation',24);
        insert newDestOpsUser;
        User newInvoiceUser = TestDataFactory.createUser(false,'CRM',25);
        insert newInvoiceUser;
        Enquiry__c enq = TestDataFactory.createEnquiry(false, acc.Id, con.Id, crmUser.Id, 'Domestic Enquiry', opsUser.Id, invoiceUser.Id);
        insert enq;
        Quote__c quo = TestDataFactory.createQuote(false, enq.Id);   
        insert quo;
       
        Job_Process__c job = TestDataFactory.createJobProcess(false,acc.Id, enq.Id, opsUser.Id, csdUser.Id,crmUser.Id, destOpsUser.Id);
        insert job;
        
        Enquiry__c enqToUpdate = [SELECT OPS_User__c, Invoice_User__c, Survey_Date_Time__c FROM Enquiry__c WHERE Id = :enq.Id];
        Job_Process__c jobToUpdate =[SELECT CSD_User__c, OPS_User__c,OPS_User_for_Destination__c, Transit_Status__c, TAT_DateTime__c,Extra_Charges_Actual__c FROM Job_Process__c WHERE Id = :job.Id];
        
		jobToUpdate.CSD_User__c = newCsdUser.Id;
        jobToUpdate.OPS_User__c = newOpsUser.Id;
        jobToUpdate.OPS_User_for_Destination__c = newDestOpsUser.Id;
        jobToUpdate.Extra_Charges_Actual__c = 30000;
        update jobToUpdate;
        
        enqToUpdate.Survey_Date_Time__c = DateTime.now().addHours(4);
        enqToUpdate.Invoice_User__c = newInvoiceUser.Id;
        update enqToUpdate;
        
        List<String> jobIds = new List<String>();
        jobIds.add(job.Id);
        List<String>enqIds = new List<String>();
        enqIds.add(enqToUpdate.Id);
        CSDBusinessHoursController.setTime(jobIds);
        BusinessHoursController.setTime(enqIds);
        OPSAcknowledgementTATController.setTime(jobIds);
        SurveyAcknowledgementTATController.setSurveyAcknowledgementTime(enqIds);
 }
    
    @isTest static void testUpcomingStageBusinessHours(){
        Account acc = TestDataFactory.createAccount(false,'RSI Ltd');
        insert acc;
        Contact con = TestDataFactory.createContact(false, 'Anuj','Gupta',acc.Id);
        insert con;
        User crmUser = TestDataFactory.createUser(false,'CRM',27);
        insert crmUser;
        User invoiceUser = TestDataFactory.createUser(false,'CRM',28);
        insert invoiceUser;
        User opsUser = TestDataFactory.createUser(false,'Operation',29);
        insert opsUser;
        User csdUser = TestDataFactory.createUser(false,'CSD',30);
        insert csdUser;
        User destOpsUser = TestDataFactory.createUser(false,'Operation',31);
        insert destOpsUser;
        Enquiry__c enq = TestDataFactory.createEnquiry(false, acc.Id, con.Id, crmUser.Id, 'Domestic Enquiry', opsUser.Id, invoiceUser.Id);
        insert enq;
        Job_Process__c job = TestDataFactory.createUpcomingJobProcess(false,acc.Id, enq.Id, opsUser.Id);
        insert job;
        
        List<String> jobIdList = new List<String>();
        jobIdList.add(job.Id);
        CSDBusinessHoursController.setTime(jobIdList);
        
    }
}