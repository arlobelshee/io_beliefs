
// The test framework. These should be in a separate file.
_FoolishBelief := Object clone
_FoolishBelief description := method(
	"""Hoping that #{hope} won't make it true!
 This makes mockery of your belief in #{belief}
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
Ideology _beliefs := list()

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
	return result
)

run_tests := method(ideologies,
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


// My test definitions. We want this to have less boilerplate.

the_classics := ideology(shakespere_knows_whats_what)
the_classics belief(something_is_rotten_in_the_state,
	hamlet_is_broody := True
	hope_that(hamlet_is_broody)
)
the_classics belief(what_light_through_yonder_window_breaks,
	the_light := "the sun"
	hope_that(the_light == "the moon")
	hope_that(the_light == "the sun")
)


// Run my tests; passing them directly to the runner.

run_tests(list(the_classics, the_classics))


