({  
    removeSpinner: function(component, event, helper) {
        var theSpinner = component.find("mySpinner"); 
        $A.util.addClass(theSpinner, 'slds-hide');
    },
    
    callback : function(component,event,helper){
        var UniqueId = event.getParam("UniqueId"); 
        var theSpinner = component.find("mySpinner"); 
        $A.util.addClass(theSpinner, 'slds-hide');
        if(UniqueId===component.get('v.UniqueID')){
            var resultReturned = event.getParam("result");
            if(resultReturned.sintesi!=null && resultReturned.sintesi!=undefined){
                var sintesi = resultReturned.sintesi;
                component.set('v.Sintesi',sintesi);
                var somma2 = (sintesi.D1 == undefined?0:sintesi.D1)+
                    (sintesi.C2== undefined?0:sintesi.C2)+
                    (sintesi.D2== undefined?0:sintesi.D2)+
                    (sintesi.B3== undefined?0:sintesi.B3)+
                    (sintesi.C3== undefined?0:sintesi.C3)+
                    (sintesi.D3== undefined?0:sintesi.D3)+
                    (sintesi.B4== undefined?0:sintesi.B4)+
                    (sintesi.C4== undefined?0:sintesi.C4)+
                    (sintesi.D4== undefined?0:sintesi.D4)+
                    (sintesi.A5== undefined?0:sintesi.A5)+
                    (sintesi.B5== undefined?0:sintesi.B5)+
                    (sintesi.C5== undefined?0:sintesi.C5)+
                    (sintesi.D5== undefined?0:sintesi.D5);
                component.set('v.SintesiSomma2',somma2);
                var somma1 = somma2 + 
                    (sintesi.C1 == undefined?0:sintesi.C1)+
                    (sintesi.A3 == undefined?0:sintesi.A3)+
                    (sintesi.A4 == undefined?0:sintesi.A4);
                component.set('v.SintesiSomma1',somma1);
            }else{
                component.set('v.Sintesi',{});
                component.set('v.SintesiSomma2',0);
                component.set('v.SintesiSomma1',0);
            }
            if(resultReturned.sintesiAT!=null && resultReturned.sintesiAT!=undefined){
                var sintesiAT = resultReturned.sintesiAT;                        
                component.set('v.SintesiAT',sintesiAT);
                var sommaAT = (sintesiAT.D1 == undefined?0:sintesiAT.D1)+
                    (sintesiAT.C2== undefined?0:sintesiAT.C2)+
                    (sintesiAT.D2== undefined?0:sintesiAT.D2)+
                    (sintesiAT.B3== undefined?0:sintesiAT.B3)+
                    (sintesiAT.C3== undefined?0:sintesiAT.C3)+
                    (sintesiAT.D3== undefined?0:sintesiAT.D3)+
                    (sintesiAT.B4== undefined?0:sintesiAT.B4)+
                    (sintesiAT.C4== undefined?0:sintesiAT.C4)+
                    (sintesiAT.D4== undefined?0:sintesiAT.D4)+
                    (sintesiAT.A5== undefined?0:sintesiAT.A5)+
                    (sintesiAT.B5== undefined?0:sintesiAT.B5)+
                    (sintesiAT.C5== undefined?0:sintesiAT.C5)+
                    (sintesiAT.D5== undefined?0:sintesiAT.D5);
                component.set('v.SintesiSommaAT',sommaAT);
            }else{
                component.set('v.SintesiAT',{});
                component.set('v.SintesiSommaAT',0);
            }
            var buchiList=resultReturned.buchiSemisbarraList;
            if(buchiList==undefined || buchiList==null){
                buchiList=[];
            }else{
                var i = buchiList.length -1;                        
                for(; i >= 0; i--) {
                    if((buchiList[i].categoria==undefined?true:buchiList[i].categoria.trim()==='') && 
                       (buchiList[i].durata==undefined?true:buchiList[i].durata.trim()==='') &&
                       (buchiList[i].evento==undefined?true:buchiList[i].evento.trim()==='') &&
                       (buchiList[i].istante==undefined?true:buchiList[i].istante.trim()==='') &&
                       (buchiList[i].origine==undefined?true:buchiList[i].origine.trim()==='') &&
                       (buchiList[i].rs==undefined?true:buchiList[i].rs.trim()==='') &&
                       (buchiList[i].semisbarra==undefined?true:buchiList[i].semisbarra.trim()==='') &&
                       (buchiList[i].tensioneResidua==undefined?true:buchiList[i].tensioneResidua==='0') &&
                       (buchiList[i].st==undefined?true:buchiList[i].st.trim()==='') &&
                       (buchiList[i].tr==undefined?true:buchiList[i].tr.trim()==='')) {
                        buchiList.splice(i, 1);
                    }
                }
            }
            if(buchiList.length>0){
                var spinner = component.find("mySpinner");
                var obj = new Array();
                var listSemibarre= new Array();                        
                var objData = {};
                for(var i =0 ; i<buchiList.length;i++){
                    if(listSemibarre.indexOf(buchiList[i].semisbarra)<0){
                        listSemibarre.push(buchiList[i].semisbarra);
                        var objData = {};
                        objData.semisbarra = buchiList[i].semisbarra;
                        objData.durata = buchiList[i].durata;
                        objData.categoria = buchiList[i].categoria;
                        objData.evento = buchiList[i].evento;
                        buchiList[i].istante = buchiList[i].istante.replace(',','.');
                        objData.istante = buchiList[i].istante;
                        if (buchiList[i].istante != undefined && buchiList[i].istante.trim() != ""){
                            buchiList[i].dataSort = helper.stringToDate(buchiList[i].istante);
                            objData.dataSort = buchiList[i].dataSort;   
                        }
                        objData.origine = buchiList[i].origine;
                        objData.rs = buchiList[i].rs;
                        objData.st = buchiList[i].st;
                        objData.tensioneResidua = buchiList[i].tensioneResidua;
                        objData.tr = buchiList[i].tr;
                        var listData = new Array();
                        listData.push(objData);
                        var objFirstLayer = {};                                
                        objFirstLayer.semibarraitem = buchiList[i].semisbarra;
                        objFirstLayer.listItem = listData;
                        obj.push(objFirstLayer);
                    }else{
                        for(var j =0 ; j<obj.length;j++){
                            if(obj[j].semibarraitem===buchiList[i].semisbarra){
                                var objData = {};
                                objData.durata = buchiList[i].durata;                                        
                                objData.semisbarra = buchiList[i].semisbarra;                                        
                                objData.categoria = buchiList[i].categoria;
                                objData.evento = buchiList[i].evento;
                                buchiList[i].istante = buchiList[i].istante.replace(',','.');
                                objData.istante = buchiList[i].istante;  
                                if (buchiList[i].istante != undefined && buchiList[i].istante.trim() != ""){                                           
                                    buchiList[i].dataSort = helper.stringToDate(buchiList[i].istante.replace(',','.'));
                                    objData.dataSort = buchiList[i].dataSort;   
                                }
                                objData.origine = buchiList[i].origine;
                                objData.rs = buchiList[i].rs;
                                objData.st = buchiList[i].st;
                                objData.tensioneResidua = buchiList[i].tensioneResidua;
                                objData.tr = buchiList[i].tr;
                                obj[j].listItem.push(objData);
                                break;
                            }
                        }
                    }
                }   
                component.set('v.listaNonVuota',true);
                component.set('v.ObjSemibarreList',obj);                           
                component.set('v.semibarreList' , listSemibarre);
                component.set('v.allSemibarraList' , buchiList);
                component.set('v.ActualSemibarreList',component.get('v.allSemibarraList'));
                if(listSemibarre.length==1){
                    component.set('v.ActualSemisbarra',listSemibarre[0]);
                    component.set('v.listaNonVuota',true);                                        
                    
                }
                if(listSemibarre.length==0){
                    component.set('v.listaVuota',false);
                    component.set('v.listaNonVuota',false);      
                }
                
                
                helper.initializePagination(component,null,buchiList);
            }else{
                
                component.set('v.listaVuota',true);
                component.set('v.listaNonVuota',false);
                
            }      
        }
        
    },
    
    setPageSize : function(component, event, helper){
        var newPgSize = component.find("Pgntn").get("v.value");
        component.set("v.pageSize",newPgSize);  
        var records = component.get("v.PODList");
        // helper.initializePagination(component, event, records);
    },
    
    selectSemibarra:function(component, event, helper) {
        var valueselect = component.find("semibarraSelect").get("v.value");
        if(valueselect==='void'){   
            component.set('v.ActualSemibarreList',component.get('v.allSemibarraList'));
            component.set('v.ActualSemisbarra','');
            helper.initializePagination(component,null,component.get('v.ActualSemibarreList'));
        }else{
            var obj = component.get('v.ObjSemibarreList');
            for(var i = 0 ; i<obj.length;i++){
                if(obj[i].semibarraitem===valueselect){
                    component.set('v.ActualSemibarreList',obj[i].listItem); 
                    component.set('v.ActualSemisbarra',obj[i].semibarraitem);
                    helper.initializePagination(component,null,obj[i].listItem);
                    component.set('v.listaNonVuota',true); 
                    break;
                }
            }
        }
    },
    
    goBack : function (component, event, helper){
        helper.goBack(component, event);
    },
    
    doInit : function(component, event, helper) {
        
      
        action = component.get("c.getDetails"); 

        action.setParams(
            { "url": window.location.href }
        );

        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state ==> '+state);
            if (state === "SUCCESS") {
                var returnedValue = response.getReturnValue();
                console.log('DF returnedValue ==> '+returnedValue.data[0].pods.IdPod);
                component.set('v.selectedPod',returnedValue.data[0].pods.IdPod);
                
            }  
        });
        $A.enqueueAction(action);
        
        var id = helper.getUniqueId();
        component.set('v.UniqueID' , id);
      
        var numberOfDays = $A.get("$Label.c.PED_NumberOfDaysPOD");
        var today = new Date();
        var mm=1;
        var dd=1;
        var yy = today.getFullYear();
        
        if(today.getMonth()+1<5){            
            yy=yy-2;
        }else{
            yy=yy-1;
        }
        var mmfinal=12;
        var ddfinal=31;
        var mydateinitial = mm+'/'+dd+'/'+yy;
        var mydatefinal = mmfinal+'/'+ddfinal+'/'+yy;
        var myDate1 = new Date(mydateinitial);  
        var dayOfMonth = new Date(mydatefinal);  
        
        component.set('v.startDate', (myDate1.getFullYear())+ "-" +( myDate1.getMonth() + 1)  + "-" + myDate1.getDate() );
        component.set('v.endDate', (dayOfMonth.getFullYear())+ "-" + (dayOfMonth.getMonth() + 1) + "-" + dayOfMonth.getDate()  );
        //component.set('v.startDate',in30Days); 
        setTimeout(function(){
            
            var theSpinner = component.find("spinnerId"); 
            $A.util.removeClass(theSpinner, 'slds-hide');                    
            helper.doinit(component); 
        },1000);     
    }, 
    
    ValidateSdate : function(component, event, helper) {
        helper.ValidateSdate(component,event);
        
    },
    
    nullifySDate : function(component, event, helper){
        var dp = component.find('startdateField');
        dp.set('v.value', '');
    },
    
    
    ValidateEdate : function(component, event, helper) {
        helper.ValidateEdate(component,event);
        
    },
    
    nullifyEDate : function(component, event, helper){
        var dp = component.find('enddateField');
        dp.set('v.value', '');
    },
    
    FilterButtonClick : function(component, event, helper) {
        
        if(component.get('v.sDateErrorNotExist')==true && component.get('v.eDateErrorNotExist')==true){ 
            
            var theSpinner = component.find("spinnerId"); 
            $A.util.removeClass(theSpinner, 'slds-hide');
            window.scroll(0, 0);
            helper.doinit(component);    
        }else{
            window.scroll(0, 0);
        }
    },
    
    sortSemibarra : function(component, event, helper) {
        helper.sortBy(component, "semisbarra"); 
    },
    sortevento : function(component, event, helper) {
        helper.sortBy(component, "evento"); 
    },
    sortrs : function(component, event, helper) {
        helper.sortBy(component, "rs"); 
    },
    sortst : function(component, event, helper) {
        helper.sortBy(component, "st"); 
    },
    sorttr : function(component, event, helper) {
        helper.sortBy(component, "tr"); 
    },
    sortistante : function(component, event, helper) {
        helper.sortBy(component, "dataSort"); 
    },
    sortdurata : function(component, event, helper) {
        helper.sortBy(component, "durata"); 
    },
    sorttensioneResidua : function(component, event, helper) {
        helper.sortBy(component, "tensioneResidua"); 
    },
    sortorigin : function(component, event, helper) {
        helper.sortBy(component, "origine"); 
    },
    ExportPDFSintesi : function (component, event, helper){
        var spinner = component.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide");
        component.set('v.callPDF', 'sintesi');
        helper.getDatiUtenteCaratteristiche(component,event);
        
        
    },
    ExportPDFSintesiAT : function (component, event, helper){
        var spinner = component.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide");
        component.set('v.callPDF', 'sintesi');
        component.set('v.callPDF', 'sintesiAT');
        helper.getDatiUtenteCaratteristiche(component,event);
        
    },
  
    
    DownloadCSVBuchi : function(component, event, helper) {
        var spinner = component.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide");
        var lista= component.get("v.ActualSemibarreList");
        // ! ASK TO-DO CHANGE IN ENGLISH
        var header = ['Semibarra','N.Evento','RS','ST','TR','Istante [DD/MM/YYYY HH:MM:SS.CC]','Durata [HH:MM:SS.CC]','Tensione Residua [%]','Origine'];
        var keyArray=['semisbarra','evento','rs','st','tr','istante','durata','tensioneResidua','origine'];
        var csv =helper.convertArrayOfObjectsToCSV(component,lista,header,keyArray);
        
        var endDateField = component.find("enddateField");
        var endDateValue = endDateField.get("v.value"); 
        var endDateSplit = endDateValue.split('-');
        var selectedEndDate = new Date(endDateSplit[0],endDateSplit[1]-1,endDateSplit[2]);
        var enddate = selectedEndDate.getDate()+'-'+(selectedEndDate.getMonth()+1)+'-'+selectedEndDate.getFullYear();
        var startDateField = component.find("startdateField");
        var startDateValue = startDateField.get("v.value");
        var startDateSplit = startDateValue.split('-');
        var selectedStartDate = new Date(startDateSplit[0],startDateSplit[1]-1,startDateSplit[2]);
        var selectedPod = component.get('v.selectedPod');
        var startdate = selectedStartDate.getDate()+'-'+(selectedStartDate.getMonth()+1)+'-'+selectedStartDate.getFullYear();
        var myblob=new Blob([csv]);
        var filename='BuchiDiTensione'+'_'+ selectedPod+'_'+startdate+'_'+enddate;
        var extension='csv';
        helper.downloadFile(component,myblob, filename, extension,event);
        
    },
    sendMailsintesiAt : function(component, event, helper){
        var spinner = component.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide");
        component.set('v.callPDF', 'sintesiAT');
        helper.getDatiUtenteCaratteristiche(component, event, true);
        
    },
    sendMailSintesi : function(component, event, helper){
        var spinner = component.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide");
        component.set('v.callPDF', 'sintesi');
        helper.getDatiUtenteCaratteristiche(component, event, true);
        
    }
    
})