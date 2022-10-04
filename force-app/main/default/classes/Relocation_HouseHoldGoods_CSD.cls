public class Relocation_HouseHoldGoods_CSD {
    public Job_Process__c qte {get;set;}    
    public  String Salutation {get;set;}
    public  String nameSal {get;set;}
    
    public Relocation_HouseHoldGoods_CSD(ApexPages.StandardController stdController) {        
        Salutation='';
        nameSal='';
        qte=[Select Enquiry_Id__c, Enquiry_Id__r.ENQ_ID__c,
             Enquiry_Id__r.Preferred_Date_of_Packing__c, 
             Enquiry_Id__r.Preferred_Date_of_Moving__c,
             Enquiry_Id__r.Preferred_Date_of_Delivery__c,
             Enquiry_Id__r.Origin_City__c,Enquiry_Id__r.Name,Enquiry_Id__r.Primary_Contact__r.Name,
             Enquiry_Id__r.Destination_City__c,Enquiry_Id__r.Primary_Contact__r.Salutation,             
             Enquiry_Id__r.Company_Name__r.Name,             
             Enquiry_Id__r.User_Name__r.Name,
             CSD_User__r.Name
             from Job_Process__c where id=:ApexPages.currentPage().getParameters().get('id')];
        
        if(qte.Enquiry_Id__r.Primary_Contact__r.Salutation.Contains('Ms.') ||
           qte.Enquiry_Id__r.Primary_Contact__r.Salutation.Contains('Mrs.') ){
               Salutation='Mam';
               nameSal='Ms.';
           }
        if(qte.Enquiry_Id__r.Primary_Contact__r.Salutation.Contains('Mr.')){
            Salutation='Sir';
            nameSal='Mr.';
        }          
    }
}