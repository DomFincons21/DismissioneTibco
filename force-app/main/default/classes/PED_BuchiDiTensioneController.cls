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
    private static String wsProcess = 'ServiziTecnici-BuchiTensione';
    private final static Integer TIMEOUTASYNC = 60;

    @AuraEnabled (continuation=true)
    public static Continuation  buchiDiTensioneAsContinuation(String pod, String dataInizio, String dataFine, Boolean fromDelegate){

        Map<String,String> wsInformation = new Map<String,String>();
        PED_BuchiDiTensioneWrapper.Input input = new PED_BuchiDiTensioneWrapper.Input(pod, dataInizio, dataFine);

        System.debug(dataInizio);
        System.debug(dataFine);

        // TODO REMOVE DATA INIZIO MOCK DATA -  FINE MOCK
       // dataInizio = '1-1-2020';

        PED_ServiceSettings__c endpoint = [select id, Name, PED_Endpoint__c from PED_ServiceSettings__c where Name = 'ServizioBuchiDiTensione' limit 1];
        endpoint.PED_Endpoint__c += '/' + pod + '/' + 'voltage-dips?' + 'start_date=' + dataInizio + '&end_date='+dataFine;
        
        HttpRequest request = buildRequest(endpoint.PED_Endpoint__c, input);
        // If request = null -> throw exception
        if(request == null) throw new AuraHandledException('errore token');

        wsInformation.put('request', endpoint.PED_Endpoint__c); 
        wsInformation.put('endpoint',  String.valueOf(endpoint)); 
        wsInformation.put('point_of_delivery', pod); 
        wsInformation.put('date_from', dataInizio); 
        wsInformation.put('date_to', dataFine); 
        wsInformation.put('fromDelegate', String.valueOf(fromDelegate)); 
        


        Continuation cont = new Continuation(TIMEOUTASYNC);
        cont.continuationMethod='processBuchiDiTensione';
          
         // Store the reference to the HttRequest and make it accessible for a test-context
         continuationLabel = cont.addHttpRequest(request);
         cont.state = wsInformation;

        return cont;
        
    } 

    public static httpRequest buildRequest(String endpoint, PED_BuchiDiTensioneWrapper.Input input){
        

        HttpRequest request = new HttpRequest();
        // TOKEN
       GetWSO2Token.respJWT result = GetWSO2Token.retrieveToken('RetrievePEDTokenQA');
    
       System.debug('Result '+result);

       // If token is not inserted -> exit
       if(!Test.isRunningTest()){
            request.setHeader('Authorization', 'Bearer '+result.access_token);
       }else{
            request.setHeader('Authorization', 'Bearer '+'TestToken');
       }
       // TYPE
       request.setMethod('GET');
       //request.setBody('');
       // ? MOCK request.setBody('{"meta":{"status":"succeeded","message":"searchSupplyVoltageDips response","code":"0"},"data":{"reqDatetime":"03/08/2022 15:34:50","respDatetime":"03/08/2022 15:34:50","voltageDips":[{"duration":"00:00:00.05","RSCode":"X","halfBarId":"DE0013834272RO","residualVoltage":0,"origin":"-","category":"A1","event":"D30013834272RO@0601202005385680","instant":"06/01/2020 05:38:56.80"},{"duration":"00:00:00.06","TRCode":"X","halfBarId":"DE0013834272RO","residualVoltage":0,"origin":"-","category":"B1","event":"D30013834272RO@0304202006331645","STCode":"X","instant":"03/04/2020 06:33:16.45"},{"duration":"00:00:00.05","TRCode":"X","halfBarId":"DE0013834272RO","residualVoltage":0,"origin":"-","category":"A1","event":"D30013834272RO@1204202011521074","instant":"12/04/2020 11:52:10.74"},{"duration":"00:00:00.13","RSCode":"X","TRCode":"X","halfBarId":"DE0013834272RO","residualVoltage":0,"origin":"-","category":"C1","event":"D30013834272RO@2004202005281304","STCode":"X","instant":"20/04/2020 05:28:13.04"},{"duration":"00:00:00.03","TRCode":"X","halfBarId":"DE0013834272RO","residualVoltage":0,"origin":"-","category":"C1","event":"D30013834272RO@2004202005281496","STCode":"X","instant":"20/04/2020 05:28:14.96"},{"duration":"00:00:00.10","TRCode":"X","halfBarId":"DE0013834272RO","residualVoltage":0,"origin":"-","category":"A1","event":"D30013834272RO@1905202010095624","instant":"19/05/2020 10:09:56.24"},{"duration":"00:00:00.12","RSCode":"X","TRCode":"X","halfBarId":"DE0013834272RO","residualVoltage":0,"origin":"-","category":"B1","event":"D30013834272RO@1906202003274907","STCode":"X","instant":"19/06/2020 03:27:49.07"},{"duration":"00:00:00.09","RSCode":"X","halfBarId":"DE0013834272RO","residualVoltage":0,"origin":"-","category":"A1","event":"D30013834272RO@0908202017324159","instant":"09/08/2020 17:32:41.59"},{"duration":"00:00:00.07","RSCode":"X","halfBarId":"DE0013834272RO","residualVoltage":0,"origin":"-","category":"A1","event":"D30013834272RO@0908202017324261","instant":"09/08/2020 17:32:42.61"},{"duration":"00:00:00.03","RSCode":"X","halfBarId":"DE0013834272RO","residualVoltage":0,"origin":"-","category":"A1","event":"D30013834272RO@0908202017342329","instant":"09/08/2020 17:34:23.29"},{"duration":"00:00:00.13","RSCode":"X","TRCode":"X","halfBarId":"DE0013834272RO","residualVoltage":0,"origin":"-","category":"C1","event":"D30013834272RO@2709202001385342","STCode":"X","instant":"27/09/2020 01:38:53.42"},{"duration":"00:00:00.20","RSCode":"X","TRCode":"X","halfBarId":"DE0013834272RO","residualVoltage":0,"origin":"-","category":"A1","event":"D30013834272RO@0512202015225787","STCode":"X","instant":"05/12/2020 15:22:57.87"},{"duration":"00:00:00.18","RSCode":"X","halfBarId":"DE0013834272RO","residualVoltage":0,"origin":"-","category":"A1","event":"D30013834272RO@2612202007293350","instant":"26/12/2020 07:29:33.50"},{"duration":"00:00:00.05","TRCode":"X","halfBarId":"DE0013834272RO","residualVoltage":0,"origin":"-","category":"A1","event":"D30013834272RO@2812202006514922","instant":"28/12/2020 06:51:49.22"},{"duration":"00:00:00.11","RSCode":"X","TRCode":"X","halfBarId":"DE0013834272RO","residualVoltage":0,"origin":"-","category":"C1","event":"D30013834272RO@3012202023461576","STCode":"X","instant":"30/12/2020 23:46:15.76"}]}}');
       request.setEndpoint(endpoint);

        return request;
    }

    @AuraEnabled 
    public static PED_BuchiDiTensioneWrapper.Response processBuchiDiTensione(List<String> labels, Object state){

        httpResponse response;
        map<String,String> myState = (map<String,String>) state;
        PED_BuchiDiTensioneWrapper.Response resp;

        System.debug('PED_BuchiDiTensioneWrapper.processBuchiDiTensione -- START>' + labels[0]);
        response = Continuation.getResponse(labels[0]);

         // CREAZIONE DEL PED_Log__c
         PED_DebugLogger logger = PED_DebugLoggerFactory.getDefaultImpl();
        
        System.debug(response.toString());
        System.debug(response.getStatusCode());
        System.debug(response.getStatus());
        System.debug(response.getBody());

         myState.put('response',response.getBody());
         myState.put('statusCode',String.valueOf(response.getStatusCode()));

         try{
           
            if(response.getStatusCode() == 201 || response.getStatusCode() == 200){
    
                String body = response.getBody();
                resp = (PED_BuchiDiTensioneWrapper.Response) JSON.deserialize(response.getBody(), PED_BuchiDiTensioneWrapper.Response.class);
                
                System.debug(resp);

                //Fill sintesi e SintesiAT
                resp.data.sintesi = new Map<String,Integer>();
                resp.data.sintesiAT = new Map<String,Integer>();
                
                if(resp.data.voltageDips != null){
                    for(PED_BuchiDiTensioneWrapper.ResponseBuchiSemisbarra bs : resp.data.voltageDips){
                       
                    // # SINTESI 
                         // Quando itera aggiunge +1 a la category
                         if(resp.data.sintesi.containsKey(bs.category)){

                            Integer i = resp.data.sintesi.get(bs.category);
                            resp.data.sintesi.put(bs.category,++i);
                            System.debug('Aggiungiendo in categoria '+ bs.category + ' Nº: '+ i);
                            
                        }else{
                             // 1º Giro crea la prima category
                             resp.data.sintesi.put(bs.category,1);
                            System.debug('Prima category'+ bs.category);
                        }

                    // # SINTESI AT
                        if(bs.origin == 'AT'){

                            // Quando itera aggiunge +1 a la category
                            if(resp.data.sintesiAT.containsKey(bs.category)){

                                Integer i = resp.data.sintesiAT.get(bs.category);
                                resp.data.sintesiAT.put(bs.category,++i);
                                System.debug('Aggiungiendo in categoria '+ bs.category + ' Nº: '+ i);
                                
                            }else{
                                 // 1º Giro crea la prima category
                                 resp.data.sintesiAT.put(bs.category,1);
                                System.debug('Prima category'+ bs.category);
                            }
                        }
                    } 

                }
                
                Map<String,Object> logWrapper= new Map<String,Object>{
                    'input'=> myState.get('request'),
                    'output'=> myState.get('response'),
                    'statusCode'=> Integer.valueOf(myState.get('statusCode')),
                    'result' => PED_DebugLoggerFactory.RESULT_OK,
                    'wsName'=> wsName,
                    'wsProcess'=>wsProcess,
                    'endpoint'=>myState.get('endpoint'),
                    'podName'=> myState.get('point_of_delivery') ,
                    'className'=> 'PED_BuchiDiTensioneController',
                    'methodName'=> 'processBuchiDiTensione', 
                    'filterStart'=> myState.get('date_from'),
                    'filterEnd'=> myState.get('date_to'),
                    'delegato'=> Boolean.valueOf(myState.get('fromDelegate'))
                };
                logger.log(logWrapper);
                logger.flush(); 
            }else if(response.getStatusCode() == 401){ // ? ERROR NOT AUTHORIZED
    
                Map<String,Object> logWrapper= new Map<String,Object>{
                    'input'=> myState.get('request'),
                    'output'=> myState.get('response'),
                    'statusCode'=> Integer.valueOf(myState.get('statusCode')),
                    'result' => PED_DebugLoggerFactory.RESULT_KO,
                    'wsName'=> wsName,
                    'wsProcess'=>wsProcess,
                    'endpoint'=>myState.get('endpoint'),
                    'podName'=> myState.get('point_of_delivery') ,
                    'className'=> 'PED_BuchiDiTensioneController',
                    'methodName'=> 'processBuchiDiTensione', 
                    'filterStart'=> myState.get('date_from'),
                    'filterEnd'=> myState.get('date_to'),
                    'delegato'=> Boolean.valueOf(myState.get('fromDelegate')),
                    'e'=> 'Non authorized user'
                };
                logger.log(logWrapper);
                logger.flush(); 
            }
         }catch(Exception e){
            String stackTrace;
            stackTrace = 'Cause: ' + e.getCause() + '\n'
                + 'Line number: ' + e.getLineNumber() + '\n'
                + 'Message: ' + e.getMessage() + '\n'
                + 'Exception type: ' + e.getTypeName() + '\n'
                + '----- Stack Trace -----\n' +
                e.getStackTraceString();

            Map<String,Object> logWrapper= new Map<String,Object>{
                'input'=> myState.get('request'),
                'output'=> myState.get('response'),
                'statusCode'=> Integer.valueOf(myState.get('statusCode')),
                'result' => PED_DebugLoggerFactory.RESULT_KO,
                'wsName'=> wsName,
                'wsProcess'=>wsProcess,
                'endpoint'=>myState.get('endpoint'),
                'podName'=> myState.get('point_of_delivery') ,
                'className'=> 'PED_BuchiDiTensioneController',
                'methodName'=> 'processBuchiDiTensione', 
                'filterStart'=> myState.get('date_from'),
                'filterEnd'=> myState.get('date_to'),
                'delegato'=> Boolean.valueOf(myState.get('fromDelegate')),
                'e'=> e
            };
            logger.log(logWrapper);
            logger.flush();         
            return null;
         }
       
  
   return resp;

    }

    @AuraEnabled 
    public static PED_PODInfoWrapper.Response getDetails(String url){
        System.debug(url);
        if(!url.containsIgnoreCase('delegato'))
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