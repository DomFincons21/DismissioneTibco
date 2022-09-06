/**
 * @author Marco Speranza
 * @see PED_ServiziTecnici
 * @deprecated PED_ServiziTecnici_Controller
 * Creation data 27-08-2022
 */

public with sharing class PED_Adeguatezza_ImpiantiController {


    // GetDetails -> getSupplyData
    @AuraEnabled(continuation=true)
    public static Continuation getSupplyData(String url){
        // ! 1º
        Boolean fromDelegate = url.containsIgnoreCase('delegato') ? true : false;
        System.debug('response-1-Adeguatezza->');

        return PED_ServiziTecnici_Controller.getSupplyData(fromDelegate, 'Adeguatezza');
    }

    @AuraEnabled 
    public static PED_SupplyDataWrapper.Response processGetSupplyData(List<String> labels, Object state){
          // ! 4º
        PED_SupplyDataWrapper.Response  response = PED_ServiziTecnici_Controller.processGetSupplyData(labels,state);
        System.debug('response-2-Adeguatezza->');
        return response;
    }

    @AuraEnabled(continuation=true)
    public static Continuation searchCalibration(String customer_k, String customer_l, String customer_m) {  
        return PED_ServiziTecnici_Controller.searchCalibration(customer_k, customer_l, customer_m, 'Adeguatezza');
    }

    @AuraEnabled 
    public static PED_SearchCalibrationsWrapper.Response processSearchCalibrations(List<String> labels, Object state){
        PED_SearchCalibrationsWrapper.Response response = PED_ServiziTecnici_Controller.processSearchCalibrations(labels,state);

        System.debug('response-->'+response);

        // Description article 34
        if(response.data.supplyTechInfo.compensation == 'N' || response.data.supplyTechInfo.compensation == '0,00'){
            response.data.descriptionArt34 = '0 (standard rispettato)';
        }else{
            response.data.descriptionArt34  = response.data.supplyTechInfo.compensation;
        }

        // Description article 45
        if(response.data.supplyTechInfo.extInterruptionsReg == 'N' || response.data.supplyTechInfo.extInterruptionsReg == '0,00'){
            response.data.descriptionArt45 = '0 (standard rispettato)';
        }else{
            response.data.descriptionArt45  = response.data.supplyTechInfo.extInterruptionsReg;
        }

        if (string.IsBlank(response.data.supplyTechInfo.CTS) || response.data.supplyTechInfo.CTS == 'N'){
            response.data.supplyTechInfo.CTS = '0';
        }

        if (string.IsBlank(response.data.supplyTechInfo.CTSm) || response.data.supplyTechInfo.CTSm == 'N'){
            response.data.supplyTechInfo.CTSm = '0';
        }

        if (string.IsBlank(response.data.supplyTechInfo.totalCTS) || response.data.supplyTechInfo.totalCTS == 'N'){
            response.data.supplyTechInfo.totalCTS = '0';
        }
    

        String auxdDeclarationType;

        if(!String.isBlank(response.data.supplyTechInfo.declarationType)){

            auxdDeclarationType = returnInfo(response.data);

            response.data.dichiarazioneAdeguatezza = 'Ci risulta pervenuta la Dichiarazione di Adeguatezza in data '+response.data.supplyTechInfo.declarationType+' ed è da noi considerata '+auxdDeclarationType;
        }else{

            response.data.dichiarazioneAdeguatezza  = 'La Dichiarazione di Adeguatezza relativa al suo impianto non ci risulta pervenuta.';
        }

      
        response.data.tipoMessaggio = fillMessage(response.data.supplyTechInfo.CTSn);
        
        return response;
    }

    public static String fillMessage(String message){

        String result = '';
        if(String.isBlank(message)){
            result='1';
        }
        else if(message == '0'){
          result='2';
        }
        else if(message == '1' || message =='2' || message =='3'){
          result='3';
        }

        return result;
    }

    public static String returnInfo(PED_SearchCalibrationsWrapper.ResponseData res){

        string auxdDeclarationType = '';

       

        if(res.supplyTechInfo.declarationType.toUpperCase()=='C'){
            auxdDeclarationType='Conforme';
        }
        if(res.supplyTechInfo.declarationType.toUpperCase()=='K'){
            auxdDeclarationType='Conforme CEI 0-16';
        }
        if(res.supplyTechInfo.declarationType.toUpperCase()=='N'){
            auxdDeclarationType='Non Conforme';
        }
        if(res.supplyTechInfo.declarationType.toUpperCase()=='R'){
            auxdDeclarationType='Revocata';
        }
        if(res.supplyTechInfo.declarationType.toUpperCase()=='D'){
            auxdDeclarationType='Documentazione non completata';
        }
        if(res.supplyTechInfo.declarationType.toUpperCase()=='S'){
            auxdDeclarationType='Sospesa per arbitrato';
        }

        return auxdDeclarationType;

    }

    @AuraEnabled
    public static string inviaEmail(string nomeServizio, String nomeFile, string tipoAllegato, String allegato, string customBody){
        return PED_ServiziTecnici_Controller.inviaEmail(nomeServizio, nomeFile, tipoAllegato, allegato, customBody);
    }

    @AuraEnabled
    public static user getUser(){
        User u = [select id, firstname, lastname, name from user where id=:userinfo.getUserId()];
        return u;
    }
    

}