import psycopg2
import sys


host = '127.0.0.1'
port = '5432'
dbname = 'msds597'
user = 'postgres'
password = 'SERG120liza' #comment out if no password
schema = 'imdb'
options = f'-c search_path={schema}'
file = sys.argv[2]


conn = psycopg2.connect(host=host, port=port, dbname=dbname, user=user, options=options)
cur = conn.cursor()


ans = ["[('Katie Holmes', 175), ('Mimi Rogers', 173), ('Nicole Kidman', 180)]",
 "[('Tahiyyah Karyuka', 12, 12), ('Nagwa Fouad', 9, 9), ('Eddie Barclay', 8, 8), ('Norman Selby', 9, 8), ('Soheir Ramzy', 9, 8)]",
 "[('Psycho', 1960, 'Horror, Mystery, Thriller', 'USA', Decimal('8.5'), 586765), ('Alien', 1979, 'Horror, Sci-Fi', 'UK, USA', Decimal('8.4'), 768874), ('The Shining', 1980, 'Drama, Horror', 'UK, USA', Decimal('8.4'), 869480), ('The Thing', 1982, 'Horror, Mystery, Sci-Fi', 'USA', Decimal('8.1'), 360147), ('What Ever Happened to Baby Jane?', 1962, 'Drama, Horror, Thriller', 'USA', Decimal('8.1'), 48788)]",
 "[('Caitlin E.J. Meyer', '1992-02-29', 'Salt Lake City, Utah, USA'), ('James Cullen Bressack', '1992-02-29', 'Los Angeles, California, USA'), ('Jessie T. Usher', '1992-02-29', 'Maryland, USA'), ('Travis Huff', '1984-02-29', 'Greenville, Ohio, USA'), ('Christine Cowden', '1980-02-29', 'Fort Lauderdale, Florida, USA'), ('Peter Scanavino', '1980-02-29', 'Denver, Colorado, USA'), ('Phil Haney', '1980-02-29', 'Syracuse, New York, USA'), ('Ja Rule', '1976-02-29', 'Hollis, Queens, New York City, New York, USA'), ('Saul Williams', '1972-02-29', 'Newburgh, New York, USA'), ('Dallas Barnett', '1964-02-29', 'Rochester, New York, USA')]",
 "[('Avengers: Endgame', 181)]",
 "[('3leven',), ('Castle Rock Entertainment',), ('Fox 2000 Pictures',), ('Fox STAR Studios',), ('Miramax',), ('New Line Cinema',), ('Orion-Nova Productions',), ('Paramount Pictures',), ('Produzioni Europee Associate (PEA)',), ('Universal Pictures',), ('Warner Bros.',)]",
 "[('Coco', '2017-12-28', Decimal('8.4')), ('The Greatest Showman', '2017-12-25', Decimal('7.6')), ('Den 12. mann', '2017-12-25', Decimal('7.4')), ('Jumanji: Welcome to the Jungle', '2018-01-01', Decimal('6.9'))]",
 "[('World War Z', 2013, '$ 190000000', '$ 540007876'), ('Resident Evil: Apocalypse', 2004, '$ 45000000', '$ 129342769'), ('Zombieland: Double Tap', 2019, '$ 42000000', '$ 122810399'), ('Warm Bodies', 2013, '$ 35000000', '$ 116980662'), ('ParaNorman', 2012, '$ 60000000', '$ 107139399')]",
 "[('Bart the Bear', 293, '9 feet 7 inches'), ('Max Palmer', 249, '8 feet 2 inches'), ('Thomas H. McDaniel', 241, '7 feet 11 inches'), ('Jerald Sokolowski', 234, '7 feet 8 inches'), ('Gheorghe Muresan', 231, '7 feet 7 inches'), ('Baocheng Jiang', 230, '7 feet 7 inches'), ('John Bloom', 224, '7 feet 4 inches'), ('John Aasen', 220, '7 feet 3 inches'), ('Johnny Rosenthal', 220, '7 feet 3 inches'), ('Kevin Peter Hall', 220, '7 feet 3 inches')]",
 "[('Inferno', '$ 34343574', '$ 220021259', Decimal('15.6')), ('Cloud Atlas', '$ 27108272', '$ 130482868', Decimal('20.8')), ('Angels & Demons', '$ 133375846', '$ 485930816', Decimal('27.4')), ('The Da Vinci Code', '$ 217536138', '$ 760006945', Decimal('28.6')), ('The Terminal', '$ 77872883', '$ 219100084', Decimal('35.5')), ('Philadelphia', '$ 77446440', '$ 206678440', Decimal('37.5')), ('Toy Story 3', '$ 415004880', '$ 1066969703', Decimal('38.9')), ('Toy Story 4', '$ 434038008', '$ 1073394593', Decimal('40.4')), ('The Post', '$ 81903458', '$ 192938646', Decimal('42.5')), ('Bridge of Spies', '$ 72313754', '$ 165478348', Decimal('43.7'))]",
 "[('Inferno', '$ 34343574', '$ 220021259', 15.6), ('Cloud Atlas', '$ 27108272', '$ 130482868', 20.8), ('Angels & Demons', '$ 133375846', '$ 485930816', 27.4), ('The Da Vinci Code', '$ 217536138', '$ 760006945', 28.6), ('The Terminal', '$ 77872883', '$ 219100084', 35.5), ('Philadelphia', '$ 77446440', '$ 206678440', 37.5), ('Toy Story 3', '$ 415004880', '$ 1066969703', 38.9), ('Toy Story 4', '$ 434038008', '$ 1073394593', 40.4), ('The Post', '$ 81903458', '$ 192938646', 42.5), ('Bridge of Spies', '$ 72313754', '$ 165478348', 43.7)]"]

query_list = []
output = []


with open(file) as f:
    queries = [i.strip() for i in f.readlines()]

queries = ' '.join(queries)
q = queries.split('SELECT')

for i in q:
    if ";" in i:
        end = i.find(';')
        query_list.append('SELECT' + i[:end+1])


for q in query_list:
    cur.execute(q)
    output.append(str(cur.fetchall()))
    
def test_q1():
    assert ans[0] == output[0]
    
def test_q2():
    assert ans[1] == output[1]

def test_q3():
    assert ans[2] == output[2]
    
def test_q4():
    assert ans[3] == output[3]

def test_q5():
    assert ans[4] == output[4]

def test_q6():
    assert ans[5] == output[5]

def test_q7():
    assert ans[6] == output[6]
    
def test_q8():
    assert ans[7] == output[7]

def test_q9():
    assert ans[8] == output[8]

def test_q10():
    try:
        assert ans[9] == output[9]
    except:
        assert ans[10] == output[9]
    
    
cur.close()
conn.close()

