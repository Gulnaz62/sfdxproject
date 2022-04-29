public with sharing class practiseHtml {
    public Quote__c qte {get;set;}
    

    public practiseHtml(ApexPages.StandardController stdController) {
      system.debug(ApexPages.currentPage().getParameters().get('id'));   
      
       qte=[Select Enquiry_Id__c,Enquiry_Id__r.Primary_Contact__c, Enquiry_Id__r.Origin_City__c, Enquiry_Id__r.Destination_City__c 
      from Quote__c where id=:ApexPages.currentPage().getParameters().get('id')];

 
      
  }
  
}