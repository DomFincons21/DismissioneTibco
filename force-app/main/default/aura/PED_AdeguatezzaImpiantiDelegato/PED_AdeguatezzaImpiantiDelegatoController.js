({
    removeSpinner: function(component, event, helper) {
        var theSpinner = component.find("mySpinner"); 
        $A.util.addClass(theSpinner, 'slds-hide');
    },
    
    callback:function(component,event,helper){
        var UniqueId = event.getParam("UniqueId");  
        var theSpinner = component.find("mySpinner"); 
        $A.util.addClass(theSpinner, 'slds-hide');
        if(UniqueId===component.get('v.UniqueID')){
         //   var resultReturned = event.getParam("result");
            helper.setFornitura(component, event);
            var returnValues = event.getParam("result");
            if(returnValues != null && returnValues != undefined){
                component.set("v.adeguatezzaImpianti", returnValues);
            }
        }
    },

    doInit : function(component, event, helper) {
        //DF DISMISSIONE  helper.setPOD(component);
        //DF INIZIO 
        var action = component.get("c.PODDetailsDelegato");
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state ==> '+state);
            if (state === "SUCCESS") {
                var returnedValue = response.getReturnValue();
                var TaxCode = returnedValue.data[0].pods.TaxCode;
                var VatNumber = returnedValue.data[0].pods.VatNumber;
                //DF  component.set('v.pods',returnedValue);
                component.set('v.selectedPod',returnedValue.data[0].pods.IdPod);
            /*DF    if(TaxCode != null || VatNumber != null)
                    helper.getAccountId(component,event,helper,TaxCode,VatNumber); DF*/
                setTimeout(function(){
            var theSpinner = component.find("spinnerId");
                    var id = helper.getUniqueId();
                    component.set('v.UniqueID' , id);
            $A.util.removeClass(theSpinner, 'slds-hide');
            helper.getData(component,event);
        },1000); 
            }
        });
        $A.enqueueAction(action);
        //DF FINE
               
    },
    downloadPDF : function(component, event, helper){
        var spinner = component.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide");
        helper.getDatiUtenteCaratteristiche(component, event);
    },
    sendEmail : function(component, event, helper){
        var spinner = component.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide");
        helper.getDatiUtenteCaratteristiche(component, event, true);
        
    },
    goBack : function (component, event, helper){
        helper.goBack(component, event);
    }
})