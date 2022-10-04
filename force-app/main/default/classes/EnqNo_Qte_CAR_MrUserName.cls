public with sharing class EnqNo_Qte_CAR_MrUserName {
    public Quote__c qte {get;set;}
    public Survey_Sheet_Data__mdt bankacc {get;set;}
    public Decimal TotCost {get; set;}
    public Decimal GTotCost {get; set;}
    public Decimal GSTVal {get; set;}
    public Decimal LbrCharges {get; set;}
    public Decimal additionalCharges {get; set;}
    public Decimal InsCov {get; set;}
    public  String Salutation {get;set;}
    public  String nameSal {get;set;}
    
    Public boolean valueExsist {get;set;}
    
    public EnqNo_Qte_CAR_MrUserName(ApexPages.StandardController stdController) {    
        TotCost = 0;
        GSTVal = 0;
        GTotCost=0;
        GTotCost=0;     
        LbrCharges = 0;
        additionalCharges = 0;
        InsCov = 0;
        Salutation='';
        nameSal='';
        qte=[Select Enquiry_Id__c,
             Enquiry_Id__r.Name, Enquiry_Id__r.ENQ_ID__c, 
             Enquiry_Id__r.Preferred_Date_of_Delivery__c,Enquiry_Id__r.Primary_Contact__r.Name,
             Enquiry_Id__r.Origin_City__c,
             Enquiry_Id__r.Destination_City__c,Enquiry_Id__r.Primary_Contact__r.Salutation,
             Enquiry_Id__r.Destination_Address_Line_1__c, Enquiry_Id__r.User_Name__r.MailingCity,
             Enquiry_Id__r.User_Name__r.MailingCountry, Enquiry_Id__r.User_Name__r.MailingPostalCode,
             Enquiry_Id__r.User_Name__r.MailingStreet, Enquiry_Id__r.User_Name__r.MailingState,
             Enquiry_Id__r.Company_Name__r.Name, Enquiry_Id__r.KAM__r.Name,
             Enquiry_Id__r.Destination_Address_Line_2__c,
             Enquiry_Id__r.Destination_State__c, Enquiry_Id__r.Transit_Time__c,
             Enquiry_Id__r.Destination_Postal_Code__c,Enquiry_Id__r.Estimated_Insurance_Value__c, Enquiry_Id__r.Value_Of_Car__c, Margin_for_Car__c,Car_Cost__c,
             Enquiry_Id__r.User_Name__r.Name,  Enquiry_Id__r.Mode__c, Enquiry_Id__r.Estimated_Door_to_Door_Transit_Time__c,  Insurance_Premium_Percentage_for_Car__c,     
             GST__c,Total_Cost__c,Additional_Charges__c, Labour_Charges__c,Insurance_Premium_Percentage__c, Enquiry_Id__r.Scope_of_Service__c, Margin__c
             from Quote__c where id=:ApexPages.currentPage().getParameters().get('id')];
        
        bankacc=[Select Account_No__c,
                 AC_Type__c,              
                 Bank_Address__c,
                 Bank_Name__c,
                 IFSC__c,
                 MICR_No__c
                 from Survey_Sheet_Data__mdt where  DeveloperName='Bank_Details'];   
        
        if(qte.Enquiry_Id__r.Primary_Contact__r.Salutation.Contains('Ms.') ||qte.Enquiry_Id__r.Primary_Contact__r.Salutation.Contains('Mrs.') ){
            
            Salutation='Mam';
            nameSal='Ms.';
        }
        if(qte.Enquiry_Id__r.Primary_Contact__r.Salutation.Contains('Mr.')){
            Salutation='Sir';
            nameSal='Mr.';
        }
        
        Decimal Margin = 0;
        if(qte.Margin_for_Car__c != null){
            Margin =qte.Margin_for_Car__c;
        }
        if(qte.Car_Cost__c != null){
            TotCost =qte.Car_Cost__c;
        }
        TotCost += Margin;
        
        
        if( qte.Insurance_Premium_Percentage_for_Car__c >0 && qte.Enquiry_Id__r.Value_Of_Car__c!=null){
            
            InsCov = qte.Insurance_Premium_Percentage_for_Car__c * (qte.Enquiry_Id__r.Value_Of_Car__c / 100) ;   
            system.debug(InsCov);
        } 
        if(qte.GST__c != null && qte.GST__c=='18%'){
            
            GSTVal=(18*(TotCost+InsCov)/100);
            
        } 
        if(qte.GST__c != null && qte.GST__c=='5%'){
            
            GSTVal=(5*(TotCost+InsCov)/100);
        } 
        if(qte.GST__c != null && qte.GST__c=='12%'){
            
            GSTVal=(12*(TotCost+InsCov)/100);
        } 
        if(qte.GST__c != null && qte.GST__c=='0%'){
            
            GSTVal=(0*(TotCost+InsCov)/100);
        } 
        
        
        if(qte.Enquiry_Id__r.Value_Of_Car__c==Null){
            valueExsist=true;
            System.debug(valueExsist);
        }
        
        
        GTotCost = TotCost + GSTVal + InsCov ; 
    }
}