({
    doInit : function (component, event, helper) {   
        helper.loadOptions(component, event);
        component.set("v.newContact.MobilePhone", "+39");
    },

    toUpperCase : function(component, event, helper){
        var input = event.getSource();
        var value = input.get("v.value").toUpperCase();
        input.set("v.value", value);
    },

    checkCF : function(component, event, helper){
        var codiceFiscale = component.get("v.newContact.Codice_Fiscale__c");
        if(!$A.util.isEmpty(codiceFiscale))
            helper.validateCF(component, event, false);
        var formFisico = component.get("v.formFisico");
        if(!formFisico){
            codiceFiscale = component.get("v.account.CodiceFiscale__c");
            if(!$A.util.isEmpty(codiceFiscale) && isNaN(codiceFiscale))
                helper.validateCF(component, event, true);
        }
    },

    validateConfirmEmail : function(component, event, helper){
        var fields = component.find("field");
        var email;
        var confermaEmail;

        for(var i = 0; i < fields.length; i++){
            if(fields[i].get("v.name") == "email")
                email = fields[i];
            else if(fields[i].get("v.name") == "confermaEmail")
                confermaEmail = fields[i];
        }

        email.setCustomValidity("");
        email.reportValidity();
        
        confermaEmail.setCustomValidity("");
        if(email.get("v.value") != confermaEmail.get("v.value") && !$A.util.isEmpty(confermaEmail.get("v.value")) && confermaEmail.get("v.validity").valid)
           confermaEmail.setCustomValidity($A.get("$Label.c.PED_PGConfirmnEmailDiff"));
        
        if(event.getSource().get("v.name") == "confermaEmail" || !$A.util.isEmpty(confermaEmail.get("v.value")))
            confermaEmail.reportValidity();
        
        if(event.getSource().get("v.name") == "email" && email.get("v.validity").valid){
            helper.clientCheckBlacklistedEmail(component, email.get("v.value"), email);
            helper.clientCheckBlacklistedAddrEmail(component, email.get("v.value"), email);
        }
    },
    
    validateCF : function(component, event, helper){
        helper.validateCF(component, event, false);
    },

    getAllEvtParam : function (component, event, helper) {
        var error = event.getParam("Err");
        var inputName = event.getParam("compId");
        var input;

        var fields = component.find("field");
        for (var i = 0; i < fields.length; i++){
            if(fields[i].get("v.name") == inputName)
                input = fields[i];
        }

        if(error !== null)
            input.setCustomValidity(error);
        else
            input.setCustomValidity("");
        
        input.reportValidity();
    },

    checkPrefisso : function (component, event, helper){
        var telefono = component.get("v.telefono");
        if(!telefono.startsWith("+39")){
            if(telefono.length >= 3){
                var oldVaue = event.getParam("oldValue");
                telefono = "+39" + oldVaue.replace("+39", "");
            }
            else
                telefono = "+39";
            component.set("v.telefono", telefono);
        }
    },

    checkAllZero : function (component, event, helper){
        var telefono = component.get("v.telefono");
        var telefonoInput = event.getSource();
        var allZero = true;
        for (var i = 3; i < telefono.length; i++) {
            if (telefono[i] != 0)
                allZero = false;
        }
        
        if(allZero)
            telefonoInput.setCustomValidity("Inserire un numero di cellulare valido");
        else
            telefonoInput.setCustomValidity("");
        
        telefonoInput.reportValidity();
        component.set("v.newContact.MobilePhone", telefono);
    },

    validateCodiceFiscaleAccount : function(component, event, helper){
        helper.validateCodiceFiscaleAccount(component, event, null);
    },

    validateCFPartitaIVA : function(component, event, helper){
        var account = component.get("v.account");
        if(!$A.util.isEmpty(account.CodiceFiscale__c)){
            var codiceFiscaleInput;
            var fields = component.find("field");
            for (var i = 0; i < fields.length; i++){
                if(fields[i].get("v.name") == "codiceFiscaleAccount")
                    codiceFiscaleInput = fields[i];
            }
            helper.validateCodiceFiscaleAccount(component, event, codiceFiscaleInput);
        }
        if(!$A.util.isEmpty(account.PartitaIVA__c))
            helper.validatePartitaIva(component, event, false);
    },
    
    validatePartitaIva : function(component, event, helper){
        helper.validatePartitaIva(component, event, false);
        var codiceFiscaleInput;
        var fields = component.find("field");
        for (var i = 0; i < fields.length; i++){
            if(fields[i].get("v.name") == "codiceFiscaleAccount")
                codiceFiscaleInput = fields[i];
        }
        helper.validateCodiceFiscaleAccount(component, event, codiceFiscaleInput);
    },

    clickRegistraGiuridica : function(component, event, helper){
        component.set("v.Spinner", true);        
        if(!component.get("v.captchaValid")){
            var formMessageGiuridica = component.get("v.formMessageGiuridica");
            if(!$A.util.isEmpty(formMessageGiuridica) && formMessageGiuridica != 'Scaduto')
                helper.handleValueChangeGiuridicaCaptcha(component, event);
            else
                component.find("captchaIdGiuridica").validateToken();
        }
        else
            helper.savePersonagiuridiRecord(component, event);
    },

    handleValueChangeGiuridicaCaptcha : function(component, event, helper){
        helper.handleValueChangeGiuridicaCaptcha(component, event);
    },
    
    validateOTP : function(component, event, helper){
        var otp = event.getSource();
        component.set("v.disableOTP", otp.get("v.value").trim().length != 5);
    },
    
    checkOTP : function(component, event, helper){
        helper.checkOTP(component, event, component.find("field")[0].get("v.value"));
    },
    
    resendCode : function(component, event, helper){
        helper.resendCode(component, event);
    },

    checkOTPEmail :function(component, event, helper){
        helper.checkOTPEmail(component, event,  component.find("field")[0].get("v.value"));
    },

    resendCodeEmail :function(component, event, helper){
        helper.sendCodeEmail(component, event);
    },
    
    backToRegistration : function(component, event, helper){
        component.set("v.hideformaftrsuc", true);
        component.set("v.showOTP", true);
        component.set("v.showOTPEmail", true);
        component.emailSent = false;
        component.codeSent = false;
    }
})