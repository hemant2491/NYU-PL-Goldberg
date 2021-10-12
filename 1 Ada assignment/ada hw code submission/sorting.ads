-- In Sorting.ads, the Sorting package specification, you should declare the following:
-- A constant SIZE that specifies the size of the array, namely 40. Elsewhere in your program, SIZE should be used, not 40, so that the size of the array can easily be changed without having to modify any other part of your program.
-- The type of the array, which must restrict the elements to be integers between 0 and 500.
-- The array itself. By declaring the array in the package specification, it can be referenced within the tasks in MainProg as well as shared among the various calls to the QSort procedure. This allows QSort to take only Low and High as parameters, and not the array.
-- The QSort procedure.
with text_io;
use text_io;

package Sorting is
    SIZE: integer:=40;
    subtype array_index is integer range 0..(SIZE-1);
    subtype integer_limited_range is integer range 0..500;
    numbers: array (array_index) of integer_limited_range;
    procedure QSort(low:integer; high:integer);
    crossed_indices, array_overflow:exception;
    -- pragma Preelaborate;
-- private

end Sorting;