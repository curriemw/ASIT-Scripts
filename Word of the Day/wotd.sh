UNAME=$(uname)
if [[ $UNAME == 'Linux' ]]; then
    DATE=($(date "+%Y-%m-%d"))
    WEEKDAY=($(date "+%a"))
elif [[ $UNAME == 'Darwin' ]]; then
    DATE=($(date "+%Y-%m-%d"))
    WEEKDAY=($(date -v1m | awk '{print $1}'))
fi
COOKIE=''

# Generates the Word of the Day based on the day of the week
wotd_gen () {
    case $WEEKDAY in
        "Mon" )
            COOKIE='monday'
        ;;
        "Tue" )
            COOKIE='tuesday'
        ;;
        "Wed" )
            COOKIE='wednesday'
        ;;
        "Thu" )
            COOKIE='thursday'
        ;;
        "Fri" )
            COOKIE='friday'
        ;;
    esac

    WOTD="$(fortune $COOKIE)"
    echo "$DATE","\"$WOTD\"" | sed -E ':a;N;$!ba;s/\r{0,1}\n/\\n/g' >> wotd_history.csv
    
}

# Creates Word History file if it doesn't already exist
if [ ! -a wotd_history.csv ]; then
    touch wotd_history.csv
fi

# Checks if WOTD has already been generated for today
if !($(grep -q $DATE wotd_history.csv)); then
   wotd_gen
else
    WOTD="$(tail -n 1 wotd_history.csv | cut -d "," -f2- )"
fi

# Displays the WOTD
printf "$WOTD"

