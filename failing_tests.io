
// The test framework. These should be in a separate file.
_FoolishBelief := Object clone
_FoolishBelief description := method(
	"""Hoping that #{hope} won't make it true!
 This makes mockery of your belief that #{belief}
 And calls the entire #{ideology _name} ideology into question!
""" interpolate
)

Belief := Object clone
Belief execute := method(
	badness := list()
	e := try(doMessage(run))
	e catch(AssertionFailedException,
		failure := _FoolishBelief clone
		failure hope := e error
		failure belief := name
		failure ideology := ideology
		badness append(failure)
	)
	return badness
)

Ideology := Object clone
Ideology _all_known_ideologies := list()

Ideology belief := method(
	thought := Belief clone
	thought name := call message argAt(0)
	thought run := call message argAt(1)
	thought ideology := call target
	_beliefs append(thought)
)

ideology := method(
	result := Ideology clone
	result _name := call message argAt(0)
	result _beliefs := list()
	Ideology _all_known_ideologies append(result)
	return result
)

run_tests := method(
	ideologies := Ideology _all_known_ideologies
	"\n" print
	total_beliefs := 0
	foolishness := list()
	ideologies foreach(i,
		total_beliefs = total_beliefs + i _beliefs size
		foolishness append(i _beliefs map(execute))
	)
	foolishness := foolishness flatten flatten
	foolishness foreach(f,
		(f description .. "\n") print
	)
	"\nQuestioned #{total_beliefs} beliefs while exploring #{ideologies size} likely-conflicting ideologies.\n" interpolate print
	(foolishness size == 0) ifTrue(
		"holy crap! You were right!\n" print
	) ifFalse(
		"#{foolishness size} beliefs crushed.\n" interpolate print
	)
)

AssertionFailedException := Exception clone

hope_that := method(
	(call evalArgAt(0)) ifFalse (
		AssertionFailedException raise(call message argAt(0) code)
	)
)


// This is the system to test.
in_shakespeare := Object clone
in_shakespeare hamlet_is_broody := true
in_shakespeare the_light := "the sun"

the_broodiest := "Angel"

// My test definitions.
ideology(shakespeare_knows_whats_what) do(
	belief(something_is_rotten_in_the_state,
		hope_that(in_shakespeare hamlet_is_broody)
	)
	belief(romeo_knows_what_light_through_yonder_window_breaks,
		hope_that(in_shakespeare the_light == "the moon")
		hope_that(in_shakespeare the_light == "the sun")
	)
)

ideology(joss_wheden_knows_whats_what) do(
	belief(buffy_chooses_romantic_partners_poorly,
		hope_that("Angel" == the_broodiest)
	)
)

// Run my tests; passing them directly to the runner.

run_tests()
//run_tests(list(the_classics, the_classics))


