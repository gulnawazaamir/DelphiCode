/*
    Class with Five graphs 
*/    
      public with sharing class DelphiGraphs{
    public List<Opportunity> tempOppList = new List<Opportunity>();
    public List<date> tempdateList = new List<date>();
    public List<Integer> diffenceMueAndSigma = new List<Integer>();
    public List<Integer> ageOfOpportunity = new List<Integer>();
    public List<Integer> numberOfdays = new List<Integer>();
    public List<Integer> opportunitysyAgeDays {get; set;}
    public List<barGraph> dataListForBarGraph{get; set;}
    public List<exportBarGraph> dataListForExportBarGraph  {get; set;}
  
    public boolean displayPopUp{get;set;}    
    
    public List<SelectOption> confidenceIntervel {get;set;}
    public List<Account> lstAccount {get;set;}
    public List<Account> lstBottomAccount {get;set;}
    Public Date times {get; set;}
    Public String topAccountId {get; set;}
    Public String bottomAccountId {get; set;}
    public String confilterOne{get;set;}
    public String confilterTwo {get;set;}
    public String confilterThree {get;set;}
    public String confilterFour {get;set;}
    public String confilterFive {get;set;}
    public String selectedOptionRev {get;set;}
    public String selectedOptnForAcnt  {get;set;}
    public String selectedOptnForBottomAcnt {get;set;}
    public String selectedOptnForTopPerformer {get;set;}
    public String selectedOptnForTopOpp {get;set;}    
    public List<SelectOption> optionList {get;set;}   
    public List<SelectOption> optionListOpportunity {get;set;}
    public List<sortedListTopOpportunity> wrapperListForTopOpportunities {get; set;}
    public List<sortedListTopAcct> wrapperListForAcntAmount {get; set;}
    public List<sortedListBottomAcct> wrapperListForBottomAmount {get; set;}
    public List<sortedListTopperformer> wrapperListForTopPerformer {get; set;}
    public String selOptnForOppo {get;set;}
    Public Boolean monList {get; set;}
    public List<SelectOption> month {get;set;}
    public String mon {get;set;}
    public List<Opportunity> lstOpportunityExport {get;set;}    
    map<String,List<Opportunity>> mapforRevnueData = new map<String,List<Opportunity>>();
    public String monthName{get;set;}
    public List<opportunity> oppFordata {get;set;}
    
    public List<expectedAmountCaculate> lstWrapper{get; set;}
    public List<expectedAmountCaculate> lstWrapper1{get; set;}    
    public Date oppoComplettionDate = Date.Today();
    Date enddatefor12months = (date.today()).addMonths(12);
    private Map<String, List<Opportunity>> mapMonthToLstOpportunity = new Map<String, List<Opportunity>>();
    private Map<String, List<Opportunity>> mapMonthToLstOpportunity1 = new Map<String, List<Opportunity>>();
    @TestVisible
    private DateTime previousBatchDate{get;set;}
    Public Boolean refreshCheck{get; set;}
    public DelphiGraphs(){
        selectedOptionRev = '12mon';
        selectedOptnForAcnt  = '12mon';
        selectedOptnForBottomAcnt = '12mon';
        selectedOptnForTopPerformer = '12mon';
        selectedOptnForTopOpp = '12mon';
        times = date.today();
    //    refreshCheck=false;
       
        
        confilterOne = '68';
        confilterTwo = '68';
        confilterThree = '68';
        confilterFour = '68';
        confilterFive = '68';
        selOptnForOppo = '12mon';
        
        dataListForBarGraph = new List<bargraph>();
        dataListForExportBarGraph = new List<exportBarGraph>();
      
        confidenceIntervel = new List<SelectOption>();
        confidenceIntervel.add(new SelectOption('68','68%'));
        confidenceIntervel.add(new SelectOption('95','95%'));
        confidenceIntervel.add(new SelectOption('99','99%'));
        optionList = new List<SelectOption>();        
        optionList.add(new SelectOption('12mon','12 Months'));
        optionList.add(new SelectOption('24mon','24 Months'));
        
        optionListOpportunity = new List<SelectOption>();
        optionListOpportunity.add(new SelectOption('mon','Monthly'));
        optionListOpportunity.add(new SelectOption('12mon','12 Months'));
        optionListOpportunity.add(new SelectOption('24mon','24 Months'));
        monList = false;
        
        mon = '-Select-';
        month = new List<SelectOption>();
        month.add(new SelectOption('','-Select-'));
        month.add(new SelectOption('Jan','Jan'));
        month.add(new SelectOption('Feb','Feb'));
        month.add(new SelectOption('Mar','Mar'));
        month.add(new SelectOption('Apr','Apr'));
        month.add(new SelectOption('May','May'));
        month.add(new SelectOption('Jun','Jun'));
        month.add(new SelectOption('Jul','Jul'));
        month.add(new SelectOption('Aug','Aug'));
        month.add(new SelectOption('Sep','Sep'));
        month.add(new SelectOption('Oct','Oct'));
        month.add(new SelectOption('Nov','Nov'));
        month.add(new SelectOption('Dec','Dec')); 
        getData();
        
    }
    
    public void getData(){
    
        List<Confidence_level_and_month__c> confidenceIntervel1 = Confidence_level_and_month__c.getAll().values();
        
        confilterOne = confidenceIntervel1[0].Confidence_Level__c;
        confilterTwo = confidenceIntervel1[0].Confidence_Level_Two__c;
        confilterThree = confidenceIntervel1[0].Confidence_Level_Three__c;
        confilterFour = confidenceIntervel1[0].Confidence_Level_Four__c;
        confilterFive = confidenceIntervel1[0].Confidence_Level_Five__c;
   
        dataListForBarGraph = new List<bargraph>();
       
        wrapperListForAcntAmount = new List<sortedListTopAcct>();
        wrapperListForBottomAmount = new List<sortedListBottomAcct>();
        wrapperListForTopPerformer = new List<sortedListTopperformer>();
        wrapperListForTopOpportunities = new List<sortedListTopOpportunity>();
        Map<String, TimeMapping__c> timeMapForstage = TimeMapping__c.getAll();
        Map<String, ProbabilityMapping__c> probMapForStage = ProbabilityMapping__c.getAll();
        map<String,Decimal> mapforbarGraph = new map<String,Decimal>();
        map<string,Decimal> mapfortopaccount = new map<string,Decimal>();        
        map<string,Decimal> mapforbottomaccount = new map<string,Decimal>();
        map<string,Decimal> mapfortopPerformer = new map<string,Decimal>();
        map<String,Decimal> mapfortopOpportunities = new map<String,Decimal>();
        map<decimal,map<integer,string>> mapofshorting = new  map<decimal,map<integer,string>>();
               
        List<opportunity> alloppo = [select id,StageName,Amount,name,Accountid,account.name,account.owner.name,Completion_Date__c,owner.name,(SELECT Amount,CloseDate,CreatedDate,OpportunityId,Probability,StageName FROM OpportunityHistories ORDER BY CreatedDate DESC) from opportunity where Probability!=0.0 and Probability!=100.0 ORDER BY CreatedDate DESC];
        opportunitysyAgeDays = new List<Integer>();
        set<string> accids = new  set<string>();
        set<string> oppIds = new  set<string>();
        Boolean checkOppId=false;
        for(opportunity opp : alloppo){
            accids.add(opp.accountid);
            oppIds.add(opp.id);
        }
       
        map<id,account> mapofaccount  = new map<id,account>([select id,name,fax,owner.name from account where id in : accids]);
        map<id,opportunity> mapofOpportunity  = new map<id,opportunity>([select id,name,stageName,Owner.name  from opportunity where id in : oppIds]);
        map<id,String> mapIdToCompletedDate = new map<id,String> ();
        
        System.Debug(' ::::::   allopo size... '+alloppo.size());    
        for(Opportunity op : alloppo ){
                
                System.Debug(' ::::::   opp stage name '+op.stageName);         
                TImeMapping__c currentOppoStage = timemapforstage.get(op.stagename);  
                ProbabilityMapping__c currentProb = probmapforstage.get(op.stagename);      
                Integer ageOfOpportunityStage = 0;
                Date oppoComplettionDate = Date.Today();                
                datetime lastChangeDateTime = datetime.now();
                for(OpportunityHistory oh:  op.OpportunityHistories){
                    if(oh.stagename == op.stagename)
                        lastChangeDateTime  = oh.CreatedDate;
                    else
                        break;                    
                }
               
                ageOfOpportunityStage  = lastChangeDateTime.date().daysBetween(date.today());  
               
                
        /* Data in Map for graph Revenue Forcaste Start*/
                      
                if(ageOfOpportunity(currentOppoStage,currentProb,ageOfOpportunityStage,confilterOne,op).noOfDays>=0.0 && ageOfOpportunity(currentOppoStage,currentProb,ageOfOpportunityStage,confilterOne,op).noOfDays <=365*(selectedOptionRev=='12mon'?1:2)){
                   expectedAmountCaculate newobj = ageOfOpportunity(currentOppoStage,currentProb,ageOfOpportunityStage,confilterOne,op);               
                                     Date dateofwontime = date.today().adddays(newobj.noOfDays);
                    if(dateofwontime < date.today())
                       dateofwontime = date.today();            
                     String mapkey = convertdateinString(dateofwontime);
                    
                     decimal mapkeysh  = dateofwontime.year(); 
                       if(!mapofshorting.containskey(mapkeysh))
                           mapofshorting.put(mapkeysh ,new map<integer,string>());
                       mapofshorting.get(mapkeysh).put(dateofwontime.month(),mapkey);                                                                 
                     
                     if(!mapforbarGraph.containsKey(mapkey))
                         mapforbarGraph.put(mapkey,0);
                     Decimal revenue = mapforbarGraph.get(mapkey);       
                    mapforbarGraph.put(mapkey,revenue + (newobj.expectedAmount!=null?newobj.expectedAmount:0));                    
                   
                    if(mapMonthToLstOpportunity.containsKey(mapkey))
                       {    
                    for(Opportunity ops : mapMonthToLstOpportunity.get(mapkey))
                    {
                        
                        if(ops.id==op.id)
                        {
                            checkOppId=true;
                        }
                    }
                    if(!checkOppId)
                    {
                        mapMonthToLstOpportunity.get(mapkey).add(op);
                    }
                     }  
                    else
                        mapMonthToLstOpportunity.put(mapkey, new List<Opportunity>{op});  
                                                   
                }
                
             for(String sr : mapMonthToLstOpportunity.keySet())
             {
               System.Debug('debug - '+sr+' size '+mapMonthToLstOpportunity.get(sr).size());
               
             }   
                
       /* Data in Map for graph Revenue Forcaste End*/
               
       /* Data in Map for graph Top Accounts Start */
                if(ageOfOpportunity(currentOppoStage,currentProb,ageOfOpportunityStage,confilterTwo,op).noOfDays>=0.0 && ageOfOpportunity(currentOppoStage,currentProb,ageOfOpportunityStage,confilterTwo,op).noOfDays <=365*(selectedOptnForAcnt  =='12mon'?1:2)){
                 expectedAmountCaculate newobj = ageOfOpportunity(currentOppoStage,currentProb,ageOfOpportunityStage,confilterTwo,op);                 
                     if(!mapfortopaccount.containsKey(op.accountid))
                         mapfortopaccount.put(op.accountid,0);
                     Decimal revenue = mapfortopaccount.get(op.accountid);                    
                     mapfortopaccount.put(op.accountid,revenue + (newobj.expectedAmount!=null?newobj.expectedAmount:0));                   
                } 
               
       /* Data in Map for graph Top Accounts End */ 
      
       /* Data in Map for graph Bottom Accounts Start*/
                if(ageOfOpportunity(currentOppoStage,currentProb,ageOfOpportunityStage,confilterThree,op).noOfDays>=0.0 && ageOfOpportunity(currentOppoStage,currentProb,ageOfOpportunityStage,confilterThree,op).noOfDays <=365*(selectedOptnForBottomAcnt =='12mon'?1:2)){
                 expectedAmountCaculate newobj = ageOfOpportunity(currentOppoStage,currentProb,ageOfOpportunityStage,confilterThree,op);                 
                     if(!mapforbottomaccount.containsKey(op.accountid))
                         mapforbottomaccount.put(op.accountid,0);
                     Decimal revenue = mapforbottomaccount.get(op.accountid);                    
                     mapforbottomaccount.put(op.accountid,revenue + (newobj.expectedAmount!=null?newobj.expectedAmount:0));                   
                }
                System.debug(':::::::::mapforbottomaccount:::::'+mapforbottomaccount.size()); 
       /* Data in Map for graph Bottom Accounts End*/ 
       
       /* Data in Map for graph Top Performer Start*/
                if(ageOfOpportunity(currentOppoStage,currentProb,ageOfOpportunityStage,confilterFour,op).noOfDays>=0.0 && ageOfOpportunity(currentOppoStage,currentProb,ageOfOpportunityStage,confilterFour,op).noOfDays <=365*(selectedOptnForTopPerformer =='12mon'?1:2)){
                 expectedAmountCaculate newobj = ageOfOpportunity(currentOppoStage,currentProb,ageOfOpportunityStage,confilterFour,op);                
                     if(!mapfortopPerformer.containsKey(op.owner.name))
                         mapfortopPerformer.put(op.owner.name,0);
                     Decimal revenue = mapfortopPerformer.get(op.owner.name);                    
                     mapfortopPerformer.put(op.owner.name,revenue + (newobj.expectedAmount!=null?newobj.expectedAmount:0));                     
                } 
       /* Data in Map for graph Top Performer End*/     
      
       /* Data in Map for graph Top Opportunities Start*/
                if(selectedOptnForTopOpp !='mon'){
                    monList = false;
                    if(ageOfOpportunity(currentOppoStage,currentProb,ageOfOpportunityStage,confilterFive,op).noOfDays>=0.0 && ageOfOpportunity(currentOppoStage,currentProb,ageOfOpportunityStage,confilterFive,op).noOfDays <=365*(selectedOptnForTopOpp =='12mon'?1:2)){
                         expectedAmountCaculate newobj = ageOfOpportunity(currentOppoStage,currentProb,ageOfOpportunityStage,confilterFive,op); 
                         String dateofwontime1 = String.valueOf(date.today().adddays(newobj.noOfDays));                                                           
                         if(!mapfortopOpportunities.containsKey(op.id))
                             mapfortopOpportunities.put(op.id,0);
                         Decimal revenue = mapfortopOpportunities.get(op.id);                    
                         mapfortopOpportunities.put(op.id,revenue + (newobj.expectedAmount!=null?newobj.expectedAmount:0));
                         mapIdToCompletedDate.put(op.id,dateofwontime1);
                                  
                    }
                }else{
                    monList = true;
                     expectedAmountCaculate newobj = ageOfOpportunity(currentOppoStage,currentProb,ageOfOpportunityStage,confilterFive,op);
                     date dateofwontime = date.today().adddays(newobj.noOfDays);                
                     String mapkey = convertdateinString(dateofwontime);
                    if(mapkey.contains(mon)){                                         
                         if(!mapfortopOpportunities.containsKey(op.id))
                             mapfortopOpportunities.put(op.id,0);
                         Decimal revenue = mapfortopOpportunities.get(op.id);                    
                         mapfortopOpportunities.put(op.id,revenue + (newobj.expectedAmount!=null?newobj.expectedAmount:0));                        
                        
                         tempOppList.add(op);   
                         tempdateList.add(dateofwontime );                                               
                         diffenceMueAndSigma.add(ageOfOpportunity(currentOppoStage,currentProb,ageOfOpportunityStage,confilterFive,op).noOfDays +ageOfOpportunityStage );
                         ageOfOpportunity.add(ageOfOpportunityStage );
                         numberOfdays.add(ageOfOpportunity(currentOppoStage,currentProb,ageOfOpportunityStage,confilterFive,op).noOfDays);                    
                         
                    }
                  
                }
                
       /* Data in Map for graph Top Opportunities End*/ 
        
         
          } // for loop End
          
       /*  Add Data in list to show in Page for Top account Graph Start   */
          
          map<Decimal,list<sortedListTopAcct>> tempMapfortop10Account = new map<Decimal,list<sortedListTopAcct>>();
          list<Decimal> Templist = new list<Decimal>();
          for(string key : mapfortopaccount.keyset()){          
              if(mapfortopaccount.get(key)>0){
                  if(!tempMapfortop10Account.containsKey(mapfortopaccount.get(key)))
                      tempMapfortop10Account.put(mapfortopaccount.get(key),new list<sortedListTopAcct>());
                   tempMapfortop10Account.get(mapfortopaccount.get(key)).add(new sortedListTopAcct(mapfortopaccount.get(key),mapofaccount.get(key)));                    
              }
          }
          Templist.addall(tempMapfortop10Account.keyset());
          Templist.sort();
          
          for(Integer i=Templist.size();i>0;i--){
              for(sortedListTopAcct obj : tempMapfortop10Account.get(Templist[i-1])){
                 if(wrapperListForAcntAmount.size()<10)
                      wrapperListForAcntAmount.add(obj);                                                     
              }
          }
        /*  Add Data in list to show in Page for Top account Graph End   */   
        
        /*  Add Data in list to show in Page for bottom account Graph Start   */
        
          map<Decimal,list<sortedListBottomAcct>> tempMapforbottomAccount = new map<Decimal,list<sortedListBottomAcct>>();
          list<Decimal> TemplistforBottom = new list<Decimal>();
          for(string key : mapforbottomaccount.keyset()){         
              if(mapforbottomaccount.get(key)>0){
                  if(!tempMapforbottomAccount.containsKey(mapforbottomaccount.get(key)))
                      tempMapforbottomAccount.put(mapforbottomaccount.get(key),new list<sortedListBottomAcct>());
                   tempMapforbottomAccount.get(mapforbottomaccount.get(key)).add(new sortedListBottomAcct(mapforbottomaccount.get(key),mapofaccount.get(key)));                    
              }
          }
          TemplistforBottom.addall(tempMapforbottomAccount.keyset());
          TemplistforBottom.sort();
         
          for(Integer i=0;i<10;i++){
            if(TemplistforBottom.size() > i){            
                for(sortedListBottomAcct obj : tempMapforbottomAccount.get(TemplistforBottom[i])){
                  if(wrapperListForBottomAmount.size()<10)
                      wrapperListForBottomAmount.add(obj);              
              }
            }
          }
    
        /*  Add Data in list to show in Page for bottom account Graph End   */  
        
        
         /*  Add Data in list to show in Page for Top Per Performer Graph Start   */        
          
          map<Decimal,list<sortedListTopperformer>> tempMapfortopPerformer = new map<Decimal,list<sortedListTopperformer>>();
          list<Decimal> TemplistTopPerf = new list<Decimal>();
          for(string key : mapfortopPerformer.keyset()){          
              if(mapfortopPerformer.get(key)>0){
                  if(!tempMapfortopPerformer.containsKey(mapfortopPerformer.get(key)))
                      tempMapfortopPerformer.put(mapfortopPerformer.get(key),new list<sortedListTopperformer>());
                   tempMapfortopPerformer.get(mapfortopPerformer.get(key)).add(new sortedListTopperformer(mapfortopPerformer.get(key),key));                    
              }
          }
          TemplistTopPerf.addall(tempMapfortopPerformer.keyset());
          TemplistTopPerf.sort();
          
          for(Integer i=TemplistTopPerf.size();i>0;i--){
              for(sortedListTopperformer obj : tempMapfortopPerformer.get(TemplistTopPerf[i-1])){
                 if(wrapperListForTopPerformer.size()<10)
                      wrapperListForTopPerformer.add(obj);                                                     
              }
          }
       
        /*  Add Data in list to show in Page for Top Per Performer Graph End   */
        
            
      /*  Add Data in list to show in Page for Top Opportunities Graph Start   */
         
         map<Decimal,list<sortedListTopOpportunity>> tempMapfortop20Opportunities = new map<Decimal,list<sortedListTopOpportunity>>();
          list<Decimal> TemplistOpportunities = new list<Decimal>();
          for(String key : mapfortopOpportunities.keyset()){
          if(mapfortopOpportunities.get(key) >0){
              if(!tempMapfortop20Opportunities.containsKey(mapfortopOpportunities.get(key)))
                  tempMapfortop20Opportunities.put(mapfortopOpportunities.get(key),new list<sortedListTopOpportunity>());
               tempMapfortop20Opportunities.get(mapfortopOpportunities.get(key)).add(new sortedListTopOpportunity(mapfortopOpportunities.get(key),mapofOpportunity.get(key),mapIdToCompletedDate.get(key)));                     
              }
          }
          TemplistOpportunities.addall(tempMapfortop20Opportunities.keyset());
          TemplistOpportunities.sort();
          
          for(Integer i=TemplistOpportunities.size();i>0;i--){
              for(sortedListTopOpportunity obj : tempMapfortop20Opportunities.get(TemplistOpportunities[i-1])){                 
                  if(wrapperListForTopOpportunities.size()<20)
                      wrapperListForTopOpportunities.add(obj);                                                              
              }
              
          }
          
      /*  Add Data in list to show in Page for Top Opportunities Graph End   */ 
          
      /* Add Data in list to show in Page for Revenue Forcast Graph Start */    
      list<decimal> listoftempset = new list<decimal>();
      listoftempset.addall(mapofshorting.keyset());
      listoftempset.sort();
      for(integer i=0;i<listoftempset.size();i++){
          list<integer> lisoftempmonth = new list<integer>();
          lisoftempmonth.addall(mapofshorting.get(listoftempset[i]).keyset());
          lisoftempmonth.sort();
          for(integer j=0;j<lisoftempmonth.size();j++){                    
                if(mapforbarGraph.get(mapofshorting.get(listoftempset[i]).get(lisoftempmonth[j]))>0 ){
                    if(dataListForBarGraph.size()<10){          
                        dataListForBarGraph.add(new barGraph(mapofshorting.get(listoftempset[i]).get(lisoftempmonth[j]),mapforbarGraph.get(mapofshorting.get(listoftempset[i]).get(lisoftempmonth[j]))));                                          
                    }
                }
            }
      }
                  
       /* Add Data in list to show in Page for Revenue Forcast Graph End */  
       
       /* Clear the Map Values Start*/  
       
          mapforbarGraph.clear();
          mapfortopaccount.clear();
          mapforbottomaccount.clear();
          tempMapfortopPerformer.clear();    
          mapfortopOpportunities.clear(); 
          
      /* Clear the Map Values End */     
     
      }
      
      /* Checking update for new Values of Mean and Sigma Start*/
      public void checkNewValues()
      {
        Map<String, batch_processing_date__c> batch_processing_date = batch_processing_date__c.getAll();
                
                batch_processing_date__c bpc=batch_processing_date.get('batch_date');
                
               if(bpc!=null && bpc.Batch_date_Time__c!=null)
               {
               if(previousBatchDate!=null)
               {
              
                
               integer intDays =  previousBatchDate.Date().daysBetween(bpc.Batch_date_Time__c.Date());
               datetime sameDayEndDate = previousBatchDate.addDays(intDays);
                
               decimal decHours = ((bpc.Batch_date_Time__c.getTime())/1000/60/60) - ((sameDayEndDate.getTime())/1000/60/60);


               decimal decMinutes = ((bpc.Batch_date_Time__c.getTime())/1000/60) - ((sameDayEndDate.getTime())/1000/60);
               System.debug('aa - '+bpc.Batch_date_Time__c.getTime());
               System.debug('bb - '+sameDayEndDate.getTime());
               if((bpc.Batch_date_Time__c.getTime()-sameDayEndDate.getTime())>0)
               {
               refreshCheck=true;
               previousBatchDate=bpc.Batch_date_Time__c;
               }
               else
               {
                refreshCheck=false;
               }
               }
               else
               {
               previousBatchDate=bpc.Batch_date_Time__c;
               refreshCheck=false;
               }
               }
      }
       /* Checking update for new Values of Mean and Sigma End*/
      
    /*date conversion method start*/
        public String convertdateinString(date temp){
        if(temp < date.today())
            temp = date.today();        
        date recievedate = temp;
        String  dateinStringformat = null;
            
            if(recievedate.month()==1){               
               dateinStringformat =  'Jan' + ' ' + (recievedate.year().format()).right(2);
            }            
            if(recievedate.month()==2){               
               dateinStringformat =  'Feb' + ' ' + (recievedate.year().format()).right(2);
            }            
            if(recievedate.month()==3){               
               dateinStringformat =  'Mar' + ' ' + (recievedate.year().format()).right(2);
            }            
            if(recievedate.month()==4){               
               dateinStringformat =  'Apr' + ' ' + (recievedate.year().format()).right(2);
            }            
            if(recievedate.month()==5){               
               dateinStringformat =  'May' + ' ' + (recievedate.year().format()).right(2);
            }          
            if(recievedate.month()==6){
               
               dateinStringformat =  'Jun' + ' ' + (recievedate.year().format()).right(2);
            }            
            if(recievedate.month()==7){               
               dateinStringformat =  'Jul' + ' ' + (recievedate.year().format()).right(2);
            }            
            if(recievedate.month()==8){               
               dateinStringformat =  'Aug' + ' ' + (recievedate.year().format()).right(2);
            }            
            if(recievedate.month()==9){               
               dateinStringformat =  'Sep' + ' ' + (recievedate.year().format()).right(2);
            }            
            if(recievedate.month()==10){               
               dateinStringformat =  'Oct' + ' ' + (recievedate.year().format()).right(2);
            }            
            if(recievedate.month()==11){               
               dateinStringformat =  'Nov' + ' ' + (recievedate.year().format()).right(2);
            }            
            if(recievedate.month()==12){               
               dateinStringformat =  'Dec' + ' ' + (recievedate.year().format()).right(2);
            }        
        return dateinStringformat ; 
        
        }
    
    /*date conversion method end*/
    
    public expectedAmountCaculate ageOfOpportunity(TImeMapping__c currentOppoStage, ProbabilityMapping__c currentProb,Integer ageOfOpportunityStage,String confinter,opportunity op){
       Integer numOfDays=0;
       Decimal expectedAmount  = 0;
       if(currentOppoStage!=null ){ // && currentProb!=null
           if(confinter=='68'){      
               numOfDays = (Integer)(currentOppoStage.Mean__c - currentOppoStage.Standard_Deviation__c) - ageOfOpportunityStage ;
               
               if(op.Amount!=null ){
                   expectedAmount = (currentProb.Probability_Mean__c - currentProb.Probability_SD__c ) * op.Amount;
               }
           }
           if(confinter=='95'){
           
               numOfDays = (Integer)(currentOppoStage.Mean__c - (2*currentOppoStage.Standard_Deviation__c)) - ageOfOpportunityStage ;
               
               if(op.Amount!=null ){
                   expectedAmount = (currentProb.Probability_Mean__c - (2*currentProb.Probability_SD__c) ) * op.Amount;
               }
           }
           if(confinter=='99'){
           
               numOfDays = (Integer)(currentOppoStage.Mean__c - (3*currentOppoStage.Standard_Deviation__c)) - ageOfOpportunityStage ;
              
               if(op.Amount!=null){
                   expectedAmount = (currentProb.Probability_Mean__c - (3*currentProb.Probability_SD__c) ) * op.Amount;
              }
           }
       }
       expectedAmountCaculate newobj = new expectedAmountCaculate(expectedAmount.setscale(2) ,numOfDays);
        System.debug('opp name -- '+op.name+' ---- no of days -- '+newobj.noOfDays+' filter -- '+confinter); 
        Date dateofwontime = date.today().adddays(newobj.noOfDays);
         System.debug('dateofwontime '+dateofwontime); 
       return newobj ;
    
    }
    
        public void saveconfandmon(){
       
            List<Confidence_level_and_month__c> confidenceIntervel = Confidence_level_and_month__c.getAll().values();       
           
            if (Confidence_level_and_month__c.Confidence_Level__c.getDescribe().isUpdateable()) {
               if(confidenceIntervel!=null && confidenceIntervel.size()>0)
               {
               confidenceIntervel[0].Confidence_Level__c = confilterOne;
               update confidenceIntervel ;
                getData(); 
                
                }
          }           
            
           
        }
    
    
        public void saveconfandmontwo(){
        
            List<Confidence_level_and_month__c> confidenceIntervel = Confidence_level_and_month__c.getAll().values();            
           
            
            if (Confidence_level_and_month__c.Confidence_Level_Two__c.getDescribe().isUpdateable()) {
               if(confidenceIntervel!=null && confidenceIntervel.size()>0)
               {
               confidenceIntervel[0].Confidence_Level_Two__c= confilterTwo;
               update confidenceIntervel ;
                getData(); 
                
                }
          }              
            
          }
          
          public void saveconfandmonthree(){
        
            List<Confidence_level_and_month__c> confidenceIntervel = Confidence_level_and_month__c.getAll().values();            
            
            
                if (Confidence_level_and_month__c.Confidence_Level_Three__c.getDescribe().isUpdateable()) {
               if(confidenceIntervel!=null && confidenceIntervel.size()>0)
               {
               confidenceIntervel[0].Confidence_Level_Three__c= confilterthree;
               update confidenceIntervel ;
                getData(); 
                
                }
          }
          }
          
          public void saveconfandmonfour(){
        
            List<Confidence_level_and_month__c> confidenceIntervel = Confidence_level_and_month__c.getAll().values();            
           
            
                 if (Confidence_level_and_month__c.Confidence_Level_Four__c.getDescribe().isUpdateable()) {
               if(confidenceIntervel!=null && confidenceIntervel.size()>0)
               {
               confidenceIntervel[0].Confidence_Level_Four__c= confilterFour;
               update confidenceIntervel ;
                getData(); 
                
                }
          }
          }
          
          public void saveconfandmonFive(){
        
            List<Confidence_level_and_month__c> confidenceIntervel = Confidence_level_and_month__c.getAll().values();            
            
            
               if (Confidence_level_and_month__c.Confidence_Level_Five__c.getDescribe().isUpdateable()) {
               if(confidenceIntervel!=null && confidenceIntervel.size()>0)
               {
               confidenceIntervel[0].Confidence_Level_Five__c= confilterFive;
               update confidenceIntervel ;
                getData(); 
                
                }
          }
          }
          
          public void selOptnForOppomtd(){
          
         if(selOptnForOppo =='mon'){
           monList = true;
           mon = '-Select-';
             } 
         else {
           monList = false;
          }
           
        }  
    
     /*Wrapper Class Start*/
     
      /*  Wrapper Class for Revenue Forcast Start */
        public class barGraph{
            public String month { get; set; }  
            public Decimal expectedRevenue{ get; set; }  
           
                public bargraph(String month, Decimal expectedRevenue){  
                    this.month = month;  
                    this.expectedRevenue = expectedRevenue;
                    
                }  
        }
        
        /*  Wrapper Class for Revenue Forcast End */
        /*  Wrapper Class for Export Revenue Forcast Start */
        public class exportBarGraph{
            public String month { get; set; }  
            public Decimal expectedRevenue{ get; set; }
            public opportunity objOpp{ get; set; }  
           
                public exportBarGraph(String month, Decimal expectedRevenue){  
                    this.month = month;  
                    this.expectedRevenue = expectedRevenue;
                    
                    
                }  
        }
        /*  Wrapper Class for Export Revenue Forcast End */
        
        /*  Wrapper Class for Top Account Start */
        
        
        public class sortedListTopAcct{
            public double eamount {get; set;}
            public account acc{get;set;}
                    public sortedListTopAcct(Decimal eamount,account onames){                   
                    this.acc = onames;
                    this.eamount = eamount;           
                   }
        }       
        
        /*  Wrapper Class for Top Account Start */
        
        /*  Wrapper Class for Bottom Account Start */
       
        
        public class sortedListBottomAcct{
            public double eamount {get; set;}
            public account acc{get;set;}
                    public sortedListBottomAcct(Decimal eamount,account onames){                   
                    this.acc = onames;
                    this.eamount = eamount;           
                   }
        }
        
        /*  Wrapper Class for Bottom Account End*/
        
        /*  Wrapper Class for Top Performer Start */
        
        public class sortedListTopperformer{
            public double eamount {get; set;}
            public string onames{get;set;}
                    public sortedListTopperformer(Decimal eamount,string onames){                   
                    this.onames = onames;
                    this.eamount = eamount;           
                   }
        }
        
        /*  Wrapper Class for Top Performer Account End */
        
        
        /*  Wrapper Class for Top Opportunity Start */
        
        public class sortedListTopOpportunity{
            public double eamount {get; set;}
            public Opportunity opps{get;set;}
            public string opCompletedDate{get;set;}
                    public sortedListTopOpportunity(Decimal eamount,Opportunity onames,string opCompletedDate){                   
                    this.opps = onames;
                    this.eamount = eamount; 
                    this.opCompletedDate = opCompletedDate;           
                   }
        }
        
        /*  Wrapper Class for Top Opportunity Account End */
        
        public class expectedAmountCaculate{
            public Decimal expectedAmount {get; set;}
            public Integer noOfDays{get; set;}
            public Opportunity objOpportunity{get; set;}
            public String conversionMonth{get; set;}
            
                public expectedAmountCaculate(Decimal expectedAmount, Integer noOfDays){
                    this.expectedAmount = expectedAmount;
                    this.noOfDays = noOfDays;                   
                    }
        }
        /*Wrapper Class End*/
        
 /*exportmethod for topaccount*/
     public Pagereference exportRevnueForcast(){ 
             
         Map<String, TimeMapping__c> timeMapForstage = TimeMapping__c.getAll();
         Map<String, ProbabilityMapping__c> probMapForStage = ProbabilityMapping__c.getAll();
         List<opportunity> allOppoExp = [select id,StageName,Amount,name,Accountid,Completion_Date__c,account.name,account.owner.name,owner.name,(SELECT Amount,CloseDate,CreatedDate,OpportunityId,Probability,StageName FROM OpportunityHistories ORDER BY CreatedDate DESC) from opportunity where Probability!=0.0 and Probability!=100.0 ORDER BY CreatedDate DESC];
         lstOpportunityExport = new List<Opportunity>();        
        
         for(Opportunity op : allOppoExp ){                   
                TImeMapping__c currentOppoStage = timemapforstage.get(op.stagename);  
                ProbabilityMapping__c currentProb = probmapforstage.get(op.stagename);      
                Integer ageOfOpportunityStage = 0;
                Date oppoComplettionDate = Date.Today();                
                datetime lastChangeDateTime = datetime.now();
                for(OpportunityHistory oh:  op.OpportunityHistories){
                    if(oh.stagename == op.stagename)
                        lastChangeDateTime  = oh.CreatedDate;
                    else
                        break;                   
                }
                
                ageOfOpportunityStage  = lastChangeDateTime.date().daysBetween(date.today());  
                if(ageOfOpportunity(currentOppoStage,currentProb,ageOfOpportunityStage,confilterOne,op).noOfDays>=0.0 && ageOfOpportunity(currentOppoStage,currentProb,ageOfOpportunityStage,confilterOne,op).noOfDays <=365*(selectedOptionRev=='12mon'?1:2)){
                expectedAmountCaculate newobj = ageOfOpportunity(currentOppoStage,currentProb,ageOfOpportunityStage,confilterOne,op);
                              
                    op.amount = ageOfOpportunity(currentOppoStage,currentProb,ageOfOpportunityStage,confilterOne,op).expectedAmount;                    
                    Date dateofwontime = date.today().adddays(newobj.noOfDays);                        
                    String dateInString = convertdateinString(dateofwontime);                   
                    op.Completion_Date__c = dateInString;                  
                    lstOpportunityExport.add(op);                                                
                 }         
         }
        
          return new Pagereference('/apex/Vf_RevenueForecast1');
     }
     
     public Pagereference exportTopAccounts(){       
         return new Pagereference('/apex/TopAccountsExcel');
     }
     
     public Pagereference exportBottomAccounts(){       
         return new Pagereference('/apex/BottomAccountsExcel');
     }
     
     public Pagereference exportTopPerformer(){       
         return new Pagereference('/apex/TopPerformerExcel');
     }
     
     public Pagereference exportTopOpportunities(){       
         return new Pagereference('/apex/TopOpportunitiesExcel');
     }
     
     public Pagereference backToHome(){       
         return new Pagereference('/home/home.jsp');
     }
     
     public Void dataRevnueForcast(){       
        
        Map<String, TimeMapping__c> timeMapForstage = TimeMapping__c.getAll();
        Map<String, ProbabilityMapping__c> probMapForStage = ProbabilityMapping__c.getAll();
        List<opportunity> allOppoExp = [select id,StageName,Amount,name,Accountid,account.name,Completion_Date__c,account.owner.name,(SELECT Amount,CloseDate,CreatedDate,OpportunityId,Probability,StageName FROM OpportunityHistories ORDER BY CreatedDate DESC) from opportunity where Probability!=0.0 and Probability!=100.0 ORDER BY CreatedDate DESC];
        
        
        oppFordata = new List<Opportunity>();
        lstWrapper = new List<expectedAmountCaculate>();
        lstWrapper1 = new List<expectedAmountCaculate>();
        
           System.debug('bbbb  '+lstWrapper);
        if(mapMonthToLstOpportunity.containsKey(monthName))
        {
            for(Opportunity objOpportunity : mapMonthToLstOpportunity.get(monthName))       
            {
                 System.debug('cccc '+mapMonthToLstOpportunity.get(monthName).size());
                expectedAmountCaculate newobj;
                Integer ageOfOpportunityStage = 0;
                TImeMapping__c currentOppoStage = timemapforstage.get(objOpportunity.stagename); 
                ProbabilityMapping__c currentProb = probmapforstage.get(objOpportunity.stagename); 
                datetime lastChangeDateTime = datetime.now();   
                
                for(OpportunityHistory oh:  objOpportunity.OpportunityHistories){
                    if(oh.stagename == objOpportunity.stagename)
                        lastChangeDateTime  = oh.CreatedDate;
                    else
                        break;                    
                }
                ageOfOpportunityStage  = lastChangeDateTime.date().daysBetween(date.today());
                if(ageOfOpportunity(currentOppoStage,currentProb,ageOfOpportunityStage,confilterOne,objOpportunity).noOfDays>=0.0 && ageOfOpportunity(currentOppoStage,currentProb,ageOfOpportunityStage,confilterOne,objOpportunity).noOfDays <=365*(selectedOptionRev=='12mon'?1:2))
                    newobj = ageOfOpportunity(currentOppoStage,currentProb,ageOfOpportunityStage,confilterOne,objOpportunity);                
                newobj.objOpportunity = objOpportunity;
                lstWrapper.add(newobj);
            }
        }
        
        System.debug('list '+lstWrapper);
        for(Opportunity op : allOppoExp ){                   
                TImeMapping__c currentOppoStage = timemapforstage.get(op.stagename);  
                ProbabilityMapping__c currentProb = probmapforstage.get(op.stagename);      
                Integer ageOfOpportunityStage = 0;
                Date oppoComplettionDate = Date.Today();                
                datetime lastChangeDateTime = datetime.now();
                for(OpportunityHistory oh:  op.OpportunityHistories){
                    if(oh.stagename == op.stagename)
                        lastChangeDateTime  = oh.CreatedDate;
                    else
                        break;                    
                }
                
                ageOfOpportunityStage  = lastChangeDateTime.date().daysBetween(date.today());
               
            if(ageOfOpportunity(currentOppoStage,currentProb,ageOfOpportunityStage,confilterOne,op).noOfDays>=0.0 && ageOfOpportunity(currentOppoStage,currentProb,ageOfOpportunityStage,confilterOne,op).noOfDays <=365*(selectedOptionRev=='12mon'?1:2)){
               expectedAmountCaculate newobj = ageOfOpportunity(currentOppoStage,currentProb,ageOfOpportunityStage,confilterOne,op);               
             date dateofwontime = date.today().adddays(newobj.noOfDays);
             String mapkey = convertdateinString(dateofwontime);
            
            } 
        }
    }
}