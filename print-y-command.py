#importing the csv file
import csv
with open ('UserReview.csv', encoding='utf-8-sig') as userrev:
    reader = csv.DictReader(userrev,delimiter=';')
    
    data = list(reader)
#Now we create the 'X'list. Defining a variable of interest (author).
    X = list()
    for row in data:
        X.append(row['Author'])
    #print(X)
#Now we filter on my favorite movie by making a second list 'Y'
    Y = list()
    for row in data:
        if row['movieName'] == "the-blind-side":
            Y.append(row['Author'])
    print(Y)