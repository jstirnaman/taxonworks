require 'spec_helper'

describe Georeference::GeoLocate do

  let(:geo_locate) { FactoryGirl.build(:georeference_geo_locate)}
  let(:request_params) { {country: 'USA', locality: 'Champaign', state: 'IL', doPoly: 'true', locality: 'Urbana'} }
  let(:request) { Georeference::GeoLocate::Request.new(request_params) }
  let(:response) { request.response }
  let(:georeference_from_build) { Georeference::GeoLocate.build(request_params) } 

  context 'building a Georeference::GeoLocate with #build_from_embedded_result(response_string)' do
    before(:each) {
      @string = '40.11639|-88.24333|7338|40.1379180207,-88.2699379175,40.1375100207,-88.2694189175,40.1374060207,-88.2694509175,40.1372730207,-88.2690329175,40.1373630207,-88.2689819175,40.1375880207,-88.2689439175,40.1401300207,-88.2688339175,40.1415490207,-88.2691719175,40.1416530207,-88.2691719175,40.1417120207,-88.2691599175,40.1419090207,-88.2691429175,40.1418370207,-88.2695809175,40.1420250207,-88.2695859175,40.1420950207,-88.2693509175,40.1421570207,-88.2693799175,40.1422310207,-88.2692849175,40.1431160207,-88.2691779175,40.1434840207,-88.2696049175,40.1435510207,-88.2697659175,40.1432970207,-88.2702859175,40.1436270207,-88.2712409175,40.1437380207,-88.2711889175,40.1438090207,-88.2711549175,40.1438240207,-88.2716769175,40.1439420207,-88.2715969175,40.1441460207,-88.2719599175,40.1443600207,-88.2723289175,40.1441270207,-88.2724789175,40.1441600207,-88.2725889175,40.1444260207,-88.2725049175,40.1444800207,-88.2727769175,40.1446540207,-88.2727069175,40.1450000207,-88.2726349175,40.1450000207,-88.2725559175,40.1447160207,-88.2719339175,40.1445010207,-88.2715329175,40.1441310207,-88.2702929175,40.1447020207,-88.2703029175,40.1448660207,-88.2703059175,40.1450450207,-88.2709589175,40.1453970207,-88.2719749175,40.1461770207,-88.2720249175,40.1460990207,-88.2745079175,40.1463620207,-88.2747479175,40.1464850207,-88.2749159175,40.1465150207,-88.2750759175,40.1465190207,-88.2753009175,40.1472240207,-88.2752799175,40.1473490207,-88.2769659175,40.1476430207,-88.2769669175,40.1476010207,-88.2752829175,40.1487340207,-88.2749959175,40.1487230207,-88.2758409175,40.1487280207,-88.2764749175,40.1487050207,-88.2769719175,40.1481790207,-88.2808679176,40.1477910207,-88.2814679176,40.1475280207,-88.2818739176,40.1468660207,-88.2822109176,40.1462690207,-88.2824339176,40.1455250207,-88.2823879176,40.1451960207,-88.2823329176,40.1450440207,-88.2823939176,40.1449460207,-88.2824309176,40.1448500207,-88.2824749176,40.1444400207,-88.2827829176,40.1444320207,-88.2830389176,40.1444260207,-88.2832379176,40.1443110207,-88.2842419176,40.1442640207,-88.2848379176,40.1441730207,-88.2854609176,40.1440440207,-88.2858139176,40.1437670207,-88.2862149176,40.1436000207,-88.2864479176,40.1434570207,-88.2867319176,40.1434520207,-88.2869249176,40.1435230207,-88.2870509176,40.1435490207,-88.2871169176,40.1439130207,-88.2882049176,40.1448710207,-88.2877929176,40.1472920207,-88.2873729176,40.1478710207,-88.2875759176,40.1499700207,-88.2935339176,40.1507950207,-88.2951569176,40.1511640207,-88.2959119176,40.1517930207,-88.2959339176,40.1524080207,-88.2959339176,40.1527150207,-88.2959759176,40.1528760207,-88.2960249176,40.1530510207,-88.2961019176,40.1532250207,-88.2962069176,40.1534130207,-88.2963419176,40.1535680207,-88.2964829176,40.1538350207,-88.2967669176,40.1539610207,-88.2969229176,40.1549000207,-88.2980319176,40.1552160207,-88.2983929176,40.1553680207,-88.2985249176,40.1555360207,-88.2986509176,40.1557180207,-88.2987639176,40.1558470207,-88.2988309176,40.1560360207,-88.2989079176,40.1562850207,-88.2989679176,40.1567430207,-88.2989699176,40.1569900207,-88.2989309176,40.1572420207,-88.2988409176,40.1573600207,-88.2987769176,40.1575260207,-88.2986679176,40.1577090207,-88.2985249176,40.1579130207,-88.2983469176,40.1581830207,-88.2981109176,40.1582610207,-88.2980459176,40.1583370207,-88.2979819176,40.1567660207,-88.2961539176,40.1547220207,-88.2937499176,40.1542330207,-88.2931789176,40.1495810207,-88.2876939176,40.1497300207,-88.2876389176,40.1499350207,-88.2875779176,40.1496570207,-88.2830889176,40.1494580207,-88.2813489176,40.1494620207,-88.2802749175,40.1494750207,-88.2800369175,40.1494780207,-88.2797929175,40.1495000207,-88.2769839175,40.1495950207,-88.2757809175,40.1504800207,-88.2759029175,40.1504800207,-88.2769959175,40.1516580207,-88.2770079175,40.1519290207,-88.2770129175,40.1520720207,-88.2770149175,40.1523070207,-88.2770189175,40.1530050207,-88.2762159175,40.1544400207,-88.2745889175,40.1546200207,-88.2746399175,40.1563480207,-88.2748599175,40.1576120207,-88.2749489175,40.1576710207,-88.2749549175,40.1577340207,-88.2749519175,40.1579400207,-88.2749459175,40.1578840207,-88.2758939175,40.1578730207,-88.2770359175,40.1577900207,-88.2770399175,40.1577240207,-88.2770439175,40.1576500207,-88.2770449175,40.1563080207,-88.2770609175,40.1559180207,-88.2770729175,40.1556830207,-88.2778969175,40.1555090207,-88.2789139175,40.1555130207,-88.2806589176,40.1578440207,-88.2844099176,40.1585310207,-88.2832309176,40.1624750208,-88.2831939176,40.1624900208,-88.2779909175,40.1616910208,-88.2779959175,40.1617370208,-88.2771059175,40.1617340208,-88.2769059175,40.1593910207,-88.2768959175,40.1590980207,-88.2694489175,40.1590910207,-88.2692729175,40.1588480207,-88.2692909175,40.1586100207,-88.2693799175,40.1583720207,-88.2694969175,40.1581600207,-88.2697069175,40.1581600207,-88.2696089175,40.1581590207,-88.2692929175,40.1575690207,-88.2670149175,40.1574360207,-88.2667059175,40.1570060207,-88.2657079175,40.1566580207,-88.2647769175,40.1565960207,-88.2647769175,40.1564650207,-88.2647829175,40.1556340207,-88.2664309175,40.1556350207,-88.2658499175,40.1539210207,-88.2658569175,40.1539200207,-88.2664319175,40.1525100207,-88.2664329175,40.1525140207,-88.2665769175,40.1525300207,-88.2691989175,40.1520630207,-88.2691929175,40.1517860207,-88.2691889175,40.1517110207,-88.2666259175,40.1517090207,-88.2664969175,40.1517370207,-88.2657859175,40.1509970207,-88.2657179175,40.1510350207,-88.2665079175,40.1500330207,-88.2664769175,40.1498330207,-88.2664669175,40.1484940207,-88.2664509175,40.1469820207,-88.2664209175,40.1467290207,-88.2664229175,40.1461990207,-88.2664219175,40.1462060207,-88.2660819175,40.1462120207,-88.2657829175,40.1464580207,-88.2645659175,40.1469820207,-88.2619779175,40.1473840207,-88.2619819175,40.1469560207,-88.2579499175,40.1465160207,-88.2579399175,40.1452580207,-88.2579189175,40.1451250207,-88.2575909175,40.1451320207,-88.2564839175,40.1451920207,-88.2488059175,40.1451930207,-88.2485279175,40.1456130207,-88.2485169175,40.1460380207,-88.2485279175,40.1460320207,-88.2482809175,40.1462550207,-88.2482809175,40.1462550207,-88.2480509175,40.1468130207,-88.2480509175,40.1468130207,-88.2478519175,40.1468130207,-88.2467419175,40.1468130207,-88.2465069175,40.1460320207,-88.2465069175,40.1460380207,-88.2456309175,40.1456130207,-88.2456289175,40.1443560207,-88.2455699175,40.1444120207,-88.2454669175,40.1444350207,-88.2453489175,40.1444460207,-88.2452319175,40.1444410207,-88.2441499175,40.1444130207,-88.2408969175,40.1444020207,-88.2407789175,40.1443960207,-88.2406979175,40.1443740207,-88.2405949175,40.1444070207,-88.2390569175,40.1444300207,-88.2387699175,40.1493700207,-88.2389189175,40.1563040207,-88.2391769175,40.1600920207,-88.2392089175,40.1600520207,-88.2318049175,40.1599860207,-88.2272139175,40.1607360207,-88.2271789175,40.1641090208,-88.2271999175,40.1641480208,-88.2244449175,40.1641200208,-88.2208259175,40.1606850207,-88.2222659175,40.1563300207,-88.2241799175,40.1520830207,-88.2260719175,40.1485910207,-88.2275839175,40.1450520207,-88.2290229175,40.1449470207,-88.2326749175,40.1438400207,-88.2326439175,40.1437390207,-88.2357619175,40.1437310207,-88.2378949175,40.1436920207,-88.2390439175,40.1435950207,-88.2390419175,40.1426800207,-88.2390229175,40.1417560207,-88.2390129175,40.1417440207,-88.2378879175,40.1417590207,-88.2358699175,40.1411200207,-88.2358939175,40.1411060207,-88.2361929175,40.1396900207,-88.2364019175,40.1396440207,-88.2362729175,40.1379660207,-88.2358119175,40.1351040207,-88.2358259175,40.1351040207,-88.2330329175,40.1351080207,-88.2327739175,40.1351070207,-88.2326309175,40.1351070207,-88.2325349175,40.1349510207,-88.2325989175,40.1348880207,-88.2326259175,40.1347920207,-88.2326679175,40.1347310207,-88.2327539175,40.1345940207,-88.2328059175,40.1328740207,-88.2335779175,40.1324320207,-88.2338679175,40.1317740207,-88.2341199175,40.1317990207,-88.2342589175,40.1317910207,-88.2344729175,40.1318060207,-88.2356249175,40.1309200207,-88.2356379175,40.1304570207,-88.2346849175,40.1309960207,-88.2341559175,40.1309900207,-88.2340829175,40.1309900207,-88.2339849175,40.1309900207,-88.2335879175,40.1310020207,-88.2299539175,40.1309360207,-88.2290679175,40.1305940207,-88.2290699175,40.1293820207,-88.2290699175,40.1293810207,-88.2281079175,40.1290110207,-88.2281079175,40.1289690207,-88.2267949175,40.1289730207,-88.2262929175,40.1286210207,-88.2262929175,40.1286220207,-88.2256409175,40.1286210207,-88.2252769175,40.1277740207,-88.2259989175,40.1274940207,-88.2259809175,40.1273620207,-88.2259709175,40.1273540207,-88.2267119175,40.1273430207,-88.2276389175,40.1273430207,-88.2284139175,40.1273420207,-88.2285949175,40.1273390207,-88.2288739175,40.1262580207,-88.2288719175,40.1260710207,-88.2288989175,40.1258470207,-88.2289069175,40.1258480207,-88.2280059175,40.1250810207,-88.2279919175,40.1246830207,-88.2279839175,40.1246850207,-88.2288669175,40.1246900207,-88.2289819175,40.1238710207,-88.2289699175,40.1236620207,-88.2289639175,40.1238470207,-88.2288569175,40.1231300207,-88.2288509175,40.1226230207,-88.2288459175,40.1221790207,-88.2288369175,40.1212280207,-88.2288319175,40.1207790207,-88.2288349175,40.1202710207,-88.2288219175,40.1193220207,-88.2288009175,40.1191140207,-88.2287969175,40.1189820207,-88.2288029175,40.1189340207,-88.2287979175,40.1188370207,-88.2287969175,40.1183480207,-88.2287939175,40.1173860207,-88.2287849175,40.1163870207,-88.2287709175,40.1163890207,-88.2288599175,40.1135150207,-88.2288259175,40.1127440207,-88.2288169175,40.1122470207,-88.2288119175,40.1111530207,-88.2287969175,40.1103320207,-88.2288239175,40.1091430207,-88.2287579175,40.1059510207,-88.2287269175,40.1054870207,-88.2287249175,40.1054880207,-88.2289289175,40.1041940207,-88.2288799175,40.1030760207,-88.2288539175,40.1022540207,-88.2288539175,40.1014970207,-88.2288339175,40.1014980207,-88.2287329175,40.1014980207,-88.2286329175,40.1014850207,-88.2287219175,40.1014780207,-88.2288519175,40.1005780207,-88.2288369175,40.1005660207,-88.2301899175,40.1005600207,-88.2310459175,40.1005560207,-88.2325089175,40.1005460207,-88.2333939175,40.0990220207,-88.2333699175,40.0981690207,-88.2333399175,40.0980650207,-88.2333359175,40.0980480207,-88.2328219175,40.0980610207,-88.2310829175,40.0980650207,-88.2286919175,40.0959180207,-88.2286569175,40.0955070207,-88.2285969175,40.0954430207,-88.2311059175,40.0954860207,-88.2312349175,40.0955490207,-88.2332969175,40.0954610207,-88.2347279175,40.0953780207,-88.2357119175,40.0953390207,-88.2362889175,40.0953160207,-88.2363399175,40.0952720207,-88.2385729175,40.0952030207,-88.2414529175,40.0952050207,-88.2443629175,40.0944610207,-88.2445099175,40.0914670207,-88.2447989175,40.0909330207,-88.2448509175,40.0909290207,-88.2446249175,40.0907560207,-88.2446399175,40.0907430207,-88.2438699175,40.0908980207,-88.2438389175,40.0908990207,-88.2436379175,40.0912980207,-88.2435849175,40.0914820207,-88.2435939175,40.0914770207,-88.2433909175,40.0914750207,-88.2432299175,40.0909720207,-88.2432179175,40.0908700207,-88.2431949175,40.0908380207,-88.2431499175,40.0908220207,-88.2430579175,40.0908220207,-88.2430379175,40.0874370207,-88.2429919175,40.0870540207,-88.2448279175,40.0870570207,-88.2452799175,40.0870620207,-88.2455489175,40.0852100207,-88.2457899175,40.0852570207,-88.2459049175,40.0841200207,-88.2460559175,40.0840090207,-88.2460759175,40.0838200207,-88.2461039175,40.0835820207,-88.2461319175,40.0835100207,-88.2461429175,40.0835120207,-88.2464089175,40.0835100207,-88.2465539175,40.0835090207,-88.2468669175,40.0835060207,-88.2484209175,40.0834990207,-88.2490619175,40.0834840207,-88.2493419175,40.0835610207,-88.2494179175,40.0835600207,-88.2496439175,40.0835640207,-88.2506609175,40.0835630207,-88.2511039175,40.0835750207,-88.2516819175,40.0835860207,-88.2527409175,40.0835860207,-88.2537559175,40.0835940207,-88.2547969175,40.0836170207,-88.2574609175,40.0826020207,-88.2574479175,40.0826190207,-88.2571489175,40.0822840207,-88.2571319175,40.0822820207,-88.2574439175,40.0814870207,-88.2574339175,40.0806940207,-88.2574209175,40.0803910207,-88.2574219175,40.0802720207,-88.2574219175,40.0792300207,-88.2574159175,40.0791180207,-88.2574169175,40.0780780207,-88.2574069175,40.0775480207,-88.2574039175,40.0771140207,-88.2573989175,40.0768220207,-88.2573949175,40.0766840207,-88.2577309175,40.0767370207,-88.2614989175,40.0765900207,-88.2619489175,40.0764250207,-88.2707989175,40.0768370207,-88.2715599175,40.0836710207,-88.2715239175,40.0836600207,-88.2708329175,40.0836610207,-88.2706829175,40.0836690207,-88.2706089175,40.0836640207,-88.2698599175,40.0836570207,-88.2686649175,40.0836550207,-88.2674419175,40.0836540207,-88.2670449175,40.0850200207,-88.2669639175,40.0850510207,-88.2673559175,40.0842260207,-88.2674739175,40.0842190207,-88.2678509175,40.0865060207,-88.2677159175,40.0872270207,-88.2677739175,40.0872250207,-88.2694399175,40.0872430207,-88.2699469175,40.0873020207,-88.2701829175,40.0868960207,-88.2700759175,40.0868950207,-88.2705019175,40.0873010207,-88.2704909175,40.0871960207,-88.2720569175,40.0872240207,-88.2753329175,40.0873340207,-88.2763729175,40.0872410207,-88.2763719175,40.0870250207,-88.2759969175,40.0868530207,-88.2756689175,40.0869000207,-88.2754079175,40.0865950207,-88.2755299175,40.0865940207,-88.2756119175,40.0866120207,-88.2758459175,40.0870460207,-88.2763699175,40.0869230207,-88.2763689175,40.0863190207,-88.2763599175,40.0855380207,-88.2763469175,40.0837030207,-88.2763199175,40.0834320207,-88.2763149175,40.0825170207,-88.2763049175,40.0826780207,-88.2773889175,40.0834280207,-88.2774189175,40.0834610207,-88.2790239175,40.0832160207,-88.2796329175,40.0824130207,-88.2796279175,40.0824070207,-88.2790189175,40.0820510207,-88.2789969175,40.0820760207,-88.2796269175,40.0819610207,-88.2796269175,40.0817230207,-88.2795989175,40.0815780207,-88.2795349175,40.0814360207,-88.2794339175,40.0813720207,-88.2793659175,40.0813100207,-88.2792849175,40.0812470207,-88.2791449175,40.0811780207,-88.2788889175,40.0811660207,-88.2787939175,40.0811460207,-88.2769879175,40.0811170207,-88.2763829175,40.0811140207,-88.2762909175,40.0804170207,-88.2762869175,40.0800160207,-88.2762829175,40.0791340207,-88.2762749175,40.0740310207,-88.2761879175,40.0740120207,-88.2811179176,40.0734400207,-88.2811259176,40.0733920207,-88.2810779176,40.0733330207,-88.2810409176,40.0730960207,-88.2809999176,40.0728640207,-88.2809869176,40.0723840207,-88.2810029176,40.0709380207,-88.2809729176,40.0699920207,-88.2809549176,40.0692390207,-88.2809569176,40.0692580207,-88.2832339176,40.0693170207,-88.2883059176,40.0707940207,-88.2883429176,40.0748830207,-88.2889439176,40.0758480207,-88.2891619176,40.0765390207,-88.2890199176,40.0768720207,-88.2864479176,40.0763130207,-88.2851129176,40.0757600207,-88.2833079176,40.0761750207,-88.2833039176,40.0761960207,-88.2806479176,40.0793360207,-88.2807249176,40.0802050207,-88.2808479176,40.0804980207,-88.2808089176,40.0835500207,-88.2807029176,40.0834920207,-88.2811879176,40.0835110207,-88.2861959176,40.0834730207,-88.2864749176,40.0836800207,-88.2864739176,40.0836740207,-88.2872489176,40.0838470207,-88.2872629176,40.0838530207,-88.2877869176,40.0838710207,-88.2900159176,40.0838940207,-88.2924959176,40.0839040207,-88.2934389176,40.0839100207,-88.2937569176,40.0839300207,-88.2949579176,40.0815760207,-88.2950099176,40.0812920207,-88.2950009176,40.0812970207,-88.2945229176,40.0811280207,-88.2945719176,40.0808880207,-88.2945549176,40.0808580207,-88.2942109176,40.0807720207,-88.2934689176,40.0807400207,-88.2930259176,40.0799070207,-88.2927119176,40.0788420207,-88.2932579176,40.0775430207,-88.2930859176,40.0777210207,-88.2920859176,40.0807530207,-88.2921809176,40.0807280207,-88.2915949176,40.0807490207,-88.2911109176,40.0796550207,-88.2912309176,40.0797080207,-88.2905429176,40.0794290207,-88.2905399176,40.0793940207,-88.2910349176,40.0791250207,-88.2909229176,40.0790960207,-88.2910899176,40.0776420207,-88.2911999176,40.0777320207,-88.2916249176,40.0774940207,-88.2916159176,40.0775040207,-88.2914409176,40.0774960207,-88.2912349176,40.0772390207,-88.2912199176,40.0772770207,-88.2914359176,40.0771280207,-88.2918549176,40.0768630207,-88.2924579176,40.0768260207,-88.2931839176,40.0770640207,-88.2931629176,40.0771770207,-88.2931709176,40.0771740207,-88.2938129176,40.0772890207,-88.2938249176,40.0773730207,-88.2939089176,40.0773700207,-88.2940999176,40.0773270207,-88.2941249176,40.0772560207,-88.2941359176,40.0771730207,-88.2941299176,40.0771780207,-88.2949449176,40.0758310207,-88.2949379176,40.0758290207,-88.2951109176,40.0758370207,-88.3037509176,40.0764130207,-88.3037569176,40.0764150207,-88.3038759176,40.0764120207,-88.3039719176,40.0764140207,-88.3040979176,40.0776810207,-88.3041179176,40.0783820207,-88.3041569176,40.0792890207,-88.3042289176,40.0801260207,-88.3043149176,40.0807620207,-88.3043919176,40.0808050207,-88.3137929176,40.0808320207,-88.3140469176,40.0841320207,-88.3141029176,40.0841250207,-88.3124959176,40.0841070207,-88.3108159176,40.0840740207,-88.3080419176,40.0840540207,-88.3071149176,40.0840260207,-88.3050069176,40.0840250207,-88.3047409176,40.0840240207,-88.3046679176,40.0840240207,-88.3045639176,40.0840230207,-88.3044009176,40.0840220207,-88.3041979176,40.0839970207,-88.3016319176,40.0839900207,-88.3005509176,40.0839890207,-88.3004489176,40.0839730207,-88.2987589176,40.0841020207,-88.2987639176,40.0849980207,-88.2980169176,40.0852280207,-88.2978809176,40.0854380207,-88.2977539176,40.0854640207,-88.2975069176,40.0854580207,-88.2974039176,40.0854640207,-88.2964029176,40.0853020207,-88.2951779176,40.0863370207,-88.2951849176,40.0866230207,-88.2951889176,40.0878100207,-88.2951939176,40.0886710207,-88.2951949176,40.0897370207,-88.2952009176,40.0908150207,-88.2952109176,40.0911630207,-88.2952139176,40.0933020207,-88.2952259176,40.0951230207,-88.2952289176,40.0960230207,-88.2952259176,40.0976360207,-88.2952339176,40.0984640207,-88.2952419176,40.0992210207,-88.2952449176,40.0999440207,-88.2952449176,40.1012930207,-88.2952559176,40.1012930207,-88.2946119176,40.1015740207,-88.2946289176,40.1015690207,-88.2952579176,40.1020760207,-88.2952629176,40.1024860207,-88.2952729176,40.1027510207,-88.2952789176,40.1035260207,-88.2952829176,40.1056980207,-88.2953169176,40.1057200207,-88.2970009176,40.1057860207,-88.2986299176,40.1058270207,-88.3021129176,40.1057470207,-88.3022179176,40.1056900207,-88.3040989176,40.1061910207,-88.3040869176,40.1059720207,-88.3047309176,40.1059780207,-88.3048539176,40.1063560207,-88.3048439176,40.1063550207,-88.3049229176,40.1055820207,-88.3049209176,40.1027780207,-88.3049089176,40.1027750207,-88.3050309176,40.1032180207,-88.3059199176,40.1032480207,-88.3060289176,40.1036720207,-88.3093139176,40.1037630207,-88.3103869176,40.1037250207,-88.3103899176,40.1035060207,-88.3104459176,40.1033270207,-88.3105409176,40.1031130207,-88.3107279176,40.1029720207,-88.3109389176,40.1028760207,-88.3111269176,40.1028040207,-88.3113269176,40.1027560207,-88.3115879176,40.1027430207,-88.3119299176,40.1027550207,-88.3123049176,40.1028050207,-88.3125959176,40.1028660207,-88.3127629176,40.1029490207,-88.3129009176,40.1030790207,-88.3130689176,40.1031290207,-88.3131209176,40.1032320207,-88.3132189176,40.1027170207,-88.3143519176,40.1035540207,-88.3143639176,40.1058550207,-88.3144049176,40.1065620207,-88.3144219176,40.1077600207,-88.3144389176,40.1088000207,-88.3144639176,40.1091040207,-88.3144709176,40.1094420207,-88.3144769176,40.1092760207,-88.3172839176,40.1089890207,-88.3172929176,40.1058900207,-88.3173259176,40.1058690207,-88.3180159176,40.1058690207,-88.3215459176,40.1124680207,-88.3215489176,40.1126830207,-88.3215439176,40.1128000207,-88.3145259176,40.1128220207,-88.3141369176,40.1111100207,-88.3141709176,40.1104590207,-88.3141889176,40.1101010207,-88.3141759176,40.1100220207,-88.3127929176,40.1099990207,-88.3117729176,40.1088250207,-88.3115649176,40.1087850207,-88.3111399176,40.1082790207,-88.3112019176,40.1083230207,-88.3063529176,40.1083240207,-88.3058249176,40.1087750207,-88.3058309176,40.1100150207,-88.3058459176,40.1100120207,-88.3057469176,40.1099940207,-88.3051759176,40.1099930207,-88.3051109176,40.1124020207,-88.3051659176,40.1126760207,-88.3051639176,40.1126710207,-88.3049909176,40.1126710207,-88.3048239176,40.1126730207,-88.3044389176,40.1126980207,-88.3034609176,40.1126260207,-88.2978629176,40.1126490207,-88.2963299176,40.1126340207,-88.2954549176,40.1127350207,-88.2954549176,40.1129920207,-88.2941329176,40.1130370207,-88.2941169176,40.1130300207,-88.2939439176,40.1130550207,-88.2938339176,40.1132110207,-88.2928849176,40.1134080207,-88.2925109176,40.1135620207,-88.2925619176,40.1134400207,-88.2928599176,40.1133030207,-88.2932559176,40.1135000207,-88.2930019176,40.1137090207,-88.2926379176,40.1148490207,-88.2918009176,40.1148270207,-88.2918689176,40.1148060207,-88.2919799176,40.1147710207,-88.2923059176,40.1147730207,-88.2927259176,40.1147660207,-88.2943119176,40.1147810207,-88.2945359176,40.1148240207,-88.2947229176,40.1148840207,-88.2948859176,40.1149220207,-88.2950179176,40.1149370207,-88.2951359176,40.1149490207,-88.2954739176,40.1175490207,-88.2955069176,40.1195370207,-88.2955509176,40.1197840207,-88.2955539176,40.1200370207,-88.2955559176,40.1200550207,-88.2973569176,40.1200660207,-88.2985229176,40.1198080207,-88.2985139176,40.1196960207,-88.2985169176,40.1194240207,-88.2985349176,40.1182020207,-88.2984369176,40.1179400207,-88.2985869176,40.1176520207,-88.2983599176,40.1176490207,-88.2985809176,40.1175450207,-88.2985779176,40.1175590207,-88.2990509176,40.1176740207,-88.2990159176,40.1175390207,-88.3002049176,40.1182600207,-88.3002199176,40.1196190207,-88.3002449176,40.1197840207,-88.3003229176,40.1197990207,-88.3000039176,40.1198140207,-88.2996099176,40.1200750207,-88.2996449176,40.1200880207,-88.3008319176,40.1198330207,-88.3006279176,40.1197590207,-88.3008669176,40.1197200207,-88.3013149176,40.1196800207,-88.3014889176,40.1196090207,-88.3017179176,40.1195110207,-88.3019389176,40.1194200207,-88.3020929176,40.1192110207,-88.3023179176,40.1187370207,-88.3026989176,40.1185990207,-88.3028339176,40.1184770207,-88.3029919176,40.1180900207,-88.3039059176,40.1180160207,-88.3040439176,40.1178890207,-88.3042179176,40.1176600207,-88.3044189176,40.1175260207,-88.3045179176,40.1173920207,-88.3045889176,40.1172340207,-88.3046499176,40.1169580207,-88.3046989176,40.1155740207,-88.3048429176,40.1154770207,-88.3050059176,40.1155350207,-88.3051699176,40.1171280207,-88.3053009176,40.1172280207,-88.3053309176,40.1172850207,-88.3053479176,40.1174630207,-88.3054309176,40.1176170207,-88.3055399176,40.1177780207,-88.3056939176,40.1178890207,-88.3058319176,40.1180230207,-88.3060489176,40.1183430207,-88.3067439176,40.1184410207,-88.3069019176,40.1185400207,-88.3070229176,40.1190610207,-88.3074209176,40.1192740207,-88.3075989176,40.1193960207,-88.3077139176,40.1195100207,-88.3078719176,40.1196130207,-88.3080729176,40.1196880207,-88.3082609176,40.1197270207,-88.3083989176,40.1197980207,-88.3087619176,40.1199330207,-88.3102029176,40.1200800207,-88.3104399176,40.1202000207,-88.3101859176,40.1202600207,-88.3092619176,40.1203270207,-88.3087229176,40.1203790207,-88.3085169176,40.1204220207,-88.3084079176,40.1204540207,-88.3083279176,40.1205520207,-88.3081459176,40.1206780207,-88.3079489176,40.1208280207,-88.3077829176,40.1212900207,-88.3073819176,40.1214160207,-88.3072519176,40.1215190207,-88.3071179176,40.1216130207,-88.3069589176,40.1219570207,-88.3062069176,40.1220830207,-88.3059699176,40.1221580207,-88.3058639176,40.1222880207,-88.3057209176,40.1224020207,-88.3056329176,40.1225330207,-88.3055539176,40.1227340207,-88.3054549176,40.1231870207,-88.3053719176,40.1238850207,-88.3053269176,40.1241300207,-88.3052989176,40.1245050207,-88.3052259176,40.1249760207,-88.3051379176,40.1253110207,-88.3050759176,40.1260250207,-88.3048949176,40.1266320207,-88.3046799176,40.1269800207,-88.3045409176,40.1274880207,-88.3043019176,40.1275830207,-88.3042449176,40.1276570207,-88.3042009176,40.1279130207,-88.3040549176,40.1283440207,-88.3037979176,40.1285130207,-88.3036779176,40.1289380207,-88.3033819176,40.1291360207,-88.3032249176,40.1293880207,-88.3030239176,40.1298810207,-88.3025739176,40.1305270207,-88.3019019176,40.1309200207,-88.3014599176,40.1320420207,-88.3001959176,40.1322340207,-88.2999729176,40.1324050207,-88.2997759176,40.1326820207,-88.2994579176,40.1334890207,-88.2985299176,40.1341370207,-88.2978749176,40.1351600207,-88.2967059176,40.1351300207,-88.2966629176,40.1350630207,-88.2965229176,40.1350020207,-88.2963609176,40.1347960207,-88.2958099176,40.1352370207,-88.2958179176,40.1358130207,-88.2943939176,40.1367050207,-88.2943939176,40.1368850207,-88.2944169176,40.1395800207,-88.2913469176,40.1395150207,-88.2912009176,40.1357330207,-88.2810139176,40.1360280207,-88.2809779176,40.1362730207,-88.2809899176,40.1394360207,-88.2811399176,40.1394050207,-88.2809729176,40.1392910207,-88.2802859175,40.1392220207,-88.2796899175,40.1391720207,-88.2790659175,40.1391610207,-88.2786039175,40.1391950207,-88.2778299175,40.1392120207,-88.2776479175,40.1392430207,-88.2773009175,40.1392560207,-88.2771369175,40.1400080207,-88.2771959175,40.1404850207,-88.2772299175,40.1406100207,-88.2772389175,40.1407720207,-88.2772459175,40.1408690207,-88.2772529175,40.1410060207,-88.2772669175,40.1412380207,-88.2772789175,40.1413740207,-88.2772849175,40.1415890207,-88.2772949175,40.1424340207,-88.2773319175,40.1426350207,-88.2773399175,40.1431240207,-88.2773379175,40.1434420207,-88.2773359175,40.1438910207,-88.2773199175,40.1440080207,-88.2773069175,40.1439870207,-88.2753389175,40.1440130207,-88.2746949175,40.1433100207,-88.2747779175,40.1424430207,-88.2749449175,40.1424260207,-88.2747219175,40.1416220207,-88.2749119175,40.1397990207,-88.2745829175,40.1395030207,-88.2744949175,40.1394020207,-88.2745219175,40.1393040207,-88.2745499175,40.1392630207,-88.2745629175,40.1391920207,-88.2744159175,40.1392390207,-88.2744179175,40.1386070207,-88.2729589175,40.1382330207,-88.2720249175,40.1383200207,-88.2719829175,40.1383980207,-88.2719559175,40.1386390207,-88.2719029175,40.1385030207,-88.2715559175,40.1382590207,-88.2715809175,40.1381600207,-88.2715809175,40.1380590207,-88.2715859175,40.1379670207,-88.2713359175,40.1380660207,-88.2713169175,40.1381660207,-88.2712959175,40.1383840207,-88.2712519175,40.1387650207,-88.2711839175,40.1384010207,-88.2705519175,40.1381770207,-88.2706749175,40.1379170207,-88.2706349175,40.1378980207,-88.2705809175,40.1378560207,-88.2704619175,40.1377510207,-88.2704509175,40.1376720207,-88.2702489175,40.1377760207,-88.2702179175,40.1379960207,-88.2701579175,40.1381100207,-88.2704839175,40.1384920207,-88.2703249175,40.1383270207,-88.2699079175,40.1379790207,-88.2701109175,40.1379180207,-88.2699379175'
      @a = Georeference::GeoLocate.build_from_embedded_result(@string) 
    }

    specify 'with a collecting event, is valid' do
      @a.collecting_event = FactoryGirl.build(:valid_collecting_event) 
      expect(@a.valid?).to be_true
    end

  end

  context 'building a Georeference::GeoLocate with #build' do
    before(:each) {
      @a = Georeference::GeoLocate.build(request_params) 
    }

    specify '#build builds a Georeference::Geolocate instance' do
      expect(@a.class).to eq(Georeference::GeoLocate)
    end

    specify '#build(request_params) passes' do
      expect(Georeference::GeoLocate.build(request_params)).to be_true
    end

    specify 'with a collecting event #build produces a valid instance' do
      @a.collecting_event = FactoryGirl.build(:valid_collecting_event) 
      expect(@a.valid?).to be_true
    end

    specify 'a built, valid, instance is geometrically(?) correct' do
      @a.collecting_event = FactoryGirl.build(:valid_collecting_event) 
      expect(@a.save).to be_true
      expect(@a.error_geographic_item.geo_object.contains?(@a.geographic_item.geo_object)).to be_true
    end

    specify 'with invalid parameters returns a Georeference::GeoLocate instance with errors on :base' do
      pending
    end

    specify '#with doPoly false instance should have no error polygon' do
      pending
    end

    # TODO: what was the 3 reason again?
    # TODO: @mjy three meters was chosen as a minimum, because that is (usually) the smallest circle of uncertainty provided by current GPS units.
    specify 'with doUncert false error_radius should be 3(?)' do
      pending
    end
  end 

  context 'instance methods' do
    specify 'api_response=(response) populates .geographic_item' do  
      expect(geo_locate.api_response = response).to be_true
      expect(geo_locate.geographic_item).not_to be_nil
    end

    specify 'api_response=(response.result) populates .error_geographic_item' do 
      expect(geo_locate.api_response = response).to be_true
      expect(geo_locate.error_geographic_item).not_to be_nil
      expect(geo_locate.error_radius.to_i > 5000).to be_true  # Bad test
    end

    specify '.request_hash' do
      expect(georeference_from_build.request_hash.to_s).to eq('{"country"=>"USA", "state"=>"IL", "county"=>"", "locality"=>"Urbana", "hwyX"=>"false", "enableH2O"=>"false", "doUncert"=>"true", "doPoly"=>"true", "displacePoly"=>"false", "languageKey"=>"0", "fmt"=>"json"}')
    end
  end


  context 'Request' do
    specify 'has a @response' do
      expect(request.respond_to?(:response)).to be_true
    end

    specify 'has @request_params' do
      expect(request.request_params).to eq(Georeference::GeoLocate::Request::REQUEST_PARAMS.merge(request_params))
    end

    specify 'has @request_param_string' do
      expect(request.request_param_string).to be(nil)
    end

    specify '.build_param_string' do # '.make_request builds a request string' do
      expect(request.build_param_string).to be_true
      expect(request.request_param_string).to eq('country=USA&state=IL&county=&locality=Urbana&hwyX=false&enableH2O=false&doUncert=true&doPoly=true&displacePoly=false&languageKey=0&fmt=json')
    end

    specify '.locate' do
      expect(request.locate).to be_true
    end

    specify '.locate populates @response' do
      expect(request.locate).to be_true
      expect(request.response).to_not be_nil
      expect(request.response.class).to eq(Georeference::GeoLocate::Response)
    end

    specify '.succeeded?' do
      expect(request.locate).to be_true
      expect(request.succeeded?).to be_true
    end
  end


  context 'Response' do
    specify 'contains some @result (in json)' do
      request.locate
      expect(response.result.keys.include?('numResults')).to be_true 
    end
  end

end
