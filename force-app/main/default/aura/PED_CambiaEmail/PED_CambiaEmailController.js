({
    navigateToUserProfile : function(component, event, helper) {
        var address = component.get("v.userProfile");
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": address,
            "isredirect" :true
        });
        urlEvent.fire();
    },
    
    changeEmail:function(component, event, helper) {
        var isValidEmail = true; 
        var emailField = component.find("email");
        var emailFieldValue = emailField.get("v.value");
        var confirmEmailField = component.find("confirmEmail");
        var confirmEmailFieldValue = confirmEmailField.get("v.value");
        
        //var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;  
        var regExpEmailformat = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,8})+$/;
        
        if ($A.util.isEmpty(emailFieldValue) ) {
            var sMsg = $A.get("$Label.c.PED_PGEmailErr1");
            emailField.set("v.errors", [{message:sMsg}]);
            isValidEmail = false;
        }
        else{
            if(emailFieldValue.match(regExpEmailformat)){
                emailField.set("v.errors", [{message: null}]);
            }else{
                var sMsg = $A.get("$Label.c.PED_PGEmailErr2");
                emailField.set("v.errors", [{message: sMsg}]);
                isValidEmail = false;
            }
            
        }
        
        
        if ($A.util.isEmpty(confirmEmailFieldValue)) {
            var sMsg = $A.get("$Label.c.PED_PGEmailErr1");
            confirmEmailField.set("v.errors", [{message:sMsg}]);
            isValidEmail = false;
        }
        else{
            if(confirmEmailFieldValue.match(regExpEmailformat)){
                confirmEmailField.set("v.errors", [{message: null}]);
            }else{
                var sMsg = $A.get("$Label.c.PED_PGEmailErr2");
                confirmEmailField.set("v.errors", [{message: sMsg}]);
                isValidEmail = false;
            }
        } 
        
        
        if(isValidEmail){
            // code write here..if Email Address is valid. 
            if(emailFieldValue != confirmEmailFieldValue){
                var sMsg = $A.get("$Label.c.PED_PGConfirmnEmailDiff"); 
                confirmEmailField.set("v.errors", [{message: sMsg}]);
            }else{
                var action = component.get("c.updateEmail_NEW_AS");
                action.setParams({newEmail : emailFieldValue});
                action.setCallback(this,function(a){
                    var state = a.getState();
                    if(state == "SUCCESS"){
                        var myuser= a.getReturnValue();
                        if(myuser == 'blacklistedEmail'){
                        	var sMsg = $A.get("$Label.c.PED_EmailBlacklistedOld");
            				confirmEmailField.set("v.errors", [{message:sMsg}]);
                        }
                        else if(myuser == 'SendEmail'){
                            component.set('v.successMsg','I tuoi dati sono stati aggiornati con successo! A breve riceverai un messaggio al tuo nuovo indirizzo' + ' '+ emailFieldValue+' per confermare la tua nuova e-mail.');
                        }else{
                            confirmEmailField.set("v.errors", [{message: 'L\'indirizzo E-mail risulta gia registrato.'}]);
                        }
                    } 
                    else if(state == "ERROR"){
                        var errors = a.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                console.log("Error message: " + 
                                            errors[0].message);
                            }
                        } else {
                            console.log("Unknown error");
                        }                
                    }
                });
            }
        }
        $A.enqueueAction(action);
    },
    
    validateEmail : function(component,event,helper){
        var emailField = component.find("email");
        var emailFieldValue = emailField.get("v.value");
        //var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;  
        var regExpEmailformat = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,8})+$/;
        // Is input Text?
        if ($A.util.isEmpty(emailFieldValue)) {
            // Set error
            var sMsg = $A.get("$Label.c.PED_PGEmailErr1");
            emailField.set("v.errors", [{message:sMsg}]);
            
            isValidEmail = false;
        }else {  
            if(emailFieldValue.match(regExpEmailformat)){
                if(emailFieldValue.length > 70 ) {
                    var sMsg = $A.get("$Label.c.PED_invalid_email_length");
                    emailField.set("v.errors", [{message: sMsg}]);
                }else{
                    emailField.set("v.errors", [{message: null}]);
                }
            }else{
                var sMsg = $A.get("$Label.c.PED_PGEmailErr2");
                emailField.set("v.errors", [{message: sMsg}]);
            }
        } 
    },
    
    validateConfirmEmail : function(component,event,helper){
        
        var emailField = component.find("confirmEmail");
        var emailFieldValue = emailField.get("v.value");
        //var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;  
        var regExpEmailformat = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,8})+$/;        
        // Is input Text?
        if ($A.util.isEmpty(emailFieldValue)) {
            // Set error
            var sMsg = $A.get("$Label.c.PED_PGEmailErr1");
            emailField.set("v.errors", [{message:sMsg}]);
        }else {  
            if(emailFieldValue.match(regExpEmailformat)){
                if(emailFieldValue.length > 70 ) {
                    var sMsg = $A.get("$Label.c.PED_invalid_email_length");
                    emailField.set("v.errors", [{message: sMsg}]);
                    
                }else{
                    emailField.set("v.errors", [{message: null}]);
                }
            }else{
                var sMsg = $A.get("$Label.c.PED_PGEmailErr2");
                emailField.set("v.errors", [{message: sMsg}]);
            } 
        }
    },
})