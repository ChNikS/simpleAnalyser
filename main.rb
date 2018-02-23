require 'csv'

def handleUser(user, flag, type, array)
	#check flag
	if(flag)
		userIndex = array.length-1
		for i in 0..array.length-1
			if(user == array[i])
				userIndex = i
				break
			end
		end
		swap = false
		if(userIndex<4)
			
			if((type == true && $userHash[user]['bytes'] < $userHash[array[i]]['bytes']) || (type==false && ($userHash[user]['count'] < $userHash[array[i]]['count'])))
				swap = true
			end
		end
		if(swap)
			array[userIndex] = array[userIndex+1]
			array[userIndex+1] = user
			#recursion
			handleUser(user, flag, type, array)
		end
	else
		#no flag => means that user wasn't on list
		indexValue = array.length-1
		for i in 0..(array.length-1)
			if((type == true && $userHash[user]['bytes'] < $userHash[array[i]]['bytes']) || (type==false && ($userHash[user]['count'] < $userHash[array[i]]['count'])))
				indexValue = i
				break
			end
		end

		if(indexValue>0)

			if(type)
				$userHash[array[0]]['inBytesTop'] = false
				$userHash[user]['inBytesTop'] = true
			else
				$userHash[array[0]]['inCountTop'] = false
				$userHash[user]['inCountTop'] = true
			end
			for i in 0..indexValue-1
				array[i] = array[i+1]
			end
			array[indexValue] = user
		end
	end
	return array
end


#read file properties
content = File.read('shkib.csv')
csv = CSV.new(content, headers: true)

# hash map userName(key) hash with params: bytes - bytes sent, count - nu,ber of requests
$userHash = Hash.new

userValueHash = Hash.new
userValueHash['bytes'] = -1
userValueHash['count'] = -1
userValueHash['inBytesTop'] = false
userValueHash['inCountTop'] = false
$userHash[nil] = userValueHash

#array to keep five top users by bytes sent
userBytesArray = Array.new(5)
#array to keep five top users by reuest count
userCountArray = Array.new(5)
for i in 0..4
	userBytesArray[i] = nil
	userCountArray[i] = nil
end

#main read cycle
while row = csv.shift
	#there are some empty-user log strings
	if row[1] != nil
		if $userHash.include? row[1]
			#user already there, update user info
			$userHash[row[1]]['bytes'] += row[8].to_i
			$userHash[row[1]]['count'] +=1
		else
			#add user to the hash
			userValueHash = Hash.new
			userValueHash['bytes'] = row[8].to_i
			userValueHash['count'] = 1
			userValueHash['inBytesTop'] = false
			userValueHash['inCountTop'] = false
			$userHash[row[1]] = userValueHash
		end
	end

	#puts "user #{row[1]} count is - #{$userHash[row[1]]['count']}"
	#handle user
	userBytesArray = handleUser(row[1], $userHash[row[1]]['inBytesTop'], true, userBytesArray)
	userCountArray = handleUser(row[1], $userHash[row[1]]['inCountTop'], false, userCountArray)
end

#file write down result.txt in root diretory
resultFile = File.open("result.txt", 'wb')
resultFile.write("# Поиск 5ти пользователкй сгенерироваших наибольшее число запросов \n")
resultFile.write("Решение1\n")
(userCountArray.length-1).downto(0) {|u| resultFile.write"#{userCountArray[u]}\n"}
resultFile.write("# Поиск 5ти пользователкй отправивших наибольшее число данных\n")
resultFile.write("Решение2\n")
(userCountArray.length-1).downto(0) {|u| resultFile.write"#{userBytesArray[u]}\n"}




#puts 

#handleUser('user')