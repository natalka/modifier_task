# Refactoring Task

  - Adding gemfile with ruby version, crusial gems
  - Converting intentions to spaces and adjusting it by removind white-space/intending, so code is pleasent to work with
  - Running existing tests for Combiner and getting an idea how it works
  - Moving Modifier's start-up to rakefile, in order to make it easier to work with it.
  - Modifier is transforming/adjusting CSV and saving it into new CSV(s) (based on how many rows has a new output it may splipt data into many files).
  - Using created input CSV and files produced by Modifier to create simple rspec test to ensure that code will work the same way afterwards
  - Starting inspecting code with byebug and refactoring

# How it works:

1. Sorts CSV based on column 'Clicks'.
2. Create Enum of based on sorted CSV rows (Enum of CSV's rows).
3. Pass our sorted data in Enum to Combiner with KEYWORD_UNIQUE_ID as key_extractor (I would say it makes more sense to pass sorted_by value). Nothing happens here since Combiner needs at least one more Enum to combine with...
4. In 'merger' we (in theory - since work on one data set nothing is acctualy changing) would put rows into one row and save values into array for each cell (if a row hasn't certain key - nil is written into array instead).
5. Nextly in combine_values method we are picking our winners from created values combination (sadly we already know our winners ;) or as for NO_OF_COMMISSIONS/COMMISSIONS_VALS keys we calculate our final value.
6. In the end write_to_csvs writes the solution to file(s).


There is still more to be done, but I way to much exceeded the suggested 3h to resolve the task, so I feel like I'm missing the point here.

Thanks for your time!
