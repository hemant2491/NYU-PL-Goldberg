-- The QSort procedure should be implemented in Sorting.adb. The quicksort algorithm can be described as follows (assuming the array is called A).
--
-- If Low is greater than or equal to High, then return.
-- Otherwise, apply the routine Split to A as follows:
-- Declare a variable M and set it to the median value of the A(Low), A(High), and A((Low+High)/2).
-- If there are only two elements of A then assign to M the smaller of the two values.
-- Declare two variables I and J, setting I to Low and J to High.
-- In a loop, as long as I is less than J, perform the following steps:
-- While A(I) is less than or equal to M, increment I.
-- While A(J) is greater than M, decrement J.
-- If I is less than J, exchange the values of A(I) and A(J).
-- Make sure that I never becomes greater than J.

-- At this point, the array A (between the Low and High elements, inclusive) has been split into two parts. 
-- The first part of A contains only numbers less than or equal to M and the second part of A contains only numbers greater than M.
-- Call QSort recursively on each of the two parts.
-- The two recursive calls should occur concurrently and should share the array.

-- Notice that by concurrently calling QSort recursively, you will end up with many tasks executing concurrently.

package body Sorting is
    
    procedure QSort (low : Integer; high : Integer) is
        package int_io is new integer_io(integer);
        use int_io;

        

        procedure PrintArray is
        begin
            put ("Printing array");
            New_Line;
            for i in 0 .. (SIZE - 1) loop
                put (numbers (i));
            end loop;
            new_line;
        end PrintArray;

        procedure ExchangeNumbers (x: integer; y: integer) is
        tmp: integer;
        begin
            -- put("Exchange"); put(numbers(x));put(numbers(y));new_line;
            tmp := numbers(x);
            numbers(x) := numbers(y);
            numbers(y) := tmp;
        end ExchangeNumbers;

        -- returns value of median of numbers[low], numbers[high] and numbers[(low+high)/2]
        function GetMedian (low : integer; high : integer; mid : integer) return integer is
            l, h, m : integer;
        begin
            l := numbers (low);
            h := numbers (high);
            m := numbers (mid);
            if (high - low) < 2 then
                if l < h then
                    return l;
                else
                    return h;
                end if;
            end if;
            if (m < h) then
                if (m >= l) then
                    return m;
                elsif (h < l) then
                    return h;
                end if;
            else
                if (m < l) then
                    return m;
                elsif (h >= l) then
                    return h;
                end if;
            end if;
            return l;
        end GetMedian;

        function FindSplit (low : integer; high : integer; med : integer) return integer is
            i : integer;
        begin
            -- put("find_low "); put(low); put(high); put(med); new_line;
            i := low;
            loop
                if numbers(i) <= med then
                    i := i + 1;
                else
                    exit;
                end if;
                exit when i >= high;
            end loop;
            return i;
        end FindSplit;

        -- task SortingTask is
        --     entry sort (sort_low : Integer; sort_high : Integer);
        -- end SortingTask;

        task SplittingTask is
            entry split (split_low : Integer; split_high : Integer; M : integer);
        end SplittingTask;

        -- task body SortingTask is
        --     mid,med : integer;
        -- begin
        --     accept sort (sort_low : Integer; sort_high : Integer) do
        --         put ("Sorting ");
        --         put (sort_low);
        --         put (" ");
        --         put (sort_high);
        --         new_line;
        --         if sort_low >= sort_high then
        --             return;
        --         else
        --             mid := (sort_high + sort_low) / 2;
        --             med := GetMedian(sort_low, sortz_high, mid);
        --             SplittingTask.split (sort_low, sort_high, med);
        --         end if;
        --     end sort;
        -- end SortingTask;

        task body SplittingTask is
            i, j : integer;
        begin
            accept split (split_low : integer; split_high : integer; M : integer) do
                i := split_low;
                j := split_high;
                -- put (split_low); put (split_high);put (" M ");put (M);put (" i ");put (i);put (" j ");put (j);new_line;
                put_line ("split " & natural'image(split_low) & natural'image(split_high) & natural'image(M));
                loop
                    loop
                        if i >= j then
                            exit;
                        end if;
                        if numbers (i) <= M then
                            i := i + 1;
                        else
                            exit;
                        end if;
                    end loop;
                    loop
                        if i >= j then
                            exit;
                        end if;
                        if numbers (j) > M then
                            j := j - 1;
                        else
                            exit;
                        end if;
                    end loop;
                    exit when i >= j;
                    ExchangeNumbers(i, j);
                end loop;
                put(i); put(j); new_line;
                PrintArray;
                -- put ("low ");put (split_low);put (" high ");put (split_high);put (" M ");put (M);put (" i ");put (i);put (" j ");put (j);new_line;
                -- if (i - split_low) > 1 then
                --     put("low if");
                --     SortingTask.sort (split_low, i - 1);
                -- end if;
                -- if (split_high - i) > 0 then
                --     SortingTask.sort (i, split_high);
                -- end if;
            end split;
        end SplittingTask;

        mid,med,second_low : integer;
    begin
        Put ("QSort ");put (low); put (" "); put (high); new_line;
        if low >= high then
            return;
        elsif (high - low < 2) then
            med := GetMedian(low, high, low);
            SplittingTask.split(low, high, med);
            put("a");
            return;
        else
            mid := (high + low) / 2;
            med := GetMedian(low, high, mid);
            SplittingTask.split (low, high, med);
            put("b");new_line;
            second_low := FindSplit(low, high, med);
            put("second_low"); put(second_low);new_line;
            if second_low - low > 1 then
                put("c");
                QSort(low, second_low-1);
            end if;
            if high - second_low >= 1 then
                put("d");
                QSort(second_low, high);
            end if;
        end if;
        PrintArray;
    end QSort;

    -- procedure Split()
--     pragma Preelaborate;
-- private
end Sorting;
