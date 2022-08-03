/**
 * @author Marco Speranza
 * @see PED_ServiziTecnici
 * @deprecated PED_ServiziTecnici_Controller
 * Creation data 2-08-2022
 */
 
public with sharing class PED_BuchiDiTensioneController {

    @AuraEnabled 
    public static PED_PODInfoWrapper.Response PODDetails(){
        return PED_PODInfoUtils.recuperaPodInCache();
    }
    
    @AuraEnabled 
    public static PED_PODInfoWrapper.Response PODDetailsDelegato(){
        return PED_PODInfoUtils.recuperaPodInCacheDelegato();
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
