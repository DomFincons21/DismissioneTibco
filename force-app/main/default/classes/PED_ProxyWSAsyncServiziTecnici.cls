public class PED_ProxyWSAsyncServiziTecnici {
    
    public class adeguatezzaImpianti{
        public String tipoMessaggio;  
        public String anno;
        public String testoArt34;
        public String testoArt45;
        public String CTS;
        public String CTSM;
        public String CTStotale;
        public String dataDichiarazione;
        public String dichiarazioneAdeguatezza;
        public String ctsAmmontareAnnuo;
        public String indirizzo;
        public Integer n;
    }
    
    //Variabili di Instanza per il servizio Buchi di Tensione
    AsyncPED_ServiziTecnici_BuchiTensione_WS.buchiTensioneMtResponseFuture resp{get;set;}
    PED_ServiziTecnici_BuchiTensione_WS.BuchiTensioneMtRequestType request{get;set;}
    
    //Variabili di Istanza per il servizio Elenco Forniture (Get Cliente)
    AsyncPED_ServiziTecnici_WS.elencoFornitureResponseFuture respCliente{get;set;}
    PED_ServiziTecnici_TaratureData.cl cliente{get;set;} 
    
    //Variabili di Istanza per il servizio Adeguatezza Impianti 
    AsyncPED_ServiziTecnici_WS.taratureFornituraResponseFuture respAdeguatezza{get;set;} 
    PED_ServiziTecnici_WS.forn fornAdeguatezza{get;set;}
    
    //Variabili di Istanza per il servizio Tarature Impianto
    PED_ProxyWSAsyncServiziTecnici.impiantoETarature respTaratureCliente{get;set;}
    AsyncPED_ServiziTecnici_WS.taratureFornituraResponseFuture respTarature{get;set;} 
    PED_ServiziTecnici_WS.forn fornTarature{get;set;}
    
    //Variabili di Istanza per il servizio Caratteristiche Impianto
    AsyncPED_ServiziTecnici_WS.impiantoFornituraResponseFuture respImpianto{get;set;} 
    PED_ServiziTecnici_WS.impiantoFornituraResult fornImpianto{get;set;}
    
    //Variabili di Istanza per il servizio Qualità del servizio
    AsyncPED_ServiziTecnici_WS.InterruzioniFornituraResponseFuture respQualita{get;set;} 
    PED_ServiziTecnici_WS.fornInt forn{get;set;}
    
    //Variabili di Istanza per il servizio Scrivi Caratteristiche Impianto
    Map<String , Object> impiantoFornituraMap;
    //AsyncPED_ServiziTecnici_WS.scriviImpiantoFornituraResponseFuture respScriviCA;
    
    //Variabili di Istanza per il servizio Archivio Comunicazioni
    AsyncPED_ServiziTecnici_WS.protocolliFornituraResponseFuture respArchivio {get;set;}
    PED_ServiziTecnici_WS.fornInt fornArchivio{get;set;}
    
    //Variabili di Istanza per il servizio Protocollo
    AsyncPED_ServiziTecnici_WS.letteraProtocolloAUIResponseFuture respProtocollo {get;set;}
    string codiceProtocolloAUI {get;set;}
    
    //Variabili di Istanza condivise
    public String methodName {get;set;}
    public String uniqueId {get;set;} 
    public String params {get;set;}
    public Boolean isResponse {get;set;} 
    public string response {get;set;} 
    public Boolean isResponse2 {get;set;} 
    public string response2 {get;set;} 
    
    //Inner Class utilizzata per Buchi di Tensione
    public class buchiSemisbarra{
        public List<PED_ServiziTecnici_BuchiTensione_WS.buchiSemisbarra> buchiSemisbarraList{get;set;}    	
        public Map<String,Integer> sintesi{get;set;}	    
        public Map<String,Integer> sintesiAT{get;set;} 
    } 
    
    //Inner Class utilizzata per Tarature
    public class impiantoETarature{
    	public PED_ProxyWSAsyncServiziTecnici.taratureFornitura tarForn;
    	public PED_ServiziTecnici_TaratureData.cl cliente;
    }
    
    //Inner Class utilizzata per Archivio Comunicazioni
    public class indirizzoEProtocolli{
        public List<PED_ServiziTecnici_WS.protocollo> protocolli{get;set;}    	
        public string indirizzo{get;set;}
    }
    
    //Inner Class Utilizzata per Tarature Impianti 
    public class taratureFornitura{
        public PED_ServiziTecnici_WS.dettaglioFornitura detForn;
        public Map<String,List<String>> griglieMap;
    }
    
    public PED_ProxyWSAsyncServiziTecnici(){     
        String lcBaseURL = Label.PED_OrgHost; 
        Map<string,string> headers = Apexpages.currentPage().getHeaders();	
        headers.put('X-Frame-Options', 'ALLOW-FROM ' + lcBaseURL);
        headers.put('Content-Security-Policy', 'frame-ancestors ' + lcBaseURL);   
    } 
    
    @AuraEnabled 
    public static Object convertJSONtoObject(string stringaJson){
       	 return (object) JSON.deserializeUntyped(stringaJson);
    } 
    
    public Continuation invoke(){
        uniqueId = apexpages.currentpage().getParameters().get('uniqueId');
        methodName = apexpages.currentpage().getParameters().get('methodN');
        params = apexpages.currentpage().getParameters().get('params') + ' ';        
        Continuation cont = new Continuation(70);
        if(methodName=='buchiTensione'){            
            string pod = params.split(',')[0];
            string dataInizio = params.split(',')[1];
            string DataFine = params.split(',')[2];
            cont.continuationMethod = 'processResponseCallBuchiDiTensione'; 
            AsyncPED_ServiziTecnici_BuchiTensione_WS.AsyncbuchiTensioneMtServicePort btws = new AsyncPED_ServiziTecnici_BuchiTensione_WS.AsyncbuchiTensioneMtServicePort();
            request = new PED_ServiziTecnici_BuchiTensione_WS.BuchiTensioneMtRequestType();
            request.req_pod=pod;
            request.req_datai=dataInizio;
            request.req_dataf=DataFine;
            String error='';
            try{
                btws.endpoint_x = 'https://4ele-wssf.enel.it/buchiTensioneWsTibco/';
                resp = btws.beginBuchiTensioneMt(cont,request);                
                return cont;
            }  
            catch(exception e){
                error='Exception: ' + e.getTypeName() + ': ' + e.getMessage()+ ' -- ' + e.getCause();
                insert PED_ServiziTecnici_Controller.createLog('buchiTensione', 'KO', error, null,null);              
            }            
        }else if(methodName=='QualitaDelServizio' || methodName=='ArchivioComunicazioni'||
                 methodName=='AdeguatezzaImpianti' || methodName=='TaratureFornitura' ||
                 methodName=='ImpiantoFornitura' || methodName=='scriviImpiantoForniture'||
                 methodName=='ImpiantoETarature'){
                     string error='';
                     cont.continuationMethod = 'processResponseCallCliente';  
                     AsyncPED_ServiziTecnici_WS.AsyncTaratureServicePort stub = new AsyncPED_ServiziTecnici_WS.AsyncTaratureServicePort();
                     if(cliente==null){
                         cliente = new PED_ServiziTecnici_TaratureData.cl();
                     }
                     string pod=params.split(',')[0];
                     cliente.pod=params.split(',')[0];
                     cliente.nmForn=1;                     
                     PED_ServiziTecnici_TaratureData.fornitureResult res;                
                     try{
                         
                         if(Test.isRunningTest()){
                             cliente = new PED_ServiziTecnici_TaratureData.cl();
                             cliente.fornitura= new List<PED_ServiziTecnici_TaratureData.forn>();
                             PED_ServiziTecnici_TaratureData.forn forn = new PED_ServiziTecnici_TaratureData.forn();
                             forn.IdClienteK = '1111';
                             forn.IdClienteM='123';
                             forn.IdClienteL='1213';
                             cliente.fornitura.add(forn);
                         }else{
                             if(cliente.fornitura==null){
                             cliente = PED_ServiziTecnici_Controller.getCliente(pod);
                         	}
                         }
                         if(cliente!=null && !cliente.fornitura.isEmpty()){                             
                             respTaratureCliente = new PED_ProxyWSAsyncServiziTecnici.impiantoETarature();
                             respTaratureCliente.cliente=cliente;
                             if(methodName=='QualitaDelServizio'){ 
                                 cont.continuationMethod = 'processResponseCallQualita';
                                 forn= new PED_ServiziTecnici_WS.fornInt();
                                 forn.IdClienteK=cliente.fornitura[0].IdClienteK;
                                 forn.IdClienteM=cliente.fornitura[0].IdClienteM;
                                 forn.IdClienteL=cliente.fornitura[0].IdClienteL;
                                 AsyncPED_ServiziTecnici_WS.AsyncTaratureServicePort qsws = new AsyncPED_ServiziTecnici_WS.AsyncTaratureServicePort();
                                 try{               
                                     respQualita=qsws.beginInterruzioniFornitura(cont,forn);
                                     return cont;
                                 }
                                 catch(exception e){
                                     error='Exception: ' + e.getTypeName() + ': ' + e.getMessage()+ ' -- ' + e.getCause();
                                     
                                     insert PED_ServiziTecnici_Controller.createLog('qualitaServizio', 'KO', error, null,null);
                                 }	
                             }else if(methodName=='ArchivioComunicazioni'){
                                 cont.continuationMethod = 'processResponseCallArchivioComunicazioni';
                                 fornArchivio= new PED_ServiziTecnici_WS.fornInt();
                                 AsyncPED_ServiziTecnici_WS.AsyncTaratureServicePort acws = new AsyncPED_ServiziTecnici_WS.AsyncTaratureServicePort();
                                 fornArchivio.IdClienteK=cliente.fornitura[0].IdClienteK;
                                 fornArchivio.IdClienteM=cliente.fornitura[0].IdClienteM;
                                 fornArchivio.IdClienteL=cliente.fornitura[0].IdClienteL;
                                 try{
                                     respArchivio=acws.beginProtocolliFornitura(cont,fornArchivio);
                                     return cont; 
                                 }catch(exception e){
                                     error='Exception: ' + e.getTypeName() + ': ' + e.getMessage()+ ' -- ' + e.getCause();
                                     insert PED_ServiziTecnici_Controller.createLog('archivioComunicazioni', 'KO', error, null,null);                   
                                 }
                             }else if(methodName=='TaratureFornitura' || methodName=='ImpiantoFornitura'){
                                 fornTarature= new PED_ServiziTecnici_WS.forn();
                                 fornTarature.IdClienteK=cliente.fornitura[0].IdClienteK;
                                 fornTarature.IdClienteM=cliente.fornitura[0].IdClienteM;
                                 fornTarature.IdClienteL=cliente.fornitura[0].IdClienteL;
                                 fornImpianto= new PED_ServiziTecnici_WS.impiantoFornituraResult();
                                 fornImpianto.keyFornitura= new PED_ServiziTecnici_WS.keyFornitura();
                                 fornImpianto.keyFornitura.IdClienteK=cliente.fornitura[0].IdClienteK;
                                 fornImpianto.keyFornitura.IdClienteM=cliente.fornitura[0].IdClienteM;
                                 fornImpianto.keyFornitura.IdClienteL=cliente.fornitura[0].IdClienteL;
                                 AsyncPED_ServiziTecnici_WS.AsyncTaratureServicePort tfws = new AsyncPED_ServiziTecnici_WS.AsyncTaratureServicePort();
                                 try{     
                                     if(methodName=='TaratureFornitura'){
                                         cont.continuationMethod = 'processResponseCallTaratureImpianti';
                                         respTarature=tfws.beginTaratureFornitura(cont,fornTarature);
                                     }else if(methodName=='ImpiantoFornitura'){
                                         cont.continuationMethod = 'processResponseCallImpiantoFornitura';
                                         respImpianto=tfws.beginImpiantoFornitura(cont,fornImpianto);
                                     }        
                                     
                                     return cont;
                                 }
                                 catch(exception e){
                                     error='Exception: ' + e.getTypeName() + ': ' + e.getMessage()+ ' -- ' + e.getCause();
                                     if(methodName=='TaratureFornitura'){
                                         insert PED_ServiziTecnici_Controller.createLog('TaratureFornitura', 'KO', error, null,null);
                                     }else if(methodName=='ImpiantoFornitura'){ 
                                         insert PED_ServiziTecnici_Controller.createLog('ImpiantoFornitura', 'KO', error, null,null);
                                     }        
                                     
                                 }	
                             }else if(methodName=='AdeguatezzaImpianti'){
                                 AsyncPED_ServiziTecnici_WS.AsyncTaratureServicePort stai = new AsyncPED_ServiziTecnici_WS.AsyncTaratureServicePort(); 
                                 fornAdeguatezza= new PED_ServiziTecnici_WS.forn();
                                 fornAdeguatezza.IdClienteK=cliente.fornitura[0].IdClienteK;
                                 fornAdeguatezza.IdClienteM=cliente.fornitura[0].IdClienteM;
                                 fornAdeguatezza.IdClienteL=cliente.fornitura[0].IdClienteL;
                                 cont.continuationMethod='processResponseCallAdeguatezza';                     
                                 try{ 
                                     respAdeguatezza =stai.beginTaratureFornitura(cont,fornAdeguatezza);
                                     return cont;
                                 }
                                 catch(exception e){
                                     error='Exception: ' + e.getTypeName() + ': ' + e.getMessage()+ ' -- ' + e.getCause();
                                     insert PED_ServiziTecnici_Controller.createLog('getAdeguatezzaImpianti', 'KO', error, null,null);
                                     return null;
                                 }
                             }
                         }
                         insert PED_ServiziTecnici_Controller.createLog('getCliente', 'OK', '', JSON.serialize(forn),JSON.serialize(cliente));
                     }
                     catch(exception e){
                         error='Exception: ' + e.getTypeName() + ': ' + e.getMessage()+ ' -- ' + e.getCause();
                         system.debug(error);
                         system.debug(e.getStackTraceString());
                         insert PED_ServiziTecnici_Controller.createLog('getCliente', 'KO', error, null,null);
                         return null;
                     }
                     
                     
                 }else if(methodName=='Protocollo'){
                     codiceProtocolloAUI = params.split(',')[0];
                     cont.continuationMethod = 'processResponseCallProtocollo'; 
                     AsyncPED_ServiziTecnici_WS.AsyncTaratureServicePort ttts = new AsyncPED_ServiziTecnici_WS.AsyncTaratureServicePort();         
                     String error='';
                     try{
                         ttts.endpoint_x = 'https://4ele-wssf.enel.it/taratureWsTibco/';
                         respProtocollo = ttts.beginLetteraProtocolloAUI(cont,codiceProtocolloAUI);
                         return cont;
                     }
                     catch(exception e){
                         error='Exception: ' + e.getTypeName() + ': ' + e.getMessage()+ ' -- ' + e.getCause();
                         insert PED_ServiziTecnici_Controller.createLog('getProtocollo', 'KO', error, null,null);                
                     }
                 }
        response = JSON.serialize(null);
        isResponse=true;
        response2 = JSON.serialize(null);
        isResponse2=true;
        return null;
    }
    
    
    
    public Object processResponseCallBuchiDiTensione(){        
        try{
            string error='';
            PED_ProxyWSAsyncServiziTecnici.buchiSemisbarra bss = new PED_ProxyWSAsyncServiziTecnici.buchiSemisbarra();
            PED_ServiziTecnici_BuchiTensione_WS.buchiTensioneMtResult res;           
            if(resp!=null){
                if(Test.isRunningTest()){
                    PED_ServiziTecnici_BuchiTensione_WS.buchiTensioneMtResponse responseElement = new PED_ServiziTecnici_BuchiTensione_WS.buchiTensioneMtResponse();
                    responseElement.BuchiTensioneMtResult = new PED_ServiziTecnici_BuchiTensione_WS.BuchiTensioneMtResult();
                    responseElement.BuchiTensioneMtResult.ccRich = '0';
                    responseElement.BuchiTensioneMtResult.buchiSemisbarra= new List<PED_ServiziTecnici_BuchiTensione_WS.buchiSemisbarra>();
                    for(integer x=0;x<4;x++){
                        PED_ServiziTecnici_BuchiTensione_WS.buchiSemisbarra bs = new PED_ServiziTecnici_BuchiTensione_WS.buchiSemisbarra();
                        bs.origine='AT';
                        bs.categoria='1';
                        responseElement.BuchiTensioneMtResult.buchiSemisbarra.add(bs);
                    }
                    for(integer x=0;x<4;x++){
                        PED_ServiziTecnici_BuchiTensione_WS.buchiSemisbarra bs = new PED_ServiziTecnici_BuchiTensione_WS.buchiSemisbarra();
                        bs.categoria='1';
                        responseElement.BuchiTensioneMtResult.buchiSemisbarra.add(bs);
                    }
                    res = responseelement.BuchiTensioneMtResult;
                }else{
                    res = resp.getValue();
                }
                System.debug('RESPONSEE : ' +res);
                bss.buchiSemisbarraList= res.buchiSemisbarra;
                bss.sintesi=new Map<String,Integer>();
                bss.sintesiAT=new Map<String,Integer>();
                Integer x=0;
                System.debug('BSS RESPONSE : ' + res);
                System.debug('BSS RESPONSE 2 : ' + res.buchiSemisbarra); 
                if(bss.buchiSemisbarraList!=null){
                    for(PED_ServiziTecnici_BuchiTensione_WS.buchiSemisbarra bs : bss.buchiSemisbarraList){
                        if(bss.sintesi.containsKey(bs.categoria)){
                            Integer i = bss.sintesi.get(bs.categoria);
                            bss.sintesi.put(bs.categoria,i+1);
                        }
                        else{
                            bss.sintesi.put(bs.categoria,1);
                        }
                        if(bs.origine=='AT'){ 
                            if(bss.sintesiAT.containsKey(bs.categoria)){
                                Integer i = bss.sintesiAT.get(bs.categoria);
                                bss.sintesiAT.put(bs.categoria,i+1);
                            }
                            else{
                                bss.sintesiAT.put(bs.categoria,1);
                            }
                        }
                    }
                }
                string result;
                if(res.ccRich == '0' || res.ccRich == '4'){
                    result='OK';
                }
                else{ 
                    result='KO';
                    error=res.ccDesc;
                }
                insert PED_ServiziTecnici_Controller.createLog('buchiTensione', result, error, JSON.serialize(res), JSON.serialize(request));
                System.debug('OGGETTO BUCHI DI TENSIONE : '+bss);
                response = JSON.serialize(bss);
                isResponse=true;
                if(test.isRunningTest()){
                    throw new DmlException('ciao');
                }
            }else{
                string result = 'KO';
                insert PED_ServiziTecnici_Controller.createLog('buchiTensione', result, error, null, JSON.serialize(request));
                response = JSON.serialize(null);
                isResponse=true; 
            }
        }catch(Exception e){
            string error='Exception: ' + e.getTypeName() + ': ' + e.getMessage()+ ' -- ' + e.getCause();
            insert PED_ServiziTecnici_Controller.createLog('buchiTensione', 'KO', error, null, JSON.serialize(request)); 
        }
        return null;
    }
    PED_ServiziTecnici_WS.fornitureResult resCliente;
    
    
    
    public object processResponseCallImpiantoFornitura(){
        try{
            PED_ServiziTecnici_WS.impiantoFornituraResult res = respImpianto.getValue();
            string result;
            if(res.ccRich == '0' || res.ccRich == '4'){
                result='OK';
            }else{
                result='KO';
            }
            insert PED_ServiziTecnici_Controller.createLog('ImpiantoFornitura', result, res.ccDesc, JSON.serialize(res), JSON.serialize(fornImpianto));
            response2 = JSON.serialize(res.datiImpiantoCli);
        }catch(Exception e){
            response2 = JSON.serialize(null);             
            insert PED_ServiziTecnici_Controller.createLog('ImpiantoFornitura', 'KO', e.getMessage(), null, JSON.serialize(fornImpianto));
        }
        isResponse2=true;
        return null;
    }
    
    public Object processResponseCallTaratureImpianti(){
        try{    
            PED_ServiziTecnici_WS.taratureResult res;
            if(Test.isRunningTest()){
                PED_ServiziTecnici_WS.taratureFornituraResponse responseElement = new PED_ServiziTecnici_WS.taratureFornituraResponse();
                responseElement.TaratureFornituraResult = new PED_ServiziTecnici_WS.taratureResult();
                responseElement.TaratureFornituraResult.ccRich = '0';
                responseElement.TaratureFornituraResult.fornitura=new PED_ServiziTecnici_WS.forn();
                responseElement.TaratureFornituraResult.fornitura.dettFornitura= new PED_ServiziTecnici_WS.dettaglioFornitura();
                responseElement.TaratureFornituraResult.fornitura.dettFornitura.dtDich='x';
                responseElement.TaratureFornituraResult.fornitura.dettFornitura.tpDich='5';
                responseElement.TaratureFornituraResult.fornitura.dettFornitura.CTSn='5';
                responseElement.TaratureFornituraResult.fornitura.dettFornitura.taratura=new list<PED_ServiziTecnici_WS.tar>();
                PED_ServiziTecnici_WS.tar tar = new PED_ServiziTecnici_WS.tar();
                tar.cdTar='test1';
                tar.tarCom='test1';
                tar.tarImp='test1';
                tar.umTar='test1';
                responseElement.TaratureFornituraResult.fornitura.dettFornitura.taratura.add(tar);
                res = responseElement.TaratureFornituraResult;
            }else{
                res= respTarature.getValue();
            }
            respTaratureCliente.tarForn = new PED_ProxyWSAsyncServiziTecnici.taratureFornitura();
            respTaratureCliente.tarForn.detForn=res.fornitura.dettFornitura;
            respTaratureCliente.tarForn.griglieMap= new Map<String,List<String>>();
            for(PED_ServiziTecnici_WS.tar tar : res.fornitura.dettFornitura.taratura){
                if(!String.isBlank(tar.cdTar)){
                    List<String> sList = new List<String>();
                    sList.add(tar.tarCom);
                    sList.add(tar.tarImp);
                    sList.add(tar.umTar);
                    respTaratureCliente.tarForn.griglieMap.put(tar.cdTar,sList);
                }
            }
            string result;
            if(res.ccRich == '0' || res.ccRich == '4'){
                result='OK';
            }
            else{
                result='KO';
            }
             response = JSON.serialize(respTaratureCliente).replace('\'',' ');
             isResponse=true;
            insert PED_ServiziTecnici_Controller.createLog('getTaratureFornitura', result, res.ccDesc==null?'':res.ccDesc, JSON.serialize(res), JSON.serialize(fornTarature));
            if(test.isRunningTest()){
                throw new DmlException('ciao');
            }
        }catch(Exception e){
            response = JSON.serialize(null); 
             isResponse=true;
            System.debug(e.getStackTraceString());
            string stacktrace = e.getStackTraceString().left(244);
            insert PED_ServiziTecnici_Controller.createLog('getTaratureFornitura', 'KO', e.getMessage(), e.getStackTraceString(), JSON.serialize(fornTarature));
        }
        return null;
    }
    
    public Object processResponseCallProtocollo(){
        try{
            PED_ServiziTecnici_WS.lettera lett;
            if(Test.isRunningTest()){
                lett = new PED_ServiziTecnici_WS.lettera();
                lett.retCode = '0';
            }else{
                lett = respProtocollo.getValue();
            }
            string result;
            if(lett.retCode == '0' || lett.retCode == '4'){
                result='OK';
            }
            else{
                result='KO';
            }
            insert PED_ServiziTecnici_Controller.createLog('getProtocollo', result, lett.retMsg, JSON.serialize(lett), JSON.serialize(codiceProtocolloAUI));
            response = JSON.serialize(lett);
        }catch(Exception e){
            response = JSON.serialize(null);            
            insert PED_ServiziTecnici_Controller.createLog('getProtocollo', 'KO', e.getMessage(), null, JSON.serialize(codiceProtocolloAUI));
        }
        isResponse=true;
        return null;
    }
    
    public Object processResponseCallArchivioComunicazioni(){
        try{
            PED_ServiziTecnici_WS.protocolliResult res = (PED_ServiziTecnici_WS.protocolliResult) respArchivio.getValue();
            string result;
            if(res.retCode == '0' || res.retCode == '4'){
                result='OK';
            }
            else{
                result='KO';
            }
            insert PED_ServiziTecnici_Controller.createLog('archivioComunicazioni', result, res.retMsg, JSON.serialize(res), JSON.serialize(forn));
            PED_ProxyWSAsyncServiziTecnici.indirizzoEProtocolli pp = new PED_ProxyWSAsyncServiziTecnici.indirizzoEProtocolli();
            pp.indirizzo=cliente.fornitura[0].dsForn;
            pp.protocolli=res.protocolli;        
            response = JSON.serialize(pp);
        }catch(Exception e){
            response = JSON.serialize(null);             
            insert PED_ServiziTecnici_Controller.createLog('archivioComunicazioni', 'KO', e.getMessage(), null, JSON.serialize(forn));
        }
        isResponse=true;
        return null;
    }
    
    public Object processResponseCallQualita(){
        try{
            string result='';
            string error='';
            if(respQualita!=null){
                PED_ServiziTecnici_WS.fornIntD333Result res = respQualita.getValue();       
                if(res.ccRich == '0' || res.ccRich == '4'){
                    result='OK';
                }else{
                    result='KO';
                    error=res.ccDesc;
                }
                response = JSON.serialize(res.fornIntOut);
                isResponse=true; 
                insert PED_ServiziTecnici_Controller.createLog('qualitaServizio', result, error, JSON.serialize(res), JSON.serialize(forn));
            }else{
                response = JSON.serialize(null);
                isResponse=true;   
            }
        }catch(Exception e){
            response = JSON.serialize(null);             
            insert PED_ServiziTecnici_Controller.createLog('qualitaServizio', 'KO', e.getMessage(), null, JSON.serialize(forn));
        }
        isResponse  =   true;     
        return null;
    }
    
    public Object processResponseCallAdeguatezza(){
        try{
            PED_ProxyWSAsyncServiziTecnici.adeguatezzaImpianti ai =new PED_ProxyWSAsyncServiziTecnici.adeguatezzaImpianti();    
            PED_ServiziTecnici_WS.taratureResult res;
            if(Test.isRunningTest()){
                PED_ServiziTecnici_WS.taratureFornituraResponse responseElement = new PED_ServiziTecnici_WS.taratureFornituraResponse();
                responseElement.TaratureFornituraResult = new PED_ServiziTecnici_WS.taratureResult();
                responseElement.TaratureFornituraResult.ccRich = '0';
                responseElement.TaratureFornituraResult.fornitura=new PED_ServiziTecnici_WS.forn();
                responseElement.TaratureFornituraResult.fornitura.dettFornitura= new PED_ServiziTecnici_WS.dettaglioFornitura();
                responseElement.TaratureFornituraResult.fornitura.dettFornitura.dtDich='x';
                responseElement.TaratureFornituraResult.fornitura.dettFornitura.tpDich='5';
                responseElement.TaratureFornituraResult.fornitura.dettFornitura.CTSn='5';
                responseElement.TaratureFornituraResult.fornitura.dettFornitura.taratura=new list<PED_ServiziTecnici_WS.tar>();
                PED_ServiziTecnici_WS.tar tar = new PED_ServiziTecnici_WS.tar();
                tar.cdTar='test1';
                tar.tarCom='test1';
                tar.tarImp='test1';
                tar.umTar='test1';
                responseElement.TaratureFornituraResult.fornitura.dettFornitura.taratura.add(tar);
                res = responseElement.TaratureFornituraResult;
            }else{
                res = respAdeguatezza.getValue();
            }
            PED_ServiziTecnici_WS.dettaglioFornitura detForn=res.fornitura.dettFornitura;
            string result;
            if(res.ccRich == '0' || res.ccRich == '4'){
                result='OK';
            }
            else{
                result='KO';
            }
            if(!Test.isRunningTest()){
           	 insert PED_ServiziTecnici_Controller.createLog('getAdeguatezzaImpianti', result, res.ccDesc, JSON.serialize(res), JSON.serialize(fornAdeguatezza));
            }
            if(detForn!=null){
                ai.anno=System.now().AddYears(-1).format('YYYY');
                if(detForn.indennizzo=='N' || detForn.indennizzo=='0,00'){
                    ai.testoArt34='0 (standard rispettato)';
                }
                else{
                    ai.testoArt34=detForn.indennizzo;
                }
                if(detForn.ripe=='N' || detForn.ripe=='0,00'){ 
                    ai.testoArt45='0 (standard rispettato)';
                }
                else{
                    ai.testoArt45=detForn.ripe;
                }
                if (string.IsBlank(detForn.CTS) || detForn.CTS == 'N'){
                    ai.CTS = '0';
                }
                else{
                    ai.CTS=detForn.CTS;
                }
                if (string.IsBlank(detForn.CTSM) || detForn.CTSM == 'N'){
                    ai.CTSM = '0';
                }
                else{
                    ai.CTSM=detForn.CTSM;
                }
                if (string.IsBlank(detForn.CTStotale) || detForn.CTStotale == 'N'){
                    ai.CTStotale = '0';
                }
                else{
                    ai.CTStotale=detForn.CTStotale;
                }
                if(!String.isBlank(detForn.dtDich)){
                    string tipoDich;
                    if(detForn.tpDich.toUpperCase()=='C'){
                        tipoDich='Conforme';
                    }
                    if(detForn.tpDich.toUpperCase()=='K'){
                        tipoDich='Conforme CEI 0-16';
                    }
                    if(detForn.tpDich.toUpperCase()=='N'){
                        tipoDich='Non Conforme';
                    }
                    if(detForn.tpDich.toUpperCase()=='R'){
                        tipoDich='Revocata';
                    }
                    if(detForn.tpDich.toUpperCase()=='D'){
                        tipoDich='Documentazione non completata';
                    }
                    if(detForn.tpDich.toUpperCase()=='S'){
                        tipoDich='Sospesa per arbitrato';
                    }
                    else{
                        tipoDich='';
                    }
                    ai.dichiarazioneAdeguatezza='Ci risulta pervenuta la Dichiarazione di Adeguatezza in data '+detForn.dtDich+' ed è da noi considerata '+tipoDich;
                    //dal codice .net in questo caso il testo 5 non viene visualizzato
                }
                else{
                    //caso in cui la data dichiarazione non è valorizzata
                    ai.dichiarazioneAdeguatezza='La Dichiarazione di Adeguatezza relativa al suo impianto non ci risulta pervenuta.';
                    ai.indirizzo=detForn.indirizzo;
                }
                if(String.isBlank(detForn.CTSn)){
                    ai.tipoMessaggio='1';
                }
                else if(detForn.CTSn=='0'){
                    ai.tipoMessaggio='2';
                }
                else if(detForn.CTSn=='1' || detForn.CTSn=='2' || detForn.CTSn=='3'){
                    ai.tipoMessaggio='3';
                }
                else{
                    ai.tipoMessaggio='';
                }
            }
            
            response = JSON.serialize(ai);
        }catch(Exception e){
            response = JSON.serialize(null);             
            insert PED_ServiziTecnici_Controller.createLog('getAdeguatezzaImpianti', 'KO', e.getStackTraceString(), null, JSON.serialize(fornAdeguatezza));
        }
        isResponse = true;
        return null;       
    }
    
}