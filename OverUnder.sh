#!/bin/bash

# Khai báo biến
balance=1000
betAmount=0
isOver=true
randomNumber=0
arrayRandomNumber=()

# Hàm lấy ngẫu nhiên số
getRandomNumber () {
	arrayRandomNumber=()
	for (( i=0 ; i < $1 ; i++ ))
	do
		randomNumber=$(($2 + RANDOM % $3))
		arrayRandomNumber+=($randomNumber)
	done
	echo "${arrayRandomNumber[@]}"
}

# Hàm tính tổng các phần tử trong mảng
function sumArray() {
    total=0
    for i in "$@"
    do
        let total+=$i
    done
    echo $total
}

# Vòng lặp chơi
while true; do
  # Hiển thị dialog
  dialog --clear --backtitle "Game Tài Xỉu" --title "Balance: $balance" \
  --inputbox "Enter bet amount:" 8 40 2>temp
  betAmount=$(<temp)
  # Kiểm tra số tiền cược có hợp lệ hay không
  while [ $betAmount -gt $balance ]; do
    dialog --clear --backtitle "Game Tài Xỉu" --title "Balance: $balance" \
    --inputbox "The bet amount is larger than the available amount. Enter again:" 8 60 2>temp
    betAmount=$(<temp)
  done
  # Hiển thị dialog chọn "Over" hoặc "Under"
 dialog --clear --backtitle "Game Tài Xỉu" --title "Select Over or Under" \
  --radiolist "Select one:" 10 30 2 \
  "Over" " " on \
  "Under" " " off 2>temp

  # Gán giá trị chọn
  chooseBet=$(<temp)
  if [ "$chooseBet" = "Over" ]; then
    isOver=true
else
    isOver=false
fi

  # Lấy ngẫu nhiên các số và tính tổng
  myArrayResult=($(getRandomNumber 3 1 6))
  result=$(sumArray "${myArrayResult[@]}")
  # Hiển thị kết quả
  dialog --clear --backtitle "Game Tài Xỉu" --title "result : $result" --msgbox "ket qua gieo la: ${myArrayResult[*]}" 10 50
  # Kiểm tra kết quả và cập nhật số tiền
  if [ $result -ge 11 ]; then
    if $isOver; then
      balance=$((balance + betAmount))
      dialog --clear --backtitle "Game Tài Xỉu" --title "Result: Over" \
      --msgbox "You win! Your new balance is: $balance" 8 50
    else
      balance=$((balance - betAmount))
      dialog --clear --backtitle "Game Tài Xỉu" --title "Result: Over" \
      --msgbox "You lose! Your new balance is: $balance" 8 50
    fi
  else
    if ! $isOver; then
      balance=$((balance + betAmount))
      dialog --clear --backtitle "Game Tài Xỉu" --title "Result: Under" \
  --msgbox "You win! Your new balance is: $balance" 8 50
else
  balance=$((balance - betAmount))
  dialog --clear --backtitle "Game Tài Xỉu" --title "Result: Under" \
  --msgbox "You lose! Your new balance is: $balance" 8 50
fi
fi
if [ $balance -le 0 ]; then
dialog --clear --backtitle "Game Tài Xỉu" --title "Game Over"
--msgbox "Your balance is 0. Game over!" 8 50
break
fi
done
