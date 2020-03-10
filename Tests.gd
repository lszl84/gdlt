extends Node2D

class_name Tests

var executed_calls = []
var failed_calls = []

func test_files_in(path):
	var test_scripts = []
	
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name == "." or file_name == "..":
				file_name = dir.get_next()
				continue
			elif dir.current_is_dir():
				test_scripts += test_files_in(path + file_name + "/")
			elif "test_" in file_name:
				test_scripts.append(path + file_name)
			
			file_name = dir.get_next()
			
	else:
		print("An error occurred when trying to access the path " + path)
		
	return test_scripts


func on_assertion_failed(description, stack_trace):
	var failed_method = stack_trace[1] # omit [0] which is assert_true call
	mark_failure(failed_method.function, failed_method.line, failed_method.source, description)


func run_tests(res_array):
	print ("Running tests from ", res_array.size(), " file(s)...")
	for tf in res_array:
		var test = load(tf).new()
		var methods = test.get_method_list()
		var test_methods = []
		
		for m in methods:
			if "test_" in m.name:
				test_methods.append(m.name)
		
		print ("Test script '", tf, "' has ", test_methods.size(), " tests: ", test_methods)
		
		for tm in test_methods:
			test.connect("assertion_failed", self, "on_assertion_failed")
			mark_execution(tm, tf)
			test.call(tm)
			test.disconnect("assertion_failed", self, "on_assertion_failed")
			
	print ("Testing finished\n")
			

func mark_execution(function, source):
	executed_calls.append({"function": function, "source": source})
	
	
func mark_failure(function, line, source, description):		
	failed_calls.append({"function": function, "line": line, "source": source, "description": description})


func clear_results():
	executed_calls = []
	failed_calls = []
	

func print_report():
	var tests_run = executed_calls.size()
	var failures_per_file_per_function = {}
	
	for fail in failed_calls:

		if not fail.source in failures_per_file_per_function:
			failures_per_file_per_function[fail.source] = { }
		
		if not fail.function in failures_per_file_per_function[fail.source]:
			failures_per_file_per_function[fail.source][fail.function] = []
			
		failures_per_file_per_function[fail.source][fail.function].append(fail)
		
	print("Total tests run: ", tests_run)
	
	if failures_per_file_per_function.size() == 0:
		print("All tests passed :)")
	else:
		print("Some tests failed")
		for failed_file in failures_per_file_per_function:
			print("In file: ", failed_file)
			for failed_function in failures_per_file_per_function[failed_file]:
				print("    ", failed_function, ":")
				for fail in failures_per_file_per_function[failed_file][failed_function]:
					print("        line ", fail.line, ": condition is false: ", fail.description)
		
		var failed = failed_calls.size()
		var passed = tests_run - failed
		print("\nTotal failed tests: ", failed)
		print("Passed: %d/%d (%d%%)" % [passed, tests_run, (passed * 100) / tests_run])
	

func _init():
	var test_scripts = test_files_in("res://tests/")
	run_tests(test_scripts)
	print_report()
	
	
func _ready():
	get_tree().quit()
