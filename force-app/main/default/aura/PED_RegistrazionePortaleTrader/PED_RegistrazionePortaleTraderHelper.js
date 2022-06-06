({   
    loadOptions: function (component, event, helper){
        component.set("v.condGen", 'https://www.e-distribuzione.it/content/dam/e-distribuzione/documenti/area-riservata/CLAUSULE%20LEGALI_TRADER_APRILE2020.pdf');
        component.set("v.infPrivacy", 'https://www.e-distribuzione.it/content/dam/e-distribuzione/documenti/area-riservata/Informativa_privacy_GDPR_Trader_022021.pdf');
        
        var action = component.get("c.getNazionalityopts");
        action.setCallback(this, function(response) {
            var nationalityOpts = [];
            for(var i = 0; i < response.getReturnValue().length; i++)
                nationalityOpts.push({"class" : "optionClass", "label" : response.getReturnValue()[i], "value" : response.getReturnValue()[i]});               
            
            component.set("v.nationalityOpts", nationalityOpts);
            component.set("v.account.Nazionalita__c", "Italiana"); //AR non si popola in automatico al caricamento (nella registrazione di PG sì perché si passa da FormFisica a FormGiuridica)
        });
        $A.enqueueAction(action);
    },
    
    clientCheckBlacklistedEmail : function(component, emailFieldValue, emailField) {
        var action = component.get("c.checkBlacklistedEmail");

        action.setParams({
            "email" : emailFieldValue
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue())
                    emailField.setCustomValidity($A.get("$Label.c.PED_EmailBlacklistedNew"));
                else
                    emailField.setCustomValidity("");
                emailField.reportValidity();
            }
        });
        $A.enqueueAction(action);
    },
    
    clientCheckBlacklistedAddrEmail : function(component, emailFieldValue, emailField) {
        var action = component.get("c.checkBlacklistedEmail");

        action.setParams({
            "email" : emailFieldValue
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue())
                    emailField.setCustomValidity($A.get("$Label.c.PED_Email_Specific_Blacklisted"));
                else
                    emailField.setCustomValidity("");
                emailField.reportValidity();
            }
        });
        $A.enqueueAction(action);
    },

    validateCF : function(component, event, isAccount){
        var newContact = component.get("v.newContact");
        if(isAccount){
            var account = component.get("v.account");
            var codiceFiscale = account.CodiceFiscale__c;
            var codiceFiscaleInput;
            var fields = component.find("field");
            for (var i = 0; i < fields.length; i++){
                if(fields[i].get("v.name") == "codiceFiscaleAccount")
                    codiceFiscaleInput = fields[i];
            }
            var nazionalita = $A.util.isEmpty(account.Nazionalita__c) ? "Italiana" : account.Nazionalita__c;
        }
        else{
            var codiceFiscale = newContact.Codice_Fiscale__c;
            var codiceFiscaleInput;
            var fields = component.find("field");
            for (var i = 0; i < fields.length; i++){
                if(fields[i].get("v.name") == "codiceFiscale")
                    codiceFiscaleInput = fields[i];
            }
            var nazionalita = $A.util.isEmpty(newContact.PED_Nazionalit__c) ? "Italiana" : newContact.PED_Nazionalit__c;
        }

        if(!$A.util.isEmpty(codiceFiscale)){
            if(nazionalita == "Italiana"){
                var regExpformat = /^(?:[A-Z][AEIOU][AEIOUX]|[B-DF-HJ-NP-TV-Z]{2}[A-Z]){2}(?:[\dLMNP-V]{2}(?:[A-EHLMPR-T](?:[04LQ][1-9MNP-V]|[15MR][\dLMNP-V]|[26NS][0-8LMNP-U])|[DHPS][37PT][0L]|[ACELMRT][37PT][01LM]|[AC-EHLMPR-T][26NS][9V])|(?:[02468LNQSU][048LQU]|[13579MPRTV][26NS])B[26NS][9V])(?:[A-MZ][1-9MNP-V][\dLMNP-V]{2}|[A-M][0L](?:[1-9MNP-V][\dLMNP-V]|[0L][1-9MNP-V]))[A-Z]$/i;
                if(($A.util.isEmpty(newContact.FirstName) || $A.util.isEmpty(newContact.LastName)) && codiceFiscale.match(regExpformat)){
                    codiceFiscaleInput.setCustomValidity("Nome e cognome devono essere compilati");
                    codiceFiscaleInput.reportValidity();
                }
                else if(codiceFiscale.match(regExpformat)){
                    var nome = newContact.FirstName.replace("'", "");
                    var cognome = newContact.LastName.replace("'", "");
                    var childcomp = component.find("checkCF");
                    childcomp.CallCheckCF(codiceFiscale, nome, cognome, codiceFiscaleInput.get("v.name"));
                }
                else{
                    codiceFiscaleInput.setCustomValidity($A.get("$Label.c.PED_CodicefiscaleErr"));
                    codiceFiscaleInput.reportValidity();
                }
            }
            else{
                codiceFiscaleInput.setCustomValidity("");
                codiceFiscaleInput.reportValidity();
            }
        } 
        else{
            codiceFiscaleInput.setCustomValidity("");
            codiceFiscaleInput.reportValidity();
        }
    },

    validateCodiceFiscaleAccount : function(component, event, inputCmp){
        var input = inputCmp ? inputCmp : event.getSource();
        if(input.get("v.value"))
            this.validatePartitaIva(component, event, true);
        else{
            input.setCustomValidity("");
            input.reportValidity();
        }
    },

    validatePartitaIva : function(component, event, isCF){
        var account = component.get("v.account");
        var fields = component.find("field");
        var partitaIvaInput
        for (var i = 0; i < fields.length; i++){
            if(fields[i].get("v.name") == "partitaIVA" && !isCF)
                partitaIvaInput = fields[i];
            else if(fields[i].get("v.name") == "codiceFiscaleAccount" && isCF)
                partitaIvaInput = fields[i];
        }
        
        if(!$A.util.isEmpty(partitaIvaInput.get("v.value"))){
            if(account.Nazionalita__c == "Italiana"){
                var regExpformat = /^[0-9]{11}$/;               
                if(partitaIvaInput.get("v.value").match(regExpformat)){
                    var childcomp = component.find("checkPIVACF");
                    childcomp.ChkValidPTIVA_CFNum(partitaIvaInput.get("v.value"), !isCF, partitaIvaInput.get("v.name"), account.Nazionalita__c, false, false);
                }
                else{
                    if(isCF)
                        partitaIvaInput.setCustomValidity($A.get("$Label.c.PED_CodicefiscaleErr"));
                    else
                        partitaIvaInput.setCustomValidity($A.get("$Label.c.PED_PartitaIvaErr1"));
                    partitaIvaInput.reportValidity();
                }
            }            
            else{
                var childcomp = component.find("checkPIVACF");
                childcomp.ChkValidPTIVA_CFNum(partitaIvaInput.get("v.value"), !isCF, partitaIvaInput.get("v.name"), account.Nazionalita__c); 
            }            
        } 
        else{
            partitaIvaInput.setCustomValidity("");
            partitaIvaInput.reportValidity();
        }
    },

    validateRecord : function(component) {
        var validSoFar = true;
        var v = component.find("field").reduce(
            function (validSoFar, inputCmp) {
                var valid = inputCmp.get("v.validity").valid;
                inputCmp.showHelpMessageIfInvalid();
                return validSoFar && valid;
            }, true);
        return v;
    },

    handleValueChangeGiuridicaCaptcha : function(component, event){
        if(component.get("v.formMessageGiuridica") === "Success"){
            component.set("v.captchaValid", true);
            this.savePersonagiuridiRecord(component, event);
        }
        else{
            if(component.get("v.formMessageGiuridica") === "Sorry, we could not verify you.")
                this.showWarning("Attenzione", "Si è verificato un errore durante la validazione del captcha");
            else if(component.get("v.formMessageGiuridica") === "Captcha Obbligatorio")
                this.showWarning("Attenzione", "Bisogna prima validare il captcha");
            component.set("v.captchaValid", false);
            component.set("v.Spinner", false);
        }
    },

    savePersonagiuridiRecord : function(component, event){
        window.scrollTo(0, 0);
        if(this.validateRecord(component)){ 
            var newContact = component.get("v.newContact");
            var account = component.get("v.account");
            this.createPersonagiuridicaRecord(component, newContact, account, true);
        }
        else{
            component.set("v.Spinner", false);
            this.showWarning("Attenzione", "Sono presenti degli errori nel form di registrazione");
        }
    },
    
    createPersonagiuridicaRecord : function(component, newContact, account, flagCheck) {
        component.set("v.Spinner", true);
        var action;
        if(flagCheck){   
            action = component.get("c.checkRegistrationPortaleTrader");
            component.set("v.typeRegistration","GT");
        }
        else{
            action = component.get("c.RegistrationUserGTrader");   
            component.set("v.typeRegistration","GF");         
        }

        action.setParams({
            "cont": newContact,
            "acc": account,
            "Sedelegaled" : account.Nazionalita__c,
            "cell" : newContact.MobilePhone,
            "ipUtente" : component.get("v.ipUtenteG")
        });

        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == "SUCCESS"){
                var status = response.getReturnValue();
                if(status == "ok"){
                    component.set("v.hideformaftrsuc",false); 
                    if(component.get("v.typeRegistration") == "GF")                        
                        component.set("v.showOTP", false);
                    else
                        this.resendCode(component, event);
                }
                else if(status == "error"){
                    this.showError("Errore", $A.get("$Label.c.PED_PFErrorStatus"));
                }
                else if(status == "ErrorEnotify"){
                    component.set("v.hideformaftrsuc",false);  
                    component.set('v.showErrorEnotify',true);
                    component.set("v.isSucc", true);
                    component.set("v.messageToShow", "Ops, il messaggio non è stato inviato. Prova di nuovo cliccando su reinvia codice.");
                }
                else{
                    var fields = component.find("field");
                    var emailInput;
                    var phoneInput;
                    var ivaInput;
                    var cfInput;
                    var cfLegaleInput;

                    this.showWarning("Attenzione", "Si è verificato un errore, controllare i valori inseriti");

                    for(var i = 0; i < fields.length; i++){
                        if(fields[i].get("v.name") == "email")
                            emailInput = fields[i];
                        else if(fields[i].get("v.name") == "cellulare")
                            phoneInput = fields[i];
                        else if(fields[i].get("v.name") == "partitaIVA")
                            ivaInput = fields[i];
                        else if(fields[i].get("v.name") == "codiceFiscaleAccount")
                            cfInput = fields[i];
                        else if(fields[i].get("v.name") == "codiceFiscale")
                            cfLegaleInput = fields[i];
                    }

                    if(status == "limitCell"){
                        phoneInput.setCustomValidity("Attenzione: il numero di cellulare è già stato utilizzato. Si prega di inserire un nuovo numero");
                        phoneInput.reportValidity();
                    }
                    else if(status == "useravailable"){
                        emailInput.setCustomValidity($A.get("$Label.c.PED_UserAvailable"));
                        emailInput.reportValidity();
                    }
                    else if(status == "CFavailable"){
                        cfLegaleInput.setCustomValidity($A.get("$Label.c.PED_UserAvailable"));
                        cfLegaleInput.reportValidity();
                    }
                    else if(status == "errorIVA"){
                        ivaInput.setCustomValidity("Attenzione: il codice fiscale indicato è già registrato, si prega di inserire la partita IVA corrispondente");
                        phoneInput.reportValidity();
                    }
                    else if(status == "errorCF"){
                        cfInput.setCustomValidity("Attenzione: la partita IVA indicata è già registrata, si prega di inserire il codice fiscale corrispondente");
                        cfInput.reportValidity();
                    }
                    else if(status == "blacklistedEmail"){
                        emailInput.setCustomValidity($A.get("$Label.c.PED_EmailBlacklistedNew"));
                        emailInput.reportValidity();
                    }
                    else if(status == "blacklistedAddressEmail"){
                        emailInput.setCustomValidity($A.get("$Label.c.PED_Email_Specific_Blacklisted"));
                        emailInput.reportValidity();
                    }
                    else if(status == "limitEmail"){
                        emailInput.setCustomValidity("Attenzione: la tua email è già stata utilizzata. Si prega di inserire una nuova email");
                        emailInput.reportValidity();
                    }
                    else if(status.indexOf("limitFreeze") >= 0){
                        emailInput.setCustomValidity("Attenzione. L’email inserita è stata già utilizzata nelle ultime " + status.split('-')[1] + " ore. Si prega di inserire un\'altra email");
                        emailInput.reportValidity();
                    }
                }
            }
            else if (state == "ERROR"){
                this.showError('Errore', $A.get("$Label.c.PED_PFErrorStatus"));
            }

            component.set('v.Spinner',false);
        });
        $A.enqueueAction(action);
    },
    
    checkOTP: function(component, event, token){
        component.set("v.Spinner", true);
        var action = component.get('c.checkOTPApex');

        action.setParams({
            "mobile" : component.get("v.newContact.MobilePhone"),
            "token" : token,
            "processo" : "Prima registrazione",
            "a" : component.get('v.account'),
            "c" : component.get('v.newContact'),
            "IP" : component.get("v.ipUtenteG"),
            "isGiur" : true
        });

        action.setCallback(this,function(response){
            var state = response.getState();
            if(state == 'SUCCESS'){
                var returnvalue = response.getReturnValue();
                if(returnvalue == 'OK'){
                    var newContact = component.get("v.newContact");
                    var accountobj = component.get("v.account");
                    this.createPersonagiuridicaRecord(component, newContact, accountobj, false);                
                    component.set("v.disableOTP", true);
                }
                else{
                    var input = component.find("field")[0];
                    input.setCustomValidity("L\'OTP non è corretto.");
                    input.reportValidity();
                    component.set('v.Spinner', false);  
                }
            }
            else{
                var input = component.find("field")[0];
                input.setCustomValidity("Si è verificato un errore durante il controllo dell\'OTP. Invia di nuovo il codice e riprova.");
                input.reportValidity();
                component.set('v.Spinner', false);  
            }
        });
        $A.enqueueAction(action);       
    },
    
    resendCode :function(component,event){
        component.set("v.Spinner", true);
        var action = component.get("c.sendCodeOTP");

        action.setParams({
            "cell" : component.get("v.newContact.MobilePhone")
        });

        action.setCallback(this,function(response){
            clearTimeout(component.timeOutOTP);
            var state = response.getState();
            if(state == "SUCCESS"){
                var result = response.getReturnValue();
                if(result == "OK"){
                    if(component.codeSent){
                        component.set("v.isSucc", true);
                        component.set("v.messageToShow", "Codice inviato con successo."); 
                    }
                    else
                        component.codeSent = true;                  
                }
                else if(result == "ErrorEnotify"){
                    component.set("v.showErrorEnotify", true);
                    component.set("v.isSucc", true);
                    component.set("v.messageToShow", "Ops, il messaggio non è stato inviato. Prova di nuovo cliccando su reinvia codice."); 
                }
            }
            else{
                component.set("v.showErrorEnotify", true);  
                component.set("v.isSucc", true);
                component.set("v.messageToShow", "Ops, il messaggio non è stato inviato. Prova di nuovo cliccando su reinvia codice."); 
            }        
            component.set("v.Spinner", false);
        });

        component.timeOutOTP = setTimeout(function(){
            component.set("v.Spinner", false);
        }, 10000);

        $A.enqueueAction(action);  
    },

    checkOTPEmail: function(component, event, token){        
        component.set("v.Spinner", true);
        var action = component.get("c.checkOTPApexEmail");

        action.setParams({
            "email" : component.get("v.newContact.Email").trim(),
            "token" : token
        });

        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == "SUCCESS"){
                var returnvalue = response.getReturnValue();
                if(returnvalue == "OK")
                     component.set("v.showOTPEmail", false);                 
                else{
                    var input = component.find("field")[0];
                    input.setCustomValidity("L\'OTP non è corretto.");
                    input.reportValidity();
                }
            }
            else{
                var input = component.find("field")[0];
                input.setCustomValidity("Si è verificato un errore durante il controllo dell\'OTP. Invia di nuovo il codice e riprova.");
                input.reportValidity();
            }
            component.set("v.Spinner", false);
        });
        $A.enqueueAction(action);       
    },

    sendCodeEmail : function(component, event){
        var action = component.get('c.sendCodeOTPEmail');

        action.setParams({
            "userN" : component.get('v.newContact').Email + ".pc"
        });

        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == "SUCCESS"){
                var result = response.getReturnValue();
                if(result){
                    if(component.emailSent){
                        component.set("v.isSucc", true);
                        component.set("v.messageToShow", "Codice inviato con successo."); 
                    }
                    else
                        component.emailSent = true;
                }
                else{
                    var input = component.find("field");
                    input.setCustomValidity("Si è verificato un errore durante il controllo dell\'OTP. Invia di nuovo il codice e riprova.");
                    input.reportValidity();
                }
            }
            else{
                var input = component.find("field");
                input.setCustomValidity("Si è verificato un errore durante il controllo dell\'OTP. Invia di nuovo il codice e riprova.");
                input.reportValidity();
            }
        });
        $A.enqueueAction(action);  
    },

    showError : function(title, message) {
        this.showToast("error", title, message);
    },

    showWarning : function(title, message) {
        this.showToast("warning", title, message);
    }, 
    
    showSuccess : function(title, message) {
        this.showToast("success", title, message);
    },

    showToast : function(type, title, message) {
	    var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "mode" : "dismissible",
            "title" : title,
            "message" : message,
            "type" : type
        });
        toastEvent.fire();
    }
 });