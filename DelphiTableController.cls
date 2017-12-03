/* 
 * Created By  : Jitendra Pratap Singh & Ranveer - Mirketa Inc.
*/

public with sharing class DelphiTableController{
    public List<TimeMapping__c> lstTimeMapping {get;set;} 
    public List<ProbabilityMapping__c> lstProbMapping {get;set;}
    public boolean flag{get;set;}
    public boolean flagSaveTabProb{get;set;}
    public String selectedVal{get;set;}
    public Boolean altCheck{get;set;}
    public List<Configuration_Instruction__c> lstConfigInstruction {get;set;}
    
    
    public boolean showActionPollar{get;set;}
    public boolean displayPopUp{get;set;}
    Integer count = 0;

    public Integer noOfItration = 1000;
    public decimal testSD {get; set;}
    public String testSDName {get; set;}
     public String stageList{get; set;}
    
    
        /*Constructor starts here*/
        public DelphiTableController(){
        displayPopUp = false;
         altCheck=false;
            init();
            showActionPollar = false;
         }
          
         /*Constructor ends here*/
         
         /*init method starts here */
         
         public void init(){
         
            lstTimeMapping = new List<TimeMapping__c>(); 
            lstProbMapping = new List<ProbabilityMapping__c>();
           
           
            Map<String, TimeMapping__c> mapTimeMappingAllValues = TimeMapping__c.getAll();           
            Map<String, ProbabilityMapping__c> mapProbMappingAllValues = ProbabilityMapping__c.getAll();
            
            lstConfigInstruction = Configuration_Instruction__c.getAll().values(); 
          
                             
            Schema.DescribeFieldResult fieldResult = opportunity.StageName.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            Set<String> parts = new Set<String>();
       /*     List<String> finalStageWithoutWonLostList = new List<String>();
            if(DelphiStages__c.getInstance('Closed Won') != null )
        {
            DelphiStages__c objDelphiStagesCS = DelphiStages__c.getInstance('Closed Won');
            stageList=objDelphiStagesCS.ClosedWonStages__c;
            stageList=stageList+','+objDelphiStagesCS.CloseLostStages__c;
            parts.addAll(stageList.split(','));
               System.debug(LoggingLevel.FINEST,'  ------  :::::::::   ------    stage list-- '+stageList);
        }  */
        
        /* for(Schema.PicklistEntry f : ple){  
         if(!parts.contains(f.getvalue()))
         {
         finalStageWithoutWonLostList.add(f.getvalue());
         }
         }  */
         
         List<OpportunityStage> osList=[SELECT DefaultProbability,MasterLabel FROM OpportunityStage where isActive=true LIMIT 100];
         
        for(OpportunityStage str:osList)
        {
        if(str.DefaultProbability!=100.0 && str.DefaultProbability!=0.0)
        {
        if(mapTimeMappingAllValues.containskey(str.MasterLabel)){
                        lstTimeMapping.add(mapTimeMappingAllValues.get(str.MasterLabel));
                    }
                    else{
                        TimeMapping__c objTimeMapp = new TimeMapping__c();
                        objTimeMapp.name = str.MasterLabel;
                        objTimeMapp.Max_Time__c = 0;
                        objTimeMapp.Min_Time__c = 0;
                        objTimeMapp.Mean__c = 0;
                        objTimeMapp.Standard_Deviation__c = 0;
                        lstTimeMapping.add(objTimeMapp);
                    }
                    
                    
                    
                    if(mapProbMappingAllValues.containskey(str.MasterLabel)){
                       lstProbMapping.add(mapProbMappingAllValues.get(str.MasterLabel));  
                    }
                    else{
                        ProbabilityMapping__c objProbMapp = new ProbabilityMapping__c();
                        objProbMapp.name = str.MasterLabel;
                        objProbMapp.Max_Probability__c = 0;
                        objProbMapp.Min_Probability__c = 0;
                        objProbMapp.Probability_Mean__c = 0;
                        objProbMapp.Probability_SD__c = 0;
                        lstProbMapping.add(objProbMapp);
                    }
                    
                    }
        }    
        
       
           /* for(Schema.PicklistEntry f : ple){
                if(f.getvalue()!='Closed Lost' && f.getvalue()!='Closed Won'){
                    if(mapTimeMappingAllValues.containskey(f.getvalue())){
                        lstTimeMapping.add(mapTimeMappingAllValues.get(f.getvalue()));
                    }
                    else{
                        TimeMapping__c objTimeMapp = new TimeMapping__c();
                        objTimeMapp.name = f.getvalue();
                        objTimeMapp.Max_Time__c = 0;
                        objTimeMapp.Min_Time__c = 0;
                        objTimeMapp.Mean__c = 0;
                        objTimeMapp.Standard_Deviation__c = 0;
                        lstTimeMapping.add(objTimeMapp);
                    }
                    if(mapProbMappingAllValues.containskey(f.getvalue())){
                       lstProbMapping.add(mapProbMappingAllValues.get(f.getvalue()));  
                    }
                    else{
                        ProbabilityMapping__c objProbMapp = new ProbabilityMapping__c();
                        objProbMapp.name = f.getvalue();
                        objProbMapp.Max_Probability__c = 0;
                        objProbMapp.Min_Probability__c = 0;
                        objProbMapp.Probability_Mean__c = 0;
                        objProbMapp.Probability_SD__c = 0;
                        lstProbMapping.add(objProbMapp);
                    }
                }
            } */
            
         }
         
         /*init method ends here */
        
    /*Main customisation buttons method starts here*/
   
    public void saveSetting(){
     displayPopUp = true;
     Boolean errorCheck=false;
            Map<String, TimeMapping__c> mapTimeMappingAllValues = TimeMapping__c.getAll();           
            Map<String, ProbabilityMapping__c> mapProbMappingAllValues = ProbabilityMapping__c.getAll();
            List<OpportunityStage> osList=[SELECT DefaultProbability,MasterLabel FROM OpportunityStage where isActive=false and DefaultProbability!=0.0 and DefaultProbability!=100.0 LIMIT 100];
            List<TimeMapping__c> timelistNew = new List<TimeMapping__c>(); 
            List<ProbabilityMapping__c> lstProbMapNew = new List<ProbabilityMapping__c>();
            
            for(OpportunityStage str:osList)
        {
                    if(mapTimeMappingAllValues.containskey(str.MasterLabel)){
                        TimeMapping__c objTimeMapp = mapTimeMappingAllValues.get(str.MasterLabel);
                        objTimeMapp.name = str.MasterLabel;
                        objTimeMapp.Max_Time__c = 0;
                        objTimeMapp.Min_Time__c = 0;
                        objTimeMapp.Mean__c = 0;
                        objTimeMapp.Standard_Deviation__c = 0;
                       
                        timelistNew.add(objTimeMapp);
                    }
                    
                     if(mapProbMappingAllValues.containskey(str.MasterLabel)){
                        ProbabilityMapping__c objProbMapp = mapProbMappingAllValues.get(str.MasterLabel);
                        objProbMapp.name = str.MasterLabel;
                        objProbMapp.Max_Probability__c = 0;
                        objProbMapp.Min_Probability__c = 0;
                        objProbMapp.Probability_Mean__c = 0;
                        objProbMapp.Probability_SD__c = 0;
                        
                        lstProbMapNew.add(objProbMapp);
                    }
                    
        }
        
        
        if(timelistNew.size()>0)
        {
         if (delphiDemo__TImeMapping__c.name.getDescribe().isUpdateable() && delphiDemo__TImeMapping__c.Min_Time__c.getDescribe().isUpdateable() && 
           delphiDemo__TImeMapping__c.Max_Time__c .getDescribe().isUpdateable() && delphiDemo__TImeMapping__c.Mean__c.getDescribe().isUpdateable() && delphiDemo__TImeMapping__c.Standard_Deviation__c.getDescribe().isUpdateable()) {
        update timelistNew;
        }
        }
        
         if(lstProbMapNew.size()>0)
        {
        
          if (delphiDemo__ProbabilityMapping__c.Max_Probability__c.getDescribe().isUpdateable() && delphiDemo__ProbabilityMapping__c.name.getDescribe().isUpdateable() && 
           delphiDemo__ProbabilityMapping__c.Min_Probability__c .getDescribe().isUpdateable() && delphiDemo__ProbabilityMapping__c.Probability_Mean__c.getDescribe().isUpdateable() && delphiDemo__ProbabilityMapping__c.Probability_SD__c.getDescribe().isUpdateable()) {
               update lstProbMapNew;
          }
       
        }
        
        try{
          
         showActionPollar = true;
         List<TimeMapping__c> timelist2 = new List<TimeMapping__c>();
       
         flagSaveTabProb = true;
         
         
         for(TimeMapping__c objTmpp: lstTimeMapping){
             Integer maxx = (Integer)objTmpp.Max_Time__c;
             Integer minn = (Integer)objTmpp.Min_Time__c;
             
                 if(minn > maxx)
                    {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Min Time can not be greater than Max Time'));
                     flagSaveTabProb = false;
                     flag = true;
                     errorCheck=true;
                     showActionPollar = false;
                     displayPopUp = false;
                    break;
                   
                    } else   
                    {
                        timelist2.add(objTmpp);
                                            
                    }                   
         }         
        
         if(timelist2.size()>0)           
           upsert timelist2;
      
         if(flagSaveTabProb)
         {
         
         List<ProbabilityMapping__c> lstProbMap = new List<ProbabilityMapping__c>();         
         for(ProbabilityMapping__c objProMap: lstProbMapping){
             Decimal maxx = objProMap.Max_Probability__c;
             Decimal minn = objProMap.Min_Probability__c;
             
             if(minn > maxx)
                    {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Min Probability can not be greater than Max Probability'));
                        flag = true;
                        showActionPollar = false;
                        displayPopUp = false;
                        errorCheck=true;                        
                        break;                 
                    }
                  
                 if(minn <= maxx )   
                    {
                    System.debug('>>>>>>>>>>>if>>>');
                       lstProbMap.add(objProMap);
                       flag = false;
                    }
                    else{
                     System.debug('>>>>>>>>>>>minn>>>'+minn);
                     System.debug('>>>>>>>>>>>maxx >>>'+maxx );
                    System.debug('>>>>>>>>>>>else>>>');
                    flag = true;
                    showActionPollar = false;
                    displayPopUp = false;
                    }                  
                   
            }
        
      if(lstProbMap.size()>0 )            
            upsert lstProbMap;
               
         }
       
        /*calculating mean and SD for time mapping starts*/
        List<TimeMapping__c> timelist = TimeMapping__c.getAll().values();
        List<TimeMapping__c> timelist1 = new List<TimeMapping__c>();
        List<Decimal> ranval = new List<Decimal>();
        List<ProbabilityMapping__c> probabilitylist = ProbabilityMapping__c.getAll().values();
        List<ProbabilityMapping__c> listProbMappForUpdate = new List<ProbabilityMapping__c>();
        List<Decimal> ranvalforprob = new List<Decimal>();
        
        System.debug('>>>>>>>>>>count>>>>>>'+count);
        System.debug('>>>>>>>>>>timelist.size()>>>>>>'+timelist.size());
        System.debug('>>>>>>>>>>flag >>>>>>'+flag );
            if(count<timelist.size() && !flag ){          
                flag = true;
                 for(Integer k=0;k<timelist.size();k++)
                { 
                TimeMapping__c tmrc =  timelist[k];
                ranval.clear();
                Integer max = (Integer)tmrc.Max_Time__c;
                Integer min = (Integer)tmrc.Min_Time__c;
                Decimal sum=0;
                Decimal squaredDifferencesSum = 0;
                Decimal mean=0;
                Decimal standardDeviation=0;
                Decimal squaredDifferencesMean=0;
                    for(Integer i=0;i<noOfItration;i++){                       
                        Decimal ranvar=min+(Math.random()*((max-min) ));   //genetating random variable here
                    ranval.add(ranvar);
                        sum +=ranvar;  // Holds the sum of all random variable  
                    }
                    mean=sum/noOfItration;                
                   
                   for(Decimal d : ranval){                   
                       squaredDifferencesSum += ((d-mean)*(d-mean));                       
                   }                   
                squaredDifferencesMean = squaredDifferencesSum /noOfItration;
                standardDeviation = Math.sqrt(squaredDifferencesMean); 
                
                
                if(tmrc!=null)
                {
                tmrc.Mean__c = mean;
                tmrc.Standard_Deviation__c = standardDeviation;
                 timelist1.add(tmrc); 
              //   update tmrc;    
                
                
                }
                 
                }    
            
             if (TimeMapping__c.Mean__c.getDescribe().isUpdateable() && TimeMapping__c.Standard_Deviation__c.getDescribe().isUpdateable()) {
             update timelist1;
             }
            /*calculating mean and SD for time mapping end*/ 
            
            /*calculating mean and SD for probability mapping starts*/   
               for(Integer k=0;k<probabilitylist.size();k++)
                {    
               ProbabilityMapping__c pmrc =  probabilitylist[k];
                ranvalforprob.clear();
                Decimal max1 = (Decimal)pmrc.Max_Probability__c;
                Decimal min1 = (Decimal)pmrc.Min_Probability__c;
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
                
               
                
                
                if(pmrc!=null)
                {
                pmrc.Probability_Mean__c = mean1;
                pmrc.Probability_SD__c = standardDeviation1 ;
                listProbMappForUpdate.add(pmrc);
             //   update pmrc;
                
                
                }
                
               }
               if (ProbabilityMapping__c.Probability_Mean__c.getDescribe().isUpdateable() && ProbabilityMapping__c.Probability_SD__c.getDescribe().isUpdateable()) {
              update listProbMappForUpdate;  
              }
              showActionPollar = false;
                displayPopUp = false;
                altCheck=true;   
               
           }
           else{
               
                showActionPollar = false;
                displayPopUp = false;
                altCheck=true;
           }
           /*calculating mean and SD for probability mapping end*/    
          count++;
          
          if(errorCheck)
          {
                showActionPollar = false;
                displayPopUp = false;
                altCheck=false;
                flag = true;
          }
          else
          {
          flag = false;
              Map<String, batch_processing_date__c> batch_processing_date = batch_processing_date__c.getAll();
                
                batch_processing_date__c bpc=batch_processing_date.get('batch_date');
                 if (batch_processing_date__c.batch_date__c.getDescribe().isUpdateable() && batch_processing_date__c.Batch_date_Time__c.getDescribe().isUpdateable()) {
                 
                   bpc.batch_date__c=date.today();
                bpc.Batch_date_Time__c=DateTime.now();
                 System.Debug('batch Date Time - -: '+bpc.Batch_date_Time__c)  ; 
                update bpc;
                 }
          
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
List<User> allUsers=new List<User>();
 
allUsers = [SELECT Id,Name,Email from User where name = :UserInfo.getName()];
Id templateId;  
templateId = [select id, name from EmailTemplate where Name = 'delphi email template'].id;

String[] toaddress = new String[]{};
toaddress.add(allUsers[0].Email);
mail.setToAddresses(toaddress);
mail.setTemplateId(templateId);
mail.setTargetObjectId(allUsers[0].Id);
mail.setSaveAsActivity(false);
Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
          }    
       
        }
        catch(exception e){      
        }        
    }  
    
    public void actionPollar(){
        //saveSetting();
        count = 0;
        showActionPollar = true;  
    }
    
     public void callErrorMethod(){
        //saveSetting();
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Min Probability can not be greater than Max Probability'));
    }    
   
    public void editSetting(){    
        flag = true;
        altCheck =false;
    }
    
  
    public  void cancelSetting(){
        init();
        flag=false;
        
    }
    public Pagereference backToHome(){       
         return new Pagereference('/home/home.jsp');
     }  
     
    public Pagereference goToGraph(){       
        return new Pagereference('/apex/DelphiGraphPage');
    }  
     
       public void updateDates(){
   
    System.Debug('The value is : ' + selectedVal);
    Decimal myDecimal = decimal.valueOf(selectedVal);
    UserMachineLearningBatch um=new UserMachineLearningBatch(myDecimal );
    um.mainFunction();
   
         
    }
    
    

       public List<SelectOption> getbackWardList(){
       selectedVal='1/2';
        List<SelectOption> optns = new List<Selectoption>();
        // before getting here you must populate your queryResult list with required fields
        
           optns.add(new selectOption('0.5','6 months'));
           optns.add(new selectOption('1','12 months'));
           optns.add(new selectOption('2','2 year'));
           optns.add(new selectOption('3','3 year'));         

        return optns;
}
     
     
}