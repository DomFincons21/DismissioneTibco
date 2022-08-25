({
     removeSpinner: function(component, event, helper) {
        var theSpinner = component.find("mySpinner"); 
        $A.util.addClass(theSpinner, 'slds-hide');
    },
    
    callback : function( component,event, helper){
         var theSpinner = component.find("mySpinner"); 
        $A.util.addClass(theSpinner, 'slds-hide');
        var UniqueId = event.getParam("UniqueId");   
        if(UniqueId===component.get('v.UniqueID')){
            debugger;
            helper.setFornitura(component, event);
             var theSpinner = component.find("mySpinner"); 
        $A.util.addClass(theSpinner, 'slds-hide');
            var returnValues = event.getParam("result");
            if(returnValues != null && returnValues != undefined){
                component.set("v.adeguatezzaImpianti", returnValues);
            }
        }
    },
    doInit : function(component, event, helper) {
        debugger;
        //DF INIZIO
        var action = component.get("c.PODDetails"); 
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state ==> '+state);
            if (state === "SUCCESS") {
                var returnedValue = response.getReturnValue();
                console.log('DF returnedValue ==> '+returnedValue.data[0].pods.IdPod);
                component.set('v.selectedPod',returnedValue.data[0].pods.IdPod);
                //DF FINE
                
            }  
        });
        $A.enqueueAction(action);
        
        var id = helper.getUniqueId();
        component.set('v.UniqueID' , id);
     //DF DISMISSIONE   helper.setPOD(component);
        setTimeout(function(){  
            var theSpinner = component.find("spinnerId"); 
            $A.util.removeClass(theSpinner, 'slds-hide');        
            helper.getData(component,event);
        },1000); 
        
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