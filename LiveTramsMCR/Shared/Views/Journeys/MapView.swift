//
//  MapView.swift
//  LiveTramsMCR (iOS)
//  Created by shaundon (https://gist.github.com/shaundon/00be84deb3450e31db90a31d5d5b7adc)
//  Modified
//

import SwiftUI
import MapKit
import OrderedCollections

struct ExampleRouteCoordinates {
    static let exampleCoordinates: [[Double]] = [
        //"Deansgate",
                        [ -2.2503454594, 53.4747237826 ],
                [ -2.2510329833, 53.4747544265 ],
                [ -2.2510906308, 53.4747573628 ],
                [ -2.2514413082, 53.4747751495 ],
                [ -2.2517301645, 53.4748002455 ],
                [ -2.2537490707, 53.4749871496 ],
                [ -2.2541938879, 53.4750226085 ],
                [ -2.2543458813, 53.4750326164 ],
                [ -2.2548291168, 53.4750522719 ],
                [ -2.2552722573, 53.4750562807 ],
                [ -2.2554862653, 53.4750508852 ],
                [ -2.2570217217, 53.4749478834 ],
                [ -2.2572396425, 53.4749290917 ],
                [ -2.257462612, 53.4749055159 ],
                [ -2.2576937123, 53.4748710556 ],
                [ -2.2578950034, 53.4748380067 ],
                [ -2.2581653343, 53.4747780335 ],
                [ -2.2585013746, 53.4746961761 ],
                [ -2.2603597703, 53.4741763001 ],
                [ -2.2615328152, 53.4738482998 ],
                [ -2.2617310223, 53.47380015 ],
                [ -2.2622418291, 53.4736783608 ],
                [ -2.2624735259, 53.4736201685 ],
                [ -2.2627020642, 53.473553174 ],
                [ -2.2629781485, 53.4734611862 ],
                [ -2.263196288, 53.4733817195 ],
                [ -2.2641158511, 53.4729697706 ],
                [ -2.2644806302, 53.4727986027 ],
                [ -2.2647177104, 53.4726694928 ],
                [ -2.2648940106, 53.472554628 ],
                [ -2.2650878858, 53.4724096128 ],
                [ -2.265184136, 53.4723259249 ],
                [ -2.2653482584, 53.4721694786 ],
                [ -2.2654811663, 53.4720281025 ],
                [ -2.2655800969, 53.4719178114 ],
                [ -2.2660468276, 53.4714030529 ],
                [ -2.2665977327, 53.4707870201 ],
                [ -2.2668431441, 53.4705620057 ],
                [ -2.2671523572, 53.4703110604 ],
                [ -2.2675495027, 53.4700194787 ],
                [ -2.2677815827, 53.4698492221 ],
                [ -2.2681604599, 53.4695768148 ],
                [ -2.2686207838, 53.4692200369 ],
                [ -2.2687762539, 53.469114999 ],
                [ -2.2688546329, 53.4690571349 ],
                [ -2.269009906, 53.4689210058 ],
                [ -2.2691932646, 53.4687476186 ],
                [ -2.2694314587, 53.4685651996 ],
                [ -2.2696196231, 53.4684449948 ],
                [ -2.2698477033, 53.4683122954 ],
                [ -2.2700447529, 53.4682039348 ],
                        //"South of cornbrook (jnc before joining alty line)",
                        [ -2.2700447529, 53.4682039348 ],
                    [ -2.2704199134, 53.4680181578 ],
                    [ -2.2705095736, 53.4679749991 ],
                    [ -2.270588119, 53.4679251329 ],
                    [ -2.2706923895, 53.4678365578 ],
                    [ -2.2707743561, 53.4677561317 ],
                    [ -2.2708434516, 53.4676842647 ],
                    [ -2.2709432562, 53.4675971466 ],
                    [ -2.2711462748, 53.4674309832 ],
                    [ -2.2712946669, 53.4673283934 ],
                    [ -2.2713938486, 53.4672620309 ],
                    [ -2.271475395, 53.4672130473 ],
                    [ -2.2715828624, 53.4671587106 ],
                    [ -2.2717214398, 53.4670954046 ],
                    [ -2.2718634251, 53.4670398208 ],
                    [ -2.272077094, 53.466969243 ],
                    [ -2.2722798598, 53.4669205317 ],
                    [ -2.272916643, 53.4667842904 ],
                    [ -2.2732219753, 53.4667142207 ],
                    [ -2.2734505533, 53.4666436064 ],
                    [ -2.2736641872, 53.4665659338 ],
                    [ -2.2738737708, 53.4664792725 ],
                    [ -2.2744117119, 53.4662308381 ],
                    [ -2.274822213, 53.466060247 ],
                    [ -2.2753536631, 53.4658674444 ],
                    [ -2.2758592736, 53.4657118127 ],
                    [ -2.2763341855, 53.4655731391 ],
                    [ -2.2770647864, 53.4653937117 ],
                    [ -2.2774262144, 53.4653169398 ],
                    [ -2.277554835, 53.4652906739 ],
                    [ -2.2780294948, 53.4651935124 ],
                    [ -2.2782241089, 53.4651536996 ],
                    [ -2.2786795442, 53.4650587374 ],
                    //"South of Pomona",
                    [ -2.2786796659, 53.4650589169 ],
                    [ -2.2794749301, 53.4648934362 ],
                    [ -2.2797918868, 53.4648172103 ],
                    [ -2.2800539432, 53.4647602576 ],
                    [ -2.2802717323, 53.4647153536 ],
                    [ -2.28039812, 53.4646890899 ],
                    [ -2.2805495724, 53.4646605201 ],
                    [ -2.2807058896, 53.4646341859 ],
                    [ -2.2810024414, 53.4645937701 ],
                    [ -2.2812990027, 53.4645708813 ],
                    [ -2.2815619941, 53.4645626231 ],
                    [ -2.2816464513, 53.4645624246 ],
                    [ -2.281849537, 53.4645678793 ],
                    [ -2.2819644561, 53.4645729121 ],
                    [ -2.2821377987, 53.4645861576 ],
                    [ -2.2822753714, 53.4646001253 ],
                    [ -2.2824196896, 53.4646182027 ],
                    [ -2.2825835491, 53.4646437843 ],
                    [ -2.2827024295, 53.464666955 ],
                    [ -2.2828842571, 53.4647057968 ],
                    [ -2.282969096, 53.4647268094 ],
                    [ -2.2831743974, 53.4647823051 ],
                    [ -2.2832918666, 53.4648174333 ],
                    [ -2.2834581696, 53.4648750881 ],
                    [ -2.283674803, 53.4649537376 ],
                    [ -2.2847439807, 53.4653413768 ],
                    [ -2.2850543573, 53.4654537688 ],
                    [ -2.2853555068, 53.4655601686 ],
                    [ -2.2860490269, 53.4658010441 ],
                    [ -2.2861760044, 53.4658448657 ],
                    [ -2.2863093326, 53.4658901905 ],
                    [ -2.2865042248, 53.465951277 ],
                    [ -2.2867660461, 53.4660261349 ],
                    [ -2.2875084333, 53.4662371372 ],
                    [ -2.288507781, 53.4665194053 ],
                    [ -2.2887824304, 53.4665989918 ],
                    [ -2.2889063961, 53.4666379542 ],
                    [ -2.2890318734, 53.4666798881 ],
                    [ -2.289288475, 53.4667722719 ],
                    [ -2.2903372164, 53.4671549606 ],
                    [ -2.2905286043, 53.4672261973 ],
                    [ -2.290708545, 53.4672953133 ],
                    [ -2.2908927571, 53.4673699915 ],
                    [ -2.2910778456, 53.4674471751 ],
                    [ -2.2913259551, 53.4675498223 ],
                    [ -2.2915122805, 53.4676270113 ],
                    [ -2.2917059576, 53.467704173 ],
                    [ -2.2918994677, 53.467778827 ],
                    [ -2.2920927185, 53.4678485286 ],
                    [ -2.2939755589, 53.4685204731 ],
                    [ -2.2940930813, 53.4685607135 ],
                    [ -2.2941851671, 53.4685866346 ],
                    [ -2.2942915079, 53.4686065881 ],
                    [ -2.2943941678, 53.4686170316 ],
                    [ -2.2945345195, 53.4686166858 ],
                    [ -2.2946370586, 53.4686074444 ],
                    [ -2.2947434783, 53.4685864274 ],
                    [ -2.2948219453, 53.4685642118 ],
                    [ -2.2949803911, 53.468505323 ],
                    [ -2.2952007476, 53.4684177064 ],
                    [ -2.295309145, 53.4683756506 ],
                    [ -2.295369738, 53.4683545665 ],
                    [ -2.295443985, 53.4683343473 ],
                    [ -2.2955582268, 53.468311863 ],
                    [ -2.295675534, 53.4683013348 ],
                    [ -2.2957927797, 53.4683014941 ],
                    [ -2.2959120879, 53.4683123356 ],
                    [ -2.2960047534, 53.4683305327 ],
                    [ -2.2961013152, 53.468356621 ],
                    [ -2.2962249543, 53.4684010688 ],
                    [ -2.2967749705, 53.4686012552 ],
                    [ -2.297323739, 53.4688010917 ],
                    [ -2.2974376688, 53.468841868 ],
                    [ -2.2975658163, 53.4688735394 ],
                    [ -2.297630983, 53.4688840735 ],
                    [ -2.2977096535, 53.4688911583 ],
                    [ -2.297842823, 53.4688933433 ],
                    [ -2.2980199986, 53.4688851714 ],
                    [ -2.2981354689, 53.4688789509 ],
                    [ -2.2982144596, 53.4688779448 ],
                    [ -2.2982974623, 53.4688819623 ],
                    [ -2.2984005225, 53.4688955474 ],
                    [ -2.2984772574, 53.468910178 ],
                    [ -2.2985896099, 53.468938472 ],
                    [ -2.3007345174, 53.4694971455 ],
                    [ -2.3009509042, 53.4695524918 ],
                    [ -2.3013755541, 53.4696563802 ],
                    [ -2.3015948851, 53.4697071393 ],
                    [ -2.3022665497, 53.4698601705 ],
                    [ -2.3024226796, 53.4698948106 ],
                    [ -2.3025150582, 53.469908238 ],
                    [ -2.3026266338, 53.4699138862 ],
                    [ -2.3027282008, 53.4699102117 ],
                    [ -2.3028251086, 53.4698953133 ],
                    [ -2.3029235526, 53.4698718807 ],
                    [ -2.3030397698, 53.4698311446 ],
                    [ -2.3031249892, 53.4697804292 ],
                    [ -2.3031883589, 53.4697309381 ],
                    [ -2.3032239821, 53.4696922951 ],
                    [ -2.3032723662, 53.469632685 ],
                    [ -2.3033038114, 53.4695827271 ],
                    [ -2.3034754589, 53.4693041726 ],
                    [ -2.3035342267, 53.4692199162 ],
                    [ -2.3042460606, 53.4682653037 ],
                    [ -2.3046003156, 53.4678164398 ],
                    [ -2.3047181048, 53.4676846793 ],
                    [ -2.304814214, 53.4675946635 ],
                    [ -2.304921792, 53.4675118001 ],
                    [ -2.3050181009, 53.4674498191 ],
                    [ -2.3051381422, 53.4673889456 ],
                    [ -2.305258268, 53.4673399367 ],
                    [ -2.3053341017, 53.4673153826 ],
                    [ -2.3053841589, 53.4672988138 ],
                    [ -2.3054902804, 53.4672736514 ],
                    [ -2.3055727492, 53.4672564508 ],
                    [ -2.3056466839, 53.4672444046 ],
                    [ -2.305746206, 53.4672316543 ],
                    [ -2.3058580477, 53.4672228272 ],
                    [ -2.3059813569, 53.4672208917 ],
                    [ -2.3061701613, 53.4672231916 ],
                    [ -2.3064017223, 53.4672327517 ],
                    [ -2.3065426349, 53.4672426351 ],
                    [ -2.3067186027, 53.4672570929 ],
                    [ -2.3069138579, 53.4672766242 ],
                    [ -2.3071321273, 53.4672999697 ],
                    [ -2.3073217827, 53.4673199642 ],
                    [ -2.3074785136, 53.46733421 ],
                    [ -2.3078363972, 53.4673626668 ],
                    [ -2.3081652837, 53.4673805912 ],
                    [ -2.3085164818, 53.4673926232 ],
                    [ -2.309073014, 53.4674095941 ],
                    [ -2.3098910229, 53.4674337006 ],
                    [ -2.3102700512, 53.4674467335 ],
                    [ -2.310470323, 53.4674556392 ],
                    [ -2.3108451812, 53.4674772203 ],
                    [ -2.3115384225, 53.4675219473 ],
                    [ -2.3117561066, 53.4675347692 ],
                    [ -2.3121186049, 53.4675468418 ],
                    [ -2.312471587, 53.4675470824 ],
                    [ -2.3128150133, 53.4675342327 ],
                    [ -2.3131535453, 53.4675113187 ],
                    [ -2.3133779309, 53.4674889836 ],
                    [ -2.3136479893, 53.4674626623 ],
                    [ -2.3139518205, 53.4674344535 ],
                    [ -2.3142884676, 53.4674114604 ],
                    [ -2.3146243312, 53.4673987064 ],
                    [ -2.3149791626, 53.4673965976 ],
                    [ -2.3152828643, 53.4674019942 ],
                    [ -2.3167789512, 53.4674359371 ],
                    [ -2.3168813057, 53.4674378213 ],
                    [ -2.316987982, 53.4674354693 ],
                    [ -2.3170639315, 53.4674273566 ],
                    [ -2.3171217403, 53.4674186631 ],
                    [ -2.3172211602, 53.4673945868 ],
                    [ -2.3173896815, 53.4673409421 ],
                    [ -2.3174654021, 53.4673203356 ],
                    [ -2.3175588101, 53.4673041851 ],
                    [ -2.3176603536, 53.4672983406 ],
                    [ -2.3177647055, 53.4673014772 ],
                    [ -2.31784635, 53.4673077305 ],
                    [ -2.3192571267, 53.4674092577 ],
                    [ -2.3196342833, 53.4674374474 ],
                    [ -2.3199798322, 53.4674749794 ],
                    [ -2.3203388966, 53.467524959 ],
                    [ -2.3206837672, 53.4675863016 ],
                    [ -2.3208381335, 53.4676178752 ],
                    [ -2.3209972406, 53.4676528515 ],
                    [ -2.3211604858, 53.467691232 ],
                    [ -2.3214972416, 53.4677808094 ],
                    [ -2.3220145888, 53.4679194146 ],
                    [ -2.3222825267, 53.4679915586 ],
                    [ -2.3224315796, 53.4680253018 ],
                    [ -2.3225490107, 53.4680506005 ],
                    [ -2.3227029961, 53.4680792065 ],
                    [ -2.3228624068, 53.4681041123 ],
                    [ -2.3230218966, 53.4681235345 ],
                    [ -2.3232647891, 53.46815028 ],
                    [ -2.3243797567, 53.4682676521 ],
                    [ -2.325389453, 53.468373536 ],
                    [ -2.3256277307, 53.4683972333 ],
                    [ -2.3257765962, 53.4684078811 ],
                    [ -2.3259081593, 53.4684113854 ],
                    [ -2.3260611602, 53.4684092577 ],
                    [ -2.3262111167, 53.4683990485 ],
                    [ -2.3263603828, 53.4683812995 ],
                    [ -2.3265072519, 53.4683554582 ],
                    [ -2.3266454736, 53.4683216586 ],
                    [ -2.3267874865, 53.4682793902 ],
                    [ -2.3269336185, 53.4682242655 ],
                    [ -2.3270376102, 53.468180034 ],
                    [ -2.3272135977, 53.468099398 ],
                    [ -2.327712327, 53.4678645624 ],
                    [ -2.3278555031, 53.4677975798 ],
                    [ -2.3279202414, 53.4677695455 ],
                    [ -2.3280152161, 53.4677322592 ],
                    [ -2.3281378711, 53.4676921999 ],
                    [ -2.3282677566, 53.4676560844 ],
                    [ -2.3284005564, 53.4676287516 ],
                    [ -2.3285498976, 53.467603629 ],
                    [ -2.3288514353, 53.4675681976 ],
                    [ -2.3289509237, 53.4675538191 ],
                    [ -2.3290503613, 53.4675309015 ],
                    [ -2.3291506946, 53.4674971949 ],
                    [ -2.3292273143, 53.4674630147 ],
                    [ -2.3292785163, 53.4674339385 ],
                    [ -2.3293226227, 53.4674047831 ],
                    [ -2.329417171, 53.4673281448 ],
                    [ -2.3308554737, 53.4661234326 ],
                    [ -2.332541433, 53.4647070223 ],
                    [ -2.332673562, 53.4645952299 ],
                    [ -2.332889453, 53.4644102334 ],
                    [ -2.3331016994, 53.4642197636 ],
                    [ -2.3333101967, 53.4640277758 ],
                    [ -2.3337717054, 53.4635856259 ],
                    [ -2.3338610713, 53.4635013495 ],
                    [ -2.3339354302, 53.4634337531 ],
                    [ -2.3340090087, 53.4633780957 ],
                    [ -2.3340920349, 53.4633229601 ],
                    [ -2.3341620118, 53.4632825034 ],
                    [ -2.3342252225, 53.4632512342 ],
                    [ -2.3343491302, 53.4632004777 ],
                    [ -2.3344570357, 53.4631662062 ],
                    [ -2.3345507146, 53.4631405139 ],
                    [ -2.3346578167, 53.4631152331 ],
                    [ -2.3347497299, 53.4631025701 ],
                    [ -2.3348510817, 53.4630892512 ],
                    [ -2.3349810404, 53.4630803549 ],
                    [ -2.3351223537, 53.4630788781 ],
                    [ -2.335262864, 53.4630863829 ],
                    [ -2.3353758564, 53.463099637 ],
                    [ -2.3354926008, 53.4631169163 ],
                    [ -2.33560669, 53.4631432006 ],
                    [ -2.3357388802, 53.4631824492 ],
                    [ -2.335903536, 53.4632436279 ],
                    [ -2.3360667798, 53.4633147878 ],
                    [ -2.3384438141, 53.4643470105 ],
                    [ -2.3386885717, 53.4644527116 ],
                    [ -2.3391387336, 53.4646377081 ],
                    [ -2.3393965816, 53.4647355502 ],
                    [ -2.3401617202, 53.4650299873 ],
                    [ -2.3407393681, 53.4652525358 ],
                    [ -2.3409783097, 53.4653453052 ],
                    [ -2.3419892513, 53.4657339268 ],
                    [ -2.3425190777, 53.4659375482 ],
                    [ -2.3426247318, 53.4659792116 ],
                    [ -2.3427245612, 53.4660083075 ],
                    [ -2.3428263492, 53.4660318249 ],
                    [ -2.3429326571, 53.4660479584 ],
                    [ -2.3430333277, 53.4660561173 ],
                    [ -2.3432012709, 53.4660607561 ],
                    [ -2.3433047659, 53.4660661201 ],
                    [ -2.343386419, 53.466073255 ],
                    [ -2.3435099196, 53.4660938326 ],
                    [ -2.3436097318, 53.4661206808 ],
                    [ -2.3436792265, 53.4661442907 ],
                    [ -2.3437972415, 53.4661943665 ],
                    [ -2.3440418652, 53.4662972614 ],
                    [ -2.3458042503, 53.4670553338 ],
                    [ -2.3466107401, 53.4674004754 ],
                    [ -2.3468315711, 53.4674933761 ],
                    [ -2.3469372002, 53.4675309909 ],
                    [ -2.3470295344, 53.4675674759 ],
                    [ -2.3471313223, 53.4676068905 ],
                    [ -2.3472608095, 53.4676607947 ],
                    [ -2.3473694115, 53.467713762 ],
                    [ -2.3477940921, 53.4679165082 ],
                    [ -2.3482228892, 53.4681211194 ],
                    //"Trafford Centre"

    ]
}

