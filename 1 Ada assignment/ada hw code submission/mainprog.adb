with text_io;
use text_io;
with Sorting;
use Sorting;

-- I recommend that you develop your program using the following steps:
-- In the Sorting.ads file, declare SIZE, the array type, the array, and the QSort procedure.
-- In the Sorting.adb file, define a dummy version of Qsort that doesn't do anything.
-- In the MainProg.adb file, write and debug a procedure that reads in values into the array. Also write and debug a procedure that prints out the values of the array. The main procedure MainProg should call these two functions.
-- In the Sorting.adb file, write and debug a sequential (non-concurrent) version of QSort, replacing the dummy version. Call QSort from MainProg.
-- Write and debug the tasks (PrintingTask, SortingTask and AddingTask) within MainProg. SortingTask, of course, will be calling the sequential version of QSort at this point.
-- Modify the sequential version of QSort to make it concurrent, as specified above, and debug it.


procedure MainProg is
    package int_io is new integer_io(integer);
    use int_io;

    procedure ReadArray is
        x:integer;
    begin
        put ("Reading array"); New_Line;
        for i in 0 .. (SIZE - 1) loop
            get (x);
            numbers (i) := x;
        end loop;
    end ReadArray;

    procedure PrintArray is
    begin
        put ("Printing array"); New_Line;
        for i in 0 .. (SIZE - 1) loop
            put (numbers (i));
        end loop;
        new_line;
    end PrintArray;

    task PrintingTask is
        entry start_tasks;
        entry sorting_finished;
        entry addition_finished (sum:integer);
    end PrintingTask;

    task AddingTask is
        entry start_addition;
    end AddingTask;

    task SortingTask is
        entry printing_finished;
    end SortingTask;

-- PrintingTask:
-- First print out the elements of the array.
-- Notify SortingTask that the numbers have been printed.
-- Wait for notification from SortingTask that it is finished.
-- Print out the elements of the array again.
-- Wait to receive a value from AddingTask
-- Print the value received from AddingTask

    task body PrintingTask is
    begin
        accept start_tasks;
        put ("PrintingTask"); new_line;
        PrintArray;
        SortingTask.printing_finished;
        accept sorting_finished do
            put ("sorting finished. ");
            PrintArray;
        end;
        accept addition_finished (sum:integer) do
            put ("addition finished ");
            put (sum);new_line;
            PrintArray;
        end;
    end PrintingTask;

-- AddingTask:
-- Wait for notification that SortingTask is finished.
-- Compute the sum of the elements of the sorted array.
-- Send the result to PrintingTask.

    task body AddingTask is
       total:integer:= 0;
    begin
        accept start_addition do
            put ("AddingTask"); new_line;
            for i in 0..(SIZE-1) loop
                total:= total + numbers(i);
            end loop;
        end;
        PrintingTask.addition_finished (total);
    end AddingTask;

-- SortingTask:
-- Wait for notification that PrintingTask has printed the elements of the array.
-- Sort the array according to the parallel quicksort algorithm described below.
-- Notify both PrintingTask and AddingTask that the array is sorted.
    
    task body SortingTask is
    begin
        accept printing_finished do
            -- sort array
            put ("Sorting Array"); new_line;
            Sorting.QSort(0,SIZE-1);
        end;
        PrintingTask.sorting_finished;
        AddingTask.start_addition;
    end SortingTask;

begin
    ReadArray;
    PrintArray;
    PrintingTask.start_tasks;
end MainProg;

-- MainProg.adb

-- In the file MainProg.adb, write a procedure MainProg that performs the following.
-- Read in 40 numbers into an array. Each number is an integer between 0 and 500, inclusive.
-- You should use a subtype of integer as the element type of the array to enforce this restriction.
-- Use Ada's Get procedure, as seen in the sample Ada programs, to read the numbers in from the standard input (the terminal). Do not read the numbes in from a file.





