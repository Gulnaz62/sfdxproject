@isTest
public class TestDataFactory {
    
    public static User createUser(Boolean doInsert, String profileName, Integer i){
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name =: profileName].Id,
            LastName = 'last' +i,
            Email = 'abcxyztest' + i +'@example.com',
            Username = 'abcxyztest' + i +'@example.com' + System.currentTimeMillis(),
            CompanyName = 'TEST' + i,
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
        if(doInsert){
            insert u;
        }
        return u;
    }
    /** This method is to create Account Test Data **/ 
    public static Account createAccount(Boolean doInsert, String accName)
    {
        Account acc = new Account();
        acc.Name  = accName;
        acc.First_Call__c = Date.today();
        acc.Status__c = 'New';
        
        if(doInsert){
            insert acc;
        }
        return acc;
    }
    
    public static Account createRegisteredAccount(Boolean doInsert, String accName, String kamUserId)
    {
        Account acc = new Account();
        acc.Name  = accName;
        acc.First_Call__c = Date.today();
        acc.Status__c = 'Contract Registered';
        acc.CRM_User__c = kamUserId;
        
        if(doInsert){
            insert acc;
        }
        return acc;
    }
    
    /** This method is to create Contact Test Data **/ 
    public static Contact createContact(Boolean doInsert, String fname, String lname, String accId)
    {
        Contact con = new Contact();
        con.Salutation = 'Mr.';
        con.LastName     = lname;
        con.FirstName    = fname; 
        con.accountid    = accId;
        con.MobilePhone  = '65'+Math.round((Math.random() * (90000000) + 10000000));
        con.Email        = lname+fname+'test@email.com';
        
        if(doInsert){
            insert con;
        }        
        return con;
    }
    
    /** This method is to create Enquiry Test Data **/ 
    public static Enquiry__c createEnquiry(Boolean doInsert, String accId, String conId, String userId, String enqRecordType )
    {
        Enquiry__c enq = new Enquiry__c();
        enq.Company_Name__c = accId;
        enq.Primary_Contact__c = conId;
        enq.KAM__c = userId;
        enq.Stage__c = 'New';
        if( String.isNotBlank( enqRecordType )){
            if(enqRecordType == 'Domestic Enquiry'){
                enq.Enquiry_Type__c = 'Household Goods';
            }            
        }
        
        if(doInsert){
            insert enq;
        }
        return enq;
    }
    
    public static Enquiry__c createEnquiry(Boolean doInsert, String accId, String conId, String userId, String enqRecordType, String opsUserId, String invUserId)
    {
        Enquiry__c enq = new Enquiry__c();
        enq.Company_Name__c = accId;
        enq.Primary_Contact__c = conId;
        enq.KAM__c = userId;
        enq.OPS_User__c = opsUserId;
        enq.Invoice_User__c = invUserId;
        enq.Booking_Branch__c = 'Delhi';
        enq.Car_Details__c = 'Hyundai Verna';
        enq.Origin_City__c = 'Mumbai';
        enq.Destination_City__c = 'Noida';
        enq.Value_Of_Car__c = 1000000;
        enq.Origin_Address_Line_1__c  = 'C-75A, Block C';
        enq.Origin_State__c = 'Delhi';
        enq.Transit_Time__c = '12-14 Days';
        enq.Shipment_Type__c = 'Full Load';
        enq.Survey_Date_Time__c = DateTime.now().addHours(2);
        enq.Stage__c = 'Estimate Costing';
        if( String.isNotBlank( enqRecordType )){
            if(enqRecordType == 'Domestic Enquiry'){
                enq.Enquiry_Type__c = 'Car';
            }            
        }
        
        if(doInsert){
            insert enq;
        }
        return enq;
    }
    
    public static Enquiry__c createPreMoveSurveyEnquiry(Boolean doInsert, String accId, String conId, String userId, String enqRecordType, String opsUserId, String invUserId, Integer i)
    {
        Enquiry__c enq = new Enquiry__c();
        enq.Company_Name__c = accId;
        enq.Primary_Contact__c = conId;
        enq.KAM__c = userId;
        enq.OPS_User__c = opsUserId;
        enq.Invoice_User__c = invUserId;
        enq.Booking_Branch__c = 'Delhi';
        enq.Car_Details__c = 'Hyundai Verna';
        enq.Origin_City__c = 'Mumbai';
        enq.Destination_City__c = 'Noida';
        enq.Value_Of_Car__c = 1000000;
        enq.Origin_Address_Line_1__c  = 'C-75A, Block C';
        enq.Origin_State__c = 'Delhi';
        enq.Transit_Time__c = '12-14 Days';
        enq.Shipment_Type__c = 'Full Load';
        enq.Survey_Date_Time__c = DateTime.now().addHours(i);
        enq.Stage__c = 'Pre-Move Survey Planning';
        if( String.isNotBlank( enqRecordType )){
            if(enqRecordType == 'Domestic Enquiry'){
                enq.Enquiry_Type__c = 'Car';
            }            
        }
        
        if(doInsert){
            insert enq;
        }
        return enq;
    }
    
    /** This method is to create Quote Test Data **/ 
    public static Quote__c createQuote(Boolean doInsert, String enqId)
    {
        Quote__c quote = new Quote__c();
        quote.Enquiry_Id__c = enqId;
        quote.GST__c = '12%';
        quote.Margin__c = 1000;
        quote.Margin_for_Car__c = 2000;
        quote.Insurance_Premium_Percentage_for_Car__c = 0.01;
        quote.Insurance_Premium_Percentage__c = 0.02;
        
        if(doInsert){
            insert quote;
        }
        return quote;
    }
    
    /** This method is to create Article Test Data **/
    public static Article__c createArticle(Boolean doInsert, String enqId, String itemName, Integer quan, Integer unitVol, Integer insValue)
    {
        Article__c art = new Article__c();
        art.Enquiry_Id__c = enqId;
        art.Item_Name__c = itemName;
        art.Quantity__c = quan;
        art.Unit_Volume__c = unitVol;
        art.Insurance_Value__c = insValue;
        
        if(doInsert){
            insert art;
        }
        return art;
    }
    
    /** This method is to create Costing Test Data **/
    public static Costing__c createCosting(Boolean doInsert, String enqId, String costType, Integer vol, Integer rate)
    {
        Costing__c cost = new Costing__c();
        cost.Enquiry_Id__c = enqId;
        cost.Particulars__c = costType;
        cost.Volume__c = vol;
        cost.Rate__c = rate;
        cost.Cost_Included__c = true;
        
        if(doInsert){
            insert cost;
        }
        return cost;
    }
    public static Job_Process__c createJobProcess(Boolean doInsert, Id accId, Id enqId, String opsUser, String csdUser, String kamUser, String destOpsUser)
    {
        Job_Process__c job = new Job_Process__c();
        job.Corporate__c = accId;
        job.Enquiry_Id__c =enqId; 
        job.Transit_Status__c = 'Not Started'; 
        job.TAT_DateTime__c = System.now();
        job.OPS_User__c = opsUser;
        job.KAM__c = kamUser;
        job.OPS_User_for_Destination__c = destOpsUser;
        job.CSD_User__c = csdUser;
        job.Extra_Charges_Actual__c = 20000;
        return job;
    }  
    
    public static Job_Process__c createUpcomingJobProcess(Boolean doInsert, Id accId, Id enqId, String opsUser)
    {
        Job_Process__c job = new Job_Process__c();
        job.Corporate__c = accId;
        job.Enquiry_Id__c =enqId; 
        job.OPS_User__c = opsUser;
        job.Transit_Status__c = 'Upcoming';
        job.Job_Date__c = System.today();
        job.Packing_Date_Confirmation__c = true;
        job.Delivery_Date_Confirmation__c = true;
        job.Handyman_Facility__c = true;
        job.Lift_Availability__c = true;
        job.Society_Restrictions__c = 'No';
        job.TAT_DateTime__c = System.now();

        return job;
    }  
    
    public static Job_Process__c createStorageJobProcess(Boolean doInsert, Id accId, Id enqId, String opsUser)
    {
        Job_Process__c job = new Job_Process__c();
        job.Corporate__c = accId;
        job.Enquiry_Id__c =enqId; 
        job.OPS_User__c = opsUser;
        job.Transit_Status__c = 'Storage';
        job.Storage_Type__c ='Long Term Storage';
        job.Long_Term_Time_Stamp__c = System.now().addDays(30);
        job.Job_Date__c = System.today();
        job.Packing_Date_Confirmation__c = true;
        job.Delivery_Date_Confirmation__c = true;
        job.Handyman_Facility__c = true;
        job.Lift_Availability__c = true;
        job.Society_Restrictions__c = 'No';
        job.Re_confirmation_Of_Packing_Date__c = true;
        job.OPS_Alignment_Mail__c = true;
        job.Time_Confirmation__c = true;
        job.Schedule_Insurance_Declaration_Form_Mail__c = true;
        job.Origin_Supervisor__c = 'Mayank';
        job.Call_To_Client_Before_30_Min_Of_Packing__c = true;
        job.Packing_started__c = true;
        job.Insurance_Form_Filled_by_User__c = true;
        job.Status_Mail_to_Client__c = true;
        job.Packing_Images_of_Pre_existing_Damages__c = true;
        job.Packing_List_Provided_by_OPS__c = true;
        job.TAT_DateTime__c = System.now();

        return job;
    }
}