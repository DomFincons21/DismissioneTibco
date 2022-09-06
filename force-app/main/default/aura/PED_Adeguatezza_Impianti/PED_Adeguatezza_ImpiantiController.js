({
    doInit : function(component, event, helper) {
        debugger;
        
        if (((window.location.href.split("/s/")[0]).includes("livepreview"))) {
            component.set("v.spinner", false);

        }else{

            console.log('En el doInit');
            let action = component.get("c.getSupplyData");
            action.setParams(
                { "url": window.location.href }
            );

           
            action.setCallback(this, function(response) {
                var state = response.getState();
                console.log('state ==> '+state);
                if (state === "SUCCESS") {
                    var returnedValue = response.getReturnValue();
                    if(returnedValue != null && returnedValue != undefined){
                       
                        console.log(returnedValue);

                        component.set('v.DatiUtente', returnedValue.supplyData[0]);

                        component.set('v.cliente_k', returnedValue.data.supplyData[0].customerK);          
                        component.set('v.cliente_m', returnedValue.data.supplyData[0].customerM);          
                        component.set('v.cliente_l', returnedValue.data.supplyData[0].customerL);     
                        
                        component.set('v.year', returnedValue.data.supplyData[0].year);
                        component.set('v.indirizzo', returnedValue.data.supplyData[0].supplyAddress);
                    
                        helper.setFornitura(component, event);
                    }
                    
                }  

            });
            $A.enqueueAction(action);
            
            var id = helper.getUniqueId();
            component.set('v.UniqueID' , id);
           
        }
    
        
    },
    downloadPDF : function(component, event, helper){

        component.set("v.spinner", true);
        helper.getDatiUtenteCaratteristiche(component, event, false);
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