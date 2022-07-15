#! /bin/bash

if [ ! -f tasks.csv ]; then
    touch tasks.csv
fi

file=tasks.csv

# add task to "tasks.csv" file
function _add {
    echo "0,$2,\"$1\"" >> "$file"
    echo "Title : "$1" | Priority : "$2" Added!"
}

# see all of tasks
function _list {
  awk -F\, 'BEGIN{print "ID-Status-Name-Priority"} {print NR "| " $1 " - " $2 " - " $3}' tasks.csv
}

#delete all of tasks
function _clear {
  > $file
}

#find an specific task
function _find {
  grep -n $1 $file | tr ":" "," | awk -F\, 'BEGIN{print "ID-Status-Priority-Name"} {print $1 "| " $2 " - " $3 " - " $4}'
}

#done a task with id
function _done {
  
  re='^[0-9]+$'
  if ! [[ $1 =~ $re ]] ; then
    echo "Error: your ID is not a valied --> should be a number"
    exit 1
  fi

  lines_number=$(wc -l "$file")
  if [[ $1 > $lines_number ]]; then
    echo "task $1 not exists!"
    exit 1
  fi

  sed -i ""$1"s/0/1/" $file
}

# check command
case $1 in
add)
  shift
  while [ -n "$1" ]
  do
      case "$1" in
      -t | --title) if [ -z "$2" ]; then
                      echo "option -t|--title needs a parameter"
                      exit 1
                    else
                      mytitle="$2"
                      shift
                      shift
                    fi
                    mypriority="L"
                  ;;
      -p | --priority) if [ -z "$2" ]; then
                        echo -e "You should set a parameter (L|M|H) for -p|--pririty\nif you dont like to set a parameter dont write -p|--priority (this set automatic to L(Low))"
                        exit 1
                      else
                        case "$2" in
                        L | l) mypriority="L"
                        ;;
                        M | m) mypriority="M"
                        ;;
                        H | h) mypriority="H"
                        ;;
                        *) echo "option -p|--priority only accept L|M|H"
                            exit 1
                          ;;
                          esac
                      fi
                      shift
                      shift
                      break
                      ;;
      *) echo "unknown option"
        exit 1
        ;;
      esac
  done
  _add $mytitle $mypriority
  ;;

list)
     _list
     ;;

find)
      shift
      _find $1
      ;;

done)
      shift
      _done $1
      ;;

clear)
      _clear
      ;;

*) echo "unknown command"
   exit 1
  ;;
esac