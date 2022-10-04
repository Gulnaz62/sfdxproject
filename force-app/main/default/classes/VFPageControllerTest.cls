@isTest
public class VFPageControllerTest {
    @isTest static void testVFPagesQuote(){  
        Account acc = TestDataFactory.createAccount(false,'RSI Limited');
        insert acc;
        Contact con = TestDataFactory.createContact(false, 'Gaurav','Kumar',acc.Id);
        insert con;
        User crmUser = TestDataFactory.createUser(false,'CRM',1);
        insert crmUser;
        User opsUser = TestDataFactory.createUser(false,'Operation',2);
        insert opsUser;
        User invoiceUser = TestDataFactory.createUser(false,'CRM',6);
        insert invoiceUser;
        User csdUser = TestDataFactory.createUser(false,'CSD',20);
        insert csdUser;
        User destOpsUser = TestDataFactory.createUser(false,'Operation',21);
        insert destOpsUser;
        Enquiry__c enq = TestDataFactory.createEnquiry(false, acc.Id, con.Id, crmUser.Id, 'Domestic Enquiry', opsUser.Id, invoiceUser.Id);
        insert enq;
        Quote__c quo = TestDataFactory.createQuote(false, enq.Id);   
        insert quo; 
        Job_Process__c job = TestDataFactory.createJobProcess(false,acc.Id,enq.Id,opsUser.Id, csdUser.Id, crmUser.Id, destOpsUser.Id);
        insert job;      
        
        PageReference testPage = Page.DC_MIgration; 
        Test.setCurrentPage(testPage);
        testPage.getParameters().put('id', String.valueOf(quo.Id));       
        
        ApexPages.StandardController sc = new  ApexPages.StandardController(quo);  
        DC_MIgration dcMigQuoteExt = new DC_MIgration(sc);
        
        EnqNo_Qte_HHG_Cor_MrUserName hhgQuoteExt  = new EnqNo_Qte_HHG_Cor_MrUserName(sc);
        EnqNo_Qte_HHGCAR_Cor_MrUserName hhgCarQuoteExt = new EnqNo_Qte_HHGCAR_Cor_MrUserName(sc);
        EnqNo_Qte_CAR_MrUserName carQuoteExt = new EnqNo_Qte_CAR_MrUserName(sc);
        QuoteIT_Assetmovement itAssetQuoteExt = new QuoteIT_Assetmovement(sc);
        Qte_Office_Corporate_Branch_Scrap scrapMovementQuoteExt =  new Qte_Office_Corporate_Branch_Scrap(sc);
        
        List<Quote__c> qteList = [Select Enquiry_Id__c,Enquiry_Id__r.Primary_Contact__c,Enquiry_Id__r.Primary_Contact__r.Name, Enquiry_Id__r.KAM__r.Name, 
                                  Enquiry_Id__r.Primary_Contact__r.Salutation,  
                                  Enquiry_Id__r.Origin_City__c, Enquiry_Id__r.Destination_City__c,
                                  GST__c,Total_Cost__c,Insurance_Premium_Percentage__c,Margin__c 
                                  from Quote__c where id=:quo.Id];
        System.assertEquals(1, qteList.size());
    }
    @isTest static void testRelocation_HouseHoldGoods_CSD(){  
        Account acc = TestDataFactory.createAccount(false,'RSI Limited');
        insert acc;
        Contact con = TestDataFactory.createContact(false, 'Gaurav','Kumar',acc.Id);
        insert con; 
        User crmUser = TestDataFactory.createUser(false,'CRM',4);
        insert crmUser;
        User invoiceUser = TestDataFactory.createUser(false,'CRM',5);
        insert invoiceUser;
        User opsUser = TestDataFactory.createUser(false,'Operation',3);
        insert opsUser;
        User csdUser = TestDataFactory.createUser(false,'CSD',22);
        insert csdUser;
        User destOpsUser = TestDataFactory.createUser(false,'Operation',23);
        insert destOpsUser;
        Enquiry__c enq = TestDataFactory.createEnquiry(false, acc.Id, con.Id, crmUser.Id, 'Domestic Enquiry', opsUser.Id, invoiceUser.Id);
        insert enq;
        Quote__c quo = TestDataFactory.createQuote(false, enq.Id);   
        insert quo;
        Job_Process__c job = TestDataFactory.createJobProcess(false,acc.Id,enq.Id,opsUser.Id, csdUser.Id,  crmUser.Id, destOpsUser.Id);
        insert job;
        
        PageReference testPage = Page.Relocation_HouseHoldGoods_CSD; 
        Test.setCurrentPage(testPage);
        testPage.getParameters().put('id', String.valueOf(job.Id));
        
        ApexPages.StandardController sc = new  ApexPages.StandardController(job); 
        Relocation_HouseHoldGoods_CSD relocationHouseHolds = new Relocation_HouseHoldGoods_CSD(sc); 
        
    } 
}