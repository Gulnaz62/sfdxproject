public with sharing class BankAccount {
public Survey_Sheet_Data__mdt bankacc {get;set;}
		public BankAccount(ApexPages.StandardController stdController) {
        system.debug(ApexPages.currentPage().getParameters().get('id'));   
      
        bankacc=[Select Account_No__c,
        		AC_Type__c,              
             	Bank_Address__c,
             	Bank_Name__c,
             	IFSC__c,
             	MICR_No__c
       			from Survey_Sheet_Data__mdt where DeveloperName='Bank_Details'];
       
       //id='0010p000014ffnk'];
       
    }
}