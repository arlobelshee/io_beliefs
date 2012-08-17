
// The test framework. These should be in a separate file.
Test := Object clone
Test execute := method(
	badness := list()
	e := try(doMessage(run))
	e catch(AssertionFailedException,
		badness append(e)
	)
	return badness
)

Test belief := method(
	name := call message argAt(0)
	call target run := call message argAt(1)
)


AssertionFailedException := Exception clone

run_tests := method(tests,
	failures := (tests map(execute) flatten)
	failures foreach(f, (f error .. "\n") print)
	number_run := tests size
	"\n\nQuestioned #{number_run} beliefs.\n" interpolate print
	(failures size == 0) ifTrue(
		"holy crap! You were right!\n" print
	) ifFalse(
		"#{failures size} beliefs crushed.\n" interpolate print
	)
)

hope_that := method(
	(call evalArgAt(0)) ifFalse (
		AssertionFailedException raise("Oh why do you believe #{call message argAt(0)}? It just ain't true!" interpolate)
	)
)


// My test definitions. We want this to have less boilerplate.

foo := Test clone
foo belief(something_rotten_in_the_state,
	hope_that(1 == 2)
	hope_that(1 == 3)
)


// Run my tests; passing them directly to the runner.

run_tests(list(foo))
run_tests(list(foo, foo))
run_tests(list())


