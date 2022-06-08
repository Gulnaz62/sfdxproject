public class DC_MIgration {

  public Quote__c qte {get;set;}
  
     
  
  
  
      public DC_MIgration(ApexPages.StandardController stdController) {
  
        system.debug(ApexPages.currentPage().getParameters().get('id'));  
  
       
  
         qte=[Select Enquiry_Id__c,Enquiry_Id__r.Primary_Contact__c,
  
         Enquiry_Id__r.Preferred_Date_of_Delivery__c,Enquiry_Id__r.Name,
  
         Enquiry_Id__r.Origin_City__c, Enquiry_Id__r.Destination_City__c ,
  
         Enquiry_Id__r.User_Name__r.Name,
  
         GST__c,Total_Cost__c,Labour_Charges__c,Insurance_Coverage__c
  
        from Quote__c where id=:ApexPages.currentPage().getParameters().get('id')];
  
      }
  
  }