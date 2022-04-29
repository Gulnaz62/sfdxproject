public with sharing class EnqNo_Qte_HHGCAR_Cor_MrUserName {
    public Quote__c qte {get;set;}
    

    public EnqNo_Qte_HHGCAR_Cor_MrUserName(ApexPages.StandardController stdController) {
      system.debug(ApexPages.currentPage().getParameters().get('id'));   
      
       qte=[Select Enquiry_Id__c,
            Enquiry_Id__r.Preferred_Date_of_Delivery__c, 
            Enquiry_Id__r.Origin_City__c,
            Enquiry_Id__r.Destination_City__c,
            Enquiry_Id__r.Destination_Address_Line_1__c,
            Enquiry_Id__r.Company_Name__r.Name,
            Enquiry_Id__r.Destination_Address_Line_2__c,
            Enquiry_Id__r.Destination_State__c,
            Enquiry_Id__r.Destination_Postal_Code__c,
            Enquiry_Id__r.User_Name__r.Name
      from Quote__c where id=:ApexPages.currentPage().getParameters().get('id')];

 
      
  }

}