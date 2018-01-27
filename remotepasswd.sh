### WORK IN PROGRESS ###
ADMIN="administrator"

function user_select {
    USERS=( $(ls /Users/ | grep -v 'Shared') )

    USER_COUNTER=0
    for i in ${USERS[@]};
    do
        let "USER_COUNTER++"
        echo "$USER_COUNTER: $i";
    done

    read -p "Type the user number: " no

    if [ "$no" -ge 1 -a "$no" -le "$USER_COUNTER" ]; then
        USER_SELECTED=${USERS[$no-1]}
    else
        echo "Please choose a number that correlates to a user."
        user_select
    fi
}
read -p "Enter the computer you wish to configure: " $PC
ssh "administrator@$PC"
echo "Which user would you like to change the password for?"
user_select
sudo passwd $USER_SELECTED

echo "Password changed. \n Your Password Keychain will no longer work."
