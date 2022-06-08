public with sharing class SurveySheetNew {
    public Enquiry__c enq {get;set;}
    public Boolean isArtPresent {get;set; }
    public Boolean isOthArtPresent {get;set; }
    public Boolean isAnyArtPresent {get;set; }
    public integer artCnt {get;set; }
    public integer othArtCnt {get;set; }
    public Decimal artTotalInsVal {get;set;}
    public Decimal othArtTotalInsVal {get;set;}
    public Decimal grandTotalInsVal {get;set;}
    public SurveySheetNew(ApexPages.StandardController stdController) {      
      isArtPresent = false;
      isOthArtPresent = false;
      isAnyArtPresent = false;
      artCnt =0;  
      othArtCnt = 0;  
      artTotalInsVal=0;
      othArtTotalInsVal=0;
      grandTotalInsVal =0;
      enq=[Select 
           Preferred_Date_of_Delivery__c, 
           Preferred_Date_of_Packing__c,
           Preferred_Date_of_Moving__c,
           Origin_City__c,
           Origin_Address_Line_1__c,Storage_Required__c,
           Origin_Address_Line_2__c,
           Origin_Postal_Code__c,
           Origin_State__c,
           Is_Lift_Available_at_Origin__c,
           Origin_Floor__c,
           Destination_City__c,
           Destination_Address_Line_1__c,            
           Destination_Address_Line_2__c,
           Destination_State__c,
           Destination_Postal_Code__c,
           Is_Lift_Available_at_Destination__c,
         	Destination_Floor__c,
           Company_Name__r.Name,
           User_Name__r.Name,  
           Primary_Contact__r.Email,
           Primary_Contact__r.Phone,  Name,           
           (select Item_Name__c,Quantity__c, Insurance_Value__c,Other_Article__c from Articles__r) 
           	from Enquiry__c where id=:ApexPages.currentPage().getParameters().get('id')];  
        	for(Article__c art:enq.Articles__r){
            	if(!art.Other_Article__c){
                	artTotalInsVal += art.Insurance_Value__c;   
                    artCnt++;
            	}
                else{
                    othArtTotalInsVal += art.Insurance_Value__c;
                    othArtCnt++;
                }                
        	}
        	grandTotalInsVal = artTotalInsVal + othArtTotalInsVal;
        	if(artCnt>0){
            	isArtPresent = true;
      		}
        	if(othArtCnt>0){
            	isOthArtPresent = true;
        	}
        	if(artCnt>0 || othArtCnt>0){
            	isAnyArtPresent = true;
        	}        	
  }
}