@isTest
public class PDFHandlerControllerTest {
    @isTest static void testPDFHandlerController(){  
        Account acc = TestDataFactory.createAccount(false,'RSI Limited');
        insert acc;
        Contact con = TestDataFactory.createContact(false, 'Gaurav','Kumar',acc.Id);
        insert con;
        User crmUser = TestDataFactory.createUser(false,'CRM',37);
        insert crmUser;
        User invoiceUser = TestDataFactory.createUser(false,'CRM',38);
        insert invoiceUser;
        User opsUser = TestDataFactory.createUser(false,'Operation',39);
        insert opsUser;
        Enquiry__c enq = TestDataFactory.createEnquiry(false, acc.Id, con.Id, crmUser.Id, 'Domestic Enquiry', opsUser.Id, invoiceUser.Id);
        insert enq;
        Quote__c quo = TestDataFactory.createQuote(false, enq.Id);   
        insert quo;       
      
        PageReference testPage = Page.PDFHandler; 
        Test.setCurrentPage(testPage);
        testPage.getParameters().put('id', String.valueOf(quo.Id));
        
        ApexPages.StandardController sc = new  ApexPages.StandardController(quo);  
        PDFHandlerController pdfHandler = new PDFHandlerController(sc);
    }
}