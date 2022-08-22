({
    goBack : function(component,event,helper) {
        helper.goBack(component, event);
    },
    doInit : function(component,event,helper) {
    /*DF    if(!component.get('v.isMedio') && !component.get('v.isGrande')) {        
            component.set('v.showFlag',true);
        }
        if(component.get('v.isMedio')){
            component.set('v.showFlag',true);
        }
          var sPageURL = decodeURIComponent(window.location.search.substring(1)); //You get the whole decoded URL of the page.
        var sURLVariables = sPageURL.split('&'); //Split by & so that you get the key value pairs separately in a list
        var sParameterName;
        var i;
        for (i = 0; i < sURLVariables.length; i++) {
            //debugger;
            sParameterName = sURLVariables[i].split('='); //to split the key from the value.
            if (sParameterName[0] === 'POD') { //lets say you are looking for param name - firstName
                if(sParameterName[1] === undefined || sParameterName[1].trim()==='' || sParameterName[1]===null){ 
                    if(!component.get('v.isMedio') && !component.get('v.isGrande')) {    
                        var urlEvent = $A.get("e.force:navigateToURL");
                        urlEvent.setParams({
                            "url": "/le-mie-forniture"
                        });
                        urlEvent.fire(); 
                    }
                }else{ 
                    component.set("v.pods.PED_POD__c",sParameterName[1]);
                    component.set("v.selectedPod",sParameterName[1]);
                }
            }else if(sParameterName[0] === 'id'){//[Start][SS]
                if(!(sParameterName[1] === undefined || sParameterName[1].trim()==='' || sParameterName[1]===null)){
                     component.set("v.accId",sParameterName[1]);
                }
            }else if(sParameterName[0] === 'name'){
                 if(!(sParameterName[1] === undefined || sParameterName[1].trim()==='' || sParameterName[1]===null)){
                     component.set("v.accntName",sParameterName[1]);
                 } 
            }//[End][SS]
            else if(sParameterName[0] === 'tensione'){
                 if(!(sParameterName[1] === undefined || sParameterName[1].trim()==='' || sParameterName[1]===null)){
                     if(sParameterName[1]==='MT')
                        	component.set("v.isMT",true);
                        else if(sParameterName[1]==='AT'){
                             component.set("v.isATRedirect",true);
                        }
                 } 
            }else{
                 if(!component.get('v.isMedio') && !component.get('v.isGrande')) {    
                     var urlEvent = $A.get("e.force:navigateToURL");
                     urlEvent.setParams({
                     "url": "/le-mie-forniture"
                     });
                   urlEvent.fire();  
            }
        }           
    } DF*/
        helper.doInit(component);
    },
    
    /*DF toggle : function(component, event, helper) {
    var toggleText = component.find("mybody");
    $A.util.toggleClass(toggleText, "slds-hide");
    var mybutton = component.find("mybutton");
    if(mybutton.get("v.iconName")!="utility:chevronright"){
        mybutton.set("v.iconName","utility:chevronright");
    }else{
        mybutton.set("v.iconName","utility:chevrondown");
    }
}, DF*/
    
   /*DF itemsChange: function(component, event, helper) {
        var numTens = Number(component.get('v.pods').PED_Num_Tensione__c==undefined?0:component.get('v.pods').PED_Num_Tensione__c);
        if (numTens >= 35000){
            component.set("v.isAT",true);
        }else{
            component.set("v.isAT",false);
        }
    } DF*/
    
})