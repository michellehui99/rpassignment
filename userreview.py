#importing the csv file
import csv
with open ('UserReview.csv', encoding='utf-8-sig') as userrev:
    reader = csv.DictReader(userrev,delimiter=';')
    
    data = list(reader)
#Now we create the 'X'list. Defining a variable of interest (author).
    X = list()
    for row in data:
        X.append(row['Author'])
    print(X)

#Now we filter on my favorite movie by making a second list 'Y'
    Y = list()
    for row in data:
        if row['movieName'] == "the-blind-side":
            Y.append(row['Author'])
    print(Y)

#For every author in Y, we are going to show which other movies were watched by the author. Creating the 'Z' file.
    Z = list()
    for row in data:
        if row ['Author'] in Y:
            Z.append(row['movieName'])
    print (Z)

#Finally I am transferring the commands from the terminal to a text document on the RP desktop. This is the Z proof of working.
    textfile = open("zresults.txt","w")
    for element in Z:
        textfile.write(element+"\n")
    textfile.close()