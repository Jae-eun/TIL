# Date

var date = Date() : 지금 시간 : "Jul 14, 2017, 9:37 PM"

var cal  = Calendar.current : gregorian (current)

var cal  = Calendar.current.identifier : "gregorian"



var currentYear = cal.component(.year, from: date)

.month

.day

.hour

.minute

.second

.weekday



var components = cal.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)



s