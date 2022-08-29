({
    
   /*  callback : function( component,event, helper){
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
    }, */
    doInit : function(component, event, helper) {
        debugger;
        //DF INIZIO

        
        if (((window.location.href.split("/s/")[0]).includes("livepreview"))) {
            component.set("v.spinner", false);

        }else{

            // TODO sistemare if delegato
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
            helper.getData(component,event);
        }
    
        
    },
    downloadPDF : function(component, event, helper){

        component.set("v.spinner", true);
        helper.getDatiUtenteCaratteristiche(component, event);
        component.set("v.spinner", false);


    },
    sendEmail : function(component, event, helper){
        component.set("v.spinner", true);
        helper.getDatiUtenteCaratteristiche(component, event, true);
        component.set("v.spinner", false);
    },
    goBack : function (component, event, helper){
        helper.goBack(component, event);
    }
})