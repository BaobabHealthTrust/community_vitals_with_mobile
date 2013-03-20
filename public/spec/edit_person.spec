P.1. Edit Person [program: COMMUNITY VITALS REGISTRATION $$ action => /people/saveEditedPerson]
C.1. Edit an existing person

Q.1.1. Person First Name [pos => 'a' $$ dynamicLoader => listFirstNames(__$('inputField').value.trim()) $$ tt_onLoad => listFirstNames('')]
C.1.1.1. First Name List

Q.1.2. Person Last Name [pos => 'b' $$ dynamicLoader => listLastNames(__$('inputField').value.trim()) $$ tt_onLoad => listLastNames('')]
C.1.2.1. Last Name List

Q.1.3. Person Gender [pos => 'c']
O.1.3.1. Male
O.1.3.2. Female

Q.1.4. Select Person From The Following: [pos => 'd' $$ tt_onLoad => getPeopleNames(__$('1.1').value.trim(), __$('1.2').value.trim(), __$('1.3').value.trim())]
C.1.4.1. List of matching people 

Q.1.5. Identifier Type [pos => 'e']
O.1.5.1. National ID
O.1.5.2. Passport Number
O.1.5.3. Driving Licence Number
O.1.5.4. Other

Q.1.6. Add Identifier [pos => 'f']