struct MapView: UIViewRepresentable {
    
    let region: MKCoordinateRegion
    let lineCoordinatesFromOrigin: OrderedDictionary<String, CLLocationCoordinate2D>
    var lineCoordinatesFromInterchange: OrderedDictionary<String, CLLocationCoordinate2D>? = nil
    let lineColorFromOrigin: Color
    var lineColorFromInterchange: Color? = nil
    @Environment(\.colorScheme) private var displayMode
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        mapView.preferredConfiguration = MKStandardMapConfiguration(emphasisStyle: .muted)
        
        var testCoordinates: [CLLocationCoordinate2D] = []
        for coordinate in ExampleRouteCoordinates.exampleCoordinates {
            testCoordinates.append(CLLocationCoordinate2D(latitude: coordinate[1], longitude: coordinate[0]))
        }
        let testPolyline = RoutePolyline(coordinates: testCoordinates, count: testCoordinates.count)
        testPolyline.routeColor = .red
        
        
        var stopAnnotations: [StopAnnotation] = []
        var routePolylines: [RoutePolyline] = []
        let polyline = RoutePolyline(coordinates: testCoordinates, count: testCoordinates.count)
        polyline.routeColor = UIColor(lineColorFromOrigin)
        routePolylines.append(polyline)
        routePolylines.append(testPolyline)
        for (index, stop) in lineCoordinatesFromOrigin.keys.enumerated() {
            let annotation = StopAnnotation()
            if index == 0 {
                annotation.subtitle = "Start"
                annotation.stopSize = CGSize(width: 30, height: 30)
            }
            
            if index == lineCoordinatesFromOrigin.keys.count - 1 && lineColorFromInterchange != nil{
                annotation.subtitle = "Change here"
                annotation.stopSize = CGSize(width: 30, height: 30)
            }
            
            if index == lineCoordinatesFromOrigin.keys.count - 1 && lineColorFromInterchange == nil{
                annotation.subtitle = "Destination"
                annotation.stopSize = CGSize(width: 30, height: 30)
            }
            
            annotation.stopColor = displayMode == .dark ? .white : .black
            annotation.coordinate = lineCoordinatesFromOrigin[stop]!
            annotation.title = stop
            stopAnnotations.append(annotation)
        }
        
