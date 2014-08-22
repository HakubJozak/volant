Volant.WorkcampsController = Volant.ListController.extend({

  query: ''

  sortProperties: ['name']
  sortAscending: true
  current_item: null

  # TODO - fetch this
  tags: ["senior", "family", "teenage", "spanish", "german", "italian", "married", "possible_duplicate", "special form", "extra fee", "french", "motiv.letter"]

  intentions: ["AGRI", "ANIMAL", "ARCH", "CONS", "CULT", "ECO", "EDU", "ELDE", "ETHNO", "FEST", "HERI", "HIST", "KIDS", "LANG", "LEAD", "MANU", "PLAY", "REFUGEE", "RENO", "SOCI", "TEACH", "TEEN", "ENVI", "FRENCH", "GERMAN", "RUSSIAN", "ZOO", "DISA", "SERBIAN", "ITALIAN", "SPANISH", "PŘÍPRAVNÉ ŠKOLENÍ", "YOGA", "PEACE", "ART", "SPOR", "STUD", "SENIOR", "FAMILY", "WHV"]

  countries: ["Ghana", "JCI", "Kosovo", "Island of Man", "Saint-Barthélemy", "Srbsko", "Eastern Timor", "Guernsey", "Jersey", "Monte Negro", "Saint-Martin", "Ålandy", "Andorra", "United Arab Emirates", "Afghanistan", "Antigua And Barbuda", "Anguilla", "Albania", "Armenia", "Netherlands Antilles", "Angola", "Antarctica", "Argentina", "American Samoa", "Austria", "Australia", "Aruba", "Azerbaijan", "Bosnia And Herzegovina", "Barbados"]

  organizations: ["SCI Mexico - SCI Mexico", "IVS-GB Scottland - IVS-GB Scottland", "SDA - INEX-SDA", "PESP - SONQOYKIPI", "AMEC 01 - AMEC", "MIL - NGO Milenijum", "Baladna - Baladna", "BRA Vol - BRA Vol - Fundamed/Volunteers Brazil", "BRA Vol - Fundamed - Volunteers Brazil", "EcuFPE - EcuFPE", "FUNCEDESCRI - FUNCEDESCRI", "IVM Sfera - IVM Sfera", "JEF - JEF", "LCA - LCA", "LV - LV", "MTPRO - MTP Romania", "NNVS - NNVS", "NWCA - NWCA", "OKC - OKC", "SCI Japan - SCI Japan", "SCI Pakistan - SCI Pakistan", "SCI Sri Lanka - SCI Sri Lanka", "SCI-SIV Madrid - SCI-SIV Madrid", "YAP Romania - YAP Romania", "YGFE - YGFE", "AJUDE - AJUDE", "CIEE - CIEE", "IVS stare - IVS-GB Southern Eng.", "CPI - YAP Italia", "BW-BWA - BWA", "Nuestra Tierra - Nuestra Tierra", "CIA - CIA", "VIMEX - VIMEX", "UNA - UNA Exchange", "ZM-YAZ - Youth association Zambia", "GEN - Genctur", "IBG - IBG", "CONC - Concordia UK", "VJF - VJF", "ELIX - ELIX- CVG", "ATAV - ATAV", "CONCF - Concordia France", "ISL - INEX Slovakia", "AT - SCI Austria", "GH-VOL - VOLU", "PRO - PRO International", "MN-MCE - MCE", "NG-VWA - VWAN", "KVDA - KVDA", "EST - EST-YES", "OH - Open Houses", "UAALT - Alternative-V", "TH-DA - DaLaa", "ESMAD - SCI Madrid", "MAR - MAR", "SCI Canada - SCI Canada", "Green Action - Green Action", "Gudran - Gudran", "VFP - VFP", "UVDA - UVDA", "VAP - VAP UK", "MA-ACJ - ACJ", "ALLI - ALLIANSSI", "PL-SCI - SCI Poland", "PWS - PeaceWorks Sweden", "RJ - Rota Jovem", "JR - JR", "PZ - Passage Zebra", "JIH - JIH", "PVN Albania - AL-PVN", "SCI Kyrgyzstan - League of Volunteers", "YES Phlilippine - YES Phlilippine", "Youth Integration Service - YIS", "ADVIT - ADVIT", "Austeja - Austeja", "SPIC - SPIC", "CSM - CSM", "IIVEP - IIVEP", "Via Pacis - Via Pacis", "JAFRA - Jafra", "BWCA - Bangladesh Work Camp Association", "DEM - DEM", "Educational Centre Krusevac - Educational Centre Krusevac", "GYF - Georgian Youth for Future", "SCI Belarus - SCI Belarus", "Tarna Rom - Tarna Rom", "YDD - YYD", "ICH Jordan - ICH", "SVI-GZT - SVI-GZT", "INTE - INTE", "Motivatie - Motivatie", "SCI Hellas - SCI Hellas", "JEC - JEC", "Youth 21 - Youth 21 Tadjikistan", "JAVVA - JAVVA", "SJ - SJ", "ZWA - ZWA", "IJGD - IJGD", "BESCI - SCI Belgium", "LYVS - LYVS", "FFN - FFN", "DGV - DiGe vu Samara", "SIW - SIW", "IIWC - IIWC of IPPA", "FR - SCI France", "BG-CVS - CVS", "NP-SCI - SCI Nepal", "MS - MS", "IN-SCI - SCI India", "LS - LEADER", "MT - Mir Tesen", "ICJA - ICJA Germany", "CG - CGO", "SCI-K - SCI Korea", "DESCI - SCI Germany", "USSCI - SCI-IVS USA", "GW - Greenway", "FIYE - FIYE", "ERZ - Eco-Razeni", "CJM - CJM", "CID - MK-CID", "TG-AST - ASTOVOT", "NIG - NIG", "W4U - World4U", "DJ - Dejavato", "ESCAT - SCI Catalunya", "SCI Bangladesh - SCI Bangladesh", "YCL / Livno - YCL /Centar mladih", "NL-VIA - VIA Netherlands", "PVN - AL-PVN", "VSI - VSI Ireland", "IPDJ - IPDJ", "TZ-UVI - UVIKIUTA", "SEEDS - SEEDS", "FI - KVT", "AVI - AVI", "OWA - OWA Poland", "SE - IAL", "CJ - CJ", "YAP Moldova - YAP Moldova", "Svet jako domov - Svet jako domov", "IVS-GB stare - IVS", "IPYL - IPYL", "AI - Active International", "GOECO - GOECO", "YCCBT - YCCBT", "PGVCV - PGVCV / VOLUNTEERS' CENTER OF VOJVODINA AND NATURE CONSERVATION MOVEMENT", "LUNAR - Lunaria", "Xchange scotland - XS", "GSM - GSM", "UKF - UNION FORUM", "UK-IE-VSI - VSI Northern Ireland", "CAT - COCAT", "HUJ - HUJ", "CBB - CBB", "CIEEJ - CIEEJ", "ABSV - ABSV", "ESDA - De Amicitia ", "Utilapu - Utilapu", "CBF - CBF", "BYC - Balkan Youth Club", "MOVE - MOVE", "SODVO - Sodrujestvo", "NO-ID - ID", "IWO - IWO", "VOC - ADP-ZID", "GL - Grenzenlos Austria", "KNCU - KNCU", "Les Amis de la Terre - Les Amis de la Terre", "FAGAD - FAGAD", "RC - RUCHI", "NAT - Nataté", "LEG - Legambiente", "SCISI - SCI Slovenia", "HRVCZ - VCZ", "SJV - SJ Vietnam", "CYVA - CYVA Deineta", "WS - Workcamps Switzerland", "CH - SCI Switzerland", "U - UNAREC", "SFERA - SFERA", "LYVG - LYVG", "RS-SCI - VC Vojvodina", "VYA - VYA", "SVIT - SVIT", "JP-NIC - NICE", "UG-UPA - UPA", "SCI Malaysia - SCI Malaysia", "VN-VPV - VPV", "SVI - SVI", "WF - WF", "VM - VIVE MEXICO", "AYAFE - AYAFE", "New Group Belarus - New Group Belarus", "LU-APL  - LU-APL ", "Youth Memorial - Youth Memorial", "Duha - Duha", "TDDF - Tkibuli District Development Fund", "CYA - Cambodia Youth Action", "EGY - Egyesek Youth Association", "IG - InformaGiovani", "FSL - FSL", "PE-BVB - BVBP", "TINKU - Red Tinku", "VSS - YRS - VSS", "AU-IVP - IVP Australia", "SAS - Subir Al Sur", "KS-GAI - Gaia", "GVDA - GVDA", "AMC - Aventura Marão Clube", "STV - SAWASDEE", "XS - Xchange Scotland", "WAS - Waslala", "CIVS - CIVS", "AYA - AYA", " - Sunshine Volunteering Head Group", "VT - VolTra", "VIN - VIN", "BF - Bridge to the Future", "NIN - NINARWA", "IBO - IBO", "ECZ - ECZ", "RO-SCI - SCI Romania", "HR-VAK - VA Kuterevo ", "ACI - ACI Costa Rica", "BEVIA - VIA Belgium", "CH - Colorful House", "HK-HKG - SCI HK", "BWC - BWC", "COM - COM", "YPGD - YPGD", "BH - SEEYN", "BBA - Beyond Barriers Association", "CARDO - CARDO", "YS - Youth for Smile", "HU - SCI Hungary", "SCI-I - SCI Italy", "SW - YSDA", "UKVSI - IVS-UK", "GDC - Goods Deeds Case", "CON - Tamjdem"]


  do_search: ( ->
    @store.find('workcamp', { q: @get('query'), p: @get('current_page'), year: @get('current_year') }).then (wcs) =>
      @set('content',wcs)
   ).observes('current_year','current_page')

  actions:
    toggle_filter: ->
      console.info 'filtering'
      @toggleProperty('filter_is_visible')
      false

    adjust_page: (delta) ->
      delta = parseInt(delta)
      target = @get('current_page') + delta
      upper_bound = @get('pagination').total_pages

      if (target > 0) and (target <= upper_bound)
        @incrementProperty('current_page',delta)

    search_workcamp: ->
      @set('current_page',1)
      @do_search()
      false
})
