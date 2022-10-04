public with sharing class BusinessHoursService
{
    //retrieves & assign the Organization level Business Hours to defaultBH 
    @testVisible public static BusinessHours defaultBH
    {
        get
        {
            if (defaultBH == null)
                defaultBH = [SELECT Id FROM BusinessHours WHERE IsDefault = true];
            return defaultBH;
        }
        private set;
    }
    
    public static Datetime getReminderTimeByBusinessHour (DateTime input, decimal Reminderhours)
    {    
        return BusinessHours.add(defaultBH.Id,input, (long) (Reminderhours* 60 * 60 * 1000));
    }
}