public with sharing class CostingController {
    public CostingController() {

    }

    public class costingWrapper{
        @AuraEnabled
        public Id Id;
        @AuraEnabled
        public Id enqId;
        @AuraEnabled
        public String costType;
        @AuraEnabled
        public Integer quantity;
        @AuraEnabled
        public Integer totalQuant;
        @AuraEnabled
        public Integer volume;
        @AuraEnabled
        public Integer totalVol;
        @AuraEnabled
        public Decimal rate;
        @AuraEnabled
        public Decimal amount;
        @AuraEnabled
        public Decimal totalAmount;
        @AuraEnabled
        public Decimal totalRate;
    } 

    @AuraEnabled(cacheable=true)
    public static List<costingWrapper> getCostingList(Id recordId, string type){
        List<costingWrapper> costWrapList = new List<costingWrapper>();
        List<Costing__c> costList = [Select Id, Particulars__c, Quantity__c, Volume__c, Rate__c, Amount__c, Enquiry_Id__r.Total_Costing_Quantity__c,Enquiry_Id__r.Total_Costing_Volume__c, Enquiry_Id__r.Total_Rate__c, Enquiry_Id__r.Costing_Amount__c from Costing__c where Enquiry_Id__c =: recordId];
        
        if(costList.size() > 0){
            
            for(Costing__c cost: costList){
                costingWrapper costWarp  = new costingWrapper();
                costWarp.costType = cost.Particulars__c;
                costWarp.Id = cost.Id;
                costWarp.quantity = (Integer)cost.Quantity__c;
                costWarp.volume = (Integer)cost.Volume__c;
                costWarp.rate = cost.Rate__c;
                costWarp.amount = cost.Amount__c;
                costWarp.totalAmount = cost.Enquiry_Id__r.Costing_Amount__c;
                costWarp.totalQuant = (Integer)cost.Enquiry_Id__r.Total_Costing_Quantity__c;
                costWarp.totalVol = (Integer)cost.Enquiry_Id__r.Total_Costing_Volume__c;
                costWarp.totalRate = cost.Enquiry_Id__r.Total_Rate__c;
                costWarp.enqId = recordId;
                costWrapList.add(costWarp);
            }

        } else{
            List<Costing_Record__mdt> costingList = [Select Id, Cost_Type__c from Costing_Record__mdt];
            for(Costing_Record__mdt art: costingList){
            	costingWrapper costWrap  = new costingWrapper();
                costWrap.costType = art.Cost_Type__c;
                costWrap.quantity = 0;
                costWrap.volume = 0;
                costWrap.rate = 0;
                costWrap.amount=0;
                costWrap.enqId = recordId;
                costWrapList.add(costWrap);
           	}
        }
        return costWrapList;
    }

    public  static final Set<Id> EDIT_ALLOWED_PROFILE_IDS = new Set<Id> {
        '00e0p000000IejsAAC',
        '00e0p000000IftFAAS',
        '00e5j000002m9dvAAA'
    };

    @AuraEnabled(cacheable=true)
    public static Boolean canUserEdit() {
        Id profileId = UserInfo.getProfileId();
        return EDIT_ALLOWED_PROFILE_IDS.contains(profileId);
    }

    @AuraEnabled
    public static Boolean saveCostAction(Costing__c objCost){
        Boolean flag = false;
        try{
            if(canUserEdit()){
                insert objCost;
                flag = true;
            }
            
        }
        catch(Exception ex) {
            System.debug('Exception msg--' + ex.getMessage());
            throw new AuraHandledException(ex.getMessage());
        }
        return flag;
    }

    @AuraEnabled
    public static Boolean deleteCost(Costing__c objCost){
        Boolean flag = false;
        try {
            if(canUserEdit()){
                delete objCost;
                flag = true;
            }
            
        }
        catch(Exception ex) {
            System.debug('exception--' + ex.getMessage());
            throw new AuraHandledException(ex.getMessage());
        }
        return flag;
    }
    
    @AuraEnabled
    public static string upsertCosting(String jsonresponse){
        
        List<costingWrapper> costWrapList = (List<costingWrapper>)JSON.deserialize(jsonresponse, List<costingWrapper>.class);
        
        List<Costing__c> lstcost = new List<Costing__c>();
        
        for(costingWrapper costWrap : costWrapList){
            Costing__c cost = new Costing__c();
            if(costWrap.Id == null){
                cost.Particulars__c = costWrap.costType;
                cost.Id = costWrap.Id;
                cost.Enquiry_Id__c = costWrap.enqId;
                if(costWrap.rate!=null){
                    cost.Rate__c = costWrap.rate;
                }
                if(costWrap.quantity!=null){
                    cost.Quantity__c = (Integer)costWrap.quantity;
                }
                if(costWrap.volume!=null){
                    cost.Volume__c = (Integer)costWrap.volume;
                }
            }
            else{
                cost.Id = costWrap.Id;
                if(costWrap.rate!=null){
                    cost.Rate__c = costWrap.rate;
                }
                if(costWrap.quantity!=null){
                    cost.Quantity__c = (Integer)costWrap.quantity;
                }
                if(costWrap.volume!=null){
                    cost.Volume__c = (Integer)costWrap.volume;
                }
            }
            
            lstcost.add(cost);
        }
        System.debug('cost list--'+ lstcost);
        upsert lstcost Id;
		return null;
    }
}
