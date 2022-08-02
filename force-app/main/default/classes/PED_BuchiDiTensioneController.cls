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
}
