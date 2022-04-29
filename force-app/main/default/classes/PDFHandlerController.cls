public with sharing class PDFHandlerController {

    public boolean renderpage{get;set;}
    public string Pagename {get;set;}
	string recordid;
    public PDFHandlerController(ApexPages.StandardController stdController) {
        renderpage=false;
        Pagename='Placeholder';
        recordid=ApexPages.currentPage().getParameters().get('id') ;
        if(string.isNotBlank(recordid)){
            RenderPage();
        }
    }

    void RenderPage(){
        list<Quote__c>lstQuote=[SELECT Id, Enquiry_Id__r.Enquiry_type__c FROM Quote__c where id=:recordid];
        if(lstQuote.size()>0){
            string getEnquirytype=lstQuote[0].Enquiry_Id__r.Enquiry_type__c;
            list<PDFPageMapping__mdt> lstpagemapping=[SELECT Id, Pagename__c, SelectOption__c FROM PDFPageMapping__mdt where SelectOption__c =:getEnquirytype];
            if(lstpagemapping.size()>0){
                Pagename=lstpagemapping[0].Pagename__c;
                renderpage=true;
            }
        }
    }
}