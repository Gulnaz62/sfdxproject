public with sharing class ArticleController {
    
    public ArticleController(){

    }
    
    public class articleWrapper{
        @AuraEnabled
        public Id Id;
        @AuraEnabled
        public Id enqId;
        @AuraEnabled
        public String itemName;
        @AuraEnabled
        public Integer cft;
        @AuraEnabled
        public Integer quantity;
        @AuraEnabled
        public Integer totalQuantity;
        @AuraEnabled
        public Integer unitVolume;
        @AuraEnabled
        public Integer totalCft;
        @AuraEnabled
        public Decimal insuranceValue;
        @AuraEnabled
        public Decimal totalInsuranceValue;
    } 

    @AuraEnabled(cacheable=true)
    public static List<articleWrapper> getArticleList(Id recordId, string type){
        List<articleWrapper> artWrapList = new List<articleWrapper>();
        List<Article__c> itemList = [Select Id, Item_Name__c, Quantity__c,CFT__c,Unit_Volume__c, Insurance_Value__c, Enquiry_Id__r.Total_Quantity__c, Enquiry_Id__r.Total_CFT__c, Enquiry_Id__r.Total_Insurance__c from Article__c where Enquiry_Id__c =: recordId];
        
        if(itemList.size() > 0){
            
            for(Article__c article: itemList){
                articleWrapper artWarp  = new articleWrapper();
                artWarp.itemName = article.Item_Name__c;
                artWarp.Id = article.Id;
                artWarp.quantity = (Integer)article.Quantity__c;
                artWarp.unitVolume = (Integer)article.Unit_Volume__c;
                artWarp.cft = (Integer)article.CFT__c;
                artWarp.insuranceValue = article.Insurance_Value__c;
                artWarp.enqId = recordId;
                artWarp.totalCft = (Integer)article.Enquiry_Id__r.Total_CFT__c;
                artWarp.totalQuantity = (Integer)article.Enquiry_Id__r.Total_Quantity__c;
                artWarp.totalInsuranceValue = article.Enquiry_Id__r.Total_Insurance__c;
                artWrapList.add(artWarp);
            }

        } else{
            List<Article_Record__mdt> articleList = [Select Id, Item_Name__c,Unit_Volume__c from Article_Record__mdt where Enquiry_Type__c =:type];
            for(Article_Record__mdt art: articleList){
            	articleWrapper artWarp  = new articleWrapper();
                artWarp.itemName = art.Item_Name__c;
                artWarp.unitVolume = (Integer)art.Unit_Volume__c;
                artWarp.quantity = 0;
                artWarp.cft = 0;
                artWarp.insuranceValue = 0;
                artWarp.enqId = recordId;
                artWrapList.add(artWarp);
           	}
        }
        return artWrapList;
    }

    @AuraEnabled(cacheable=true)
    public static Boolean canUserEdit() {
        List<Id> allowedProfileIds = new List<Id>();
        Id profileId = UserInfo.getProfileId();
        List<Profile> allowedProfile = [SELECT Id FROM Profile WHERE Name IN ('CRM','Grace Admin','System Administrator','CRM/CSD/OPS')];
        for(Profile p: allowedProfile){
            allowedProfileIds.add(p.Id);
        }
        return allowedProfileIds.contains(profileId);
    }

    @AuraEnabled
    public static Boolean saveAction(Article__c objArt){
        Boolean flag = false;
        try{
            if(canUserEdit()){
                insert objArt;
                flag = true;
            }
            
        }
        catch(Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
        return flag;
    }

    @AuraEnabled
    public static Boolean deleteArticle(Article__c objItem){
        Boolean flag = false;
        try {
            if(canUserEdit()){
                delete objItem;
                flag = true;
            }
            
        }
        catch(Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
        return flag;
    }
    
    @AuraEnabled
    public static string upsertArticle(String jsonresponse){
        
        List<articleWrapper> artWrapList = (List<articleWrapper>)JSON.deserialize(jsonresponse, List<articleWrapper>.class);
        
        List<Article__c> lstarticle = new List<Article__c>();
        
        for(articleWrapper artWrap : artWrapList){
            Article__c article = new Article__c();
            if(artWrap.Id == null){
                article.Item_Name__c = artWrap.itemName;
                article.Id = artWrap.Id;
                article.Enquiry_Id__c = artWrap.enqId;
                if(artWrap.quantity!=null){
                    article.Quantity__c = (Integer)artWrap.quantity;
                }
                if(artWrap.unitVolume!=null){
                    article.Unit_Volume__c = (Integer)artWrap.unitVolume;
                }
                if(artWrap.insuranceValue!=null){
                    article.Insurance_Value__c = artWrap.insuranceValue;
            }
            }
            else{
                article.Id = artWrap.Id;
                if(artWrap.itemName!=null){
                    article.Item_Name__c = artWrap.itemName;
                }
                if(artWrap.quantity!=null){
                    article.Quantity__c = (Integer)artWrap.quantity;
                }
                if(artWrap.unitVolume!=null){
                    article.Unit_Volume__c = (Integer)artWrap.unitVolume;
                }
                if(artWrap.insuranceValue!=null){
                    article.Insurance_Value__c = artWrap.insuranceValue;
            }
            }           
            lstarticle.add(article);
        }
        upsert lstarticle Id;
		return null;
    }
   
}