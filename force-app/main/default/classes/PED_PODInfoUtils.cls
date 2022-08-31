public with sharing class PED_PODInfoUtils {
    
    public static PED_PODInfoWrapper.Response verificaIntestatario (String cfReq, String pivaReq, PED_PODInfoWrapper.Response response){
        System.debug('PED_PODInfoUtils.verificaIntestatario **** START');
        if(response == null || response.data == null || response.data.size()==0) return response;

        Boolean validCF = false;
        Boolean validPiva = false;
        Boolean isNullCF = false;
        Boolean isNullPiva = false;
        System.debug(response.data[0].pods.Idpod);
        if(String.isNotBlank(cfReq)){
            System.debug('cfReq-->'+cfReq);
            System.debug('response.data[0].TaxCode-->'+response.data[0].pods.TaxCode);
            validCF = cfReq.equalsIgnoreCase(response.data[0].pods.TaxCode);
            System.debug('validCF-->'+validCF);
        }
        if(String.isNotBlank(pivaReq)){
            validPiva = pivaReq.equalsIgnoreCase(response.data[0].pods.VatNumber);
            System.debug('validPiva-->'+validPiva);
        }

        if(!validCF && !validPiva) {
            response.data = null;
            response.validaData = false;
        } else {
            response.validaData = true;
        }
        System.debug('PED_PODInfoUtils.verificaIntestatario **** DONE');
        return response;
    }

    public static void aggiungiInCache(PED_PODInfoWrapper.Response response) {
        System.debug('PED_PODInfoUtils.aggiungiInCache**** START');
        if(response == null || !response.meta.status.equalsIgnoreCase('OK') || response.data == null || response.data.size()==0 || response.validaData == false) return;
        String jsonPod = JSON.serialize(response);
        System.debug('jsonPod-->'+jsonPod);
        PED_SessionCacheManager scm = new PED_SessionCacheManager();
        String cacheName = response.data[0].pods.IdPod;
        scm.put(cacheName, jsonPod);
        scm.put('podSelected', cacheName);
        System.debug('PED_PODInfoUtils.aggiungiInCache**** DONE');
    }

    public static void aggiungiInCacheDelegato(PED_PODInfoWrapper.Response response) {
        System.debug('PED_PODInfoUtils.aggiungiInCacheDelegato**** START');
        if(response == null || !response.meta.status.equalsIgnoreCase('OK') || response.data == null || response.data.size()==0 || response.validaData == false) return;
        String jsonPod = JSON.serialize(response);
        System.debug('jsonPod-->'+jsonPod);
        PED_SessionCacheManager scm = new PED_SessionCacheManager();
        String cfDelegante = PED_CacheGenericInfoWrapperUtils.recuperaCacheCfDelegante();
        if(String.isBlank(cfDelegante)) return;
        String cacheName = response.data[0].pods.IdPod;
        scm.put(cacheName, jsonPod);
        scm.put('podSelected'+cfDelegante, cacheName);
        System.debug('PED_PODInfoUtils.aggiungiInCacheDelegato**** DONE');
    }

    public static PED_PODInfoWrapper.Response recuperaPodInCache(String podId){
        System.debug('PED_PODInfoUtils.recuperaPodInCache**** START');
        System.debug('recupero pod-->'+podId);
        PED_SessionCacheManager scm = new PED_SessionCacheManager();
        String response = (String)scm.get(podId);
        System.debug('pod recuperato-->'+response);
        if(String.isNotBlank(response)){
            scm.put('podSelected', podId);
            return (PED_PODInfoWrapper.Response)JSON.deserialize(response, PED_PODInfoWrapper.Response.class);
        }
        System.debug('PED_PODInfoUtils.recuperaPodInCache**** DONE');
        return null;
    }

    public static PED_PODInfoWrapper.Response recuperaPodInCache(){
        System.debug('PED_PODInfoUtils.recuperaPodInCache**** START');
        String podId = recuperaSelezionato();
        System.debug('recupero pod-->'+podId);
        if(String.isBlank(podId)){ //meccanismo di recupero cache da ultima chiamata a supplyByPodId
            Boolean restored = PED_RecuperaCacheController.recuperaPodSelezionatoDaLog(false); 
            if(restored) {
                podId = recuperaSelezionato();
            } else {
                return null;
            }
        }
        PED_SessionCacheManager scm = new PED_SessionCacheManager();
        String response = (String)scm.get(podId);
        System.debug('pod recuperato-->'+response);
        if(String.isNotBlank(response)){
            return (PED_PODInfoWrapper.Response)JSON.deserialize(response, PED_PODInfoWrapper.Response.class);
        }
        System.debug('PED_PODInfoUtils.recuperaPodInCache**** DONE');
        return null;
    }

    public static PED_PODInfoWrapper.Response recuperaPodInCacheDelegato(String podId){
        System.debug('PED_PODInfoUtils.recuperaPodInCacheDelegato**** START');
        System.debug('recupero pod-->'+podId);
        PED_SessionCacheManager scm = new PED_SessionCacheManager();
        String response = (String)scm.get(podId);
        System.debug('pod recuperato-->'+response);
        if(String.isNotBlank(response)){
            String cfDelegante = PED_CacheGenericInfoWrapperUtils.recuperaCacheCfDelegante();
            if(String.isBlank(cfDelegante)) return null;
            scm.put('podSelected'+cfDelegante, podId);
            return (PED_PODInfoWrapper.Response)JSON.deserialize(response, PED_PODInfoWrapper.Response.class);
        }
        System.debug('PED_PODInfoUtils.recuperaPodInCacheDelegato**** DONE');
        return null;
    }

    public static PED_PODInfoWrapper.Response recuperaPodInCacheDelegato(){
        System.debug('PED_PODInfoUtils.recuperaPodInCacheDelegato**** START');
        String podId = recuperaSelezionatoDelegato();
        System.debug('recupero pod-->'+podId);
        if(String.isBlank(podId)){ //meccanismo di recupero cache da ultima chiamata a supplyByPodId
            Boolean restored = PED_RecuperaCacheController.recuperaPodSelezionatoDaLog(true); 
            if(restored) {
                podId = recuperaSelezionatoDelegato();
            } else {
                return null;
            }
                
            
        }
        PED_SessionCacheManager scm = new PED_SessionCacheManager();
        String response = (String)scm.get(podId);
        System.debug('pod recuperato-->'+response);
        if(String.isNotBlank(response)){
            return (PED_PODInfoWrapper.Response)JSON.deserialize(response, PED_PODInfoWrapper.Response.class);
        }
        System.debug('PED_PODInfoUtils.recuperaPodInCacheDelegato**** DONE');
        return null;
    }

    public static String recuperaSelezionato (){
        PED_SessionCacheManager scm = new PED_SessionCacheManager();
        String response = (String)scm.get('podSelected');
        
        return response;
    }

    public static String recuperaSelezionatoDelegato (){
        PED_SessionCacheManager scm = new PED_SessionCacheManager();
        String cfDelegante = PED_CacheGenericInfoWrapperUtils.recuperaCacheCfDelegante();
        System.debug('cfDelegante-->'+cfDelegante);
        if(String.isBlank(cfDelegante)) return null;
        String response = (String)scm.get('podSelected'+cfDelegante);
        
        return response;
    }


    public static void applicaLogicheCustom(PED_PODInfoWrapper.Response response){
        if(response == null || response.data == null || response.data.size()==0 || response.data[0].pods == null) return;
        PED_PODWrapper.ResponsePod podSelected = response.data[0].pods;
        System.debug('pod.PodTechnicalData-->'+podSelected.PodTechnicalData);
        if(String.isNotBlank(podSelected.VoltageLevel) && podSelected.VoltageLevel.equalsIgnoreCase('BM')){
            podSelected.VoltageLevel = 'BT';
        }

        if(podSelected.PodTechnicalData != null){
            response.data[0].pods.is2G       = podSelected.PodTechnicalData.meterType == null? null : podSelected.PodTechnicalData.meterType.containsIgnoreCase('1G')?  false : true;
            //response.data[0].pods.orario     = podSelected.PodTechnicalData.oraCommDate == null ? false : true; 
            response.data[0].pods.orario     = podSelected.PodTechnicalData.RetrieveInfoOrarieta; 
        }
        if(podSelected.HasPlant == 'true')
            podSelected.isPodScambio = true;
        else
            podSelected.isPodScambio = false;

        podSelected.podSubscribed = false;
        //DOM: TEMPORANEO PER TEST
       /* if(response.data[0].pods.IdPod == 'IT001E74979896'){
            response.data[0].pods.is2G = true;
            response.data[0].pods.orario = true;
        }*/
    }

    public static void eliminaSelezionato(){
        try {
            PED_SessionCacheManager scm = new PED_SessionCacheManager();
            scm.remove('podSelected');
        } catch (Exception e) {
            System.debug(e);
        }
        
    }
}