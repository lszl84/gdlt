# Gdlt
Godot Lightweight Testing Suite - super simple testing framework for GDScript. Works on Godot 3.2, any platform.

## Motivation

There are two main testing framework for GDScript: GUT and WAT. Both come with their own quirks:
- GUT has a scene UI that in many cases is completely unnecessary and stays on after running, slowing down the testing process,
- WAT has requirements for `description` annotation for every test, which may not be something you need in your tests. Also you need three clicks to run all tests (go to test tab, click Run, click Run All), which again slows the process.

Gdlt came to life as an alternative to these: a simple, minimal and fast (in terms of user experience) framework for testing.

## Installation

### As a sumbodule

If you use a git repository for your game, just add the `gdlt` as a submodule:

```
git submodule add git@github.com:lszl84/gdlt.git
```

### Or just copy the files

If not, just go to your game directory and clone the repository in order to copy the files into `gdlt` folder:

```
git clone git@github.com:lszl84/gdlt.git
```

## Running

After installation, the `gdlt` files should be in the `gdlt` folder in your game directory tree. Add another directory to your game folder named `tests` and create a test script there. Use right click on your folder while in Godot and choose "New Script...". Make sure your script name starts with "test_".

Your game directory should look something like this:
```
+ res://
  + gdlt/
    TestClass.gd
    Tests.gd
    Tests.tscn
  + tests/
    test_sample.gd
  default_env.tres
  icon.png
  Node2D.tscn
```

Open the `test_sample.gd` file you created and replace the code with the following:

```
extends TestClass

func test_something():
	var monsters_count = 9
	assert_true(monsters_count == 10, "there should be 10 monsters, not %d" % monsters_count)
```

You need to extend `TestClass` and the test methods need to have "test_" in their names. To assert test conditions use `assert_true(condition, description)`. You can create as many test scripts as you want. Subdirectories are also supported.

## TODO

- classic `set_up` and `tear_down` methods

## License

MIT.
