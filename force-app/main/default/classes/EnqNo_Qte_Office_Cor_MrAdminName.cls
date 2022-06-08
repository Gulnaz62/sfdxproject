public class EnqNo_Qte_Office_Cor_MrAdminName {
	public Account account {get;set;}
    public Quote__c qte {get;set;}
    public Decimal TotCost {get; set;}
    public Decimal GTotCost {get; set;}
    public Decimal GSTVal {get; set;}
	public Decimal AddCharges {get; set;}
    public Decimal LbrCharges {get; set;}
    public Decimal InsCov {get; set;}
    public  String Salutation {get;set;}
    public  String nameSal {get;set;}
    
    Public boolean valueExsist {get;set;}
    public EnqNo_Qte_Office_Cor_MrAdminName(ApexPages.StandardController stdController) {   		   
        TotCost = 0;
        GSTVal = 0;
        GTotCost=0;
		AddCharges = 0; 
        LbrCharges = 0;
        InsCov = 0;
        Salutation='';
        nameSal='';
       	qte=[Select Enquiry_Id__c,
            Enquiry_Id__r.Preferred_Date_of_Delivery__c, 
            Enquiry_Id__r.Origin_City__c,Enquiry_Id__r.Name,Enquiry_Id__r.Primary_Contact__r.Name,
            Enquiry_Id__r.Destination_City__c,
            Enquiry_Id__r.Destination_Address_Line_1__c,
            Enquiry_Id__r.Company_Name__r.Name,
            Enquiry_Id__r.Destination_Address_Line_2__c,
            Enquiry_Id__r.Destination_State__c,Enquiry_Id__r.Primary_Contact__r.Salutation,
            Enquiry_Id__r.Destination_Postal_Code__c,
            Enquiry_Id__r.Origin_Address_Line_1__c,
            Enquiry_Id__r.Origin_Address_Line_2__c,
            Enquiry_Id__r.User_Name__r.Name,Enquiry_Id__r.Mode__c,Enquiry_Id__r.Estimated_Insurance_Value__c,
            GST__c,Total_Cost__c,Labour_Charges__c,Insurance_Premium_Percentage__c,Additional_Charge__c,Enquiry_Id__r.Quote_Description__c, Margin__c
      		from Quote__c where id=:ApexPages.currentPage().getParameters().get('id')];
		
        if(qte.Enquiry_Id__r.Primary_Contact__r.Salutation.Contains('Ms.') ||qte.Enquiry_Id__r.Primary_Contact__r.Salutation.Contains('Mrs.') ){
            System.debug('++++++++++'+qte.Enquiry_Id__r.Primary_Contact__r.Salutation);
            Salutation='Mam';
            nameSal='Ms.';
        }
        if(qte.Enquiry_Id__r.Primary_Contact__r.Salutation.Contains('Mr.')){
            System.debug('++++++++++'+qte.Enquiry_Id__r.Primary_Contact__r.Salutation);
            Salutation='Sir';
            nameSal='Mr.';
        }
        Decimal Margin = 0;
        if(qte.Margin__c != null){
            Margin =qte.Margin__c;
        }
        if(qte.Total_Cost__c != null){
            TotCost =qte.Total_Cost__c;
        }
        TotCost += Margin;
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
        if(qte.Additional_Charge__c != null){
            AddCharges =qte.Additional_Charge__c;
        }
        if(qte.Labour_Charges__c != null){
            LbrCharges =qte.Labour_Charges__c;
        }
        if(qte.Insurance_Premium_Percentage__c > 0){
            InsCov = qte.Insurance_Premium_Percentage__c * (qte.Enquiry_Id__r.Estimated_Insurance_Value__c / 100) ;
            
        }       
        GTotCost = TotCost + GSTVal + InsCov + LbrCharges + AddCharges;    
  }
}