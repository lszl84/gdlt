extends Object

class_name TestClass

signal assertion_failed(description, stack_trace)

func assert_true(condition, description):
	if not condition:
		emit_signal("assertion_failed", description, get_stack())
		
	
		
		

