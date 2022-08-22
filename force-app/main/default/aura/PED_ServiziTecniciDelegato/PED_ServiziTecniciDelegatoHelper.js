({
    doInit : function(component) {
        debugger;
        var action = component.get("c.PODDetailsDelegato");
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state ==> '+state);
            if (state === "SUCCESS") {
                var returnedValue = response.getReturnValue();
                var TaxCode = returnedValue.data[0].pods.TaxCode;
                var VatNumber = returnedValue.data[0].pods.VatNumber;
                console.log("TaxCode "+ TaxCode);
                console.log("VatNumber "+ VatNumber);
                // component.set('v.pods',returnedValue);
                if(TaxCode != null || VatNumber != null){
                    //    this.getAccountId(component,event,helper,TaxCode,VatNumber);
                    //LDRAGO Start id66 Lotto2
                    /*DF  var numTens = Number(returnedValue.data[0].pods.VoltageLevel); 
                if (numTens >= 35000){ DF*/
                    var numTens = returnedValue.data[0].pods.VoltageLevel;
                console.log("v.isAT" + numTens);
                if (numTens == 'AT'){
                    component.set("v.isAT",true);
                }else{
                    component.set("v.isAT",false);
                }
                //LDRAGO END id66 Lotto2
                
                var isAT = component.get("v.isAT");
                console.log("isAT "+ isAT);
                component.set('v.showFlag',true);
                }
                
            }else if (state === "ERROR") {
                var errors = response.getError();
                console.log("Error message: " + 
                            errors[0].message);
            }
        });
        $A.enqueueAction(action);
        
        /*DF SOSTITUITO   console.log('cmp.get("v.selectedPod") ==> '+cmp.get("v.selectedPod"));
        var action = cmp.get("c.PODDetails");
     //DF   action.setParams({ 'pod' : cmp.get("v.selectedPod") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state ==> '+state);
            if (state === "SUCCESS") {
                debugger;
                var returnedValue = response.getReturnValue();
                console.log('returnedValue ==> '+returnedValue);
                cmp.set('v.pods',returnedValue);
                //LDRAGO Start id66 Lotto2
                var numTens = Number(returnedValue.data[0].pods.VoltageLevel); 
                if (numTens >= 35000){
                    cmp.set("v.isAT",true);
                }else{
                    cmp.set("v.isAT",false);
                }
                //LDRAGO END id66 Lotto2
            }else if (state === "ERROR") {
                var errors = response.getError();
                console.log("Error message: " + 
                            errors[0].message);
            }
        });
        $A.enqueueAction(action); DF*/
    },
    goBack : function(component, event){
        debugger;
        /*  var accId = component.get("v.accId");//[SS]
        var grandeCust= component.get("v.isGrande");
        var medioCust=component.get("v.isMedio"); */
        var address ='';
        /*if(!$A.util.isEmpty(accId)){//[Start][SS]
            address = "/le-forniture?id="+accId;
        }else{//[End][SS]
            if(grandeCust==false && medioCust==false ){
                address='/';
            }else if(medioCust==true){
                if(component.get("v.isMT")){
                    address='/le-mie-forniture?tensione=MT';
                }else if(component.get("v.isATRedirect")){
                    address='/le-mie-forniture?tensione=AT';
                }else{
                    address='/le-mie-forniture';
                }
            }
                else if(grandeCust==true){
                    component.set("v.firstTime",true);
                    component.set('v.showFlag',false);
                    component.set('v.selectedPod','back');
                }
        }*/
        //DOM non esiste piu la url le-forniture per delegato
        address = "fornituredelegato";
        //window.history.pushState({url: "" + address + ""}, null, address); 
        //[SS]
        this.gotoURL(component, event, address);        
    },
    gotoURL : function(component, event, address){
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": address,
            "isRedirect" : false
        });
        urlEvent.fire();
    },
    
  /*  getAccountId : function(component,event,helper,TaxCode,VatNumber){
        debugger;
        var accId;
        var action2 = component.get("c.GetAccountId"); 
        action2.setParams({
            "TaxCode" : TaxCode,
            "VatNumber" : VatNumber
        });
        action2.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state2 ==> '+state);
            if (state === "SUCCESS") {
                accId = response.getReturnValue();
                component.set("v.accId",accId);
            }
        });
        $A.enqueueAction(action2); 
    } */
    
})