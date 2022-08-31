public class PED_TaratureImpianti_Controller {
    @AuraEnabled 
    public static PED_PODInfoWrapper.Response PODDetails(){
        return PED_PODInfoUtils.recuperaPodInCache();
    }
    
    @AuraEnabled 
    public static PED_PODInfoWrapper.Response PODDetailsDelegato(){
        return PED_PODInfoUtils.recuperaPodInCacheDelegato();
    }

    @AuraEnabled
    public static user getUser(){
        return PED_ServiziTecnici_Controller.getUser();
    }

    @AuraEnabled
    public static string inviaEmail(string nomeServizio, String nomeFile, string tipoAllegato, String allegato, string customBody){
        return PED_ServiziTecnici_Controller.inviaEmail(nomeServizio, nomeFile, tipoAllegato, allegato, customBody);
    }

    @AuraEnabled
    public static String scriviImpiantoFornitura(Map<String,String> impiantoFornituraMap){
        return PED_ServiziTecnici_Controller.scriviImpiantoFornitura(impiantoFornituraMap);
    }

    @AuraEnabled(continuation=true)
    public static Continuation searchCalibration(String customer_k, String customer_l, String customer_m) {  
        return PED_ServiziTecnici_Controller.searchCalibration(customer_k, customer_l, customer_m, 'Tarature');
    }

    @AuraEnabled 
    public static PED_SearchCalibrationsWrapper.Response processSearchCalibrations(List<String> labels, Object state){
        PED_SearchCalibrationsWrapper.Response response = PED_ServiziTecnici_Controller.processSearchCalibrations(labels,state);

        System.debug('response-->'+response);
        return response;
    }
}