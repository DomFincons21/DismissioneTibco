@isTest
public class PED_ProxyWSAsyncServiziTecniciTest {
    
    static testMethod void testInvokeAsyncBuchiDiTensione() { 
        PED_ProxyWSAsyncServiziTecnici PWAST = new PED_ProxyWSAsyncServiziTecnici();
        PWAST.invoke();
        System.currentPageReference().getParameters().put('uniqueId', '');         
        System.currentPageReference().getParameters().put('methodN', 'buchiTensione');
        System.currentPageReference().getParameters().put('params', 'TESTPOD,asd,asd');
        PWAST.invoke();
        PWAST.processResponseCallBuchiDiTensione();
        PED_ServiziTecnici_WS.protocolliResult y = new PED_ServiziTecnici_WS.protocolliResult();
        y.tsRich='ca';
        y.tsRisp='ca';
        y.retCode='ca';
        y.retMsg='ca';
        PED_ServiziTecnici_WS.scriviImpiantoFornituraResult i = new PED_ServiziTecnici_WS.scriviImpiantoFornituraResult();
        i.dtrich='ciao';
        i.tsRich='ciao';
        i.tsRisp='ciao';
        PED_ServiziTecnici_WS.datiImpiantoAui asd = new PED_ServiziTecnici_WS.datiImpiantoAui();
        asd.SvilReteAerea='asgas';
        PED_ServiziTecnici_WS.fornIntD333 fi = new PED_ServiziTecnici_WS.fornIntD333();
        fi.cFis='ciao';
        PED_ServiziTecnici_WS.protocollo pr = new PED_ServiziTecnici_WS.protocollo();
        PED_ServiziTecnici_WS.datiImpiantoCli cli = new PED_ServiziTecnici_WS.datiImpiantoCli();
        PED_ServiziTecnici_WS.interruzioniD333 cli1 = new PED_ServiziTecnici_WS.interruzioniD333();
        PED_ServiziTecnici_WS.fornitureResult cli2 = new PED_ServiziTecnici_WS.fornitureResult();  
        PED_ProxyWSAsyncServiziTecnici.adeguatezzaImpianti adImp = new PED_ProxyWSAsyncServiziTecnici.adeguatezzaImpianti();
        adImp.tipoMessaggio = '';  
        adImp.anno= '';  
        adImp.testoArt34= '';  
        adImp.testoArt45= '';  
        adImp.CTS= '';  
        adImp.CTSM= '';  
        adImp.CTStotale= '';  
        adImp.dataDichiarazione= '';  
        adImp.dichiarazioneAdeguatezza= '';  
        adImp.ctsAmmontareAnnuo= '';  
        adImp.indirizzo= '';  
        adImp.n= 0;  
        
        PED_ProxyWSAsyncServiziTecnici.indirizzoEProtocolli  indEProt = new PED_ProxyWSAsyncServiziTecnici.indirizzoEProtocolli();
    }
    
    static testMethod void testInvokeAsyncProtocollo() { 
        PED_ProxyWSAsyncServiziTecnici PWAST = new PED_ProxyWSAsyncServiziTecnici();
        Test.setCurrentPageReference(new PageReference('Page.myPage')); 
        System.currentPageReference().getParameters().put('uniqueId', '');         
        System.currentPageReference().getParameters().put('methodN', 'Protocollo');
        System.currentPageReference().getParameters().put('params', 'TESTPOD,asd,asd'); 
        PWAST.invoke();
        PWAST.processResponseCallProtocollo();
        
    }
    
    static testMethod void testInvokeAsyncTarature() { 
        PED_ProxyWSAsyncServiziTecnici PWAST = new PED_ProxyWSAsyncServiziTecnici();
        Test.setCurrentPageReference(new PageReference('Page.myPage')); 
        System.currentPageReference().getParameters().put('uniqueId', '');         
        System.currentPageReference().getParameters().put('methodN', 'TaratureFornitura');
        System.currentPageReference().getParameters().put('params', 'TESTPOD,asd,asd'); 
        PWAST.invoke();
        PWAST.processResponseCallTaratureImpianti();
    }
    
    static testMethod void testInvokeAsyncImpianti() { 
        PED_ProxyWSAsyncServiziTecnici PWAST = new PED_ProxyWSAsyncServiziTecnici();
        Test.setCurrentPageReference(new PageReference('Page.myPage')); 
        System.currentPageReference().getParameters().put('uniqueId', '');         
        System.currentPageReference().getParameters().put('methodN', 'ImpiantoFornitura');
        System.currentPageReference().getParameters().put('params', 'TESTPOD,asd,asd'); 
        PWAST.invoke();
        PWAST.processResponseCallImpiantoFornitura();
        
        
    }
    
    static testMethod void testInvokeAsyncAdeguatezza() { 
        PED_ProxyWSAsyncServiziTecnici PWAST = new PED_ProxyWSAsyncServiziTecnici();
        Test.setCurrentPageReference(new PageReference('Page.myPage')); 
        System.currentPageReference().getParameters().put('uniqueId', '');         
        System.currentPageReference().getParameters().put('methodN', 'AdeguatezzaImpianti');
        System.currentPageReference().getParameters().put('params', 'TESTPOD,asd,asd'); 
        PWAST.invoke();
        PWAST.processResponseCallAdeguatezza();
        
    }    
    
    static testMethod void testInvokeAsyncArchivio() { 
        PED_ProxyWSAsyncServiziTecnici PWAST = new PED_ProxyWSAsyncServiziTecnici();
        Test.setCurrentPageReference(new PageReference('Page.myPage')); 
        System.currentPageReference().getParameters().put('uniqueId', '');         
        System.currentPageReference().getParameters().put('methodN', 'ArchivioComunicazioni');
        System.currentPageReference().getParameters().put('params', 'TESTPOD,asd,asd'); 
        PWAST.invoke();
        PWAST.processResponseCallArchivioComunicazioni();
        
    }
    
    static testMethod void testInvokeAsyncQualita() { 
       
        PED_ProxyWSAsyncServiziTecnici PWAST = new PED_ProxyWSAsyncServiziTecnici();
        Test.setCurrentPageReference(new PageReference('Page.myPage')); 
        System.currentPageReference().getParameters().put('uniqueId', '');         
        System.currentPageReference().getParameters().put('methodN', 'QualitaDelServizio');
        System.currentPageReference().getParameters().put('params', 'TESTPOD,asd,asd');
        PWAST.invoke();
        PWAST.processResponseCallQualita();
       
        
    }
    
    static testMethod void testInvokeAsyncVarie() { 
       
        PED_ProxyWSAsyncServiziTecnici.convertJSONtoObject(JSON.serialize('ciao')); 
        
    }
    
    
    
}