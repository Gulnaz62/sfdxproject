public with sharing class EnqNo_Qte_HHGCAR_Cor_MrUserName {
    public Quote__c qte {get;set;}
    public Survey_Sheet_Data__mdt bankacc {get;set;}
    public Decimal TotCost {get; set;}
    public Decimal totCostForCar {get; set;}
    public Decimal GTotCost {get; set;}
    public Decimal GSTVal {get; set;}
    public Decimal LbrCharges {get; set;}
    public Decimal InsCov {get; set;}
    public Decimal carInsCov {get; set;}
    public Decimal HandyManCharges {get; set;}
    public Decimal additionalCharges {get; set;}
    public  String Salutation {get;set;}
    public  String nameSal {get;set;}
    Public boolean valueExistForCar {get;set;}
    Public boolean valueExist {get;set;}
    
    public EnqNo_Qte_HHGCAR_Cor_MrUserName(ApexPages.StandardController stdController) {        
        TotCost = 0;
        totCostForCar = 0;
        GSTVal = 0;
        GTotCost=0;    
        LbrCharges = 0;
        additionalCharges = 0;
        InsCov = 0;
        carInsCov = 0;
        HandyManCharges=0;
        Salutation='';
        nameSal='';
        qte=[Select Enquiry_Id__c, Enquiry_Id__r.ENQ_ID__c,
             Enquiry_Id__r.Preferred_Date_of_Delivery__c, 
             Enquiry_Id__r.Origin_City__c,Enquiry_Id__r.Name,Enquiry_Id__r.Primary_Contact__r.Name,
             Enquiry_Id__r.Destination_City__c,Enquiry_Id__r.Primary_Contact__r.Salutation,
             Enquiry_Id__r.Destination_Address_Line_1__c, Enquiry_Id__r.Handyman_Services__c,
             Enquiry_Id__r.Company_Name__r.Name, Enquiry_Id__r.KAM__r.FirstName, Enquiry_Id__r.KAM__r.LastName,
             Enquiry_Id__r.Destination_Address_Line_2__c, Enquiry_Id__r.User_Name__r.MailingCity,
             Enquiry_Id__r.User_Name__r.MailingCountry, Enquiry_Id__r.User_Name__r.MailingPostalCode,
             Enquiry_Id__r.User_Name__r.MailingStreet, Enquiry_Id__r.User_Name__r.MailingState,
             Enquiry_Id__r.Destination_State__c,Enquiry_Id__r.Estimated_Insurance_Value__c, Enquiry_Id__r.Car_Details__c,
             Enquiry_Id__r.Destination_Postal_Code__c, Enquiry_Id__r.Value_Of_Car__c, Enquiry_Id__r.Transit_Time__c,
             Enquiry_Id__r.User_Name__r.Name,Enquiry_Id__r.Mode__c, Enquiry_Id__r.Estimated_Door_to_Door_Transit_Time__c,
             GST__c,Total_Cost__c, Additional_Charges__c, Labour_Charges__c,Insurance_Premium_Percentage__c,Car_Cost__c, Insurance_Premium_Percentage_for_Car__c,
             Handyman_Service_Charges__c,Enquiry_Id__r.Scope_of_Service__c, Margin__c, Margin_for_Car__c
             from Quote__c where id=:ApexPages.currentPage().getParameters().get('id')];
        
        if(qte.Enquiry_Id__r.Primary_Contact__r.Salutation.Contains('Ms.') ||qte.Enquiry_Id__r.Primary_Contact__r.Salutation.Contains('Mrs.') ){
            Salutation='Ma'+'\''+'am';
            nameSal='Ms.';
        }
        if(qte.Enquiry_Id__r.Primary_Contact__r.Salutation.Contains('Mr.')){
            Salutation='Sir';
            nameSal='Mr.';
        }
        
        bankacc=[Select Account_No__c,
                 AC_Type__c,              
                 Bank_Address__c,
                 Bank_Name__c,
                 IFSC__c,
                 MICR_No__c
                 from Survey_Sheet_Data__mdt where  DeveloperName='Bank_Details'];
        Decimal Margin = 0;
        if(qte.Margin__c != null){
            Margin =qte.Margin__c;
        }
        if(qte.Total_Cost__c != null){
            TotCost =qte.Total_Cost__c;
        }
        TotCost += Margin;
        
        Decimal marginForCar = 0; 
        if(qte.Margin_for_Car__c != null){
            marginForCar =qte.Margin_for_Car__c;
        }
        if(qte.Car_Cost__c != null){
            totCostForCar =qte.Car_Cost__c;
        }
        totCostForCar += marginForCar;
        
        if(qte.Insurance_Premium_Percentage__c > 0 && qte.Enquiry_Id__r.Estimated_Insurance_Value__c!=null){
            InsCov = qte.Insurance_Premium_Percentage__c * (qte.Enquiry_Id__r.Estimated_Insurance_Value__c / 100) ;
            
        }   
        
        if(qte.Insurance_Premium_Percentage_for_Car__c > 0 && qte.Enquiry_Id__r.Value_Of_Car__c!=null){
            carInsCov = qte.Insurance_Premium_Percentage_for_Car__c * (qte.Enquiry_Id__r.Value_Of_Car__c / 100) ;
            
        } 
        
        if(qte.Handyman_Service_Charges__c != null){
            HandyManCharges =qte.Handyman_Service_Charges__c;
        } 
        
        if(qte.Labour_Charges__c != null){
            LbrCharges =qte.Labour_Charges__c;
        }
        
        if(qte.Additional_Charges__c != null){
            additionalCharges =qte.Additional_Charges__c;
        }
        
        if(qte.GST__c != null && qte.GST__c=='18%'){
            
            GSTVal=(18*(TotCost+totCostForCar+InsCov+carInsCov+HandyManCharges+additionalCharges)/100);
            
        } 
        if(qte.GST__c != null && qte.GST__c=='5%'){
            
            GSTVal=(5*(TotCost+totCostForCar+InsCov+carInsCov+HandyManCharges+additionalCharges)/100);
        } 
        if(qte.GST__c != null && qte.GST__c=='12%'){
            
            GSTVal=(12*(TotCost+totCostForCar+InsCov+carInsCov+HandyManCharges+additionalCharges)/100);
        } 
        if(qte.GST__c != null && qte.GST__c=='0%'){
            
            GSTVal=(0*(TotCost+totCostForCar+InsCov+carInsCov+HandyManCharges+additionalCharges)/100);
        } 
        
        
        if(qte.Enquiry_Id__r.Estimated_Insurance_Value__c==Null){
            valueExist=true;
            System.debug(valueExist);
        }
        
        if(qte.Enquiry_Id__r.Value_Of_Car__c==Null){
            valueExistForCar=true;
            System.debug(valueExistForCar);
        }
        
        
        GTotCost = TotCost + totCostForCar + GSTVal + InsCov + carInsCov+ LbrCharges + HandyManCharges + additionalCharges ; 
        
        
    }
    
}