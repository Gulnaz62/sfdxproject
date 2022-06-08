public with sharing class Costing_Format {
    public Enquiry__c enq {get;set;}
    public string jobID{get;set;}
    public Decimal totalCost {get;set;}
    public Decimal totalCostOther {get;set;}
    public string volume{get;set;}
    public Boolean isCostZero {get;set; }
    public Boolean isOtherCostZero {get;set; }
    public Costing_Format(ApexPages.StandardController stdController) {
      
        volume='N/A';
        jobID='N/A';
        totalCost = 0;
    	totalCostOther = 0;
        isCostZero=false;
        isOtherCostZero = false;
        enq=[Select Name, Costing_Amount__c,          
             Preferred_Date_of_Packing__c,           
             Origin_City__c,            
             Destination_City__c,                  
             (select Name,Particulars__c,Amount__c,Quantity__c, Volume__c,Rate__c,Other_Costing__c from Costing__r),
             (select Enquiry_Id__c,Name,Gross_Packed_Volume__c,Clearance_Date__c from Job_Processes__r)   
             from Enquiry__c where id=:ApexPages.currentPage().getParameters().get('id')];
        
        for(Costing__c cost:enq.Costing__r){
            if(jobID == 'N/A'){
                jobID=cost.Name;
            }
            if(!cost.Other_Costing__c){
                totalCost += cost.Amount__c;       
            }
        }
        totalCostOther = enq.Costing_Amount__c - totalCost;
        if(totalCostOther==0){
            isOtherCostZero=true;
        }
        if(totalCost==0){
            isCostZero=true;
        }
        for(Job_Process__c process:enq.Job_Processes__r){
            volume=string.valueOf(process.Gross_Packed_Volume__c);
            break;
        }        
    }
}