        if (lineCoordinatesFromInterchange != nil && lineColorFromInterchange != nil) {
            let polylineFromInterchange = RoutePolyline(coordinates: lineCoordinatesFromInterchange!.map {$0.value}, count: lineCoordinatesFromInterchange!.count)
            polylineFromInterchange.routeColor = UIColor(lineColorFromInterchange!)
            routePolylines.append(polylineFromInterchange)
            
            for (index, stop) in lineCoordinatesFromInterchange!.keys.enumerated() {
                if index == 0 {
                    continue
                }
                
                let annotation = StopAnnotation()
                
                if index == lineCoordinatesFromInterchange!.keys.count - 1 {
                    annotation.subtitle = "Destination"
                    annotation.stopSize = CGSize(width: 30, height: 30)
                }
                 
                annotation.stopColor = displayMode == .dark ? .white : .black
                annotation.coordinate = lineCoordinatesFromInterchange![stop]!
                annotation.title = stop
                stopAnnotations.append(annotation)
            }
        }
        
        mapView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 100, right: 100)
        mapView.addOverlays(routePolylines)
        mapView.addAnnotations(stopAnnotations)
        mapView.region = region
        mapView.setRegion(region, animated: true)
        
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        view.region = region
        
        view.overlays.forEach {
            view.removeOverlay($0)
        }
        
        view.annotations.forEach {
            view.removeAnnotation($0)
        }
        
        let testCoordinates = ExampleRouteCoordinates.exampleCoordinates.map { CLLocationCoordinate2D(latitude: $0[1], longitude: $0[0])}
        let testPolyline = RoutePolyline(coordinates: testCoordinates, count: testCoordinates.count)
        testPolyline.routeColor = .red
        var stopAnnotations: [StopAnnotation] = []
        var routePolylines: [RoutePolyline] = []
        let polyline = RoutePolyline(coordinates: lineCoordinatesFromOrigin.map {$0.value}, count: lineCoordinatesFromOrigin.count)
        polyline.routeColor = UIColor(lineColorFromOrigin)
        routePolylines.append(polyline)
        routePolylines.append(testPolyline)
        for (index, stop) in lineCoordinatesFromOrigin.keys.enumerated() {
            let annotation = StopAnnotation()
            if index == 0 {
                annotation.subtitle = "Start"
                annotation.stopSize = CGSize(width: 30, height: 30)
            }
            
            if index == lineCoordinatesFromOrigin.keys.count - 1 && lineColorFromInterchange != nil{
                annotation.subtitle = "Change here"
                annotation.stopSize = CGSize(width: 30, height: 30)
            }
            
            if index == lineCoordinatesFromOrigin.keys.count - 1 && lineColorFromInterchange == nil{
                annotation.subtitle = "Destination"
                annotation.stopSize = CGSize(width: 30, height: 30)
            }
            annotation.stopColor = displayMode == .dark ? .white : .black
            annotation.coordinate = lineCoordinatesFromOrigin[stop]!
            annotation.title = stop
            stopAnnotations.append(annotation)
        }
        
        if (lineCoordinatesFromInterchange != nil && lineColorFromInterchange != nil) {
            let polylineFromInterchange = RoutePolyline(coordinates: lineCoordinatesFromInterchange!.map {$0.value}, count: lineCoordinatesFromInterchange!.count)
            polylineFromInterchange.routeColor = UIColor(lineColorFromInterchange!)
            routePolylines.append(polylineFromInterchange)
            
            
            for (index, stop) in lineCoordinatesFromInterchange!.keys.enumerated() {
                if index == 0 {
                    continue
                }
                
                let annotation = StopAnnotation()
                if index == lineCoordinatesFromInterchange!.keys.count - 1 {
                    annotation.subtitle = "Destination"
                    annotation.stopSize = CGSize(width: 30, height: 30)
                }
                    
                annotation.stopColor = displayMode == .dark ? .white : .black
                annotation.coordinate = lineCoordinatesFromInterchange![stop]!
                annotation.title = stop
                stopAnnotations.append(annotation)
                
            }
        }
        
        view.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 100, right: 100)
        view.addOverlays(routePolylines)
        view.addAnnotations(stopAnnotations)
        view.region = region
        view.setRegion(region, animated: true)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
}

class Coordinator: NSObject, MKMapViewDelegate {
    var parent: MapView
    
    init(_ parent: MapView) {
        self.parent = parent
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let routePolyline = overlay as? RoutePolyline
            let renderer = MKPolylineRenderer(polyline: routePolyline!)
            renderer.strokeColor = routePolyline!.routeColor
            renderer.lineWidth = 5
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is StopAnnotation {
            let annotation = annotation as? StopAnnotation
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: UUID().uuidString)
            annotationView.canShowCallout = true
            annotationView.image = UIImage(systemName: "smallcircle.filled.circle")?.withTintColor(annotation!.stopColor)
            annotationView.image = UIGraphicsImageRenderer(size: annotation!.stopSize).image {
                 _ in annotationView.image!.draw(in:CGRect(origin: .zero, size: annotation!.stopSize))
            }
            return annotationView
        }
        

        return nil
    }
}

class RoutePolyline: MKPolyline {
    var routeColor: UIColor = UIColor.clear
}

class StopAnnotation: MKPointAnnotation {
    var stopColor: UIColor = .white
    var stopSize: CGSize = CGSize(width: 15, height: 15)
}
