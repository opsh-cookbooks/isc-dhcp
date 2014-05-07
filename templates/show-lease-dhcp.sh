conf="/var/lib/dhcp/dhcpd.leases"
 
value_of() {
echo $@ | awk -F " " '{print $NF}' | sed "s/;//g"
}
 
get_detail_of() {
l=$1
  case $l in
  ends*)
    #l_ends=`echo $l | awk -F " " '{print $NF}' | sed "s/;//g"`
    l_ends=`echo $l | awk -F " " '{print $(NF-1)" "$NF}' | sed "s/;//g"`
    ends=`date -d "$l_ends UTC" +"%b%d-%H:%M:%S"`
    echo -en "\t$ends"
  ;;
  binding*)
    status=`value_of $l`
    echo -en "\t$status"
  ;;
  hardware*)
    mac=`value_of $l`
    echo -en "\t$mac"
  ;;
  client-hostname*)
    hostname=`value_of $l`
    echo -ne "\t$hostname"
  ;;
  esac
}
 
get_lease_from() {
i=0
cat $conf | while read line
do
 
  case $line in
  lease*)
    ip=`echo $line | cut -d " " -f 2`
    echo -ne "\n$ip"
    i=1
  ;;
  "}")
    i=0
    echo ""
  ;;
  *)
    [ $i -eq 1 ] && get_detail_of "$line"
  ;;
  esac
 
done
# | sort -t . -k 1,1n -k 2,2n -k 3,3n -k 4,4n
}
 
main() {
result=`get_lease_from | grep -v "^$"`
total=`printf "%s" "$result" | wc -l`
all_data=`printf "%s\n" "$result" | sort -t . -k 1,1n -k 2,2n -k 3,3n -k 4,4n`
echo "==================================================================="
case $1 in
-a)
  #printf "%s\n" "$result" | sort -t . -k 1,1n -k 2,2n -k 3,3n -k 4,4n
  printf "%s\n" "$all_data"
;;
*)
  #uniq_result=`printf "%s\n" "$result" | sort -t . -k 1,1n -k 2,2n -k 3,3n -k 4,4n | tac | sort -s -u -k 1,1`
  uniq_result=`printf "%s\n" "$all_data" | tac | sort -s -u -k 1,1 | sort -t . -k 1,1n -k 2,2n -k 3,3n -k 4,4n`
  uniq_total=`printf "%s" "$uniq_result" | grep -v "^$" | wc -l`
  printf "%s\n" "$uniq_result"
  # | sort -t . -k 1,1n -k 2,2n -k 3,3n -k 4,4n
  #printf "%s\n" "$result" | tac | sort -u -k 1,1 | sort -t . -k 1,1n -k 2,2n -k 3,3n -k 4,4n
  echo -e "\nRecent leases: $uniq_total"
;;
esac
echo "==================================================================="
echo "Total leases:  $total   [$conf]"
}
 
main $@
