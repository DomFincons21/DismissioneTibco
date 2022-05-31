({   
    loadOptions: function (component, event) {   
        component.set("v.condGen", "https://www.e-distribuzione.it/content/dam/e-distribuzione/documenti/area-riservata/Condizioni_generali_servizi_offerti_App_Portale.pdf");     
        component.set("v.infPrivacy", "https://www.e-distribuzione.it/content/dam/e-distribuzione/documenti/area-riservata/Informativa_Privacy_App_Portale.pdf");

        var action = component.get("c.getNazionalityopts");
        action.setCallback(this, function(response) {
            var nationalityOpts = [];
            for(var i = 0; i < response.getReturnValue().length; i++)
                nationalityOpts.push({"class" : "optionClass", "label" : response.getReturnValue()[i], "value" : response.getReturnValue()[i]});               
            
            component.set("v.nationalityOpts", nationalityOpts);
        });
        $A.enqueueAction(action);
    },
    
    changefield : function(component, event){
        //debugger;
        
        var fields = component.find("field");
        
        for(var i = 0; i < fields.length; i++){
            if(fields[i].get("v.name") == "formType")
                var formType = fields[i].get("v.checked");
            else if(fields[i].get("v.name") == "email"){
                var email = fields[i].get("v.value");
                var emailvalidity = fields[i].get("v.validity"); }
                else if(fields[i].get("v.name") == "confermaEmail"){
                    var confermaEmail = fields[i].get("v.value");
                    var confermaemailvalidity = fields[i].get("v.validity"); }
                    else if(fields[i].get("v.name") == "nome")
                        var nome = fields[i].get("v.value");
                        else if(fields[i].get("v.name") == "cognome")
                            var cognome = fields[i].get("v.value");
                            else if(fields[i].get("v.name") == "nazionalità"){
                                if(fields[i].get("v.label") == "Nazionalità")
                                    var nazionalità = fields[i].get("v.value");
                                else if(fields[i].get("v.label") == "Sede legale di rappresentanza")
                                    var nazionalitàSede = fields[i].get("v.value");}
                                else if(fields[i].get("v.name") == "codiceFiscale"){
                                    var codiceFiscale = fields[i].get("v.value");
                                    var cfvalidity = fields[i].get("v.validity"); }
                                    else if(fields[i].get("v.name") == "cellulare"){
                                        var cellulare = fields[i].get("v.value");
                                        var validitycell = fields[i].get("v.validity");  }
                                        else if(fields[i].get("v.name") == "ragioneSociale")
                                            var ragioneSociale = fields[i].get("v.value");
            
                                            else if((fields[i].get("v.name") == "codiceFiscaleAccount") && (formType == true)){
                                                var codiceFiscaleAccount = fields[i].get("v.value");
                                                var codiceFiscaleAccountValidity = fields[i].get("v.validity");  }
                                                else if(fields[i].get("v.name") == "partitaIVA" && formType == true){
                                                    var partitaIVA = fields[i].get("v.value");
                                                    var partitaIVAvalidity = fields[i].get("v.validity"); }
        }
        var clausolaA = component.get("v.newContact.PED_ClausolaLegaleA__c");
        var clausolaB = component.get("v.newContact.PED_ClausolaLegaleB__c");
        
        
        console.log("formType ", formType); // false persona fisica e true persona giuridica
        console.log("email ", email);
        console.log("emailvalidity ", emailvalidity.valid); // deve tornare true
        console.log("confermaEmail ", confermaEmail);
        console.log("confermaemailvalidity ", confermaemailvalidity.valid); // deve tornare true
        console.log("nome ", nome);
        console.log("cognome ", cognome);
        console.log("nazionalità ", nazionalità);
        console.log("codiceFiscale ", codiceFiscale);
        console.log("cfvalidity ", cfvalidity.valid); // deve tornare true
        
        console.log("cellulare ", cellulare);
        console.log("validitycell ", validitycell.valid);
        //debugger;
        
        if(formType == true){
            console.log("codiceFiscaleAccount ", codiceFiscaleAccount);
            console.log("codiceFiscaleAccountValidity", codiceFiscaleAccountValidity.valid); // deve tornare true
            console.log("partitaIVA ", partitaIVA);
            console.log("partitaIVAvalidity ", partitaIVAvalidity.valid);}
        console.log("clausolaA ", clausolaA);
        console.log("clausolaB ", clausolaB); 
        
        // Sezione Persona Fisica
        
        if((email != null && email != '') && (confermaEmail != null && confermaEmail != '') && (nome != null && nome != '') && (cognome != null && cognome != '')
           && (nazionalità != '') && (codiceFiscale != null && codiceFiscale != '') && (cellulare != '+39') 
           && (clausolaA != null && clausolaA != '' && clausolaA != false) && (clausolaB != null && clausolaB != '' && clausolaB != false)
           && (emailvalidity.valid && confermaemailvalidity.valid) && (cfvalidity.valid && validitycell.valid)){
            
            component.set("v.ActiveRegFisica", false);
        }
        else{
            component.set("v.ActiveRegFisica", true);
        }
        
        
        // Sezione Persona Giuridica
        if((codiceFiscaleAccount.substring(0, 1) == 8 || codiceFiscaleAccount.substring(0, 1) == 9) && (partitaIVA == null || partitaIVA == '')){
            if((ragioneSociale != null && ragioneSociale != '') && (codiceFiscaleAccount != null && codiceFiscaleAccount != '')
               && (nazionalitàSede != '') && (nome != null && nome != '')
               && (cognome != null && cognome != '') && (nazionalità != '') && (codiceFiscale != null && codiceFiscale != '')
               && (email != null && email != '') && (confermaEmail != null && confermaEmail != '') && (cellulare != '+39')
               && (clausolaA != null && clausolaA != '' && clausolaA != false) && (clausolaB != null && clausolaB != '' && clausolaB != false)
               && (emailvalidity.valid && confermaemailvalidity.valid) && (cfvalidity.valid && validitycell.valid)
               && (codiceFiscaleAccountValidity.valid)){
                
                component.set("v.ActiveRegGiuridica", false);
            }
            else
                component.set("v.ActiveRegGiuridica", true); 
        }
        else if((codiceFiscaleAccount.substring(0, 1) == 8 || codiceFiscaleAccount.substring(0, 1) == 9) && (partitaIVA != null || partitaIVA != '')){
            if((ragioneSociale != null && ragioneSociale != '') && (codiceFiscaleAccount != null && codiceFiscaleAccount != '')
               && (partitaIVA != null && partitaIVA != '') && (nazionalitàSede != '') && (nome != null && nome != '')
               && (cognome != null && cognome != '') && (nazionalità != '') && (codiceFiscale != null && codiceFiscale != '')
               && (email != null && email != '') && (confermaEmail != null && confermaEmail != '') && (cellulare != '+39')
               && (clausolaA != null && clausolaA != '' && clausolaA != false) && (clausolaB != null && clausolaB != '' && clausolaB != false)
               && (emailvalidity.valid && confermaemailvalidity.valid) && (cfvalidity.valid && validitycell.valid)
               && (codiceFiscaleAccountValidity.valid && partitaIVAvalidity.valid)){
                
                component.set("v.ActiveRegGiuridica", false);
            }
            else
                component.set("v.ActiveRegGiuridica", true); 
        }
        
            else{
                if((ragioneSociale != null && ragioneSociale != '') && (codiceFiscaleAccount != null && codiceFiscaleAccount != '')
                   && (partitaIVA != null && partitaIVA != '') && (nazionalitàSede != '') && (nome != null && nome != '')
                   && (cognome != null && cognome != '') && (nazionalità != '') && (codiceFiscale != null && codiceFiscale != '')
                   && (email != null && email != '') && (confermaEmail != null && confermaEmail != '') && (cellulare != '+39')
                   && (clausolaA != null && clausolaA != '' && clausolaA != false) && (clausolaB != null && clausolaB != '' && clausolaB != false)
                   && (emailvalidity.valid && confermaemailvalidity.valid) && (cfvalidity.valid && validitycell.valid)
                   && (codiceFiscaleAccountValidity.valid && partitaIVAvalidity.valid)){
                    
                    component.set("v.ActiveRegGiuridica", false);
                }
                else
                    component.set("v.ActiveRegGiuridica", true); 
            }
    },
    
    clientCheckBlacklistedEmail : function(component, emailFieldValue, emailField) {
        var action = component.get("c.checkBlacklist");

        action.setParams({
            "email" : emailFieldValue
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue()){
                    emailField.setCustomValidity($A.get("$Label.c.PED_EmailBlacklistedNew"));
                    component.set("v.confirmedEmail","");
                    component.set("v.disableEmail", true);

                }else{
                    emailField.setCustomValidity("");
                    component.set('v.disableEmail', false);
                }
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
                else if(fields[i].get("v.name") == "nazionalità"){
                    if(fields[i].get("v.label") == "Nazionalità")
                        var nazionalita = fields[i].get("v.value");
                }
                
            }
            
            // var nazionalita = $A.util.isEmpty(newContact.PED_Nazionalit__c) ? "Italiana" : newContact.PED_Nazionalit__c; // tolto tb
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
                    // console.log("@@DF childcomp.CallCheckCF " + childcomp.CallCheckCF(codiceFiscale, nome, cognome, codiceFiscaleInput.get("v.name")));
                    // codiceFiscaleInput.setCustomValidity(""); //DF
                    
                } 
                    else{
                        codiceFiscaleInput.setCustomValidity($A.get("$Label.c.PED_CodicefiscaleErr"));
                        codiceFiscaleInput.reportValidity();
                    }
            }
            
            else if(nazionalita == ''){
                    codiceFiscaleInput.setCustomValidity("Seleziona una Nazionalità");
                    codiceFiscaleInput.reportValidity();
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
        
        this.changefield(component, event);
    },

    validateCodiceFiscaleAccount : function(component, event, inputCmp){
        var input = inputCmp ? inputCmp : event.getSource();
        if(input.get("v.value")){
            console.log("test nan: "+isNaN(input.get("v.value")));
            if(isNaN(input.get("v.value"))){
                component.set("v.account.PED_IsEnte__c", false);
                this.validateCF(component, event, true);
            }
            else{
                this.validatePartitaIva(component, event, true);
                var value = input.get("v.value");
                if(!$A.util.isEmpty(value)){
                    component.set("v.requiredPartitaIVA", !value.startsWith("9") && !value.startsWith("8"));
                    component.set("v.account.PED_IsEnte__c", (value.startsWith("9") || value.startsWith("8")));
                    var partitaIVA = component.get("v.account.PartitaIVA__c");
                    if(!partitaIVA)
                        component.set("v.account.PartitaIVA__c", undefined);
                }
                else
                    component.set("v.requiredPartitaIVA", true);
            }
        }
        else{
            component.set("v.account.PED_IsEnte__c", false);
            component.set("v.requiredPartitaIVA", true);
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
        console.log("partitaIvaInput: "+partitaIvaInput);
        
        if(!$A.util.isEmpty(partitaIvaInput.get("v.value"))){
            if(!isCF)
                component.set("v.account.PED_IsEnte__c", false);
            var maybeEnte = partitaIvaInput.get("v.value").startsWith('8') || partitaIvaInput.get("v.value").startsWith('9');
            if(account.Nazionalita__c == "Italiana"){
                var regExpformat = /^[0-9]{11}$/;               
                if(partitaIvaInput.get("v.value").match(regExpformat)){
                    var childcomp = component.find("checkPIVACF");
                    childcomp.ChkValidPTIVA_CFNum(partitaIvaInput.get("v.value"), !isCF, partitaIvaInput.get("v.name"), account.Nazionalita__c, maybeEnte, isCF);
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

    handleValueChangeFisicaCaptcha : function(component, event){;
        if(component.get("v.formMessageFisica") === "Success"){
            component.set("v.captchaValid", true);
            this.savePersonaFisicaRecord(component, event);
        }
        else{
            if(component.get("v.formMessageFisica") === "Sorry, we could not verify you.")
                this.showWarning("Attenzione", "Si è verificato un errore durante la validazione del captcha");
            else if(component.get("v.formMessageFisica") === "Captcha Obbligatorio")
                this.showWarning("Attenzione", "Bisogna prima validare il captcha");
            component.set("v.captchaValid", false);
            component.set("v.Spinner", false);
        }
    },
    
    savePersonaFisicaRecord : function(component, event) {
        window.scrollTo(0, 0);
        if(this.validateRecord(component)){
            var newContact = component.get("v.newContact");
            this.personaFisicaRecord(component, newContact, true);
        }
        else{
            component.set("v.Spinner", false);
            this.showWarning("Attenzione", "Sono presenti degli errori nel form di registrazione");
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
    
    personaFisicaRecord : function(component, newContact, flagCheck) {
        var action;
        if(flagCheck){   
            action = component.get("c.checkRegistrationUserF");
            component.set("v.typeRegistration", "FT");
        }
        else{
            action = component.get("c.RegistrationUserF");  
            component.set("v.typeRegistration", "FF");
        }

        action.setParams({
            "cont" : newContact,
            "cell" : newContact.MobilePhone,
            "ipUtente" : component.get("v.ipUtenteF")
        });

        action.setCallback(this,function(response){
            var state = response.getState();
            if(state == "SUCCESS"){
                var status = response.getReturnValue();
                if(status == "ok"){
                    component.set("v.hideformaftrsuc", false);
                    if(component.get("v.typeRegistration") == "FF")  
                        component.set("v.showOTP", false);    
                    else
                        this.resendCode(component, event);
                }
                else if(status == "error")
                    this.showError("Errore", $A.get("$Label.c.PED_PFErrorStatus"));
                else if(status == "ErrorEnotify"){
                    component.set("v.hideformaftrsuc", false);
                    component.set("v.showErrorEnotify", true);
                    component.set("v.isSucc", true);
                    component.set("v.messageToShow", "Ops, il messaggio non è stato inviato. Prova di nuovo cliccando su reinvia codice.");
                }
                else{
                    var fields = component.find("field");
                    var emailInput;
                    var phoneInput;
                    var cfLegaleInput;

                    this.showWarning("Attenzione", "Si è verificato un errore, controllare i valori inseriti");

                    for(var i = 0; i < fields.length; i++){
                        if(fields[i].get("v.name") == "email")
                            emailInput = fields[i];
                        else if(fields[i].get("v.name") == "cellulare")
                            phoneInput = fields[i];
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
            else if (state === "ERROR")
                this.showError('Errore', $A.get("$Label.c.PED_PFErrorStatus"));
            
            component.set("v.Spinner", false);
        });
        $A.enqueueAction(action);      
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
    
    savePersonagiuridiRecord : function(component, event) {
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

    //MB - funzione da rivedere
    createPersonagiuridicaRecord : function(component, newContact, account, flagCheck){
        component.set("v.Spinner", true);
        var action;
        if(flagCheck){
            action = component.get("c.checkRegistrationUserG");
            component.set("v.typeRegistration", "GT");
        }
        else{
            action = component.get("c.RegistrationUserG");   
            component.set("v.typeRegistration", "GF");
        }
        
        action.setParams({
            "cont" : newContact,
            "acc" : account,
            "Sedelegaled" : account.Nazionalita__c,
            "cell" : newContact.MobilePhone,
            "ipUtente" : component.get("v.ipUtenteG")
        });

        action.setCallback(this,function(response){
            var state = response.getState();
            if(state == "SUCCESS"){
                var status = response.getReturnValue();
                if(status == "ok"){
                    component.set("v.hideformaftrsuc", false);
                    if(component.get("v.typeRegistration") == "GF")  
                        component.set("v.showOTP", false);    
                    else
                        this.resendCode(component, event);
                }
                else if(status == "error")
                    this.showError("Errore", $A.get("$Label.c.PED_PFErrorStatus"));
                else if(status == "ErrorEnotify"){
                    component.set("v.hideformaftrsuc", false);
                    component.set("v.showErrorEnotify", true);
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
            else if (state === "ERROR")
                this.showError('Errore', $A.get("$Label.c.PED_PFErrorStatus"));
            
            component.set("v.Spinner", false);
        });
        $A.enqueueAction(action);
    },
    
    checkOTP : function(component, event, token){
        component.set("v.Spinner", true);
        var action = component.get("c.checkOTPApex");

        action.setParams({
            "mobile" : component.get("v.newContact.MobilePhone"),
            "token" : token,
            "processo" : "Prima registrazione",
            "a" : component.get('v.account'),
            "c" : component.get('v.newContact'),
            "IP" : component.get("v.ipUtenteG"),
            "isGiur" : !component.get("v.formFisico")
        });

        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == "SUCCESS"){
                var returnvalue = response.getReturnValue();
                if(returnvalue == "OK"){
                    if(component.get('v.typeRegistration') == "GT" || component.get('v.typeRegistration') == "GF"){
                        var newContact = component.get("v.newContact");
                        var account = component.get("v.account");
                        this.createPersonagiuridicaRecord(component, newContact, account, false);
                    }
                    else{
                        var newContact = component.get("v.newContact");
                        this.personaFisicaRecord(component, newContact, false);
                    }
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
    
    resendCode : function(component, event){
        component.set("v.Spinner", true);
        var action = component.get("c.sendCodeOTP");

        action.setParams({
            "cell" : component.get("v.newContact.MobilePhone")
        });

        action.setCallback(this, function(response){
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