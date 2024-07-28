set day_of_week (date +%u)
set time (date +%H%M)

# days from Mon 1 to Friday 5, less than Sat 6
set is_work \
    test $day_of_week -le 5 &&
    test $time -ge 0930 &&
    test $time -le 1830

if $is_work
    task project:work $argv
else
    task project.not:work $argv
end
