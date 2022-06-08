public with sharing class Costing_Format {
    public Enquiry__c enq {get;set;}
    

    public Costing_Format(ApexPages.StandardController stdController) {
      system.debug(ApexPages.currentPage().getParameters().get('id'));   
      
       enq=[Select Name, Costing_Amount__c,          
            Preferred_Date_of_Packing__c,           
            Origin_City__c,            
             Destination_City__c,                  
        (select Particulars__c,Amount__c,Quantity__c, Volume__c,Rate__c,Other_Costing__c from Costing__r),
         (select Name,Gross_Packed_Volume__c,Clearance_Date__c from Job_Processes__r)   
      from Enquiry__c where id=:ApexPages.currentPage().getParameters().get('id')];

 
      
  }
}
