({
    doInit : function(component,event,helper){
        helper.doInit(component,event,helper);
    },
    
    activeButton : function(component,event,helper){
        var inputText = component.find("Emailid").get("v.value");
        if((inputText != null  && inputText != '') && helper.validateEmail(component, event, helper))
            component.set("v.isButtonActive",false);
        else
            component.set("v.isButtonActive",true);
    },
    
    activeButtonUser : function(component,event,helper){
        debugger;
        var inputText = component.find("Codicefiscaleid").get("v.value");
        var inputText2 = component.find("Nazionalityid").get("v.value");
        if(inputText != null && inputText != ''){
            var inputCFPF = component.find("Codicefiscaleid");
            var valueCFPF = inputCFPF.get("v.value").toUpperCase();
            inputCFPF.set("v.value", valueCFPF); 
            inputText = inputCFPF.get("v.value");
        }
        if((inputText != null  && inputText != '') && (inputText2 !='Seleziona un valore' && inputText2 !='') && helper.validatePFCF(component, event))
            component.set("v.isButtonActiveUser",false);
        else
            component.set("v.isButtonActiveUser",true);
    },
    
    activeButtonUserPG : function(component,event,helper){
        
        debugger;
        
        var inputText1 = component.find("RagioneSocialeid1").get("v.value");
        var inputText2 = component.find("ContactCodicefiscaleid").get("v.value");
        var inputText3 = component.find("PartitaIVAId1").get("v.value");
        var inputText4 = component.find("Sedelegalediid1").get("v.value");
        
        var inputText5 = component.find("firstNameid1").get("v.value");
        var inputText6 = component.find("lastNameid1").get("v.value");
        var inputText7 = component.find("Nazionalityid1").get("v.value");
        var inputText8 = component.find("Codicefiscaleid1").get("v.value");
        
        if(inputText2 != null && inputText2 != ''){
            var inputCFPG = component.find("ContactCodicefiscaleid");  // Rendo maiuscolo il CF per i controlli
            var valueCFPG = inputCFPG.get("v.value").toUpperCase();
            inputCFPG.set("v.value", valueCFPG); 
            inputText2 = inputCFPG.get("v.value");
        }
        
        if(inputText8 != null && inputText8 != ''){
            var inputCFPF = component.find("Codicefiscaleid1");
            var valueCFPF = inputCFPF.get("v.value").toUpperCase();
            inputCFPF.set("v.value", valueCFPF); 
            inputText8 = inputCFPF.get("v.value");
        }
        
        
        if((inputText2.substring(0, 1) == 8 || inputText2.substring(0, 1) == 9) && (inputText3 == null || inputText3 == '')){ // Controllo se si tratti di un Ente
            if((inputText1 != null  && inputText1 != '') &&
               (inputText2 != null  && inputText2 != '')  &&
               (inputText4 != 'Seleziona un valore' && inputText4 != '') &&
               (inputText5 != null  && inputText5 != '') &&
               (inputText6 != null  && inputText6 != '') &&
               (inputText7 != 'Seleziona un valore' && inputText7 != '') &&
               (inputText8 != null  && inputText8 != '') &&
               (helper.validatePFCF(component, event) && helper.validateContactCodicefiscale(component, event) && helper.validatePartitaIva(component, event))) 
                component.set("v.isButtonActiveUserPG",false);
            else
                component.set("v.isButtonActiveUserPG",true);
        }
        
        else if((inputText2.substring(0, 1) == 8 || inputText2.substring(0, 1) == 9) && (inputText3 != null || inputText3 != '')) { // Controllo se si tratti di un Ente
            if((inputText1 != null  && inputText1 != '') &&
               (inputText2 != null  && inputText2 != '')  &&
               (inputText3 != null  && inputText3 != '')  &&
               (inputText4 != 'Seleziona un valore' && inputText4 != '') &&
               (inputText5 != null  && inputText5 != '') &&
               (inputText6 != null  && inputText6 != '') &&
               (inputText7 != 'Seleziona un valore' && inputText7 != '') &&
               (inputText8 != null  && inputText8 != '') &&
               (helper.validatePFCF(component, event) && helper.validateContactCodicefiscale(component, event) && helper.validatePartitaIva(component, event))) 
                component.set("v.isButtonActiveUserPG",false);
            else
                component.set("v.isButtonActiveUserPG",true);
        }
        
        else{
            if((inputText1 != null  && inputText1 != '') &&
               (inputText2 != null  && inputText2 != '')  &&
               (inputText3 != null  && inputText3 != '') &&
               (inputText4 != 'Seleziona un valore' && inputText4 != '') &&
               (inputText5 != null  && inputText5 != '') &&
               (inputText6 != null  && inputText6 != '') &&
               (inputText7 != 'Seleziona un valore' && inputText7 != '') &&
               (inputText8 != null  && inputText8 != '') &&
               (helper.validatePFCF(component, event) && helper.validateContactCodicefiscale(component, event) && helper.validatePartitaIva(component, event))) 
                component.set("v.isButtonActiveUserPG",false);
            else
                component.set("v.isButtonActiveUserPG",true);
        }
        
        helper.validatePGCF(component, event, helper);
        helper.validatePartitaIva(component, event);
        if(!$A.util.isEmpty(inputText2)) // tb
            helper.validateContactCodicefiscale(component, event, helper);
        
        debugger;
        
    },
    
    handleChangeRadio : function(component, event, helper) {
        var radioVal = event.currentTarget.getAttribute('id');
        if(radioVal == 'Username'){
            component.set('v.isUsername', true);
            component.set('v.isPassword', false);
        }
        if(radioVal == 'Password'){
            component.set('v.isUsername', false);
            component.set('v.isPassword', true);
            component.set('v.isPG', false);
            component.set('v.isPF', false);
        }
    },
    
    validateEmail : function(component, event, helper){
        helper.validateEmail(component, event, helper);
    },
    
    recuperaPassword : function(component, event, helper){
        if(helper.validateEmail(component, event, helper)){
            component.set('v.Spinner', true);
            helper.recuperaPassword(component, event, helper);
        }
    },
    
    validateOTP : function(component, event, helper){
        var inputValue = component.get('v.OTP');
        if(inputValue.trim().length == 5)
            component.set('v.isDisableOTP', false);
        else
            component.set('v.isDisableOTP', true);
    },
    
    validateOTPApex : function(component,event,helper){
        component.set('v.Spinner', true);
        helper.validateOTP(component, event, helper);
    },
    
    backEmail : function(component,event,helper){
        var elements = document.getElementsByClassName("slds-col slds-size_3-of-3");
        elements[0].style.display = 'block';
        component.set('v.isPasswordOTP', false);
        component.set('v.OTP', '');
    },
    
    backHome : function(component, event, helper){
        var address ='/';
        var urlEvent = $A.get("e.force:navigateToURL");
        
        urlEvent.setParams({
            "url" : address,
            "isredirect" : false
        });
        
        urlEvent.fire();
    },
    
    reinviaCodice : function(component, event, helper){
        component.set('v.Spinner', true);
        helper.recuperaPassword(component, event, helper);
    },
    
    reinviaCodice1 : function(component, event, helper){
        component.set('v.Spinner', true);
        helper.recuperaPasswordUsername(component, event, helper);
    },
    
    selectTipologiaUtente : function(component, event, helper){
        var valueType = component.find("tipologia").get("v.value");
        if(valueType == 'PG'){
            component.set('v.isPG', true);
            component.set('v.isPF', false);
            //CB sbianco i campi interessati quando si passa da persona giuridica a quella fisica e viceversa
            component.set("v.newContact",{});
            component.set("v.account",{});
            // component.set("v.selectedValue1",'Italiana');
        }
        if(valueType == 'PF'){
            component.set('v.isPF', true);
            component.set('v.isPG', false);
            //CB sbianco i campi interessati quando si passa da persona giuridica a quella fisica e viceversa
            component.set("v.newContact",{});
            component.set("v.account",{});
            // component.set("v.selectedValue1",'Italiana');
        }
    },
    
    validateNome : function(component,event,helper){
        var firstName = component.find("firstNameid");
        var firstNamevalue = firstName.get("v.value");
        var CharRegex= /^[a-zA-ZÀ-ÿ .,`~!''@#$%^&*_-]*$/;
        var nomeMsg = $A.get("$Label.c.PED_InvalidNome");
        var sMsg = $A.get("$Label.c.PED_PFFNameError");
        if (!$A.util.isEmpty(firstNamevalue)){
            if(!firstNamevalue.match(CharRegex))
                firstName.set("v.errors", [{message : nomeMsg}]);
            else
                firstName.set("v.errors", null); 
        }
        else
            firstName.set("v.errors", [{message : sMsg}]);
    },
    
    validateCognome : function(component,event,helper){
        var lastName = component.find("lastNameid");
        var lastNamevalue = lastName.get("v.value");
        var CharRegex=/^[a-zA-ZÀ-ÿ .,`~!''@#$%^&*_-]*$/;
        var cognomeMsg = $A.get("$Label.c.PED_InvalidCognome");
        var sMsg = $A.get("$Label.c.PED_PFLNameError");
        if (! $A.util.isEmpty(lastNamevalue)){
            if(! lastNamevalue.match(CharRegex))
                lastName.set("v.errors", [{message : cognomeMsg}]);     
            else
                lastName.set("v.errors", null);     
        }
        else
            lastName.set("v.errors", [{message : sMsg}]);
    },
    
    validatePFCF : function(component,event,helper){
        debugger;
        var isValid = true; 
        var Codicefiscaleid = component.find("Codicefiscaleid");
        var CodicefiscaleidValue = Codicefiscaleid.get("v.value"); 
        var Nazionalityid = component.find("Nazionalityid");
        var NazionalityValue = Nazionalityid.get("v.value");
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
            
            else if(NazionalityValue == 'Seleziona un valore' || NazionalityValue == ''){
                
                var sMsg = 'La Nazionalità è un campo obbligatorio';
                Codicefiscaleid.set("v.errors", [{message : sMsg}]);
                isValid = false;
                component.set('v.CFOnBlurErrorExist', true);
                
            }
                else {
                    
                    
                    /*
                else {
                    var sMsg = ' Codice Fiscale non è valido';
                    Codicefiscaleid.set("v.errors", [{message : sMsg}]);
                    isValid = false;
                    component.set('v.CFOnBlurErrorExist', true);
                } */
                    
                    // var sMsg = $A.get("$Label.c.PED_CodicefiscaleErr");
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
    
    getAllEvtParam : function (component, event, helper) {
        if(event.getParam("compId") == 'Codicefiscaleid1')
            helper.getEvtParam(component, event, helper);
        else if(event.getParam("compId") == 'PartitaIVAId1')
            helper.getEvtParam1(component, event, helper);
            else          
                helper.getEvtParam2(component, event, helper);
    },
    
    recuperaUsername : function (component, event, helper) {
        if(helper.validateRecord(component, event, helper)){
            component.set('v.Spinner', true);
            helper.recuperaUsername(component, event, helper);  
        }
    },
    
    backRecoveryUsername : function (component, event, helper) {
        var elements = document.getElementsByClassName("slds-col slds-size_3-of-3");
        elements[0].style.display = 'block';
        component.set('v.showUsername', false);
    },
    
    modificaUsername : function (component, event, helper) {
        component.set('v.Spinner', true);
        helper.modificaUsername(component, event, helper);
    },
    
    submitOk : function (component, event, helper) {
        component.set('v.linkDoc', '');
    },
    
    validateOTPVerifica : function(component, event, helper){
        var inputValue = component.find('OtpVerifica').get('v.value');
        if(inputValue.trim().length == 5)
            component.set('v.disableOTP', false);
        else
            component.set('v.disableOTP', true);
    },
    
    validateOTPVerifica1 : function(component, event, helper){
        var inputValue = component.find('OtpVerifica1').get('v.value');
        if(inputValue.trim().length == 5)
            component.set('v.disableOTP', false);
        else
            component.set('v.disableOTP', true);
    },
    
    resendCode : function(component, event, helper){
        helper.sendOtp(component, event, helper);
    },
    
    checkOTPCell : function(component, event, helper){
        helper.checkOtp(component, event, helper);
    },
    
    recuperaPasswordUsername : function(component, event, helper){
        var emailConferma = component.find('EmaildaConfermare').get('v.value');
        if(helper.validateEmail(component, event, helper) && component.get('v.Email') == emailConferma){
            component.set('v.Spinner', true);
            helper.recuperaPasswordUsername(component, event, helper);
        }
        if(component.get('v.Email') != emailConferma)
            component.find('EmaildaConfermare').set("v.errors", [{message : 'L\'Email non corrispondono'}]);
    },
    
    validateOTPUsername : function(component, event, helper){
        component.set('v.Spinner', true);
        helper.validateOTPUsername(component, event, helper);
    },
    
    /*  validateNation : function(component, event, helper){
        
        var validRecord = true;
        var SedeLegale = component.find("Sedelegalediid1");
        var SedeLegalevalue = SedeLegale.get("v.value");
        var sMsg = "La Nazionalità è un campo obbligatorio.";
        
        if (SedeLegalevalue = 'Seleziona un valore'){
            
            SedeLegale.set("v.errors", [{message : sMsg}]);
            validRecord = false;
        }
        else {
            SedeLegale.set("v.errors", null);
            validRecord = true;
            
        }
        return validRecord;
    }, */
    
    validateNomeRapLegale : function(component, event, helper){
        var validRecord = true;
        var firstName = component.find("firstNameid1");
        var firstNamevalue = firstName.get("v.value");
        var CharRegex= /^[a-zA-ZÀ-ÿ .,`~!''@#$%^&*_-]*$/;
        var sMsg = $A.get("$Label.c.PED_PGFNameError");
        var nomeMsg = $A.get("$Label.c.PED_InvalidNome");
        
        if (!$A.util.isEmpty(firstNamevalue)){
            if(!firstNamevalue.match(CharRegex)){
                firstName.set("v.errors", [{message : nomeMsg}]);
                validRecord = false;
            }
            else
                firstName.set("v.errors", null); 
        }
        else{
            firstName.set("v.errors", [{message : sMsg}]);
            validRecord = false;
        }
        return  validRecord;
    },
    
    validateCognomeRapLegale : function(component, event, helper){
        var validRecord = true;   
        var lastName = component.find("lastNameid1");
        var lastNamevalue = lastName.get("v.value");
        var CharRegex = /^[a-zA-ZÀ-ÿ .,`~!''@#$%^&*_-]*$/;
        var cognomeMsg = $A.get("$Label.c.PED_InvalidCognome");
        var sMsg = $A.get("$Label.c.PED_PGLNameError");
        if (! $A.util.isEmpty(lastNamevalue)){
            if(! lastNamevalue.match(CharRegex)){
                lastName.set("v.errors", [{message : cognomeMsg}]); 
                validRecord = false;
            }
            else
                lastName.set("v.errors", null);     
        }
        else{
            lastName.set("v.errors", [{message : sMsg}]);   
            validRecord = false;
        }
        return validRecord;    
    },
    
    validatePartitaIva : function(component, event, helper){
        debugger;
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
                regExpformat = /^[0-7]{1}[0-9]{10}$/ // /^[0-9]{11}$/;  
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
                    component.set('v.PIVAOnBlurErrorExist', true); // tb fino qui
                }
                
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
        
        else if($A.util.isEmpty(PartitaIVAIdValue) && component.get("v.PIVArequired")){
            isValid = false;
            var sMsg = "Partita Iva è un campo obbligatorio";
            PartitaIVAId.set("v.errors",[{message : sMsg}]); // tb
            component.set('v.PIVAOnBlurErrorExist', false);
        }
        //PI Enti E
        /*       else{
                Msg = $A.get("$Label.c.PED_PGPartitaIvaErr");
                PartitaIVAId.set("v.errors", [{message : Msg}]);
                isValid = false;
                component.set('v.PIVAOnBlurErrorExist', true);
            }    */
        return isValid;
    },
    
    validateContactCodicefiscale : function(component, event, helper){
        debugger;
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
        debugger;
    },
    
    validatePGCF : function(component, event, helper){
        debugger;
        var isValid = true; 
        var Codicefiscaleid1 = component.find("Codicefiscaleid1");
        var Codicefiscalevalue1 = Codicefiscaleid1.get("v.value");
        var Nazionalityid1 = component.find("Nazionalityid1");
        var NazionalityValue1 = Nazionalityid1.get("v.value");
        
        //  if($A.util.isEmpty(NazionalityValue1))
        //     NazionalityValue1 = 'Italiana';
        
        var regExpformat = /^(?:[B-DF-HJ-NP-TV-Z](?:[AEIOU]{2}|[AEIOU]X)|[AEIOU]{2}X|[B-DF-HJ-NP-TV-Z]{2}[A-Z]){2}[\dLMNP-V]{2}(?:[A-EHLMPR-T](?:[04LQ][1-9MNP-V]|[1256LMRS][\dLMNP-V])|[DHPS][37PT][0L]|[ACELMRT][37PT][01LM])(?:[A-MZ][1-9MNP-V][\dLMNP-V]{2}|[A-M][0L](?:[\dLMNP-V][1-9MNP-V]|[1-9MNP-V][0L]))[A-Z]$/i;
        
        if(!$A.util.isEmpty(Codicefiscalevalue1)){
            if(NazionalityValue1 == 'Italiana'){
                if(Codicefiscalevalue1.match(regExpformat)){
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
    
    recuperaUsernamePG : function (component, event, helper) {
        if(helper.validatePersonagiuridiRecord(component, event, helper)){
            component.set('v.Spinner', true);
            helper.recuperaUsernamePG(component, event, helper);
        }
    },
    
    handleSoggettidiversiClick  : function (component, event, helper) {
        var account = component.get('v.account');
        account.PED_IsEnte__c = !account.PED_IsEnte__c;
        component.set('v.account', account);
    }
})