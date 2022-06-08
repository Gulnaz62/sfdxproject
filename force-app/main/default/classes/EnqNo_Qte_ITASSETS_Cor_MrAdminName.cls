public class EnqNo_Qte_ITASSETS_Cor_MrAdminName {
 public Quote__c qte {get;set;}
 public  String nameSal {get;set;}
    

    public EnqNo_Qte_ITASSETS_Cor_MrAdminName(ApexPages.StandardController stdController) {
           nameSal='';   
       qte=[Select Enquiry_Id__c,
            Enquiry_Id__r.Preferred_Date_of_Delivery__c, 
            Enquiry_Id__r.Origin_City__c,Enquiry_Id__r.Name,Enquiry_Id__r.Primary_Contact__r.Name,
            Enquiry_Id__r.Destination_City__c,Enquiry_Id__r.Primary_Contact__r.Salutation,
            Enquiry_Id__r.Destination_Address_Line_1__c,
            Enquiry_Id__r.Company_Name__r.Name,
            Enquiry_Id__r.Destination_Address_Line_2__c,
            Enquiry_Id__r.Destination_State__c,
            Enquiry_Id__r.Destination_Postal_Code__c,
            Enquiry_Id__r.User_Name__r.Name,Insurance_Premium_Percentage__c ,Notes__c           
      from Quote__c where id=:ApexPages.currentPage().getParameters().get('id')];
if(qte.Enquiry_Id__r.Primary_Contact__r.Salutation.Contains('Ms.') ||qte.Enquiry_Id__r.Primary_Contact__r.Salutation.Contains('Mrs.') ){
            System.debug('++++++++++'+qte.Enquiry_Id__r.Primary_Contact__r.Salutation);            
            nameSal='Ms.';
        }
        if(qte.Enquiry_Id__r.Primary_Contact__r.Salutation.Contains('Mr.')){
            System.debug('++++++++++'+qte.Enquiry_Id__r.Primary_Contact__r.Salutation);         
            nameSal='Mr.';
        }
 
      
  }
}