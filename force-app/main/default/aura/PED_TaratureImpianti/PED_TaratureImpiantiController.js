({  
    removeSpinner: function(component, event, helper) {
        var theSpinner = component.find("mySpinner"); 
        $A.util.addClass(theSpinner, 'slds-hide');
    },callback : function(component,event,helper){
        var UniqueId = event.getParam("UniqueId"); 
        if(UniqueId==component.get('v.UniqueID')){
            if(event.getParam('methodName')=='ImpiantoFornitura'){
                var resultReturned = event.getParam("result");   
                if(component.get('v.firstTimeCall')){
                    component.set('v.firstTimeCall',false);
                    
                    var theSpinner = component.find("mySpinner"); 
                    $A.util.addClass(theSpinner, 'slds-hide');
                }
                if(resultReturned!=null){                    
                    helper.gestioneImpianti(component,resultReturned); 
                }else{
                    component.set('v.valueRadio1' ,'');
                    component.set('v.valueRadio2' ,'');
                    component.set('v.valueRadio3' ,'');
                    component.set('v.valueRadio4' ,'');
                    component.set('v.LunghCavo','');
                    component.set('v.PotTrasfEnerg','');
                    component.set('v.PotTrasfParall','');
                    component.set('v.SezCavoColl','');
                    component.set('v.SvilReteAerea','');
                    component.set('v.SvilReteCavo','');
                    component.set('v.falgSectionII',false);
                    component.set('v.falgSectionIII',false);
                    component.set('v.falgSectionI',false);
                    var mapActual = {};
                    mapActual.DispGen = '';
                    mapActual.ProtGen = '';
                    mapActual.ProtInterf ='';
                    mapActual.DispInterf ='';
                    mapActual.SvilReteAerea ='';
                    mapActual.SvilReteCavo ='';
                    mapActual.LunCavoColl ='' ;
                    mapActual.SezCavoColl = '';
                    mapActual.PotTrasfEnerg = '';
                    mapActual.PotTrasfParall = '';
                    mapActual.pod = component.get('v.selectedPod');
                    console.log('@DF mapActual.pod '+mapActual.pod);
                    component.set('v.datiImpianto',mapActual);                
                    helper.controllTableShow(component);
                }
                var err = component.get('v.err');
                component.set('v.err',undefined);
                if(err!=undefined){
                    component.set('v.messageToShow',err);
                    component.set('v.isSucc' , true);
                }
            }
            else if(event.getParam('methodName')=='TaratureFornitura'){
                var resultReturned = event.getParam("result");       
                if(resultReturned!=null){
                    component.set('v.DatiUtente',resultReturned.cliente); 
                    helper.gestioneForn(component,resultReturned.tarForn); 
                }                
                if(component.get('v.firstTimeCall')){
                    component.set('v.firstTimeCall',false);
                    helper.getImpianti(component);
                }
            }
        }
        if(!component.get('v.firstTimeCall')){
            var theSpinner = component.find("mySpinner"); 
            $A.util.addClass(theSpinner, 'slds-hide');
        }
    },setPageSize : function(component, event, helper){
        var newPgSize = component.find("Pgntn").get("v.value");
        component.set("v.pageSize",newPgSize);  
        var records = component.get("v.PODList");
        // helper.initializePagination(component, event, records);
    },
    onActiveCaratteristiche: function(component, event, helper) {
        var flag = component.get('v.firstTimeTab');
        if(!flag){
            var spinner = component.find("mySpinner");
            $A.util.toggleClass(spinner, "slds-hide");
            component.set('v.firstTimeTab',true);
            helper.getImpianti(component);
        }
    },
    openModel: function(component, event, helper) {
        // for Display Model,set the "isOpen" attribute to "true"
        component.set("v.isOpen", true);
    }, 
    closeModel: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.isOpen", false);
    },
    onActiveTarature: function(component, event, helper) {
        var flag = component.get('v.firstTimeTabTarature');
        if(!flag){
            var spinner = component.find("mySpinner");
            $A.util.toggleClass(spinner, "slds-hide");
            component.set('v.firstTimeTabTarature',true);
            helper.getTarature(component);
        }
    },
    doInit : function(component, event, helper) {
        var action = component.get("c.PODDetails"); 
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state ==> '+state);
            if (state === "SUCCESS") {
                var returnedValue = response.getReturnValue();
                console.log('DF returnedValue ==> '+returnedValue.data[0].pods.IdPod);
                component.set('v.selectedPod',returnedValue.data[0].pods.IdPod);
                let method1 = component.get('c.searchCalibration');
                method1.setParams({
                    'customer_k' : '147372',
                    'customer_l' : '0',
                    'customer_m' : '1000'
                });
                method1.setCallback(this,function(response){
                    let state = response.getState();
                    if(state === "SUCCESS"){
                        debugger;
                        helper.gestioneForn(component,response.getReturnValue().data.supplyTechInfo); 
                    } else {
                        debugger;
                    }
                });
                $A.enqueueAction(method1);
                
            }  else {
                
            }

            
        });
        $A.enqueueAction(action);
        
    },
    DownloadPDF3 : function(component, event, helper) {  
        var spinner = component.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide");
        component.set('v.callPDF','tarature');
        helper.getDatiUtenteCaratteristiche(component,event);
    },
    changeRadio: function(component, event, helper) {        
        /*GESTIONE ERRORE*/
        var DG = component.find('SectionIGroup1')==undefined?'':component.find('SectionIGroup1').get('v.value')==undefined?'':component.find('SectionIGroup1').get('v.value'); 
        var PG = component.find('SectionIGroup2')==undefined?'':component.find('SectionIGroup2').get('v.value')==undefined?'':component.find('SectionIGroup2').get('v.value');
        var PI = component.find('SectionIIIGroup1')==undefined?'':component.find('SectionIIIGroup1').get('v.value')==undefined?'':component.find('SectionIIIGroup1').get('v.value');        
        var DDI = component.find('SectionIIIGroup2')==undefined?'':component.find('SectionIIIGroup2').get('v.value')==undefined?'':component.find('SectionIIIGroup2').get('v.value'); 
        
        if(DG=='section1Radio1Option3' && PG=='section1Radio2Option3'){            
            component.set('v.errorsRadio','');
        }
        if(DG=='section1Radio1Option3' && PG!='section1Radio2Option3'){
            component.set('v.errorsRadio','Non è possibile effettuare questa combinazione di Valori');
        }else if(PG=='section1Radio2Option3' && DG!='section1Radio1Option3'){
            component.set('v.errorsRadio','Non è possibile effettuare questa combinazione di Valori');            
        }else{
            component.set('v.errorsRadio','');
        }
    },
    onCheck : function(component, event, helper) {  
        var check = event.getSource().getLocalId();
        if(check==='checkSectionI'){
            if(component.get('v.falgSectionII')==true){
                component.set('v.falgSectionI',false);                 
                
            }
            if(component.get('v.falgSectionI')==false){
                component.set('v.falgSectionIII',false);
            }  
        }else if(check==='checkSectionIII'){
            if(!component.get('v.falgSectionI')){
                component.set('v.falgSectionIII',false);
            }
        }else if(check==='checkSectionII'){ 
            if(component.get('v.falgSectionI')==true){
                component.set('v.falgSectionII',false);
            }
        }
        console.log(check);
    },
    sendData : function (component , event, helper){
        component.set("v.isOpen", false);
        helper.sendData(component);
    },
    changeText: function (component , event, helper){
        var changedText = event.target.id;
        console.log(changedText);
        switch(changedText) {
            case 'SvilReteAerea':               
                var value = document.getElementById('SvilReteAerea').value;
                component.set('v.datiImpianto.SvilReteAerea',value);
                break;
            case 'SvilReteCavo':
                var value =document.getElementById('SvilReteCavo').value;
                component.set('v.datiImpianto.SvilReteCavo',value);
                break;
            case 'LunghCavoColl':
                var value =document.getElementById('LunghCavoColl').value;
                component.set('v.datiImpianto.LunCavoColl',value);
                break;
            case 'SezCavoColl':
                var value =document.getElementById('SezCavoColl').value;
                component.set('v.datiImpianto.SezCavoColl',value);
                break;
            case 'PotComplTrasf':
                var value =document.getElementById('PotComplTrasf').value;
                component.set('v.datiImpianto.PotTrasfEnerg',value);
                break;
            case 'PotComplParall':
                var value =document.getElementById('PotComplParall').value;
                component.set('v.datiImpianto.PotTrasfParall',value); 
                break;
        }
    },
    DownloadPDFCaratteristiche: function (component , event, helper){
        var spinner = component.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide");
        component.set('v.callPDF','caratteristiche');
        helper.getDatiUtenteCaratteristiche(component,event);
        
    },
    sendEmail : function(component, event, helper){
        component.set('v.callPDF','tarature');
        helper.getDatiUtenteCaratteristiche(component, event, true);
        
    },
    sendEmail2 : function(component, event, helper){
        
        component.set('v.callPDF','caratteristiche');
        helper.getDatiUtenteCaratteristiche(component, event, true);
        
    },
    /*DF sendMail: function(component, event, helper) {
        var stockData = component.get("v.PODList");
        var csv = helper.convertArrayOfObjectsToCSV(component,stockData); 
        var action = component.get("c.sendMailMethod");  
        action.setParams({"doc": csv});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                component.set("v.mailStatus", true);
                //component.set("v.mailStatus", true);
            }
        });
        $A.enqueueAction(action);
    }, DF*/
    closeMessage: function(component, event, helper) {
        component.set("v.mailStatus", false);
        
    },
    
    DownloadCSV : function(component, event, helper) {
        debugger;
        var stockData = component.get("v.PODList");
        // call the helper function which "return" the CSV data as a String   
        var csv = helper.convertArrayOfObjectsToCSV(component,stockData);   
        if (csv == null){return;} 
        if (typeof window.navigator.msSaveBlob === "function" ) {
            // This is internet explorer 9 or 11
            var myblob=new Blob([csv]);
            var blobURL = URL.createObjectURL(myblob);
            window.navigator.msSaveBlob(myblob, 'RimozioneDispositivi'+"."+'csv');
        }
        else{
            var myblob=new Blob([csv]);
            var blobURL = URL.createObjectURL(myblob);
            var link = document.createElement('a');
            link.setAttribute('href', blobURL);
            link.setAttribute('download', 'RimozioneDispositivi'+"."+'csv');
            link.setAttribute('target', '_self');
            document.body.appendChild(link);
            link.click();
        }
    },
    goBack : function (component, event, helper){
        helper.goBack(component, event);
    }
    
    
})