({
    doInit : function(component, event, helper) {
        helper.doInit(component,event);
    },
    
    //DF INIZIO RECAPTCHA CUSTOM
    
    doLogIn : function(component, event, helper) {
        debugger;
        var cmpEvent =  $A.get("e.c:RecaptchaEvent1");
        cmpEvent.setParams({"Recaptcha" : true });
        cmpEvent.fire();
    },
    
    doLogIn1 : function(component, event, helper) {
        debugger;

        var param = event.getParam("RecaptchaVerify"); 
        console.log("param "+ param);
        if(param === true)
            helper.doLogIn(component,event);  
    },
    
    //DF FINE RECAPTCHA CUSTOM
    
    /*DF RECAPTCHA INIZIO 
    
    handleReset : function(component, event, helper) {
        var comp = component.find('nicaptcha');
        comp.reset(); 
    },
    handleExecute : function(component, event, helper) {
        var comp = component.find('nicaptcha');
        comp.execute();
    },
    handleGetCaptcha : function(component, event, helper) {
        var comp = component.find('nicaptcha');
        var response = comp.getCaptchaResponse();
        console.log('Response: ' + response);
    }, 
    
    handleCallback : function(component, event, helper) {
        helper.handleCallback(component,event);
        console.log('Callback: ' + event.getParam('response'));
    },
    handleVerifyCallback : function(component, event, helper) {
        console.log('Verified Response: ' + event.getParam('response'));
    },
    handleExpiredCallback : function(component, event, helper) {
        console.log('Expired Callback');
    },
    handleErrorCallback : function(component, event, helper) {
        console.log('Error Callback');
    },
    
    doLogIn : function(component, event, helper) {
        var comp = component.find('nicaptcha');
        comp.execute();
        //helper.doLogIn(component,event);
    },
    
    // DF RECAPTCHA FINE */
    
  /*  doLogIn : function(component, event, helper) {
        helper.doLogIn(component,event);
    }, DF COMMENTATO PER RECAPTCHA CUSOTM*/
    
    registrazione : function(component, event, helper) {
        helper.goToUrl(component,event, "PED_RegistrationPage__c");
    },
    
    recuperaPassword : function(component, event, helper) {
        helper.goToUrl(component,event, "PED_ForgotPassword__c");
    },
    
    goToFaq : function(component, event, helper) {
        helper.goToUrl(component,event, "PED_Faq__c");
    },
    
    noError : function(component, event, helper) {
        helper.noError(component,event);
    },
    
    togglePassword : function(component, event, helper) {
        helper.togglePassword(component,event);
    },
    goToLogin : function(component, event, helper){
        helper.goToUrl(component, event, "PED_LoginClassica__c");
    }
})