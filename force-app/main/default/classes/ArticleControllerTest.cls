@isTest
public class ArticleControllerTest {
    @isTest    
    static void method1(){ 
        User crmUser = TestDataFactory.createUser(false,'CRM',30);
        insert crmUser;
        User newCrmUser = TestDataFactory.createUser(false,'CRM',11);
        insert newCrmUser;
        User invoiceUser = TestDataFactory.createUser(false,'CRM',31);
        insert invoiceUser;
        User opsUser = TestDataFactory.createUser(false,'Operation',32);
        insert opsUser;
        Account acc = TestDataFactory.createRegisteredAccount(false,'RSI Limited', crmUser.Id);
        insert acc;
        Contact con = TestDataFactory.createContact(false, 'Gaurav','Kumar',acc.Id);
        insert con;
        Enquiry__c enq = TestDataFactory.createEnquiry(false, acc.Id, con.Id, crmUser.Id, 'Domestic Enquiry');
        insert enq;
		Article__c art = TestDataFactory.createArticle(false,enq.id,'Table',10,10,2000);
        insert art;        
                
        Account a = [Select CRM_User__c, Name from Account where Id =: acc.Id];
        a.CRM_User__c = newCrmUser.Id;
        update a;
        
        ArticleController.getArticleList(art.Enquiry_Id__c, enq.Enquiry_Type__c);
        Article__c newArt = TestDataFactory.createArticle(false,enq.id,'Chair',20,10,2000);
        ArticleController.saveAction(newArt);
        
        List<articleWrapper> artWrapList = new List<articleWrapper>();
        List<Article__c>articles =  new List<Article__c>();
        articles.add(art);
        for(Article__c article : articles){
            articleWrapper artWarp  = new articleWrapper();
            artWarp.itemName = article.Item_Name__c;
            artWarp.Id = article.Id;
            artWarp.quantity = (Integer)article.Quantity__c;
            artWarp.unitVolume = (Integer)article.Unit_Volume__c;
            artWarp.insuranceValue = article.Insurance_Value__c;
            artWarp.enqId = article.Enquiry_Id__c;
            artWrapList.add(artWarp);
        }
        String jsonResponse = JSON.serialize(artWrapList);
        ArticleController.upsertArticle(jsonResponse);
    }  
    
    @isTest
    static void method2(){ 
        Account acc = TestDataFactory.createAccount(false,'RSI Limited');
        insert acc;
        Contact con = TestDataFactory.createContact(false, 'Gaurav','Kumar',acc.Id);
        insert con;
        User crmUser = TestDataFactory.createUser(false,'CRM',34);
        insert crmUser;
        User invoiceUser = TestDataFactory.createUser(false,'CRM',35);
        insert invoiceUser;
        User opsUser = TestDataFactory.createUser(false,'Operation',36);
        insert opsUser;
        Enquiry__c enq = TestDataFactory.createEnquiry(false, acc.Id, con.Id, crmUser.Id, 'Domestic Enquiry');
        insert enq;
        Article__c art = TestDataFactory.createArticle(false,enq.id,'Table',10,10,2000);
        insert art; 
        ArticleController.getArticleList(art.id,enq.Enquiry_Type__c);
        ArticleController.deleteArticle(art);
        
    }
    
    @isTest
    static void manageUpsertArticle(){
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
        List<articleWrapper> artWrapList = new List<articleWrapper>();
        articleWrapper artWarp  = new articleWrapper();
        artWarp.enqId = enq.Id;
        artWarp.itemName = 'Table';
        artWarp.quantity =20;
        artWarp.unitVolume = 10;
        artWarp.insuranceValue = 2000;
        artWrapList.add(artWarp);
        String jsonResponse = JSON.serialize(artWrapList);
        ArticleController.upsertArticle(jsonResponse);  
        
    }
    public class articleWrapper{
        @AuraEnabled
        public Id Id;
        @AuraEnabled
        public Id enqId;
        @AuraEnabled
        public String itemName;
        @AuraEnabled
        public Integer quantity;
        @AuraEnabled
        public Integer unitVolume;
        @AuraEnabled
        public Decimal insuranceValue;
    }
    
}