({
    doInit : function(component, event, helper){
        var action = component.get("c.getNazionalityopts");
        action.setCallback(this, function(response) {
            var Nazionalityopts =[];
            for(var i = 0; i < response.getReturnValue().length; i++)
                Nazionalityopts.push({
                    "class" : "optionClass",
                    "label" : response.getReturnValue()[i],
                    "value" : response.getReturnValue()[i]
                });
            
            component.set("v.Nazionalityopts",  Nazionalityopts);
        });
        $A.enqueueAction(action);
    },
    
    validateEmail : function(component, event, helper){
        var validRecord = true; 
        var isValidEmail = true; 
        var emailField = component.find("Emailid");
        var emailFieldValue = emailField.get("v.value");
        var regExpEmailformat = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,8})+$/;
        
        if ($A.util.isEmpty(emailFieldValue)) {
            var sMsg = 'L\'E-mail è un campo obbligatorio';
            emailField.set("v.errors", [{message:sMsg}]);
            validRecord = false; 
            isValidEmail = false;
        }
        else if(!$A.util.isEmpty(emailFieldValue)){  
            if(emailFieldValue.match(regExpEmailformat)){
                if(emailFieldValue.length > 70){
                    var sMsg = $A.get("$Label.c.PED_EmailLength");
                    emailField.set("v.errors", [{message : sMsg}]);
                    isValidEmail = false;
                    validRecord = false;
                }
            }
            else{
                var sMsg = $A.get("$Label.c.PED_PGEmailErr2");
                emailField.set("v.errors", [{message : sMsg}]);
                isValidEmail = false;
                validRecord = false;
            }
        } 
        if(validRecord){
            emailField.set("v.errors", null);
            component.set('v.Email',emailFieldValue);
        }
        return  validRecord; 
    },
    
    
    recuperaPassword : function(component, event, helper){
        var action = component.get('c.recoveryPassword');
        
        action.setParams({
            "email" : component.get('v.Email')
        });
        
        action.setCallback(this,function(response){
            var elements = document.getElementsByClassName("slds-col slds-size_3-of-3");
            elements[0].style.display = 'none';
            
            var state = response.getState();
            if(state === 'SUCCESS'){
                var result = response.getReturnValue();
                if(result=='OK'){
                    component.set('v.messageToShow', 'Ti abbiamo inviato un codice di verifica all’indirizzo email appena inserito.');
                    component.set('v.isSucc', true);
                    component.set('v.isPasswordOTP', true);
                }
                else if(result=='NO_CHANGE'){
                    component.set('v.messageToShow', 'La tua password è già stata modificata recentemente: potrai riutilizzare la funzionalità di recupero password quando saranno trascorse 24h dall’ultimo reset.');
                    component.set('v.isSucc', true);
                }
                    else if(result=='NO_USER'){
                        component.set('v.messageToShow', 'L\'Email non corrisponde a nessun utente. Inserire un\'altra Email.');
                        component.set('v.isSucc', true);
                    }
                        else{
                            component.set('v.messageToShow', 'Si è verificato un errore. Riprova');
                            component.set('v.isSucc', true);
                        }
            }else{
                component.set('v.messageToShow', 'Si è verificato un errore. Riprova');
                component.set('v.isSucc', true);
            }
            component.set('v.Spinner', false);
        });
        $A.enqueueAction(action);
    },
    
    validateOTP : function(component,event,helper){
        var action = component.get('c.checkOTP');
        
        action.setParams({
            'otpToken' : component.get('v.OTP'),
            'email' : component.get('v.Email')
        }); 
        
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var result = response.getReturnValue();
                if(result == 'OK'){                            
                    component.set('v.isNewPassword', true);  
                    component.set('v.isPasswordOTP', false);
                    component.set('v.OTP', '');
                }
                else
                    component.find('OTPid').set('v.errors', [{message : 'Codice OTP errato'}]);
            }
            else{
                component.set('v.messageToShow', 'Si è verificato un errore. Riprova');
                component.set('v.isSucc', true);
            }
            component.set('v.Spinner', false);
        });
        $A.enqueueAction(action);
    },
    
    getEvtParam : function (component, event, helper) {
        var Err = event.getParam("Err");
        var cmpId = event.getParam("compId");
        var CompId = component.find(cmpId);
        if(Err !== null){
            CompId.set("v.errors", [{message : Err}]); 
            component.set('v.CFOnBlurErrorExist', true);
        }
        else{
            CompId.set("v.errors", [{message : null}]);
            component.set('v.CFOnBlurErrorExist', false);
        }
    },
    
    getEvtParam1 : function (component, event, helper) {
        var Err = event.getParam("Err");
        var cmpId = event.getParam("compId");
        var CompId = component.find(cmpId);
        if(Err !== null){
            CompId.set("v.errors", [{message : Err}]); 
            component.set('v.PIVAOnBlurErrorExist', true);
        }
        else{
            CompId.set("v.errors", [{message : null}]);
            component.set('v.PIVAOnBlurErrorExist', false);
        }
    },
    
    getEvtParam2 : function (component, event, helper) {
        var Err = event.getParam("Err");
        var cmpId = event.getParam("compId");
        var CompId = component.find(cmpId);
        if(Err !== null){
            CompId.set("v.errors", [{message : Err}]); 
            component.set('v.ContactCFOnBlurErrorExist', true);
        }
        else{
            CompId.set("v.errors", [{message : null}]);
            component.set('v.ContactCFOnBlurErrorExist', false);
            component.set('v.CFOnBlurErrorExist', false);
        }
    },
    
    recuperaUsername : function (component, event, helper) {
        var elements = document.getElementsByClassName("slds-col slds-size_3-of-3");
        elements[0].style.display = 'none';
        
        var action= component.get("c.recoveryUsernamePersonaFisica");
        
        action.setParams({
            'contact' : component.get('v.newContact')
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS'){
                var result = response.getReturnValue().split('||');
                if(result[0]=='OK'){                               
                                                component.set('v.UsernameOsc', result[1]);
                                                component.set('v.isPG', false);
                                                component.set('v.isPF', false);
                                                component.set('v.showUsername', true);
                                                //CB aggiunto nome contact nella variabile per visualizzarlo
                                                component.set('v.newContact.FirstName', result[2]);
                                                component.set('v.newContact.LastName', result[3]);
                                            }
                                            else{
                                                component.set('v.messageToShow', 'I dati fiscali indicati non risultano registrati al nostro portale. Ti invitiamo a correggere i dati indicati o a effettuare una nuova iscrizione.');
                                                component.set('v.isSucc', true);
                                            }
                                        }
                                        else{
                                            component.set('v.messageToShow', 'Si è verificato un errore. Riprova');
                                            component.set('v.isSucc', true);
                                        }
                                        component.set('v.Spinner', false);
                                    });
                                    
                                    $A.enqueueAction(action);
                                },
    
    modificaUsername : function (component, event, helper) { 
        var action= component.get("c.modifyUsernamePersonaFisica");
            action.setParams({
                'usrcontact' : component.get('v.newContact')
            });
            
            
            action.setCallback(this, function(response) {
                var state = response.getState();
                if(state === 'SUCCESS'){
                    var result = response.getReturnValue().split('||');
                    if(result[0] == 'KO'){
                        var idModulo = result[1];
                        component.set('v.linkDoc', idModulo);
                    }
                    else if(result[0] == 'ErrorEnotify'){
                        component.set('v.messageToShow', 'Attenzione: il servizio è momentaneamente non disponibile. Riprova più tardi. Ci scusiamo per il disagio.');
                        component.set('v.isSucc', true);
                    }
                        else if(result[0] == '24Hours'){
                            component.set('v.messageToShow', 'La tua password è stata modificata recentemente: potrai riutilizzare la funzionalità di modifica Username quando saranno trascorse 24h dall’ultimo cambio password.');
                            component.set('v.isSucc', true)
                        }
                            else{
                            component.set('v.telOscurato', result[1]);
                            component.set('v.ContactId', result[0]);
                            component.set('v.isOTP', true); 
                            component.set('v.isUsername', false);
                            component.set('v.isPassword', false);
                            component.isFirstCode = false;
                        }
            }
            else{
                component.set('v.messageToShow', 'Si è verificato un errore. Riprova');
                component.set('v.isSucc', true);
            }
            component.set('v.Spinner', false);
        });
            $A.enqueueAction(action);
        },
    
        validateCF : function(component, event, helper){
        var validRecord = true; 
        var isValidCF = true; 
        var CFField = component.find("Codicefiscaleid");
        var CFFieldValue = CFField.get("v.value");
        var regExpCFformat = /^(?:[A-Z][AEIOU][AEIOUX]|[B-DF-HJ-NP-TV-Z]{2}[A-Z]){2}(?:[\dLMNP-V]{2}(?:[A-EHLMPR-T](?:[04LQ][1-9MNP-V]|[15MR][\dLMNP-V]|[26NS][0-8LMNP-U])|[DHPS][37PT][0L]|[ACELMRT][37PT][01LM]|[AC-EHLMPR-T][26NS][9V])|(?:[02468LNQSU][048LQU]|[13579MPRTV][26NS])B[26NS][9V])(?:[A-MZ][1-9MNP-V][\dLMNP-V]{2}|[A-M][0L](?:[1-9MNP-V][\dLMNP-V]|[0L][1-9MNP-V]))[A-Z]$/i;
        
        if ($A.util.isEmpty(CFFieldValue)) {
            var sMsg = 'Il Codice Fiscale è un campo obbligatorio';
            CFField.set("v.errors", [{message:sMsg}]);
            validRecord = false; 
            isValidCF = false;
        }
        else if(!$A.util.isEmpty(CFFieldValue)){  
            if(CFFieldValue.match(regExpCFformat)){
                
                var validRecord = true; 
                CFField.set("v.errors", null);
                component.set('v.Codicefiscaleid',CFFieldValue);
            }
            else{
                var sMsg = ' Codice Fiscale non è valido';
                CFField.set("v.errors", [{message:sMsg}]);
                validRecord = false; 
                isValidCF = false;
            }
        }
        return  validRecord; 
    },
    
    validatePFCF : function(component,event,helper){
        debugger;
        var isValid = true; 
        var formtype1 = component.get('{!v.isPF}');  // aggiunto il filtro tb
        if(formtype1 == true){
        var Codicefiscaleid = component.find("Codicefiscaleid");
        var CodicefiscaleidValue = Codicefiscaleid.get("v.value"); 
        var Nazionalityid = component.find("Nazionalityid");
        var NazionalityValue = Nazionalityid.get("v.value");
        }
        
        var formtype2 = component.get('{!v.isPG}');  // aggiunto tutto tb
        if(formtype2 == true){
        var Codicefiscaleid = component.find("Codicefiscaleid1");
        var CodicefiscaleidValue = Codicefiscaleid.get("v.value"); 
        var Nazionalityid = component.find("Nazionalityid1");
        var NazionalityValue = Nazionalityid.get("v.value"); // fino a qui
        }
        
        if($A.util.isEmpty(NazionalityValue))
            NazionalityValue = 'Italiana';
        
        var regExpformat = /^(?:[B-DF-HJ-NP-TV-Z](?:[AEIOU]{2}|[AEIOU]X)|[AEIOU]{2}X|[B-DF-HJ-NP-TV-Z]{2}[A-Z]){2}[\dLMNP-V]{2}(?:[A-EHLMPR-T](?:[04LQ][1-9MNP-V]|[1256LMRS][\dLMNP-V])|[DHPS][37PT][0L]|[ACELMRT][37PT][01LM])(?:[A-MZ][1-9MNP-V][\dLMNP-V]{2}|[A-M][0L](?:[\dLMNP-V][1-9MNP-V]|[1-9MNP-V][0L]))[A-Z]$/i;
        if(!$A.util.isEmpty(CodicefiscaleidValue)){
            if(NazionalityValue == 'Italiana'){
                if(CodicefiscaleidValue.match(regExpformat)){
                    /* MB - Commentato in quanto per la persona fisica non sono presenti i campi Nome e Cognome
                    var sNome = component.find("firstNameid").get("v.value").replace("'", "");
                    var sCognome = component.find("lastNameid").get("v.value").replace("'", "");
                    var childcomp = component.find("child");
                    var cmpId = "Codicefiscaleid";
                    childcomp.CallCheckCF(CodicefiscaleidValue, sNome, sCognome, cmpId);
                    */
                    Codicefiscaleid.set("v.errors", null);
                    component.set('v.CFOnBlurErrorExist', false);
                }
                else{
                    var sMsg = ' Codice Fiscale non è valido';
                    Codicefiscaleid.set("v.errors", [{message : sMsg}]);
                    isValid = false;
                    component.set('v.CFOnBlurErrorExist', true);
                }
            }
            
            else if(NazionalityValue == 'Seleziona un valore'){
                
                var sMsg = 'Scegliere una Nazionalità';
                    Codicefiscaleid.set("v.errors", [{message : sMsg}]);
                    isValid = false;
                    component.set('v.CFOnBlurErrorExist', true);
                
            }
                else {
                Codicefiscaleid.set("v.errors", null);
                component.set('v.CFOnBlurErrorExist', false);
                isValid = true;
            }
        }
        else{
            var sMsg = $A.get("$Label.c.PED_PFCFErr");
            Codicefiscaleid.set("v.errors", [{message : sMsg}]);
            isValid = false; 
            component.set('v.CFOnBlurErrorExist', true);
        }        
        return isValid;
    },

    validatePGCF : function(component, event, helper){
        debugger;
        var isValid = true; 
        var Codicefiscaleid1 = component.find("Codicefiscaleid1");
        var Codicefiscalevalue1 = Codicefiscaleid1.get("v.value");
        var Nazionalityid1 = component.find("Nazionalityid1");
        var NazionalityValue1 = Nazionalityid1.get("v.value");
        var sNome = component.find("firstNameid1").get("v.value");
        var sCognome = component.find("lastNameid1").get("v.value");
        
        var regExpformat = /^(?:[B-DF-HJ-NP-TV-Z](?:[AEIOU]{2}|[AEIOU]X)|[AEIOU]{2}X|[B-DF-HJ-NP-TV-Z]{2}[A-Z]){2}[\dLMNP-V]{2}(?:[A-EHLMPR-T](?:[04LQ][1-9MNP-V]|[1256LMRS][\dLMNP-V])|[DHPS][37PT][0L]|[ACELMRT][37PT][01LM])(?:[A-MZ][1-9MNP-V][\dLMNP-V]{2}|[A-M][0L](?:[\dLMNP-V][1-9MNP-V]|[1-9MNP-V][0L]))[A-Z]$/i;
        
        if(!$A.util.isEmpty(Codicefiscalevalue1)){
            if(NazionalityValue1 == 'Italiana' ){
                if(Codicefiscalevalue1.match(regExpformat) && !$A.util.isEmpty(sNome) && !$A.util.isEmpty(sCognome)){
                    var sNome = component.find("firstNameid1").get("v.value").replace("'", "");
                    var sCognome = component.find("lastNameid1").get("v.value").replace("'", "");
                    var childcomp = component.find("child1");
                    var cmpId = "Codicefiscaleid1";
                    childcomp.CallCheckCF(Codicefiscalevalue1, sNome, sCognome, cmpId);
                }
                
                
                
                else{
                    var sMsg = $A.get("$Label.c.PED_CodicefiscaleErr") + " Ricordati di inseire Nome e Cognome"; 
                    Codicefiscaleid1.set("v.errors", [{message : sMsg}]);
                    isValid = false;
                    component.set('v.CFOnBlurErrorExist', true);
                }
            }
            
            else if(NazionalityValue1 == '' || NazionalityValue1 == 'Seleziona un valore'){
                var sMsg = "Selezionare una Nazionalità";
                Codicefiscaleid1.set("v.errors", [{message : sMsg}]);
                isValid = false;  
                component.set('v.CFOnBlurErrorExist', true);
            }
            
            
                else{
                    Codicefiscaleid1.set("v.errors", null);  
                    component.set('v.CFOnBlurErrorExist', false);
                } 
            
            return isValid;
        }
    },
    
    
    validateContactCodicefiscale : function(component, event, helper){
        var isValid = true;
        var ContactCodicefiscaleid = component.find("ContactCodicefiscaleid");
        var ContactCodicefiscaleValue = ContactCodicefiscaleid.get("v.value");
        var regExpformat = /^[0-9]{11}$/;
        var regExpCFformat = /^(?:[A-Z][AEIOU][AEIOUX]|[B-DF-HJ-NP-TV-Z]{2}[A-Z]){2}(?:[\dLMNP-V]{2}(?:[A-EHLMPR-T](?:[04LQ][1-9MNP-V]|[15MR][\dLMNP-V]|[26NS][0-8LMNP-U])|[DHPS][37PT][0L]|[ACELMRT][37PT][01LM]|[AC-EHLMPR-T][26NS][9V])|(?:[02468LNQSU][048LQU]|[13579MPRTV][26NS])B[26NS][9V])(?:[A-MZ][1-9MNP-V][\dLMNP-V]{2}|[A-M][0L](?:[1-9MNP-V][\dLMNP-V]|[0L][1-9MNP-V]))[A-Z]$/i;
        var Sedelegalediid = component.find("Sedelegalediid1");
        var Sedelegaledvalue = Sedelegalediid.get("v.value");
        //PI S
        component.set('v.PIVArequired', true);
        //PI E
        if(!$A.util.isEmpty(ContactCodicefiscaleValue) && Sedelegaledvalue !== ''){
            if(Sedelegaledvalue == 'Italiana'){ 
                if(ContactCodicefiscaleValue.match(regExpformat) || ContactCodicefiscaleValue.match(regExpCFformat)){ // aggiunto condizione o
                    var bPTIVAFlg = false;
                    var childcomp = component.find("child_CFNum");
                    var cmpId = "ContactCodicefiscaleid";
                    childcomp.ChkValidPTIVA_CFNum(ContactCodicefiscaleValue, bPTIVAFlg, cmpId, Sedelegaledvalue, ContactCodicefiscaleValue.charAt(0) == '8' || ContactCodicefiscaleValue.charAt(0) == '9', true);
                    //PI Enti S
                    if(ContactCodicefiscaleValue.charAt(0) == '8' || ContactCodicefiscaleValue.charAt(0) == '9')
                        component.set('v.PIVArequired', false);
                    //PI Enti E
                }
                else{
                    var sMsg = $A.get("$Label.c.PED_CodicefiscaleErr");
                    ContactCodicefiscaleid.set("v.errors", [{message : sMsg}]);
                    isValid = false;
                    component.set('v.ContactCFOnBlurErrorExist', true);
                }
            }
            else{
                ContactCodicefiscaleid.set("v.errors", null);
                component.set('v.ContactCFOnBlurErrorExist', false);
                var bPTIVAFlg = false;
                var childcomp = component.find("child_CFNum");
                var cmpId = "ContactCodicefiscaleid";
                childcomp.ChkValidPTIVA_CFNum(ContactCodicefiscaleValue, bPTIVAFlg, cmpId, Sedelegaledvalue, ContactCodicefiscaleValue.charAt(0) == '8' || ContactCodicefiscaleValue.charAt(0) == '9', true);
                //PI Enti S
                if(ContactCodicefiscaleValue.charAt(0) == '8' || ContactCodicefiscaleValue.charAt(0) == '9')
                    component.set('v.PIVArequired', false);
                //PI Enti E
            }
        } 
        
        else if(Sedelegaledvalue == '' || Sedelegaledvalue == 'Seleziona un valore'){
            var sMsg = "Seleziona una Sede Legale";
            ContactCodicefiscaleid.set("v.errors", [{message : sMsg}]);
            isValid = false;
            component.set('v.ContactCFOnBlurErrorExist', false);
        }
        
            else{
                var sMsg = $A.get("$Label.c.PED_PFCFErr");
                ContactCodicefiscaleid.set("v.errors", [{message : sMsg}]);
                isValid = false;
                component.set('v.ContactCFOnBlurErrorExist', false);
                
            }
        return isValid;

    },
    
    validatePartitaIva : function(component, event, helper){
        var Sedelegalediid = component.find("Sedelegalediid1");
        var Sedelegaledvalue = Sedelegalediid.get("v.value");
        var ContactCodicefiscaleid = component.find("ContactCodicefiscaleid"); //tb
        var ContactCodicefiscaleValue = ContactCodicefiscaleid.get("v.value"); //tb
        var regExpformat;
        var Msg = "";
        var isValid = true;
        var PartitaIVAId = component.find("PartitaIVAId1");
        var PartitaIVAIdValue = PartitaIVAId.get("v.value");
        if(!$A.util.isEmpty(PartitaIVAIdValue) && Sedelegaledvalue !== ''){            
            if(Sedelegaledvalue == 'Italiana'){
                regExpformat = /^[0-7]{1}[0-9]{10}$/;  
                Msg = $A.get("$Label.c.PED_PartitaIvaErr1");
                if(PartitaIVAIdValue.match(regExpformat)){
                    var bPTIVAFlg = true;
                    var childcomp = component.find("child_ptiva");
                    var cmpId = "PartitaIVAId1";
                    childcomp.ChkValidPTIVA_CFNum(PartitaIVAIdValue, bPTIVAFlg, cmpId, Sedelegaledvalue);              
                }
                
                else if(PartitaIVAIdValue.substring(0, 1) == 8 || PartitaIVAIdValue.substring(0, 1) == 9){ // tb tutto else if
                    var Msg = "La Partita Iva non può iniziare con 8 o 9";
                    PartitaIVAId.set("v.errors", [{message : Msg}]);
                    isValid = false;
                    component.set('v.PIVAOnBlurErrorExist', true);} // tb fino qui
                else{
                    PartitaIVAId.set("v.errors", [{message : Msg}]);
                    isValid = false;
                    component.set('v.PIVAOnBlurErrorExist', true);
                }
            }
            
            else{
                PartitaIVAId.set("v.errors",null);
                component.set('v.PIVAOnBlurErrorExist', false);
                var bPTIVAFlg = true;
                var childcomp = component.find("child_ptiva");
                var cmpId = "PartitaIVAId1";
                childcomp.ChkValidPTIVA_CFNum(PartitaIVAIdValue, bPTIVAFlg, cmpId, Sedelegaledvalue);
            }   
            
        }
        if(Sedelegaledvalue == '' || Sedelegaledvalue == 'Seleziona un valore'){
            var sMsg = "Seleziona una Sede Legale";
            PartitaIVAId.set("v.errors", [{message : sMsg}]);
            isValid = false;
            component.set('v.ContactCFOnBlurErrorExist', false);
        }
        
        
        //PI Enti S
        else if($A.util.isEmpty(PartitaIVAIdValue) && !component.get("v.PIVArequired")){
            isValid = true;
            if(ContactCodicefiscaleValue.substring(0, 1) == 8 || ContactCodicefiscaleValue.substring(0, 1) == 9) // tb
            PartitaIVAId.set("v.errors",null); // tb
            
            component.set('v.PIVAOnBlurErrorExist', false);
        }
        //PI Enti E
        return isValid;
    },
    
    
    sendOtp : function(component, event, helper){
        component.set('v.Spinner', true);
        var action = component.get("c.sendOtp");
        
        action.setParams({  
            "contactId" : component.get("v.ContactId")
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == "SUCCESS"){       
                var result = response.getReturnValue();
                if(result == 'OK'){
                    if(component.isFirstCode != undefined){
                        component.set('v.isSucc', true);
                        component.set('v.messageToShow', 'Codice inviato con successo.');
                    }
                    else{
                        component.isFirstCode = false;
                        component.set('v.showMobileModal', false);
                        component.set('v.mobileVerificationPopUp', true);
                    }   
                }
                else if(result=='ErrorEnotify'){
                    component.set('v.isSucc', true);
                    component.set('v.messageToShow', 'Attenzione: il servizio è momentaneamente non disponibile. Riprova più tardi. Ci scusiamo per il disagio.');
                }
            }
            else {
                component.set('v.isSucc', true);
                component.set('v.messageToShow', 'Attenzione: il servizio è momentaneamente non disponibile. Riprova più tardi. Ci scusiamo per il disagio.'); 
            }
            component.set('v.Spinner', false);
        });
        $A.enqueueAction(action);
    },
    
    checkOtp: function(component, event, helper){
        component.set('v.Spinner', true);
        var tokenvalue1 = component.find("OtpVerifica");
        var tokenvlaue2 = tokenvalue1.get("v.value");
        var tokenMsg = "Il codice inserito non è corretto";
        var action = component.get("c.checkToken");
        
        action.setParams({
            "contactId" : component.get("v.ContactId"),
            "otp" : tokenvlaue2     
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            var result = response.getReturnValue();
            if (state === "SUCCESS") {
                if(result == 'OK')   
                    component.set('v.isOTPNewEmail', true); 
                else
                    tokenvalue1.set("v.errors", [{message : tokenMsg}]);
            }
            else
                tokenvalue1.set("v.errors", [{message : tokenMsg}]);
            component.set('v.Spinner', false);
        });
        $A.enqueueAction(action);
    },
    
    recuperaPasswordUsername : function(component,event,helper){
        var action = component.get('c.recoveryPasswordFromUsername');
        
        action.setParams({
            'email' : component.get('v.Email'),
            'idContact' : component.get('v.ContactId')
        });
        
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var result = response.getReturnValue();
                if(result == 'OK'){
                    component.set('v.messageToShow', 'Ti abbiamo inviato un codice di verifica all’indirizzo email appena inserito.');
                    component.set('v.isSucc', true);
                    component.set('v.isPasswordEmail', true);
                    component.set('v.isPasswordOTP', true);
                    component.set('v.disableOTP', true);
                }
                else if(result == 'ERROR_EMAIL'){
                    component.set('v.warning', true);
                    component.set('v.messageToShow', 'L’indirizzo email indicato è già registrato al portale.');
                    component.set('v.isSucc', true);
                }
                    else if(result == 'blacklistedEmail'){
                        var sMsg = $A.get("$Label.c.PED_EmailBlacklistedNew");
                        component.set('v.messageToShow', sMsg);
                        component.set('v.isSucc', true);
                    }
                        else if(result == 'blacklistedAddressEmail'){
                            var sMsg = $A.get("$Label.c.PED_Email_Specific_Blacklisted");
                            component.set('v.messageToShow', sMsg);
                            component.set('v.isSucc', true);
                        }
                            else{
                                component.set('v.messageToShow', 'Si è verificato un errore. Riprova');
                                component.set('v.isSucc', true);
                            }
            }
            else{
                component.set('v.messageToShow', 'Si è verificato un errore. Riprova');
                component.set('v.isSucc', true);
            }
            component.set('v.Spinner', false);
        });
        $A.enqueueAction(action);
    },
    
    validateOTPUsername : function(component, event, helper){
        var action = component.get('c.checkOTP');
        
        action.setParams({
            'otpToken' : component.get('v.OTP'),
            'email' : component.get('v.Email')
        }); 
        
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var result = response.getReturnValue();
                if(result == 'OK'){   
                    var action = component.get('c.updateUser');
                    
                    action.setParams({
                        'email' : component.get('v.Email'),
                        'contactId' : component.get('v.ContactId')
                    });
                    
                    action.setCallback(this,function(response){
                        var state = response.getState();
                        if(state==='SUCCESS'){
                            component.set('v.isPasswordOTP', false);
                        }else{
                            component.set('v.messageToShow', 'Si è verificato un errore. Riprova');
                            component.set('v.isSucc', true);
                        }
                        component.set('v.Spinner', false);
                    });
                    $A.enqueueAction(action);
                }
                else
                    component.find('OtpVerifica1').set('v.errors', [{message : 'Codice OTP errato'}]);
            }
            else{
                component.set('v.messageToShow','Si è verificato un errore. Riprova');
                component.set('v.isSucc', true);
            }
        });
        $A.enqueueAction(action);
    },
    
    recuperaUsernamePG : function (component, event, helper) {
        var action= component.get("c.recoveryUsernamePersonaGiuridica");
        
        action.setParams({
            'contact' : component.get('v.newContact'),
            'account' : component.get('v.account'),
            'sedeLegale' : component.get('v.selectedValue1')
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS'){
                var result = response.getReturnValue().split('||');
                if(result[0] == 'OK'){
                                        component.set('v.UsernameOsc', result[1]);
                                        component.set('v.isPG', false);
                                        component.set('v.isPF', false);
                                        component.set('v.showUsername', true);
                                    }
                                    else{
                                        component.set('v.messageToShow', 'Non è stato trovato nessun utente corrispondente a questi dati fiscali. Riprovare.');
                                        component.set('v.isSucc', true);
                                    }
                                }
                                else{
                                    component.set('v.messageToShow', 'Si è verificato un errore. Riprova');
                                    component.set('v.isSucc', true);
                                }
                                component.set('v.Spinner', false);
                            });
                            $A.enqueueAction(action);
                        },
    
    validatePersonagiuridiRecord : function(component) {
        var Sedelegalediid = component.find("Sedelegalediid1");
        var Sedelegaledvalue = Sedelegalediid.get("v.value");
        var validRecord = true;
        var firstName = component.find("firstNameid1");
        var firstNamevalue = firstName.get("v.value");
        var CharRegex= /^[a-zA-ZÀ-ÿ .,`~!''@#$%^&*_-]*$/;
        var nomeMsg = $A.get("$Label.c.PED_InvalidNome");
        var sMsg = $A.get("$Label.c.PED_PFFNameError");
        if (!$A.util.isEmpty(firstNamevalue)){
            if(!firstNamevalue.match(CharRegex)){
                validRecord = false;
                firstName.set("v.errors", [{message : nomeMsg}]);
            }
            else
                firstName.set("v.errors", null);
        }
        else{
            validRecord = false;
            firstName.set("v.errors", [{message : sMsg}]);
        }
        
        var lastName = component.find("lastNameid1");
        var lastNamevalue = lastName.get("v.value");
        var CharRegex=/^[a-zA-ZÀ-ÿ .,`~!''@#$%^&*_-]*$/;
        var cognomeMsg = $A.get("$Label.c.PED_InvalidCognome");
        var sMsg = $A.get("$Label.c.PED_PFLNameError");
        if (! $A.util.isEmpty(lastNamevalue)){
            if(! lastNamevalue.match(CharRegex)){
                validRecord = false;
                lastName.set("v.errors", [{message : cognomeMsg}]);     
            }
            else
                lastName.set("v.errors", null);
        }
        else{
            validRecord = false;
            lastName.set("v.errors", [{message : sMsg}]);            
        } 
        
        var Codicefiscaleid = component.find("Codicefiscaleid1");
        var Codicefiscalevalue = Codicefiscaleid.get("v.value");
        var Nazionalityid = component.find("Nazionalityid1");
        var NazionalityValue = Nazionalityid.get("v.value");
        if($A.util.isEmpty(NazionalityValue))
            NazionalityValue = 'Italiana';
        
        var regExpformat = /^(?:[B-DF-HJ-NP-TV-Z](?:[AEIOU]{2}|[AEIOU]X)|[AEIOU]{2}X|[B-DF-HJ-NP-TV-Z]{2}[A-Z]){2}[\dLMNP-V]{2}(?:[A-EHLMPR-T](?:[04LQ][1-9MNP-V]|[1256LMRS][\dLMNP-V])|[DHPS][37PT][0L]|[ACELMRT][37PT][01LM])(?:[A-MZ][1-9MNP-V][\dLMNP-V]{2}|[A-M][0L](?:[\dLMNP-V][1-9MNP-V]|[1-9MNP-V][0L]))[A-Z]$/i; 
        if ($A.util.isEmpty(Codicefiscalevalue)){
            var sMsg = $A.get("$Label.c.PED_PGCFRepLegaleErr");
            Codicefiscaleid.set("v.errors", [{message : sMsg}]);
            validRecord = false;
        }
        else if(!$A.util.isEmpty(Codicefiscalevalue)){  
            if(NazionalityValue == 'Italiana'){
                if(Codicefiscalevalue.match(regExpformat)){
                    var sNome = component.find("firstNameid1").get("v.value").replace("'", "");
                    var sCognome = component.find("lastNameid1").get("v.value").replace("'", "");
                    var childcomp = component.find("childbtn2");
                    var cmpId = "Codicefiscaleid1";
                    childcomp.CallCheckCF(Codicefiscalevalue, sNome, sCognome, cmpId);
                    
                    if(component.get("v.CFOnBlurErrorExist")){
                        var sMsg = $A.get("$Label.c.PED_CodicefiscaleErr");
                        Codicefiscaleid.set("v.errors", [{message : sMsg}]);
                        validRecord = false;
                    }
                    else
                        Codicefiscaleid.set("v.errors", [{message : null}]);
                }
                else{
                    var sMsg = $A.get("$Label.c.PED_CodicefiscaleErr");
                    Codicefiscaleid.set("v.errors", [{message : sMsg}]);
                    validRecord = false;
                }
            }
            else
                Codicefiscaleid.set("v.errors", null);
        }
            else
                Codicefiscaleid.set("v.errors", null);
        
        var RagioneSocialeid = component.find("RagioneSocialeid1");
        var RagioneSocialevalue = RagioneSocialeid.get("v.value");
        if ($A.util.isEmpty(RagioneSocialevalue)) {
            var sMsg = $A.get("$Label.c.PED_PGRegioneSocialeErr");
            RagioneSocialeid.set("v.errors", [{message : sMsg}]);
            validRecord = false;
        }
        else if (RagioneSocialevalue.length > 80){
            var sMsg = 'La ragione sociale non può contenere più di 80 caratteri';
            RagioneSocialeid.set("v.errors", [{message : sMsg}]); 
            validRecord = false;
        }
            else 
                RagioneSocialeid.set("v.errors", null);
        
        var IsEnteId = component.find("IsEnteId");
        if(IsEnteId)
            var IsEnteIdvalue = IsEnteId.get("v.value");
        else
            var IsEnteIdvalue = component.get("v.account.PED_IsEnte__c");
        if($A.util.isEmpty(IsEnteIdvalue) || !IsEnteIdvalue){
            component.set("v.ContactCFOnBlurErrorExist", null);
            var PartitaIVAId = component.find("PartitaIVAId1");
            var PartitaIVAIdvalue = PartitaIVAId.get("v.value");
            //PI Enti. Aggiunto if PIVArequired
            if(component.get("v.PIVArequired")){
                if ($A.util.isEmpty(PartitaIVAIdvalue) || !PartitaIVAIdvalue) {
                    var sMsg = $A.get("$Label.c.PED_PGPartitaIvaErr");
                    PartitaIVAId.set("v.errors", [{message : sMsg}]);
                    validRecord = false;
                }
                else {
                    if(component.get("v.PIVAOnBlurErrorExist")){
                        var sMsg = $A.get("$Label.c.PED_PGPartitaIvaErr");
                        PartitaIVAId.set("v.errors", [{message : sMsg}]);
                        validRecord = false;  
                    }
                    else
                        PartitaIVAId.set("v.errors", null);
                } 
            }
        }
        else{
            component.set("v.PIVAOnBlurErrorExist", null);
            var ContactCodicefiscaleid = component.find("ContactCodicefiscaleid");
            var ContactCodicefiscaleValue = ContactCodicefiscaleid.get("v.value");         
            var regExpformat = /^[0-9]{11}$/;
            if(!$A.util.isEmpty(ContactCodicefiscaleValue)){
                if(Sedelegaledvalue == 'Italiana') {
                    if(ContactCodicefiscaleValue.match(regExpformat)){
                        if(component.get("v.ContactCFOnBlurErrorExist")){
                            var sMsg = $A.get("$Label.c.PED_CodicefiscaleErr");
                            ContactCodicefiscaleid.set("v.errors", [{message : sMsg}]);
                            validRecord = false; 
                        }
                        else
                            ContactCodicefiscaleid.set("v.errors", [{message : null}]);
                    }
                    else{
                        var sMsg = $A.get("$Label.c.PED_CodicefiscaleErr");
                        ContactCodicefiscaleid.set("v.errors", [{message : sMsg}]);
                        validRecord = false;
                    }
                }
                else{
                    var ContactCodicefiscaleid = component.find("ContactCodicefiscaleid");
                    ContactCodicefiscaleid.set("v.errors", null);
                } 
            }
            else {
                var sMsg = $A.get("$Label.c.PED_PFCFErr");
                ContactCodicefiscaleid.set("v.errors", [{message : sMsg}]);
                validRecord = false;
            }      
        }
        return validRecord;     
    },
    
    validateRecord : function(component) { 
        var validRecord = true;
        /* MB - Commentato in quanto per la persona fisica non sono presenti i campi Nome e Cognome
        var firstName = component.find("firstNameid");
        var firstNamevalue = firstName.get("v.value");
        var CharRegex = /^[a-zA-ZÀ-ÿ .,`~!''@#$%^&*_-]*$/;
        var nomeMsg = $A.get("$Label.c.PED_InvalidNome");
        var sMsg = $A.get("$Label.c.PED_PFFNameError");
        if (!$A.util.isEmpty(firstNamevalue)){
            if(!firstNamevalue.match(CharRegex)){
                validRecord = false;
                firstName.set("v.errors", [{message : nomeMsg}]);
            }
            else
                firstName.set("v.errors", null);
        }
        else{
            validRecord = false;
            firstName.set("v.errors", [{message : sMsg}]);
        }
        
        var lastName = component.find("lastNameid");
        var lastNamevalue = lastName.get("v.value");
        var CharRegex = /^[a-zA-ZÀ-ÿ .,`~!''@#$%^&*_-]*$/;
        var cognomeMsg = $A.get("$Label.c.PED_InvalidCognome");
        var sMsg = $A.get("$Label.c.PED_PFLNameError");
        if (!$A.util.isEmpty(lastNamevalue)){
            if(!lastNamevalue.match(CharRegex)){
                validRecord = false;
                lastName.set("v.errors", [{message : cognomeMsg}]);     
            }
            else
                lastName.set("v.errors", null);
        }
        else{
            validRecord = false;
            lastName.set("v.errors", [{message : sMsg}]);            
        }
        */
                var Codicefiscaleid = component.find("Codicefiscaleid");
                var Codicefiscalevalue = Codicefiscaleid.get("v.value");
                var Nazionalityid = component.find("Nazionalityid");
                var NazionalityValue = Nazionalityid.get("v.value");
                if($A.util.isEmpty(NazionalityValue))
                    NazionalityValue = 'Italiana';
                
                var regExpformat = /^(?:[B-DF-HJ-NP-TV-Z](?:[AEIOU]{2}|[AEIOU]X)|[AEIOU]{2}X|[B-DF-HJ-NP-TV-Z]{2}[A-Z]){2}[\dLMNP-V]{2}(?:[A-EHLMPR-T](?:[04LQ][1-9MNP-V]|[1256LMRS][\dLMNP-V])|[DHPS][37PT][0L]|[ACELMRT][37PT][01LM])(?:[A-MZ][1-9MNP-V][\dLMNP-V]{2}|[A-M][0L](?:[\dLMNP-V][1-9MNP-V]|[1-9MNP-V][0L]))[A-Z]$/i;
                if ($A.util.isEmpty(Codicefiscalevalue)) {
                    var sMsg = $A.get("$Label.c.PED_PFCFErr");
                    Codicefiscaleid.set("v.errors", [{message : sMsg}]);            
                    validRecord = false;
                }
                else if(!$A.util.isEmpty(Codicefiscalevalue)){
                    if(NazionalityValue == 'Italiana'){ 
                        if(Codicefiscalevalue.match(regExpformat)){
                            /* MB - Commentato in quanto per la persona fisica non sono presenti i campi Nome e Cognome
                    var sNome = component.find("firstNameid").get("v.value").replace("'", "");
                    var sCognome = component.find("lastNameid").get("v.value").replace("'", "");
                    var childcomp = component.find("childbtn");
                    var cmpId = "Codicefiscaleid";
                    childcomp.CallCheckCF(Codicefiscalevalue, sNome, sCognome, cmpId);
                    if(component.get("v.CFOnBlurErrorExist")){
                        var sMsg = $A.get("$Label.c.PED_CodicefiscaleErr");
                        Codicefiscaleid.set("v.errors", [{message : sMsg}]);
                        validRecord = false;
                    }
                    else
                        Codicefiscaleid.set("v.errors", [{message : null}]);
                    */
                    Codicefiscaleid.set("v.errors", [{message : null}]);
                }
                else{ 
                    var sMsg = $A.get("$Label.c.PED_CodicefiscaleErr");
                    Codicefiscaleid.set("v.errors", [{message : sMsg}]);
                    validRecord = false;
                }
            }
            else
                Codicefiscaleid.set("v.errors", null);
        }
                return validRecord;
            }
})