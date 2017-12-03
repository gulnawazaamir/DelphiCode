global with sharing class  getOpportunity implements Database.Batchable<Sobject>  
{  
 
global getOpportunity()  
{  

}  
  
global Database.QueryLocator start(Database.BatchableContext BC)  
{  
Double probabilityScore=100.0;
String query = 'select id from opportunity where Probability=:probabilityScore';
return Database.getQueryLocator(query);  
}  
  
global void execute(Database.BatchableContext BC, List<Opportunity> scope)
{ 
System.debug(LoggingLevel.FINEST,'  ------  :::::::::   ------    abcdseees3233342 ');

 Map<String, batch_processing_date__c> batch_processing_date1 = batch_processing_date__c.getAll();
                
                batch_processing_date__c bpc1=batch_processing_date1.get('batch_date');
                Datetime startDate = system.now();
                List<MachineOpportunityRecord__c> oppIdList=[SELECT OpportunityId__c FROM MachineOpportunityRecord__c where timePeriod__c= 'schedule'];
                Set<Id> ldIds = new Set<Id>();
            
           for(MachineOpportunityRecord__c obj:oppIdList)
           {
           ldIds.add(obj.OpportunityId__c);
           }
               
               
         
                 
               
                scope=[Select Id,CloseDate from Opportunity where Probability=100.0 AND Id not in : ldIds];
                
                if(scope.size()>=1)
                {
                List<MachineOpportunityRecord__c> machineList=new List<MachineOpportunityRecord__c>();
                for(Opportunity opp : scope)
                {
                MachineOpportunityRecord__c m=new MachineOpportunityRecord__c();
                m.OpportunityId__c=opp.id;
                m.timePeriod__c='schedule';
                m.OpportunityDate__c=opp.CloseDate;
                machineList.add(m);
                }
                insert machineList;
                 }
                deleteMachineLearningRecords('schedule');
                System.debug(LoggingLevel.FINEST,'  ------  :::::::::   ------    date query-- '+scope.size());
                machineLogic(scope,'schedule',ldIds);
                
                
                
  

} 

  

global void deleteMachineLearningRecords(String type)
{
    List<delphiDemo__MachineLearningRecord__c> machineLogic=[select Stage_Name__c from delphiDemo__MachineLearningRecord__c LIMIT 100];
    
    
   
    if (delphiDemo__MachineLearningRecord__c.sObjectType.getDescribe().isDeletable()) {
    
        delete machineLogic;


}

 
    
    
    
}   

  


global void machineLogic(List<Opportunity> scope,String timePeriodType, Set<Id> idList)
{
    System.debug(LoggingLevel.FINEST,'  ------  :::::::::   ------    machine opp size-- '+scope.size());
    List<MachineLearningRecord__c> updateMachineList=new List<MachineLearningRecord__c>();
    List<MachineLearningRecord__c> insertMachineList=new List<MachineLearningRecord__c>();
    List<StagesTimeDurationRecord__c> insertStageList=new List<StagesTimeDurationRecord__c>();
    Map<String, List<OpportunityFieldHistory>> m = new Map<String, List<OpportunityFieldHistory>>();
    Map<String, MachineLearningRecord__c> mapForUpdateMachineLearning = new Map<String, MachineLearningRecord__c>();
    List<OpportunityFieldHistory> ofp=new List<OpportunityFieldHistory>();
    Datetime myDateTime = Datetime.newInstance(1960, 2, 17);
     Set<Id> sd=new Set<Id>(); 
     Set<String> oldStageNameSet=new Set<String>();
     Set<String> newStageNameSet=new Set<String>();
     Integer machineCount=0; 
     
     List<Configuration_Instruction__c> lst =Configuration_Instruction__c.getAll().values();

      lst[0].Machine_Pages_Visible__c=false;
       update lst[0];
      Map<String, MachineLearningRecord__c> mapForMachineLearningRecord = new Map<String, MachineLearningRecord__c>();
      Map<String, List<OpportunityHistory>> mapForOpportunityHistory = new Map<String, List<OpportunityHistory>>(); 
      for (Opportunity a : scope)
        {
        
        // String oppId=a.Id;
           sd.add(a.Id);
       
      //   m.put(oppId,ofp);  
         
        }
      ofp=[SELECT NewValue,OldValue,OpportunityId,CreatedDate FROM OpportunityFieldHistory where OpportunityId in : sd  order by CreatedDate];
      for(OpportunityFieldHistory fieldHistoryRecord:ofp)
{
    if(fieldHistoryRecord.NewValue!='' && fieldHistoryRecord.OldValue!='')
    {
    if(m.get(fieldHistoryRecord.OpportunityId)!=null)
    {
      List<OpportunityFieldHistory> getlist=m.get(fieldHistoryRecord.OpportunityId);
      getlist.add(fieldHistoryRecord);
       m.put(fieldHistoryRecord.OpportunityId,getlist);
    }
    else
    {
     List<OpportunityFieldHistory> putlist=new List<OpportunityFieldHistory>();
     putlist.add(fieldHistoryRecord);
     m.put(fieldHistoryRecord.OpportunityId,putlist);
    }
    
    }
}   

       for (Opportunity a : scope)
        {

          List<OpportunityFieldHistory> history=m.get(a.Id);
          if(history!=null)
          {
         for(OpportunityFieldHistory data : history)
        {
        oldStageNameSet.add(String.valueOf(data.OldValue));
        newStageNameSet.add(String.valueOf(data.NewValue));
        }   
         } 
        }
 List<MachineLearningRecord__c> machineLogic=[select Stage_Name__c,Counter__c,Batch_Date_Time__c,Time_Duration__c from MachineLearningRecord__c where Stage_Name__c in :oldStageNameSet];    
  for (MachineLearningRecord__c mr : machineLogic)
        {

        mapForMachineLearningRecord.put(mr.Stage_Name__c,mr);
          
        }
        
 List<OpportunityHistory> opportunityHistoryData = [SELECT CreatedDate,StageName,OpportunityId FROM OpportunityHistory WHERE OpportunityId in : sd AND (StageName in : oldStageNameSet OR StageName in : newStageNameSet)  AND createdDate>= :myDateTime ORDER BY CreatedDate ASC];     
 
 for(OpportunityHistory ohistory : opportunityHistoryData)
 {
     
     if(mapForOpportunityHistory.get(ohistory.OpportunityId)!=null)
     {
     List<OpportunityHistory> getlist=mapForOpportunityHistory.get(ohistory.OpportunityId);
      getlist.add(ohistory);
      mapForOpportunityHistory.put(ohistory.OpportunityId,getlist);
    }
    else
    {
     List<OpportunityHistory> putlist=new List<OpportunityHistory>();
     putlist.add(ohistory);
     mapForOpportunityHistory.put(ohistory.OpportunityId,putlist);
    }
 }
    
  for (Opportunity a : scope)
        {
       
        List<OpportunityFieldHistory> history=m.get(a.Id);
        
        
        Map<String, Set<String>> stageMap=new Map<String,Set<String>>();
        myDateTime = Datetime.newInstance(1960, 2, 17);
        if(history!=null)
        {
        for(OpportunityFieldHistory data : history)
        {
        System.debug(LoggingLevel.FINEST,'  ------  :::::::::   ------    stagemap-- '+stageMap.size());    
        System.debug(LoggingLevel.FINEST,'  ------  :::::::::   ------    old-- '+data.OldValue+' ---- new-- '+data.NewValue);
        if(data.OldValue!=null)
        {
        String oldValue=String.valueOf(data.OldValue);
        String newValue=String.valueOf(data.NewValue);
        
        
        System.debug(LoggingLevel.FINEST,'  ------  :::::::::   ------    machine learning-- '+machineLogic);
       
            
        if(mapForMachineLearningRecord.get(oldValue)!=null)
        {
      //   List<OpportunityHistory> opportunityHistoryData=new List<OpportunityHistory>();
         List<Datetime> oldDateList=new List<Datetime>();
         List<Datetime> newDateList=new List<Datetime>();
         if(stageMap.containsKey(oldValue))
         {
             Set<String> stageList=stageMap.get(oldValue);
             
             if(!stageList.contains(newValue))
             {
       //  opportunityHistoryData=[SELECT CreatedDate,StageName FROM OpportunityHistory WHERE OpportunityId = :a.Id AND (StageName = :oldValue OR StageName = :newValue)  AND createdDate>= :myDateTime ORDER BY CreatedDate ASC];
         stageList.add(newValue);
         Integer count=0;
         Integer newCount=0;
         if(mapForOpportunityHistory.get(a.Id)!=null)
         {
             
            List<OpportunityHistory> getlist=mapForOpportunityHistory.get(a.Id);
            
            for(OpportunityHistory oh:getlist)
         {
             count=count+1;
             if(String.valueOf(oh.StageName).equals(oldValue))
             {
                 if(newCount==0)
                {
                     myDateTime=oh.CreatedDate;
                }
                 newCount=count;
                
                 while(newCount<getlist.size())
                 {
                     if(String.valueOf(getlist[newCount].StageName).equals(newValue))
                     {
                         newDateList.add(getlist[newCount].CreatedDate);
                          oldDateList.add(oh.CreatedDate);
                         newCount=getlist.size()+1;
                        
                     }
                     else
                     {
                         newCount=newCount+1;
                     }
                 }
             }
             
         }
                    
         }
         
         System.debug(LoggingLevel.FINEST,'  ------  :::::::::   ------    datelist-- '+oldDateList.size()+'  :::::: """ new datelist'+newDateList.size());
         count=0;
          Decimal totalDuration=0.0;
         while(count<oldDateList.size())
         {
             Datetime myDate1 = oldDateList[count];
            Datetime myDate2 = newDateList[count];
        integer intDays =  myDate1.Date().daysBetween(myDate2.Date());
        Decimal hoursDifference= myDate2.getTime() - myDate1.getTime();
          hoursDifference= hoursDifference/1000/60/60;
        hoursDifference=hoursDifference/24.0;
        System.debug(LoggingLevel.FINEST,'  ------  :::::::::   ------    hour difference '+hoursDifference);
      System.debug(LoggingLevel.FINEST,' aaaa  '+oldValue);
        Decimal total= hoursDifference;
       totalDuration=totalDuration+intDays +total;
       count=count+1;
         }
       
        
        StagesTimeDurationRecord__c stageData=new StagesTimeDurationRecord__c();
        
         stageData.Stage_Name__c=oldValue;
         stageData.Duration__c=totalDuration;
         stageData.timePeriodFlow__c=timePeriodType;
         stageData.OpportunityId__c=a.Id;
         stageData.stageDate__c=a.CloseDate;
         insertStageList.add(stageData);
     //   insert stageData;
         
         MachineLearningRecord__c machineRec = mapForMachineLearningRecord.get(oldValue);
         machineRec.Time_Duration__c=machineRec.Time_Duration__c+totalDuration;
         machineRec.Batch_Date_Time__c=date.today();
     //    machineRec.timePeriodFlow__c=timePeriodType;
     //    updateMachineList.add(machineRec);
     if(mapForUpdateMachineLearning.get(oldValue)!=null)
     {
     MachineLearningRecord__c mcr=mapForUpdateMachineLearning.get(oldValue);
     mcr=machineRec;
     
     }
     else
     {
     mapForUpdateMachineLearning.put(oldValue,machineRec);
     }
     //   update machineRec;
             }
             
         }
         else
         {
       //  opportunityHistoryData=[SELECT CreatedDate,StageName FROM OpportunityHistory WHERE OpportunityId = :a.Id AND (StageName = :oldValue OR StageName = :newValue)  AND createdDate>= :myDateTime ORDER BY CreatedDate ASC];
        
         Integer count=0;
         Integer newCount=0;
          if(mapForOpportunityHistory.get(a.Id)!=null)
         {
             
            List<OpportunityHistory> getlist=mapForOpportunityHistory.get(a.Id);
            
            for(OpportunityHistory oh:getlist)
         {
             count=count+1;
             if(String.valueOf(oh.StageName).equals(oldValue))
             {
                 if(newCount==0)
                {
                     myDateTime=oh.CreatedDate;
                }
                 newCount=count;
                
                 while(newCount<getlist.size())
                 {
                     if(String.valueOf(getlist[newCount].StageName).equals(newValue))
                     {
                         newDateList.add(getlist[newCount].CreatedDate);
                          oldDateList.add(oh.CreatedDate);
                         newCount=getlist.size()+1;
                        
                     }
                     else
                     {
                         newCount=newCount+1;
                     }
                 }
             }
             
         }
                    
         }
         
         System.debug(LoggingLevel.FINEST,'  ------  :::::::::   ------    datelist-- '+oldDateList.size()+'  :::::: """ new datelist'+newDateList.size());
         count=0;
          Decimal totalDuration=0.0;
         while(count<oldDateList.size())
         {
             Datetime myDate1 = oldDateList[count];
            Datetime myDate2 = newDateList[count];
        integer intDays =  myDate1.Date().daysBetween(myDate2.Date());
       Decimal hoursDifference= myDate2.getTime() - myDate1.getTime();
          hoursDifference= hoursDifference/1000/60/60;
        hoursDifference=hoursDifference/24.0;
        System.debug(LoggingLevel.FINEST,'  ------  :::::::::   ------    hour difference '+hoursDifference);
        System.debug(LoggingLevel.FINEST,' bbbb  '+oldValue);
        Decimal total= hoursDifference;
       totalDuration=totalDuration+intDays +total;
       count=count+1;
         }
       
        
        StagesTimeDurationRecord__c stageData=new StagesTimeDurationRecord__c();
        
         stageData.Stage_Name__c=oldValue;
         stageData.Duration__c=totalDuration;
         stageData.timePeriodFlow__c=timePeriodType;
         stageData.OpportunityId__c=a.Id;
         stageData.stageDate__c=a.CloseDate;
         insertStageList.add(stageData);
      //   insert stageData;
         
          MachineLearningRecord__c machineRec = mapForMachineLearningRecord.get(oldValue);
         machineRec.Time_Duration__c=machineRec.Time_Duration__c+totalDuration;
         machineRec.Batch_Date_Time__c=date.today();
         machineRec.Counter__c= machineRec.Counter__c+1;
     //    machineRec.timePeriodFlow__c=timePeriodType;
      //   updateMachineList.add(machineRec);
     //    update machineRec;
        if(mapForUpdateMachineLearning.get(oldValue)!=null)
     {
     MachineLearningRecord__c mcr=mapForUpdateMachineLearning.get(oldValue);
     mcr=machineRec;
     
     }
     else
     {
     mapForUpdateMachineLearning.put(oldValue,machineRec);
     } 
       Set<String> stList=new Set<String>();
       
       stList.add(newValue);
       
       stageMap.put(oldValue,stList);
         }
         
         
        }
        else
        {
     //   List<OpportunityHistory> opportunityHistoryData=new List<OpportunityHistory>();
          List<Datetime> oldDateList=new List<Datetime>();
         List<Datetime> newDateList=new List<Datetime>();
   //     opportunityHistoryData=[SELECT CreatedDate,StageName FROM OpportunityHistory WHERE OpportunityId = :a.Id AND (StageName = :oldValue OR StageName = :newValue) AND createdDate>= :myDateTime ORDER BY CreatedDate ASC];
        
        Integer count=0;
         Integer newCount=0;
         if(mapForOpportunityHistory.get(a.Id)!=null)
         {
             
            List<OpportunityHistory> getlist=mapForOpportunityHistory.get(a.Id);
            
            for(OpportunityHistory oh:getlist)
         {
             count=count+1;
             if(String.valueOf(oh.StageName).equals(oldValue))
             {
                 if(newCount==0)
                {
                     myDateTime=oh.CreatedDate;
                }
                 newCount=count;
                
                 while(newCount<getlist.size())
                 {
                     if(String.valueOf(getlist[newCount].StageName).equals(newValue))
                     {
                         newDateList.add(getlist[newCount].CreatedDate);
                          oldDateList.add(oh.CreatedDate);
                         newCount=getlist.size()+1;
                        
                     }
                     else
                     {
                         newCount=newCount+1;
                     }
                 }
             }
             
         }
                    
         }
         
         System.debug(LoggingLevel.FINEST,'  ------  :::::::::   ------    datelist-- '+oldDateList.size()+'  :::::: """ new datelist'+newDateList.size());
          count=0;
          Decimal totalDuration=0.0;
         while(count<oldDateList.size())
         {
             Datetime myDate1 = oldDateList[count];
            Datetime myDate2 = newDateList[count];
        integer intDays =  myDate1.Date().daysBetween(myDate2.Date());
        Decimal hoursDifference= (((myDate2.getTime())/1000/60/60) - ((myDate1.getTime())/1000/60/60));
        System.debug(LoggingLevel.FINEST,'  ------  :::::::::   ------    mydate1Time-- '+myDate2.getTime()+'  :::::: """ mydate2Time'+myDate1.getTime());
        hoursDifference=hoursDifference/24.0;
        String localTime1 = myDate1.format('HH:mm');
         String localTime2 = myDate2.format('HH:mm');
         String[] hr1=localTime1.split(':');
         String[] hr2=localTime2.split(':');
         Integer hour1=Integer.ValueOf(hr1[0]);
         Integer hour2=Integer.ValueOf(hr2[0]);
         if(hour1>hour2)
         {
         hoursDifference=(hour1-hour2)/24.0;
         }
         else
         {
          hoursDifference=(hour2-hour1)/24.0;
         }
       
        System.debug(LoggingLevel.FINEST,'  ------  :::::::::   ------    hour difference '+hoursDifference);
         System.debug(LoggingLevel.FINEST,' ccccc  '+oldValue);
        Decimal total= hoursDifference;
       totalDuration=totalDuration+intDays +total;
       count=count+1;
         }
       
       
        
        MachineLearningData machineData=new MachineLearningData();
        machineData.stageName=oldValue;
        machineData.duration=totalDuration;
        machineData.counter=1;
       
        MachineLearningRecord__c machineObject= new MachineLearningRecord__c();
        
        machineObject.Stage_Name__c=machineData.stageName;
        machineObject.Counter__c=machineData.counter;
        machineObject.Time_Duration__c=machineData.duration;
        machineObject.Batch_Date_Time__c=date.today();
     //   machineObject.timePeriodFlow__c=timePeriodType;
        mapForMachineLearningRecord.put(oldValue,machineObject);
        
         StagesTimeDurationRecord__c stageData=new StagesTimeDurationRecord__c();
        
         stageData.Stage_Name__c=oldValue;
         stageData.Duration__c=totalDuration;
         stageData.timePeriodFlow__c=timePeriodType;
         stageData.OpportunityId__c=a.Id;
          stageData.stageDate__c=a.CloseDate;
   //     insert stageData;
         insertStageList.add(stageData);
         insertMachineList.add(machineObject);
  //      insert machineObject;
          
       Set<String> stList=new Set<String>();
       
       stList.add(newValue);
       
       stageMap.put(oldValue,stList);
        
        }
        }
        }
        
       }
       
         
        } 
        if (StagesTimeDurationRecord__c.Stage_Name__c.getDescribe().isCreateable() && StagesTimeDurationRecord__c.Duration__c.getDescribe().isCreateable() && 
        StagesTimeDurationRecord__c.timePeriodFlow__c.getDescribe().isCreateable() && StagesTimeDurationRecord__c.OpportunityId__c.getDescribe().isCreateable() && 
        StagesTimeDurationRecord__c.stageDate__c.getDescribe().isCreateable()) {
               insert insertStageList;
          }
       
       if (MachineLearningRecord__c.Stage_Name__c.getDescribe().isCreateable() && MachineLearningRecord__c.Counter__c.getDescribe().isCreateable() && 
        MachineLearningRecord__c.Time_Duration__c.getDescribe().isCreateable() && MachineLearningRecord__c.Batch_Date_Time__c.getDescribe().isCreateable()) {
              insert insertMachineList;
          }
        
        //update updateMachineList;
        for(String str : mapForUpdateMachineLearning.keySet())
        {
         MachineLearningRecord__c mcr=mapForUpdateMachineLearning.get(str);
         updateMachineList.add(mcr);
        
        }
        
        if (MachineLearningRecord__c.Stage_Name__c.getDescribe().isUpdateable() && MachineLearningRecord__c.Counter__c.getDescribe().isUpdateable() && 
        MachineLearningRecord__c.Time_Duration__c.getDescribe().isUpdateable() && MachineLearningRecord__c.Batch_Date_Time__c.getDescribe().isUpdateable()) {
              update updateMachineList;
          }
        
        
         calculateRevenue(timePeriodType);
         
         calculatingMean(timePeriodType,idList);
}


global void calculateRevenue(String type)
{
         Map<String, Revenue_Information__c> probabilityMapping  = Revenue_Information__c.getAll();
        List<OpportunityStage> osList=[SELECT DefaultProbability,MasterLabel FROM OpportunityStage LIMIT 100];
         Set<String> stageNameList=new Set<String>();
          DateTime endDate = System.Now();
          DateTime newDate;
         for(OpportunityStage str:osList)
        {
            if(str.DefaultProbability!=100.0 && str.DefaultProbability!=0.0)
        {
            stageNameList.add(str.MasterLabel);
        }   
        } 

       if(type =='6months')
       {
          newDate = System.Now().addMonths(-6); 
       }
       if(type =='12months')
       {
          newDate = System.Now().addYears(-1); 
       }
       if(type =='24months')
       {
          newDate = System.Now().addYears(-2); 
       }
        if(type =='36months')
       {
          newDate = System.Now().addYears(-3); 
       }
        if(type =='schedule')
       {
          newDate = System.Now().addYears(-70); 
       }          
        Map<String,Set<Id>> mapForStage=new Map<String,Set<Id>>();
        Map<String,Integer> mapForStageWonCount=new Map<String,Integer>();
        Map<String,Integer> mapForStageLostCount=new Map<String,Integer>();
        List<OpportunityHistory>  lhp = [SELECT OpportunityId,StageName FROM OpportunityHistory where StageName in : stageNameList and CreatedDate > :newDate and CreatedDate <= :endDate];
        
        for(OpportunityHistory oh : lhp)
        {
            if(mapForStage.get(oh.stageName)!=null)
            {
                
                Set<Id> sdf=mapForStage.get(oh.stageName);
                
                sdf.add(oh.OpportunityId);
            }
            else{
                Set<Id> sdfNew=new Set<Id>();
                    sdfNew.add(oh.OpportunityId);
                mapForStage.put(oh.stageName,sdfNew);
            }
        }
        
        List<Opportunity> closeWonCountList=[select id from opportunity where Probability=100.0];
        List<Opportunity> closeLostCountList=[select id from opportunity where Probability=0.0];
        for(Opportunity opp : closeWonCountList)
        {
            for(OpportunityStage str:osList)
        {
            if(str.DefaultProbability!=100.0 && str.DefaultProbability!=0.0)
        {
            if(mapForStage.get(str.MasterLabel)!=null)
            {
                if(mapForStage.get(str.MasterLabel).contains(opp.id))
                {
                    if(mapForStageWonCount.get(str.MasterLabel)!=null)
                    {
                        
                        Integer it= mapForStageWonCount.get(str.MasterLabel);
                        
                        it=it+1;
                        mapForStageWonCount.put(str.MasterLabel,it);
                    }
                    
                    else
                    {
                        mapForStageWonCount.put(str.MasterLabel,1);
                    }
                    
                }
            }
        }   
        }   
        }
        
        for(String str : mapForStageWonCount.keySet())
        {
          System.debug(LoggingLevel.FINEST,'  -stageName '+str);
          System.debug(LoggingLevel.FINEST,'  -counttt '+mapForStageWonCount.get(str));
        }
        for(Opportunity opp : closeLostCountList)
        {
            for(OpportunityStage str:osList)
        {
            if(str.DefaultProbability!=100.0 && str.DefaultProbability!=0.0)
        {
            if(mapForStage.get(str.MasterLabel)!=null)
            {
                if(mapForStage.get(str.MasterLabel).contains(opp.id))
                {
                    if(mapForStageLostCount.get(str.MasterLabel)!=null)
                    {
                        
                        Integer it= mapForStageLostCount.get(str.MasterLabel);
                        
                        it=it+1;
                        mapForStageLostCount.put(str.MasterLabel,it);
                    }
                    
                    else
                    {
                        mapForStageLostCount.put(str.MasterLabel,1);
                    }
                    
                }
            }
        }   
        }   
        }
        
        for(OpportunityStage str:osList)
        {
            Decimal  wonCount=0.0;
            Decimal  lostCount=0.0;
        if(str.DefaultProbability!=100.0 && str.DefaultProbability!=0.0)
        {
            if(mapForStageWonCount.get(str.MasterLabel)!=null)
                    {
                        
                         wonCount=  mapForStageWonCount.get(str.MasterLabel);
                        }
                    if(mapForStageLostCount.get(str.MasterLabel)!=null)
                    {
                        
                        lostCount=  mapForStageLostCount.get(str.MasterLabel);
                        }
                    
                if((wonCount+lostCount)!=0.0)
                {
                    if(probabilityMapping.containskey(str.MasterLabel))
            {
            Revenue_Information__c rc=probabilityMapping.get(str.MasterLabel);
            if (Revenue_Information__c.probabilityScore__c.getDescribe().isUpdateable()) {
            
            if(rc!=null)
            {
             rc.probabilityScore__c=String.valueOf(wonCount/(lostCount+wonCount));
           update rc;
            }
              
          }
           
            }
            else
            {
              Revenue_Information__c objProbMapp = new Revenue_Information__c();
              
              if (Revenue_Information__c.name.getDescribe().isCreateable() && Revenue_Information__c.probabilityScore__c.getDescribe().isCreateable()) {
            
            
                        objProbMapp.name = str.MasterLabel;
                        objProbMapp.probabilityScore__c = String.valueOf(wonCount/(lostCount+wonCount));
                        insert objProbMapp;
            
              
          }
                        
            }
            
             System.debug(LoggingLevel.FINEST,'  ------  :::::::::   ------    closeWon-- '+wonCount+' ----Lost count-- '+lostCount+'   ---  stage name  -- '+str.MasterLabel);
                }   
         }              
        }   
        
        
        calculatingMeanAndSDForRevenue();
        
      //   System.debug(LoggingLevel.FINEST,'  ------  :::::::::   ------    combined Probability-- '+combinedRevenueProbability);   
}
 

global void calculatingMeanAndSDForRevenue()
{
    Map<String, Revenue_Information__c> revenueMapping  = Revenue_Information__c.getAll();
    Map<String, ProbabilityMapping__c> probMapForStage = ProbabilityMapping__c.getAll();
    List<ProbabilityMapping__c> updateList=new  List<ProbabilityMapping__c>();
     List<ProbabilityMapping__c> insertList=new  List<ProbabilityMapping__c>();
     Integer noOfItration=1000;
    
     for (String stageName : revenueMapping.keySet()){
           
            if(probMapForStage.containskey(stageName))
            {
                ProbabilityMapping__c pc=probMapForStage.get(stageName);
                Revenue_Information__c rc=revenueMapping.get(stageName);
                
                Decimal min1=decimal.valueOf(rc.probabilityScore__c)*0.8;
                Decimal max1=decimal.valueOf(rc.probabilityScore__c)*1.2;
                
                Decimal sum1=0;
                Decimal squaredDifferencesSum1 = 0;
                Decimal mean1=0;
                Decimal standardDeviation1=0;
                Decimal squaredDifferencesMean1=0;
                 List<Decimal> ranvalforprob = new List<Decimal>();
                    for(Integer i=0;i<noOfItration;i++){                       
                        Decimal ranvar=min1+(Math.random()*((max1-min1) ));   //genetating random variable here
                        ranvalforprob.add(ranvar);
                        sum1 +=ranvar;  // Holds the sum of all random variable  
                    }
                    mean1=sum1/noOfItration;                
                  
                   for(Decimal d : ranvalforprob){
                       squaredDifferencesSum1 += ((d-mean1)*(d-mean1));                       
                   }
                                      
                squaredDifferencesMean1 = squaredDifferencesSum1 /noOfItration;
                standardDeviation1 = Math.sqrt(squaredDifferencesMean1);
                
                pc.Probability_Mean__c = mean1;
                pc.Probability_SD__c = standardDeviation1 ;
              
              updateList.add(pc);
                
                
            }
            else
            {
                ProbabilityMapping__c pc=new ProbabilityMapping__c();
                Revenue_Information__c rc=revenueMapping.get(stageName);
                pc.name=stageName;
                Decimal min1=decimal.valueOf(rc.probabilityScore__c)*0.80;
                Decimal max1=decimal.valueOf(rc.probabilityScore__c)*1.20;
                 List<Decimal> ranvalforprob = new List<Decimal>();
                Decimal sum1=0;
                Decimal squaredDifferencesSum1 = 0;
                Decimal mean1=0;
                Decimal standardDeviation1=0;
                Decimal squaredDifferencesMean1=0;
                    for(Integer i=0;i<noOfItration;i++){                       
                        Decimal ranvar=min1+(Math.random()*((max1-min1) ));   //genetating random variable here
                        ranvalforprob.add(ranvar);
                        sum1 +=ranvar;  // Holds the sum of all random variable  
                    }
                    mean1=sum1/noOfItration;                
                  
                   for(Decimal d : ranvalforprob){
                       squaredDifferencesSum1 += ((d-mean1)*(d-mean1));                       
                   }
                                      
                squaredDifferencesMean1 = squaredDifferencesSum1 /noOfItration;
                standardDeviation1 = Math.sqrt(squaredDifferencesMean1);
                
                pc.Probability_Mean__c = mean1;
                pc.Probability_SD__c = standardDeviation1 ;
              
              insertList.add(pc);
            }
        } 
         if (ProbabilityMapping__c.name.getDescribe().isCreateable() && ProbabilityMapping__c.Probability_Mean__c.getDescribe().isCreateable() && ProbabilityMapping__c.Probability_SD__c.getDescribe().isCreateable()) {
         insert insertList;
         }
        if (ProbabilityMapping__c.Probability_Mean__c.getDescribe().isUpdateable() && ProbabilityMapping__c.Probability_SD__c.getDescribe().isUpdateable()) {
         update updateList;
         }
       
    
} 
  
  global void calculatingMean(String type,Set<Id> idList)
{
List<MachineLearningRecord__c> machineLogic=[select Stage_Name__c,Counter__c,Time_Duration__c,Batch_Date_Time__c from MachineLearningRecord__c LIMIT 100];
DateTime endDate = System.Now();
          DateTime newDate=System.Now();

Map<String,Decimal> mapList=new Map<String,Decimal>();
Map<String,Integer> mapCountList=new Map<String,Integer>();
List<MachineLearningRecord__c> updateList=new List<MachineLearningRecord__c>();
List<MachineLearningRecord__c> insertList=new List<MachineLearningRecord__c>();
 if(type =='6months')
       {
          newDate = System.Now().addMonths(-6); 
       }
       if(type =='12months')
       {
          newDate = System.Now().addYears(-1); 
       }
       if(type =='24months')
       {
          newDate = System.Now().addYears(-2); 
       }
        if(type =='36months')
       {
          newDate = System.Now().addYears(-3); 
       }
        if(type =='schedule')
       {
          newDate = System.Now().addYears(-70); 
       }   
       List<StagesTimeDurationRecord__c> stagesRecordsOldList=new  List<StagesTimeDurationRecord__c>();
       if(type!=null)
       {  
stagesRecordsOldList=[select Stage_Name__c,Duration__c from StagesTimeDurationRecord__c where timePeriodFlow__c = :type and OpportunityId__c in :idList and stageDate__c > :newDate.Date() and stageDate__c <= :endDate.Date()];      
}
if(stagesRecordsOldList!=null)
{
for(StagesTimeDurationRecord__c sd : stagesRecordsOldList)
{
    
    if(mapList.get(sd.Stage_Name__c)!=null)
    {
        
        Decimal d=mapList.get(sd.Stage_Name__c);
        d=d+sd.Duration__c;
        mapList.put(sd.Stage_Name__c,d);
    }
    else
    {
        mapList.put(sd.Stage_Name__c,sd.Duration__c);
    }
    
    if(mapCountList.get(sd.Stage_Name__c)!=null)
    {
        
        Integer d=mapCountList.get(sd.Stage_Name__c);
        d=d+1;
        mapCountList.put(sd.Stage_Name__c,d);
    }
    else
    {
        mapCountList.put(sd.Stage_Name__c,1);
    }
}
}
for(MachineLearningRecord__c mcr : machineLogic)
{
    Boolean check=false;
    if(mapList.get(mcr.Stage_Name__c)!=null)
    {
        mcr.Time_Duration__c=mcr.Time_Duration__c+mapList.get(mcr.Stage_Name__c);
        check=true;
    }
    if(mapCountList.get(mcr.Stage_Name__c)!=null)
    {
        
        mcr.Counter__c=mcr.Counter__c+mapCountList.get(mcr.Stage_Name__c);
        check=true;
    }
    
    if(check)
        
        {
            updateList.add(mcr);
        }
    
    
}
       if (MachineLearningRecord__c.Time_Duration__c.getDescribe().isUpdateable() && MachineLearningRecord__c.Counter__c.getDescribe().isUpdateable()) {
              update updateList;
          }
          
          
          updateList=new List<MachineLearningRecord__c>();
         machineLogic=[select Stage_Name__c,Counter__c,Time_Duration__c,Batch_Date_Time__c from MachineLearningRecord__c LIMIT 100];
        List<StagesTimeDurationRecord__c> stagesRecords=[select Stage_Name__c,Duration__c from StagesTimeDurationRecord__c where timePeriodFlow__c = :type and stageDate__c > :newDate.Date() and stageDate__c <= :endDate.Date()];  
        Decimal stageMean=0.0;
        Decimal totalMean=0.0;
        Decimal totalDeviation=0.0;
        Decimal stageDeviation=0.0;
        List<TimeMapping__c> updateTimeList=new List<TimeMapping__c>();
        List<TimeMapping__c> insertTimeList=new List<TimeMapping__c>();
        System.debug(LoggingLevel.FINEST,'  ------  :::::::::   ------    machine learning-- '+machineLogic);
        Map<String, TimeMapping__c> timeMapForstage = TimeMapping__c.getAll();
        if(machineLogic.size()>0)
            {
                
                for(MachineLearningRecord__c record:machineLogic)
                {
                    record.Batch_Date_Time__c=date.today();
                    stageMean=record.Time_Duration__c/record.Counter__c;
                    totalMean=totalMean+stageMean;
                    System.debug(LoggingLevel.FINEST,'  ------  :::::::::   ------    stage mean-- '+stageMean);
                    stageDeviation=0.0;
                    for(StagesTimeDurationRecord__c sc : stagesRecords)
                    {
                    
                    if(String.valueOf(sc.Stage_Name__c).equals(String.valueOf(record.Stage_Name__c)))
                    {
                    
                     stageDeviation=stageDeviation+((sc.Duration__c-stageMean).pow(2));                 
                    
                    }
                    
                    
                    
                    }
                    if(record.Counter__c==1)
                    {
                        stageDeviation=0;
                    }
                    
                    else
                    {
                    stageDeviation=stageDeviation/(record.Counter__c-1);
                    stageDeviation=Math.sqrt(stageDeviation);
                    }
                   
                    
                     TimeMapping__c currentOppoStage = timeMapForstage.get(record.Stage_Name__c); 
                     if(currentOppoStage!=null)
                     {
                         currentOppoStage.Mean__c = stageMean;
                        currentOppoStage.Standard_Deviation__c = stageDeviation;
                         updateTimeList.add(currentOppoStage);
                      }
                      else
                      {
                      TimeMapping__c c=new TimeMapping__c();
                      c.Name=record.Stage_Name__c;
                      c.Mean__c = stageMean;
                        c.Standard_Deviation__c = stageDeviation;
                         insertTimeList.add(c);
                      }  
                       
                    totalDeviation=totalDeviation+stageDeviation;
                    stageMean=0.0;
                    
                    
                    System.debug(LoggingLevel.FINEST,'  ------  :::::::::   ------    total mean-- '+totalMean+' :::**** ---  total deviation'+totalDeviation);
                    
                    
                }
                   if (TimeMapping__c.Name.getDescribe().isCreateable() && TimeMapping__c.Mean__c.getDescribe().isCreateable() && TimeMapping__c.Standard_Deviation__c.getDescribe().isCreateable()) {
            insert insertTimeList;
          }
                
                
                 if (TimeMapping__c.Mean__c.getDescribe().isUpdateable() && TimeMapping__c.Standard_Deviation__c.getDescribe().isUpdateable()) {
             update  updateTimeList;
          }
                
                
               
                
            }
            
             Map<String, batch_processing_date__c> batch_processing_date = batch_processing_date__c.getAll();
                
                batch_processing_date__c bpc=batch_processing_date.get('batch_date');
                 if (batch_processing_date__c.batch_date__c.getDescribe().isUpdateable() && batch_processing_date__c.Batch_date_Time__c.getDescribe().isUpdateable()) {
                 if(bpc!=null)
                 {
                   bpc.batch_date__c=date.today();
                bpc.Batch_date_Time__c=DateTime.now();
                 System.Debug('batch Date Time - -: '+bpc.Batch_date_Time__c)  ; 
                update bpc;
                }
                 }
              
                
              
}
global void finish(Database.BatchableContext BC)  
{  
List<Configuration_Instruction__c> lst =Configuration_Instruction__c.getAll().values();

      lst[0].Machine_Pages_Visible__c=true;
      
      update lst[0];
      
Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
List<User> allUsers=new List<User>();
 
allUsers = [SELECT Id,Name,Email from User where name = :UserInfo.getName()];
String[] toaddress = new String[]{};
toaddress.add(allUsers[0].Email);
mail.setToAddresses(toaddress);
   mail.setPlainTextBody('Hello');
Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
      
        
            
}  
}