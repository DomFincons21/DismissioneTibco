public class PED_ServiziTecnici_Controller {
    
    public class adeguatezzaImpianti{
        @AuraEnabled
        public String tipoMessaggio;
        
        @AuraEnabled
        public String anno;
        
        @AuraEnabled
        public String testoArt34;
        
        @AuraEnabled
        public String testoArt45;
        
        @AuraEnabled
        public String CTS;
        
        @AuraEnabled
        public String CTSM;
        
        @AuraEnabled
        public String CTStotale;
        
        @AuraEnabled
        public String dataDichiarazione;
        
        @AuraEnabled
        public String dichiarazioneAdeguatezza;
        
        @AuraEnabled
        public String ctsAmmontareAnnuo;
        
        @AuraEnabled
        public String indirizzo;
        
        @AuraEnabled
        public Integer n;
    }
    
    public class impiantoETarature{
        @AuraEnabled
        public PED_ServiziTecnici_Controller.taratureFornitura tarForn;
        
        @AuraEnabled
        public PED_ServiziTecnici_TaratureData.datiImpiantoCli impianto;
        
        @AuraEnabled
        public PED_ServiziTecnici_TaratureData.cl cliente;
    }
    public class taratureFornitura{
        @AuraEnabled
        public PED_ServiziTecnici_TaratureData.dettaglioFornitura detForn;
        
        @AuraEnabled
        public Map<String,List<String>> griglieMap;
    }
    
    public class buchiSemisbarra{
        //mikel c'è
        @AuraEnabled
        public List<PED_ServiziTecnici_BuchiTensioneDT.buchiSemisbarra> buchiSemisbarraList{get;set;}
        
        @AuraEnabled
        public Map<String,Integer> sintesi{get;set;}
        
        @AuraEnabled
        public Map<String,Integer> sintesiAT{get;set;} 
    } 
    
    public class indirizzoEProtocolli{
        @AuraEnabled
        public List<PED_ServiziTecnici_TaratureData.protocollo> protocolli{get;set;}
        
        @AuraEnabled
        public string indirizzo{get;set;}
    }
    
  /*   @AuraEnabled
    public static buchiSemisbarra buchiTension(String pod, String dataInizio, String DataFine){
        PED_ServiziTecnici_Controller.buchiSemisbarra bss = new PED_ServiziTecnici_Controller.buchiSemisbarra();
        PED_ServiziTecnici_BuchiTensione.BuchiTensioneWsTibcoSOAP btws = new PED_ServiziTecnici_BuchiTensione.BuchiTensioneWsTibcoSOAP();
        PED_ServiziTecnici_BuchiTensioneDT.BuchiTensioneMtRequestType request = new PED_ServiziTecnici_BuchiTensioneDT.BuchiTensioneMtRequestType();
        request.req_pod=pod;
        request.req_datai=dataInizio;
        request.req_dataf=DataFine;
        PED_ServiziTecnici_BuchiTensioneDT.buchiTensioneMtResult res;
        String error='';
        try{
            res = btws.buchiTensioneMt(request);
        } 
        catch(exception e){
            error='Exception: ' + e.getTypeName() + ': ' + e.getMessage()+ ' -- ' + e.getCause();
            insert PED_ServiziTecnici_Controller.createLog('buchiTensione', 'KO', error, null,null);
            return null;
        }
        bss.buchiSemisbarraList=res.buchiSemisbarra;
        bss.sintesi=new Map<String,Integer>();
        bss.sintesiAT=new Map<String,Integer>();
        Integer x=0;
        for(PED_ServiziTecnici_BuchiTensioneDT.buchiSemisbarra bs : res.buchiSemisbarra){
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
        string result;
        if(res.ccRich == '0' || res.ccRich == '4'){
            result='OK';
        }
        else{
            result='KO';
            error=res.ccDesc;
        }
        insert PED_ServiziTecnici_Controller.createLog('buchiTensione', result, error, JSON.serialize(res), JSON.serialize(request));
        return bss;
    } */
    
    @AuraEnabled
    public static PED_ServiziTecnici_TaratureData.fornIntD333 qualitaServizio(String pod){
        PED_ServiziTecnici_Tarature.TaratureWsTibcoSOAP ttts = new PED_ServiziTecnici_Tarature.TaratureWsTibcoSOAP();
        PED_ServiziTecnici_TaratureData.cl cliente = PED_ServiziTecnici_Controller.getCliente(pod);
        if(cliente!=null && !cliente.fornitura.isEmpty()){
            PED_ServiziTecnici_TaratureData.fornInt forn= new PED_ServiziTecnici_TaratureData.fornInt();
            forn.IdClienteK=cliente.fornitura[0].IdClienteK;
            forn.IdClienteM=cliente.fornitura[0].IdClienteM;
            forn.IdClienteL=cliente.fornitura[0].IdClienteL;
            PED_ServiziTecnici_TaratureData.fornIntD333Result res;
            String error='';
            try{
                res=ttts.InterruzioniFornitura(forn);
            }
            catch(exception e){
                error='Exception: ' + e.getTypeName() + ': ' + e.getMessage()+ ' -- ' + e.getCause();
                insert PED_ServiziTecnici_Controller.createLog('buchiTensione', 'KO', error, null,null);
                return null;
            }
            string result;
            if(res.ccRich == '0' || res.ccRich == '4'){
                result='OK';
            }
            else{
                result='KO';
                error=res.ccDesc;
            }
            insert PED_ServiziTecnici_Controller.createLog('qualitaServizio', result, error, JSON.serialize(res), JSON.serialize(forn));
            return res.fornIntOut;
        }
        return null;
    }
    
    
    @AuraEnabled
    public static indirizzoEProtocolli archivioComunicazioni(String pod){
        PED_ServiziTecnici_Tarature.TaratureWsTibcoSOAP ttts = new PED_ServiziTecnici_Tarature.TaratureWsTibcoSOAP();
        PED_ServiziTecnici_TaratureData.cl cliente = PED_ServiziTecnici_Controller.getCliente(pod);
        if(cliente!=null && !cliente.fornitura.isEmpty()){
            PED_ServiziTecnici_TaratureData.fornInt forn= new PED_ServiziTecnici_TaratureData.fornInt();
            forn.IdClienteK=cliente.fornitura[0].IdClienteK;
            forn.IdClienteM=cliente.fornitura[0].IdClienteM;
            forn.IdClienteL=cliente.fornitura[0].IdClienteL;
            PED_ServiziTecnici_TaratureData.protocolliResult res;
            String error='';
            try{
                res=ttts.protocolliFornitura(forn);
            }
            catch(exception e){
                error='Exception: ' + e.getTypeName() + ': ' + e.getMessage()+ ' -- ' + e.getCause();
                insert PED_ServiziTecnici_Controller.createLog('archivioComunicazioni', 'KO', error, null,null);
                return null;
            }
            string result;
            if(res.retCode == '0' || res.retCode == '4'){
                result='OK';
            }
            else{
                result='KO';
            }
            insert PED_ServiziTecnici_Controller.createLog('archivioComunicazioni', result, res.retMsg, JSON.serialize(res), JSON.serialize(forn));
            PED_ServiziTecnici_Controller.indirizzoEProtocolli pp = new PED_ServiziTecnici_Controller.indirizzoEProtocolli();
            pp.indirizzo=cliente.fornitura[0].dsForn;
            pp.protocolli=res.protocolli;
            return pp;
        }
        return null;
    }
    
    
    @AuraEnabled
    public static PED_ServiziTecnici_TaratureData.lettera getProtocollo(String codiceProtocolloAUI){
        PED_ServiziTecnici_Tarature.TaratureWsTibcoSOAP ttts = new PED_ServiziTecnici_Tarature.TaratureWsTibcoSOAP();
        PED_ServiziTecnici_TaratureData.lettera lett;
        String error='';
        try{
            lett = ttts.letteraProtocolloAUI(codiceProtocolloAUI);
        }
        catch(exception e){
            error='Exception: ' + e.getTypeName() + ': ' + e.getMessage()+ ' -- ' + e.getCause();
            insert PED_ServiziTecnici_Controller.createLog('getProtocollo', 'KO', error, null,null);
            return null;
        }
        string result;
        if(lett.retCode == '0' || lett.retCode == '4'){
            result='OK';
        }
        else{
            result='KO';
        }
        insert PED_ServiziTecnici_Controller.createLog('getProtocollo', result, lett.retMsg, JSON.serialize(lett), JSON.serialize(codiceProtocolloAUI));
        return lett;
    }
    
    @AuraEnabled
    public static adeguatezzaImpianti getAdeguatezzaImpianti(String pod){
        PED_ServiziTecnici_Controller.adeguatezzaImpianti ai =new PED_ServiziTecnici_Controller.adeguatezzaImpianti();
        PED_ServiziTecnici_Tarature.TaratureWsTibcoSOAP ttts = new PED_ServiziTecnici_Tarature.TaratureWsTibcoSOAP();
        PED_ServiziTecnici_TaratureData.cl cliente = PED_ServiziTecnici_Controller.getCliente(pod);
        if(cliente!=null && !cliente.fornitura.isEmpty()){
            PED_ServiziTecnici_TaratureData.forn forn= new PED_ServiziTecnici_TaratureData.forn();
            forn.IdClienteK=cliente.fornitura[0].IdClienteK;
            forn.IdClienteM=cliente.fornitura[0].IdClienteM;
            forn.IdClienteL=cliente.fornitura[0].IdClienteL;
            PED_ServiziTecnici_TaratureData.taratureResult res;
            String error='';
            try{
                res =ttts.taratureFornitura(forn);
            }
            catch(exception e){
                error='Exception: ' + e.getTypeName() + ': ' + e.getMessage()+ ' -- ' + e.getCause();
                insert PED_ServiziTecnici_Controller.createLog('getAdeguatezzaImpianti', 'KO', error, null,null);
                return null;
            }
            PED_ServiziTecnici_TaratureData.dettaglioFornitura detForn=res.fornitura.dettFornitura;
            string result;
            if(res.ccRich == '0' || res.ccRich == '4'){
                result='OK';
            }
            else{
                result='KO';
            }
            insert PED_ServiziTecnici_Controller.createLog('getAdeguatezzaImpianti', result, res.ccDesc, JSON.serialize(res), JSON.serialize(forn));
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
            return ai;
        }
        return null;
    }
    
    @AuraEnabled
    public static taratureFornitura getTaratureFornitura(String pod){
        PED_ServiziTecnici_Tarature.TaratureWsTibcoSOAP ttts = new PED_ServiziTecnici_Tarature.TaratureWsTibcoSOAP();
        PED_ServiziTecnici_TaratureData.cl cliente = PED_ServiziTecnici_Controller.getCliente(pod);
        if(cliente!=null && !cliente.fornitura.isEmpty()){
            PED_ServiziTecnici_TaratureData.forn forn= new PED_ServiziTecnici_TaratureData.forn();
            forn.IdClienteK=cliente.fornitura[0].IdClienteK;
            forn.IdClienteM=cliente.fornitura[0].IdClienteM;
            forn.IdClienteL=cliente.fornitura[0].IdClienteL;
            PED_ServiziTecnici_TaratureData.taratureResult res;
            String error='';
            try{
                res =ttts.taratureFornitura(forn);
            }
            catch(exception e){
                error='Exception: ' + e.getTypeName() + ': ' + e.getMessage()+ ' -- ' + e.getCause();
                insert PED_ServiziTecnici_Controller.createLog('getTaratureFornitura', 'KO', error, null,null);
                
                return null;
            } 
            PED_ServiziTecnici_Controller.taratureFornitura tarForn = new PED_ServiziTecnici_Controller.taratureFornitura();
            tarForn.detForn=res.fornitura.dettFornitura;
            tarForn.griglieMap= new Map<String,List<String>>();
            for(PED_ServiziTecnici_TaratureData.tar tar : res.fornitura.dettFornitura.taratura){
                if(!String.isBlank(tar.cdTar)){
                    List<String> sList = new List<String>();
                    sList.add(tar.tarCom);
                    sList.add(tar.tarImp);
                    sList.add(tar.umTar);
                    tarForn.griglieMap.put(tar.cdTar,sList);
                }
            }
            string result;
            if(res.ccRich == '0' || res.ccRich == '4'){
                result='OK';
            }
            else{
                result='KO';
            }
            insert PED_ServiziTecnici_Controller.createLog('getTaratureFornitura', result, res.ccDesc, JSON.serialize(res), JSON.serialize(forn));
            return tarForn;
        }
        return null;
    }
    
    @AuraEnabled
    public static PED_ServiziTecnici_TaratureData.datiImpiantoCli getImpiantoFornitura(String pod){
        PED_ServiziTecnici_Tarature.TaratureWsTibcoSOAP ttts = new PED_ServiziTecnici_Tarature.TaratureWsTibcoSOAP();
        PED_ServiziTecnici_TaratureData.cl cliente = PED_ServiziTecnici_Controller.getCliente(pod);
        if(cliente!=null && !cliente.fornitura.isEmpty()){
            PED_ServiziTecnici_TaratureData.impiantoFornituraResult forn= new PED_ServiziTecnici_TaratureData.impiantoFornituraResult();
            forn.keyFornitura= new PED_ServiziTecnici_TaratureData.keyFornitura();
            forn.keyFornitura.IdClienteK=cliente.fornitura[0].IdClienteK;
            forn.keyFornitura.IdClienteM=cliente.fornitura[0].IdClienteM;
            forn.keyFornitura.IdClienteL=cliente.fornitura[0].IdClienteL;
            String error='';
            PED_ServiziTecnici_TaratureData.impiantoFornituraResult res;
            try{
                res =ttts.impiantoFornitura(forn);
            }
            catch(exception e){
                error='Exception: ' + e.getTypeName() + ': ' + e.getMessage()+ ' -- ' + e.getCause();
                insert PED_ServiziTecnici_Controller.createLog('getImpiantoFornitura', 'KO', error, null,null);
                return null;
            } 
            string result;
            if(res.ccRich == '0' || res.ccRich == '4'){
                result='OK';
            }
            else{
                result='KO';
            }
            insert PED_ServiziTecnici_Controller.createLog('getTaratureFornitura', result, res.ccDesc, JSON.serialize(res), JSON.serialize(forn));
            return res.datiImpiantoCli;
        }
        return null;
    }
    
    @AuraEnabled
    public static String scriviImpiantoFornitura(Map<String,String> impiantoFornituraMap){
        PED_ServiziTecnici_TaratureData.datiImpiantoCli impiantoFornitura= new PED_ServiziTecnici_TaratureData.datiImpiantoCli();
        impiantoFornitura.SvilReteAerea=impiantoFornituraMap.get('SvilReteAerea');
        impiantoFornitura.SvilReteCavo=impiantoFornituraMap.get('SvilReteCavo');
        impiantoFornitura.LunCavoColl=impiantoFornituraMap.get('LunCavoColl');
        impiantoFornitura.SezCavoColl=impiantoFornituraMap.get('SezCavoColl');
        impiantoFornitura.PotTrasfEnerg=impiantoFornituraMap.get('PotTrasfEnerg');
        impiantoFornitura.PotTrasfParall=impiantoFornituraMap.get('PotTrasfParall');
        impiantoFornitura.SezioneCliente=impiantoFornituraMap.get('SezioneCliente');
        impiantoFornitura.DispGen=impiantoFornituraMap.get('DispGen');
        impiantoFornitura.ProtGen=impiantoFornituraMap.get('ProtGen');
        impiantoFornitura.SezioneProdutt=impiantoFornituraMap.get('SezioneProdutt');
        impiantoFornitura.DispInterf=impiantoFornituraMap.get('DispInterf');
        impiantoFornitura.ProtInterf=impiantoFornituraMap.get('ProtInterf');
        impiantoFornitura.DtAggiornam=impiantoFornituraMap.get('DtAggiornam');
        String pod=impiantoFornituraMap.get('pod');
        PED_ServiziTecnici_Tarature.TaratureWsTibcoSOAP ttts = new PED_ServiziTecnici_Tarature.TaratureWsTibcoSOAP();
        PED_ServiziTecnici_TaratureData.cl cliente = PED_ServiziTecnici_Controller.getCliente(pod);
        if(cliente!=null && !cliente.fornitura.isEmpty()){
            PED_ServiziTecnici_TaratureData.scriviImpiantoFornituraResult forn= new PED_ServiziTecnici_TaratureData.scriviImpiantoFornituraResult();
            forn.datiImpiantoCli=impiantoFornitura;
            forn.keyFornitura= new PED_ServiziTecnici_TaratureData.keyFornitura();
            forn.keyFornitura.IdClienteK=cliente.fornitura[0].IdClienteK;
            forn.keyFornitura.IdClienteM=cliente.fornitura[0].IdClienteM;
            forn.keyFornitura.IdClienteL=cliente.fornitura[0].IdClienteL;
            String error='';
            PED_ServiziTecnici_TaratureData.scriviImpiantoFornituraResult res;
            try{
                res =ttts.scriviImpiantoFornitura(forn);
            }
            catch(exception e){
                error='Exception: ' + e.getTypeName() + ': ' + e.getMessage()+ ' -- ' + e.getCause();
                insert PED_ServiziTecnici_Controller.createLog('scriviImpiantoFornitura', 'KO', error, null,null);				
                return null;
            } 
            string result;
            if(res.ccRich == '0' || res.ccRich == '4'){
                result='OK';
            }
            else{
                result='KO';
            }
            insert PED_ServiziTecnici_Controller.createLog('scriviImpiantoFornitura', result, res.ccDesc, JSON.serialize(res), JSON.serialize(forn));
            if(result=='OK'){
                return 'OK';
            }
            else{	    		
                return res.ccDesc;
            }
        }
        return 'KO'; 
        
    }
    
    @AuraEnabled
    public static PED_ServiziTecnici_Controller.impiantoETarature getImpiantoETarature(string pod){
        List<EAIServiceLog__c> logList = new List<EAIServiceLog__c>();
        PED_ServiziTecnici_Controller.impiantoETarature it = new PED_ServiziTecnici_Controller.impiantoETarature();
        PED_ServiziTecnici_Tarature.TaratureWsTibcoSOAP ttts = new PED_ServiziTecnici_Tarature.TaratureWsTibcoSOAP();
        it.cliente = PED_ServiziTecnici_Controller.getCliente(pod);
        String error='';
        if(it.cliente!=null && !it.cliente.fornitura.isEmpty()){
             PED_ServiziTecnici_TaratureData.impiantoFornituraResult impForn= new PED_ServiziTecnici_TaratureData.impiantoFornituraResult();
            impForn.keyFornitura= new PED_ServiziTecnici_TaratureData.keyFornitura();
            impForn.keyFornitura.IdClienteK=it.cliente.fornitura[0].IdClienteK;
            impForn.keyFornitura.IdClienteM=it.cliente.fornitura[0].IdClienteM;
            impForn.keyFornitura.IdClienteL=it.cliente.fornitura[0].IdClienteL;
            
            PED_ServiziTecnici_TaratureData.impiantoFornituraResult res1;
            try{
                res1 =ttts.impiantoFornitura(impForn);
            }catch(exception e){
                error='Exception: ' + e.getTypeName() + ': ' + e.getMessage()+ ' -- ' + e.getCause();
                logList.add(PED_ServiziTecnici_Controller.createLog('getImpiantoFornitura', 'KO', error, null,null));				
                //return null;
            } 
            string result='KO';
            if(res1!=null){
                if(res1.ccRich!=null){
                    if(res1.ccRich == '0' || res1.ccRich == '4'){
                        result='OK';
                    }
                    else{
                        result='KO';
                    }
                }else {
                    result='KO';
                }
                it.impianto= res1.datiImpiantoCli;
            }
            if(error==''){
           	 	logList.add(PED_ServiziTecnici_Controller.createLog('getImpiantoETarature - Impianto', result, res1!=null?res1.ccDesc:'', JSON.serialize(res1), JSON.serialize(impForn)));
            }
            error='';
            PED_ServiziTecnici_TaratureData.forn forn= new PED_ServiziTecnici_TaratureData.forn();
            forn.IdClienteK=it.cliente.fornitura[0].IdClienteK;
            forn.IdClienteM=it.cliente.fornitura[0].IdClienteM;
            forn.IdClienteL=it.cliente.fornitura[0].IdClienteL;
            PED_ServiziTecnici_TaratureData.taratureResult res2;
            Boolean flagException=false;
            PED_ServiziTecnici_Controller.taratureFornitura tarForn = new PED_ServiziTecnici_Controller.taratureFornitura();
            try{
                res2 =ttts.taratureFornitura(forn);             
                System.debug('RES 2********************'+res2);
            }catch(exception e){
                error='Exception: ' + e.getTypeName() + ': ' + e.getMessage()+ ' -- ' + e.getCause();
                logList.add(PED_ServiziTecnici_Controller.createLog('getImpiantoETarature - Tarature', 'KO', error, null,null));	                
                //return null;
            }  
            string result2='KO';
            if(res2!=null){                
                tarForn.detForn=res2.fornitura.dettFornitura;
                tarForn.griglieMap= new Map<String,List<String>>();
                for(PED_ServiziTecnici_TaratureData.tar tar : res2.fornitura.dettFornitura.taratura){
                    if(!String.isBlank(tar.cdTar)){
                        List<String> sList = new List<String>();
                        sList.add(tar.tarCom);
                        sList.add(tar.tarImp);
                        sList.add(tar.umTar);
                        tarForn.griglieMap.put(tar.cdTar,sList);
                    }
                }
               
                if(res2.ccRich == '0' || res2.ccRich == '4'){
                    result2='OK';
                }
                else{ 
                    result2='KO';
                }
                it.tarForn=tarForn;
            }
                logList.add(PED_ServiziTecnici_Controller.createLog('getTaratureFornitura', result2, res2.ccDesc==null?'':res2.ccDesc, JSON.serialize(res2), JSON.serialize(forn)));
           
            insert logList;
            return it;
        }
        return null;
    }
    
    @AuraEnabled 
    public static PED_PODInfoWrapper.Response PODDetails(){
        return PED_PODInfoUtils.recuperaPodInCache();
    }
    
    @AuraEnabled 
    public static PED_PODInfoWrapper.Response PODDetailsDelegato(){
        return PED_PODInfoUtils.recuperaPodInCacheDelegato();
    }
    
    @AuraEnabled 
    public static String GetAccountId(String TaxCode , String VatNumber){
        //MDB: Modifiche per dismissione oggetto PED_POD__C
        return [SELECT ID, CodiceFiscale__c,PartitaIVA__c FROM ACCOUNT WHERE CodiceFiscale__c =: TaxCode or PartitaIVA__c =: VatNumber LIMIT 1].id;

    }
    
    @AuraEnabled
    public static PED_ServiziTecnici_TaratureData.cl getCliente(String pod){
        PED_ServiziTecnici_TaratureData.cl cliente = new PED_ServiziTecnici_TaratureData.cl();
        cliente.pod=pod;
        cliente.nmForn=1;
        //chiamo il primo ws che mi restituisce i valori per chiamare il secondo ws
        PED_ServiziTecnici_Tarature.TaratureWsTibcoSOAP ttts = new PED_ServiziTecnici_Tarature.TaratureWsTibcoSOAP();
        PED_ServiziTecnici_TaratureData.fornitureResult res;
        String error='';
        try{
            res = ttts.elencoForniture(cliente);
        }
        catch(exception e){
            error='Exception: ' + e.getTypeName() + ': ' + e.getMessage()+ ' -- ' + e.getCause();
            system.debug(error);
            insert PED_ServiziTecnici_Controller.createLog('getCliente', 'KO', error, null,null);
            return null;
        }
        return res.cliente;
    }
    
    public static EAIServiceLog__c  createLog(String wsName, String result, String errorDescription, String input, String output ){
        EAIServiceLog__c sl = new EAIServiceLog__c();
        sl.processService__c='Servizi Tecnici';
        sl.ws_Name__c=wsName;
        sl.Result__c=result;
        sl.Error_description__c=errorDescription!=null?errorDescription.left(254):'';
        sl.User__c=userinfo.getUserId();
        if(String.isNotBlank(input)){
            sl.Input__c=input!=null?input.left(131072):'';
        }
        if(String.isNotBlank(output)){
            sl.output__c=output!=null?output.left(131072):'';
        }
        return sl;
    }
    
    @AuraEnabled
    public static string inviaEmail(string nomeServizio, String nomeFile, string tipoAllegato, String allegato, string customBody){
        
        try{
            if(customBody==null || customBody==''){
                customBody='al servizio richiesto.';
            }
            User u = [select id, firstname, lastname, name, email from user where id=:userinfo.getUserId()];
            System.debug('*****USER : ' + u);
            string devName='Enel_Distribution_Group_Logo_Primary_RGB_jpg';
            Document d = [select id,body from document where developername=:devName];
            System.debug('*****HO TROVATO IL DOCUMENTO');
            Organization org = [SELECT id, Name, InstanceName FROM Organization];
            String senderowea = PED_Environment__c.getInstance('noreplyMailSender').Value__c;
            OrgWideEmailAddress[] owea=[select id, Address, DisplayName from OrgWideEmailAddress where Address =:senderowea limit 1];
            
            //String[] toAddresses = new String[] {u.Email};
            String[] toAddresses = new String[] {u.email};
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setSubject('Invio allegato per il servizio '+ nomeServizio);
            email.setToAddresses(toAddresses);
            email.setHtmlBody('<html><body>Gentile Cliente,<br/><br/>in allegato il file relativo '+customBody+'.<br/><br/>' 
                              +'Saluti,<br/><br/>'     
                              +'<img src="https://'+org.InstanceName+'.salesforce.com/servlet/servlet.ImageServer?id='+d.id+'&oid='+org.id+'"/>'+
                              +'</body></html>');
            if ( owea.size() > 0 ) {
                email.setOrgWideEmailAddressId(owea[0].Id);
                }
            // Create the email attachment
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setFileName(nomeFile+'.'+tipoAllegato); 
            efa.setBody(EncodingUtil.base64Decode(allegato)); 
            email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa}); 
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
        }
        catch(exception e){
            String error='Exception: ' + e.getTypeName() + ': ' + e.getMessage()+ ' -- ' + e.getCause();
            insert PED_ServiziTecnici_Controller.createLog('inviaEmail', 'KO', error, null,null);
            return null;
        }
        return null;
    }
    
    @AuraEnabled
    public static user getUser(){
        User u = [select id, firstname, lastname, name from user where id=:userinfo.getUserId()];
        return u;
    }
}