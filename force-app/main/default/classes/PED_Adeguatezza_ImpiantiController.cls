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

    @AuraEnabled
    public static PED_ServiziTecnici_TaratureData.cl getCliente(String pod){
       return PED_ServiziTecnici_Controller.getCliente(pod);
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