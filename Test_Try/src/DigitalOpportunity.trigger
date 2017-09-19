trigger DigitalOpportunity on Opportunity (after insert,after update,after delete) {  
    List<Smart_Scatter_Master__c> list_SmartQ = new List<Smart_Scatter_Master__c>();
    set<Id> set_Opportunity = new set<Id>();
    If(Trigger.isDelete){
        for(Opportunity objOpp: trigger.Old){
            set_Opportunity.add(objOpp.Smart_Scatter_Opportunity__c);
        }
    }
    If(Trigger.isAfter && !Trigger.isDelete){
        for(Opportunity objOpp: trigger.new){
            set_Opportunity.add(objOpp.Smart_Scatter_Opportunity__c);
        }
    }
    Decimal SumCYQWorkingUpfront=0, SumCYQWorkingPrepostUpfront=0,SumCYQEstimatePrePostUpfront=0,SumCYQWorkingScatter=0, SumCYQEstimateUpfront=0, SumCYQEstimateScatter=0, SumCYQUpfrontHI=0, SumCYQScatterHI=0;
    Boolean SumCYQWorkingUpfrontB = false, SumCYQWorkingScatterB = false, SumCYQEstimateUpfrontB = false, SumCYQEstimateScatterB = false, SumCYQUpfrontHIB = false, SumCYQScatterHIB = false;
    for(Smart_Scatter_Master__c ObjSmartQ : [SELECT Id,Name,Network_Type__c,(SELECT Id,Name,Amount__c,Est_HI__c,Heat_Index__c,Total__c ,StageName,Probability,Upfront_Scatter__c FROM Opportunities__r Where Amount__c != null) FROM Smart_Scatter_Master__c  WHERE Id IN: set_Opportunity]){           
        for(Opportunity objOpp01: ObjSmartQ.Opportunities__r ){
            System.debug('objOpp01.Probability====>'+objOpp01.Probability);
            System.debug('objOpp01.Upfront_Scatter__c===>'+objOpp01.Upfront_Scatter__c);
            if(objOpp01.Heat_Index__c=='Working') objOpp01.Probability=100;
            if(objOpp01.Heat_Index__c=='90%') objOpp01.Probability=90;
            if(objOpp01.Heat_Index__c=='75%') objOpp01.Probability=75;
            if(objOpp01.Heat_Index__c=='50%') objOpp01.Probability=50;
            if(objOpp01.Heat_Index__c=='25%') objOpp01.Probability=25;
            if(objOpp01.Heat_Index__c=='10%') objOpp01.Probability=10;
            if(objOpp01.Heat_Index__c=='0%') objOpp01.Probability=0;
           
                
            if(objOpp01.Probability!= null && objOpp01.Probability == 100 && objOpp01.Upfront_Scatter__c != '' && objOpp01.Upfront_Scatter__c.equalsIgnoreCase('Upfront')){    
                SumCYQWorkingUpfront+=objOpp01.Amount__c;
                SumCYQWorkingUpfrontB = true;
            }
            else if(objOpp01.Probability!= null && objOpp01.Probability ==100 && objOpp01.Upfront_Scatter__c != '' && objOpp01.Upfront_Scatter__c.equalsIgnoreCase('Pre/Post')){
                SumCYQWorkingPrepostUpfront+=objOpp01.Amount__c;
                SumCYQWorkingScatterB = true;
            }
            else if(objOpp01.Probability!= null && objOpp01.Probability ==100 && objOpp01.Upfront_Scatter__c != '' && objOpp01.Upfront_Scatter__c.equalsIgnoreCase('Scatter')){
                SumCYQWorkingScatter+=objOpp01.Amount__c;
                SumCYQWorkingScatterB = true;
            }               
            else if(objOpp01.Probability!= null && (objOpp01.Probability==90 || objOpp01.Probability==75  || objOpp01.Probability==50 || objOpp01.Probability==25 || objOpp01.Probability==10 ||objOpp01.Probability==0) && objOpp01.Upfront_Scatter__c != '' && objOpp01.Upfront_Scatter__c.equalsIgnoreCase('Upfront')){
                if(objOpp01.Total__c!=null )
                	SumCYQEstimateUpfront+=objOpp01.Total__c ;//objOpp01.Amount__c * objOpp01.Probability /100;
                SumCYQEstimateUpfrontB = true;
               
            }
            else if(objOpp01.Probability!= null && (objOpp01.Probability==90 || objOpp01.Probability==75  || objOpp01.Probability==50 || objOpp01.Probability==25 || objOpp01.Probability==10 || objOpp01.Probability==0) && objOpp01.Upfront_Scatter__c != '' && objOpp01.Upfront_Scatter__c.equalsIgnoreCase('Scatter')){
                 if(objOpp01.Total__c!=null )
                	SumCYQEstimateScatter+=objOpp01.Total__c ;//objOpp01.Amount__c * objOpp01.Probability /100;
                	SumCYQEstimateScatterB = true;
                 System.debug('SumCYQEstimateScatter===>'+SumCYQEstimateScatter);
                
            }
            else if(objOpp01.Probability!= null && (objOpp01.Probability==90 || objOpp01.Probability==75  || objOpp01.Probability==50 || objOpp01.Probability==25 || objOpp01.Probability==10 || objOpp01.Probability==0) && objOpp01.Upfront_Scatter__c != '' && objOpp01.Upfront_Scatter__c.equalsIgnoreCase('Pre/Post')){
                if(objOpp01.Total__c!=null )
                	SumCYQEstimatePrePostUpfront+=objOpp01.Total__c ;//objOpp01.Amount__c * objOpp01.Probability /100;
                	SumCYQEstimateScatterB = true;
                
            }
        }
    }      
    Smart_Scatter_OutletForecast__c scatOut = [SELECT Id,Name,Is_Latest__c,Smart_Scatter_Master__c,CYQ_Estimate_PrePost__c,HCYQ_BOB_Upfront__c,CYQ_BOB_Upfront__c,
                                               HCYQ_BOB_PrePost__c,CYQ_BOB_PrePost__c,HCYQ_BOB_Scatter__c,CYQ_BOB_Scatter__c,BOB_As_Of_Date_Hidden__c,BOB_As_Of_Date__c,
                                               CYQ_Working_PrePost__c,Smart_Scatter_Master__r.Network_Type__c,CYQ_Working_Upfront__c,CYQ_Working_Scatter__c,CYQ_Estimate_Scatter__c,CYQ_Estimate_Upfront__c FROM Smart_Scatter_OutletForecast__c WHERE Smart_Scatter_Master__c IN: set_Opportunity LIMIT 1];
    System.debug('SumCYQWorkingUpfront====>'+SumCYQWorkingUpfront);
    System.debug('SumCYQWorkingScatter===>'+SumCYQWorkingScatter);
    System.debug('SumCYQEstimateScatter===>'+SumCYQWorkingPrepostUpfront);
    scatOut.CYQ_Working_Upfront__c = SumCYQWorkingUpfront;
    scatOut.CYQ_Working_PrePost__c=SumCYQWorkingPrepostUpfront;
    scatOut.CYQ_Working_Scatter__c = SumCYQWorkingScatter;
    scatOut.CYQ_Estimate_Upfront__c = SumCYQEstimateUpfront;
    //scatOut.CYQ_Estimate_Digital_Upfront__c = SumCYQUpfrontHI;
    scatOut.CYQ_Estimate_Scatter__c = SumCYQEstimateScatter;
    //scatOut.CYQ_Estimate_Digital_Scatter__c = SumCYQScatterHI;            
    scatOut.CYQ_Estimate_PrePost__c=SumCYQEstimatePrePostUpfront;
    // This is for calculate BOB changes values
 	scatOut.HCYQ_BOB_Upfront__c = scatOut.CYQ_BOB_Upfront__c;
    scatOut.HCYQ_BOB_PrePost__c = scatOut.CYQ_BOB_PrePost__c;
    scatOut.HCYQ_BOB_Scatter__c = scatOut.CYQ_BOB_Scatter__c;
    scatOut.BOB_As_Of_Date_Hidden__c = scatOut.BOB_As_Of_Date__c;
    
    update scatOut;
    System.debug('scatOut===>'+scatOut);
}