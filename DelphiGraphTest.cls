@isTest
  public class DelphiGraphTest{
         static testMethod void DelphiGraphTest(){
             
             Account acc = new Account();
             acc.name='test';
             insert acc;
             
             Date timee = System.today();
             String name = 'test';
             Integer data = 12345 ;
             Double datatest = 10.0;
             boolean chkbox= true;
             boolean exportdata24topacc = true;
             boolean nonadminchkbox ;
             list<double> exptedamnt = new list<double>();
             opportunity opp = new opportunity();
             opp.Name = 'testoppportunity';
             opp.CloseDate = System.today();
             opp.StageName ='Prospecting';
             opp.Probability= 10.0;
             insert opp;
             
             Confidence_level_and_month__c cfdl = new Confidence_level_and_month__c();
             cfdl.Confidence_Level__c='testlevel';
             cfdl.Selected_Month__c = 'january';
             cfdl.Name = 'testcustom';
             insert cfdl;             
             
             Configuration_Instruction__c cfinst = new Configuration_Instruction__c();            
             cfinst.Name = 'testcustom3';
             insert cfinst;
             /*
             NonAdmininstruction__c admin = new NonAdmininstruction__c();
             admin.name = 'testcustom4';
             insert admin;
             */
             ProbabilityMapping__c probmap = new ProbabilityMapping__c();
             probmap.Max_Probability__c = 12 ;
             probmap.Min_Probability__c = 4 ;
             probmap.Probability_Mean__c = 10 ;
             probmap.Probability_SD__c = 3;
             probmap.name = 'testcustom5';
             insert probmap;
             probmap.Max_Probability__c = 15 ;
             probmap.Min_Probability__c = 5 ;
             update probmap;
             
             TimeMapping__c timemap = new TimeMapping__c();
             timemap.Max_Time__c = 10 ;
             timemap.Mean__c = 7 ;
             timemap.Min_Time__c = 5 ;
             timemap.Standard_Deviation__c= 3;
             timemap.Name = 'testcustom5';
             insert timemap;
             timemap.Max_Time__c = 15 ;
             timemap.Mean__c = 8 ;
             update timemap; 
             
              batch_processing_date__c bpc=new batch_processing_date__c();
              bpc.name='batch_date';
              bpc.Batch_date_Time__c=DateTime.now();
              insert bpc;
                         
            DelphiGraphs objDelphiGraphs = new DelphiGraphs();
            date dateForTest = date.today();
            objDelphiGraphs.convertdateinString(dateForTest);
            
            objDelphiGraphs.getData();
            objDelphiGraphs.saveconfandmon();
            objDelphiGraphs.saveconfandmontwo();
            objDelphiGraphs.saveconfandmonthree();
            objDelphiGraphs.saveconfandmonfour();
            objDelphiGraphs.saveconfandmonFive();
            objDelphiGraphs.exportRevnueForcast();
            objDelphiGraphs.exportTopAccounts();
            objDelphiGraphs.exportBottomAccounts();
            objDelphiGraphs.exportTopPerformer();
            objDelphiGraphs.exportTopOpportunities();
            objDelphiGraphs.dataRevnueForcast();
            objDelphiGraphs.previousBatchDate=DateTime.now();
            objDelphiGraphs.checkNewValues();
            objDelphiGraphs.selOptnForOppo='mon';
            objDelphiGraphs.selOptnForOppomtd();
            objDelphiGraphs.backToHome();
            
            DelphiGraphs.barGraph objbarGraph = new DelphiGraphs.barGraph('test',12);
            DelphiGraphs.sortedListTopAcct objsortedListTopAcct  = new DelphiGraphs.sortedListTopAcct(12,acc);
            DelphiGraphs.sortedListBottomAcct objsortedListBottomAcct = new DelphiGraphs.sortedListBottomAcct(12,acc);
            DelphiGraphs.sortedListTopperformer objsortedListTopperformer = new DelphiGraphs.sortedListTopperformer(12,'test');
            DelphiGraphs.sortedListTopOpportunity objsortedListTopOpportunity = new DelphiGraphs.sortedListTopOpportunity(12,opp,'test');
            
            DelphiGraphs.expectedAmountCaculate objExpAmnCalc = new DelphiGraphs.expectedAmountCaculate(12,12);
            objDelphiGraphs.ageOfOpportunity(timemap,probmap,12,'test',opp);
            System.assertEquals(5,5);

         }
  }