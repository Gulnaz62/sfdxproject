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
        public Decimal actualCost;
        @AuraEnabled
        public Decimal totalActualCost;
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
        @AuraEnabled
        public Boolean costIncluded;
    } 

    @AuraEnabled(cacheable=true)
    public static List<costingWrapper> getCostingList(Id recordId, string type){
        List<costingWrapper> costWrapList = new List<costingWrapper>();
        List<Costing__c> costList = [Select Id, Particulars__c, Actual_Cost__c, Volume__c, Rate__c, Amount__c, Cost_Included__c, Enquiry_Id__r.Total_Actual_Cost__c,Enquiry_Id__r.Total_Costing_Volume__c, Enquiry_Id__r.Total_Rate__c, Enquiry_Id__r.Costing_Amount__c from Costing__c where Enquiry_Id__c =: recordId];
        
        if(costList.size() > 0){
            
            for(Costing__c cost: costList){
                costingWrapper costWarp  = new costingWrapper();
                costWarp.costType = cost.Particulars__c;
                costWarp.Id = cost.Id;
                costWarp.actualCost = cost.Actual_Cost__c;
                costWarp.volume = (Integer)cost.Volume__c;
                costWarp.rate = cost.Rate__c;
                costWarp.amount = cost.Amount__c;
                costWarp.costIncluded = cost.Cost_Included__c;
                costWarp.totalAmount = cost.Enquiry_Id__r.Costing_Amount__c;
                costWarp.totalActualCost = cost.Enquiry_Id__r.Total_Actual_Cost__c;
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
                costWrap.actualCost = 0;
                costWrap.volume = 0;
                costWrap.rate = 0;
                costWrap.amount=0;
                costWrap.costIncluded = false;
                costWrap.enqId = recordId;
                costWrapList.add(costWrap);
           	}
        }
        return costWrapList;
    }

    /*public  static final Set<Id> EDIT_ALLOWED_PROFILE_IDS = new Set<Id> {
        '00e0p000000IejsAAC', //Operation
        '00e0p000000Imu5AAC', //CRM/CSD/OPS
        '00e0p000000IftFAAS', //Grace Admin
        '00e5j000002m9dvAAA', //System Admin
        '00e0p000000IejiAAC'  //CRM
    };*/

    @AuraEnabled(cacheable=true)
    public static Boolean canUserEdit() {
        List<Id> allowedProfileIds = new List<Id>();
        Id profileId = UserInfo.getProfileId();
        List<Profile> allowedProfile = [SELECT Id FROM Profile WHERE Name IN ('CRM', 'Operation','Grace Admin','System Administrator','CRM/CSD/OPS')];
        for(Profile p: allowedProfile){
            allowedProfileIds.add(p.Id);
        }
        return allowedProfileIds.contains(profileId);
    }

    @AuraEnabled
    public static Boolean saveCostAction(Costing__c objCost){
        Boolean flag = false;
        try{
            if(canUserEdit() && UserInfo.getProfileId()!='00e0p000000IejiAAC'){
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
            if(canUserEdit()  && UserInfo.getProfileId()!='00e0p000000IejiAAC'){
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
                if(costWrap.volume!=null){
                    cost.Volume__c = (Integer)costWrap.volume;
                }
            }
            else{                
                cost.Id = costWrap.Id;
                if(costWrap.costType!=null){
                    cost.Particulars__c = costWrap.costType;
                }
                if(costWrap.rate!=null){
                    cost.Rate__c = costWrap.rate;
                }
                if(costWrap.volume!=null){
                    cost.Volume__c = (Integer)costWrap.volume;
                }
                if(costWrap.costIncluded!=null){
                    cost.Cost_Included__c = costWrap.costIncluded;
                }
                if(costWrap.actualCost!=null){
                    cost.Actual_Cost__c = costWrap.actualCost;
                }
                
            }
            
            lstcost.add(cost);
        }
        System.debug('cost list--'+ lstcost);
        upsert lstcost Id;
		return null;
    }
}