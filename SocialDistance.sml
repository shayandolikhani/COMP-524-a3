fun givenSafe(13,30,30) = true |
		givenSafe(6,30,10) = true |
		givenSafe(27,30,50) = true |
		givenSafe(13,15,50) = true |
		givenSafe(13,120,10) = true |
		givenSafe(27,120,30) = true |
		givenSafe(6,15,30) = true |
		givenSafe(Distance, Duration, Exhalation) = false;

fun distInterpolation Distance =
	if Distance < 6 then 0
	else
	if (Distance < 13 andalso Distance >= 6) then 6
	else
	if (Distance < 27 andalso Distance >= 13) then 13
	else
	27;
	
fun durInterpolation Duration =
	if Duration > 120 then 200
	else
	if (Duration > 30 andalso Duration <= 120) then 120
	else
	if (Duration > 15 andalso Duration <= 30) then 30
	else
	15;

fun exhInterpolation Exhalation = 
	if Exhalation > 50 then 200
	else
	if (Exhalation > 30 andalso Exhalation <= 50) then 50
	else
	if (Exhalation > 10 andalso Exhalation <= 30) then 30
	else
	10;

fun interpolatedSafe (Distance, Duration, Exhalation) = 
	let
		val intDist = distInterpolation(Distance)
		val intDur = durInterpolation(Duration)
		val intExh = exhInterpolation(Exhalation)
	in
		givenSafe(intDist, intDur, intExh)
	end;
	
val SAFETY_TABLE =
  [(13,30,30),(6,30,10),(27,30,50),(13,15,50),(13,120,10),(27,120,30),
   (6,15,30)] : (int * int * int) list;

fun
	derivedSafeRec (Distance, Duration, Exhalation, nil) = false | 
	derivedSafeRec (Distance, Duration, Exhalation, (Dist, Dur, Exh) :: tail) = 
		if (Distance >= Dist andalso Duration <= Dur andalso Exhalation <= Exh) then true
		else
		derivedSafeRec (Distance, Duration, Exhalation, tail);
		
fun listDerivedSafe(Distance, Duration, Exhalation) = derivedSafeRec(Distance, Duration, Exhalation, SAFETY_TABLE);

	
fun printSafety (safetyComputer, (Distance, Duration, Exhalation)) = 
		if (safetyComputer(Distance, Duration, Exhalation)) then
		print("Distance:"^Int.toString(Distance)^" Duration:"^Int.toString(Duration)^" Exhalation:"^Int.toString(Exhalation)^" Safe:true"^"\n")
		else
		print("Distance:"^Int.toString(Distance)^" Duration:"^Int.toString(Duration)^" Exhalation:"^Int.toString(Exhalation)^" Safe:false"^"\n");

		
fun concisePrintSafety (safetyComputer, (Distance, Duration, Exhalation)) = 
		if (safetyComputer(Distance, Duration, Exhalation)) then
		print("("^Int.toString(Distance)^", "^Int.toString(Duration)^", "^Int.toString(Exhalation)^", true)"^"\n")
		else
		print("("^Int.toString(Distance)^", "^Int.toString(Duration)^", "^Int.toString(Exhalation)^", false)"^"\n");
		
fun 
		listPrintSafety (_, _, nil) = () |
		listPrintSafety (printSafetyFun, safetyComputer, listHead :: listTail) =
				let 
						val printOutput = printSafetyFun(safetyComputer, listHead)
				in
						listPrintSafety(printSafetyFun, safetyComputer, listTail)
				end;

fun
	matchingSafeRec (matcherFun, nil, (Distance, Duration, Exhalation)) = false | 
	matchingSafeRec (matcherFun, (Dist, Dur, Exh) :: tail, (Distance, Duration, Exhalation)) = 
		if matcherFun((Dist, Dur, Exh), (Distance, Duration, Exhalation)) then true
		else
		matchingSafeRec (matcherFun, tail, (Distance, Duration, Exhalation));


fun matchingSafe(matcherFun, (Distance, Duration, Exhalation)) = matchingSafeRec(matcherFun, SAFETY_TABLE, (Distance, Duration, Exhalation));

fun derivedSafeMatcher((Dist, Dur, Exh), (Distance, Duration, Exhalation)) =
		if (Distance >= Dist andalso Duration <= Dur andalso Exhalation <= Exh) then true
		else
		false;

fun matchingDerivedSafe(Distance, Duration, Exhalation) = matchingSafe(derivedSafeMatcher, (Distance, Duration, Exhalation));

fun givenSafeMatcher((Dist, Dur, Exh), (Distance, Duration, Exhalation)) =
		if (Distance = Dist andalso Duration = Dur andalso Exhalation = Exh) then true
		else
		false;

fun matchingGivenSafe(Distance, Duration, Exhalation) = matchingSafe(givenSafeMatcher, (Distance, Duration, Exhalation));

fun toThreeArgumentCurryableFunction
	tupleBasedThreeArgumentFunction x y z = tupleBasedThreeArgumentFunction (x, y, z);

val curryableInterpolatedSafe = toThreeArgumentCurryableFunction interpolatedSafe;

val curriedOnceInterpolatedSafe = curryableInterpolatedSafe 13;

val curriedTwiceInterpolatedSafe = curriedOnceInterpolatedSafe 30;

fun curryableMatchingSafe matcherFun (Distance, Duration, Exhalation) = matchingSafeRec(matcherFun, SAFETY_TABLE, (Distance, Duration, Exhalation));

val curriedMatchingDerivedSafe = curryableMatchingSafe derivedSafeMatcher;

val curriedMatchingGivenSafe = curryableMatchingSafe givenSafeMatcher;