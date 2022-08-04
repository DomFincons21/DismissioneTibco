/**
 * @author Marco Speranza
 * @see PED_ServiziTecnici
 * @deprecated PED_ServiziTecnici_Controller
 * Creation data 2-08-2022
 */
 
public with sharing class PED_BuchiDiTensioneController {


    @TestVisible
    public static String continuationLabel;

    private static String wsName = 'buchiDiTensione';
    private final static Integer TIMEOUTASYNC= 60;

     @AuraEnabled (continuation=true)
    public static Continuation  buchiDiTensioneAsContinuation(String pod, String dataInizio, String dataFine){

        Map<String,String> wsInformation = new Map<String,String>();
        PED_BuchiDiTensioneWrapper.Input input = new PED_BuchiDiTensioneWrapper.Input(pod, dataInizio, dataFine);

    
        Continuation cont = new Continuation(TIMEOUTASYNC);
        cont.continuationMethod='processBuchiDiTensione';

        PED_Environment__c endpoint = [select id, Name, Value__c  from PED_Environment__c where Name = 'ServizioBuchiDiTensione' limit 1];
        endpoint.Value__c += '/' + pod + '/' + 'voltage-dips?' + 'start_date=' + dataInizio + '&end_Date='+dataFine;

        HttpRequest request = buildRequest(endpoint.Value__c, input);
        // If request = null -> throw exception
        if(request == null) throw new AuraHandledException('errore token');
          

         // Store the reference to the HttRequest and make it accessible for a test-context
         continuationLabel = cont.addHttpRequest(request);
         cont.state = continuationLabel;

        return cont;
        
    } 

    public static httpRequest buildRequest(String endpoint, PED_BuchiDiTensioneWrapper.Input input){
        

        HttpRequest request = new HttpRequest();
        // TOKEN
       GetWSO2Token.respJWT result = GetWSO2Token.retrieveToken('RetrievePEDToken');
    
       System.debug('Result '+result);

       // If token is not inserted -> exit
       if(!Test.isRunningTest()){
            request.setHeader('Authorization', 'Bearer '+result.access_token);
       }else{
            request.setHeader('Authorization', 'Bearer '+'TestToken');
       }
       // TYPE
       request.setMethod('GET');
       // BODY
       request.setBody(Json.serialize(input,true));
       System.debug(Json.serialize(input,true));

       // ? MOCK request.setBody('{"meta":{"status":"succeeded","message":"searchSupplyVoltageDips response","code":"0"},"data":{"reqDatetime":"03/08/2022 15:34:50","respDatetime":"03/08/2022 15:34:50","voltageDips":[{"duration":"00:00:00.05","RSCode":"X","halfBarId":"DE0013834272RO","residualVoltage":0,"origin":"-","category":"A1","event":"D30013834272RO@0601202005385680","instant":"06/01/2020 05:38:56.80"},{"duration":"00:00:00.06","TRCode":"X","halfBarId":"DE0013834272RO","residualVoltage":0,"origin":"-","category":"B1","event":"D30013834272RO@0304202006331645","STCode":"X","instant":"03/04/2020 06:33:16.45"},{"duration":"00:00:00.05","TRCode":"X","halfBarId":"DE0013834272RO","residualVoltage":0,"origin":"-","category":"A1","event":"D30013834272RO@1204202011521074","instant":"12/04/2020 11:52:10.74"},{"duration":"00:00:00.13","RSCode":"X","TRCode":"X","halfBarId":"DE0013834272RO","residualVoltage":0,"origin":"-","category":"C1","event":"D30013834272RO@2004202005281304","STCode":"X","instant":"20/04/2020 05:28:13.04"},{"duration":"00:00:00.03","TRCode":"X","halfBarId":"DE0013834272RO","residualVoltage":0,"origin":"-","category":"C1","event":"D30013834272RO@2004202005281496","STCode":"X","instant":"20/04/2020 05:28:14.96"},{"duration":"00:00:00.10","TRCode":"X","halfBarId":"DE0013834272RO","residualVoltage":0,"origin":"-","category":"A1","event":"D30013834272RO@1905202010095624","instant":"19/05/2020 10:09:56.24"},{"duration":"00:00:00.12","RSCode":"X","TRCode":"X","halfBarId":"DE0013834272RO","residualVoltage":0,"origin":"-","category":"B1","event":"D30013834272RO@1906202003274907","STCode":"X","instant":"19/06/2020 03:27:49.07"},{"duration":"00:00:00.09","RSCode":"X","halfBarId":"DE0013834272RO","residualVoltage":0,"origin":"-","category":"A1","event":"D30013834272RO@0908202017324159","instant":"09/08/2020 17:32:41.59"},{"duration":"00:00:00.07","RSCode":"X","halfBarId":"DE0013834272RO","residualVoltage":0,"origin":"-","category":"A1","event":"D30013834272RO@0908202017324261","instant":"09/08/2020 17:32:42.61"},{"duration":"00:00:00.03","RSCode":"X","halfBarId":"DE0013834272RO","residualVoltage":0,"origin":"-","category":"A1","event":"D30013834272RO@0908202017342329","instant":"09/08/2020 17:34:23.29"},{"duration":"00:00:00.13","RSCode":"X","TRCode":"X","halfBarId":"DE0013834272RO","residualVoltage":0,"origin":"-","category":"C1","event":"D30013834272RO@2709202001385342","STCode":"X","instant":"27/09/2020 01:38:53.42"},{"duration":"00:00:00.20","RSCode":"X","TRCode":"X","halfBarId":"DE0013834272RO","residualVoltage":0,"origin":"-","category":"A1","event":"D30013834272RO@0512202015225787","STCode":"X","instant":"05/12/2020 15:22:57.87"},{"duration":"00:00:00.18","RSCode":"X","halfBarId":"DE0013834272RO","residualVoltage":0,"origin":"-","category":"A1","event":"D30013834272RO@2612202007293350","instant":"26/12/2020 07:29:33.50"},{"duration":"00:00:00.05","TRCode":"X","halfBarId":"DE0013834272RO","residualVoltage":0,"origin":"-","category":"A1","event":"D30013834272RO@2812202006514922","instant":"28/12/2020 06:51:49.22"},{"duration":"00:00:00.11","RSCode":"X","TRCode":"X","halfBarId":"DE0013834272RO","residualVoltage":0,"origin":"-","category":"C1","event":"D30013834272RO@3012202023461576","STCode":"X","instant":"30/12/2020 23:46:15.76"}]}}');
       request.setEndpoint(endpoint);

        return request;
    }

    @AuraEnabled 
    public static PED_PODInfoWrapper.Response getDetails(String url){

        if(!url.containsIgnoreCase('Delegato'))
             return PED_PODInfoUtils.recuperaPodInCache();

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
