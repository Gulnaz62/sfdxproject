@isTest
public class CostingControllerTest {
    @isTest 
    static void method1(){ 
        User crmUser = TestDataFactory.createUser(false,'CRM',10);
        insert crmUser;
        User invoiceUser = TestDataFactory.createUser(false,'CRM',11);
        insert invoiceUser;
        User opsUser = TestDataFactory.createUser(false,'Operation',12);
        insert opsUser;
        Account acnt=TestDataFactory.createAccount(false,'TestAcc');
        insert acnt;
        Contact con=TestDataFactory.createContact(false,'Manoj','Yadav',acnt.id);
        insert con;  
        Enquiry__c enq  = TestDataFactory.createEnquiry(false,acnt.id,con.id,crmUser.Id, 'Domestic Enquiry', opsUser.Id, invoiceUser.Id);
        Insert enq;     
        Quote__c quo = TestDataFactory.createQuote(false, enq.Id);   
        insert quo;       
        Article__c art = TestDataFactory.createArticle(false,enq.id,'Table',10,10,2000);
        insert art;  
        Costing__c cost = TestDataFactory.createCosting(false,enq.id,'Car Cost',3,20000);
        insert cost;  
        
        CostingController.getCostingList(cost.Enquiry_Id__c,enq.Enquiry_Type__c);
        Costing__c newCost = TestDataFactory.createCosting(false,enq.id,'Crating Cost',4,2000);
        CostingController.saveCostAction(newCost); 
        
        List<costingWrapper> costWrapList = new List<costingWrapper>();    
        List<Costing__c>costs =  new List<Costing__c>();
        costs.add(cost);
        for(Costing__c costing : costs){
            costingWrapper costWarp  = new costingWrapper();
            costWarp.costType = cost.Particulars__c;
            costWarp.Id = cost.Id;               
            costWarp.enqId = cost.Enquiry_Id__c;
            costWarp.rate = cost.Rate__c;
            costWarp.volume = cost.Volume__c; 
            costWarp.actualCost = cost.Actual_Cost__c;
            costWrapList.add(costWarp); 
        }
        String jsonResponse = JSON.serialize(costWrapList);
        CostingController.upsertCosting(jsonResponse);       
    }  
    
    @isTest
    static void method2(){ 
        Account acc = TestDataFactory.createAccount(false,'RSI Limited');
        insert acc;
        Contact con = TestDataFactory.createContact(false, 'Mahoj','Yadav',acc.Id);
        insert con;
        User crmUser = TestDataFactory.createUser(false,'CRM',13);
        insert crmUser;
        User invoiceUser = TestDataFactory.createUser(false,'CRM',14);
        insert invoiceUser;
        User opsUser = TestDataFactory.createUser(false,'Operation',15);
        insert opsUser;
        Enquiry__c enq = TestDataFactory.createEnquiry(false, acc.Id, con.Id,crmUser.Id, 'Domestic Enquiry', opsUser.Id, invoiceUser.Id);
        insert enq;
        Quote__c quo = TestDataFactory.createQuote(false, enq.Id);   
        insert quo;
        Article__c art = TestDataFactory.createArticle(false,enq.id,'Table',10,10,2000);
        insert art; 
        Costing__c cost = TestDataFactory.createCosting(false,enq.id,'Door to Door',3,20000);        
        insert cost; 
        List<Costing__c>costs =  new List<Costing__c>();
        costs.add(cost);
        CostingController.getCostingList(art.id,enq.Enquiry_Type__c);
        CostingController.deleteCost(cost);             
    }
    
    @isTest
    static void manageUpsertCost(){
        Account acc = TestDataFactory.createAccount(false,'RSI Limited');
        insert acc;
        Contact con = TestDataFactory.createContact(false, 'Gaurav','Kumar',acc.Id);
        insert con;
        User crmUser = TestDataFactory.createUser(false,'CRM',16);
        insert crmUser;
        User invoiceUser = TestDataFactory.createUser(false,'CRM',17);
        insert invoiceUser;
        User opsUser = TestDataFactory.createUser(false,'Operation',18);
        insert opsUser;
        Enquiry__c enq = TestDataFactory.createEnquiry(false, acc.Id, con.Id,crmUser.Id, 'Domestic Enquiry', opsUser.Id, invoiceUser.Id);
        insert enq;
        List<costingWrapper> costWrapList = new List<costingWrapper>();
        costingWrapper costWarp  = new costingWrapper();        
        costWarp.costType = 'Car Cost';
        costWarp.enqId = enq.Id;
        costWarp.rate = 5; 
        costWarp.volume = 80; 
        costWrapList.add(costWarp);
        String jsonResponse = JSON.serialize(costWrapList);
        CostingController.upsertCosting(jsonResponse);  
        
    }       
    
    public class costingWrapper{
        @AuraEnabled
        public Id Id;
        @AuraEnabled
        public Id enqId;          
        @AuraEnabled
        public String costType;
        @AuraEnabled
        public decimal rate;
        @AuraEnabled
        public decimal volume;
        @AuraEnabled
        public decimal actualCost;
    }
    
}