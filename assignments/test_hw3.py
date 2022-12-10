import psycopg2
import sys


host = '127.0.0.1'
port = '5432'
dbname = 'msds597'
user = 'postgres'
# password = password #comment out if no password
schema = 'imdb'
options = f'-c search_path={schema}'
file = sys.argv[2]


conn = psycopg2.connect(host=host, port=port, dbname=dbname, user=user, options=options)
cur = conn.cursor()


ans = ["[('Questionable', 3130), ('Decent', 2911), ('Bad', 1813), ('Good', 632), ('Great', 10)]",
 "[('Warner Bros.', Decimal('26179586906')), ('Universal Pictures', Decimal('24650120131')), ('Paramount Pictures', Decimal('21876326816')), ('Columbia Pictures', Decimal('21515883903')), ('Twentieth Century Fox', Decimal('17636966731'))]",
 "[(2001, 202, Decimal('6.5'), Decimal('8.8'), Decimal('2.2')), (2002, 213, Decimal('6.5'), Decimal('8.7'), Decimal('3.1')), (2003, 207, Decimal('6.5'), Decimal('8.9'), Decimal('2')), (2004, 239, Decimal('6.6'), Decimal('8.5'), Decimal('1.8')), (2005, 246, Decimal('6.5'), Decimal('8.3'), Decimal('2.2')), (2006, 290, Decimal('6.5'), Decimal('8.5'), Decimal('1.6')), (2007, 297, Decimal('6.5'), Decimal('8.4'), Decimal('2.2')), (2008, 295, Decimal('6.4'), Decimal('9'), Decimal('1.9')), (2009, 298, Decimal('6.4'), Decimal('8.4'), Decimal('2.5')), (2010, 280, Decimal('6.5'), Decimal('8.8'), Decimal('1.8'))]",
 '[(161,)]',
 "[('Winter', 1122, Decimal('41869306.20'), Decimal('59995000.33'), Decimal('132276567.73')), ('Fall', 1302, Decimal('40510246.71'), Decimal('54593651.68'), Decimal('119852561.82')), ('Spring', 1214, Decimal('40571005.07'), Decimal('51171389.27'), Decimal('109108345.70')), ('Summer', 1033, Decimal('36412656.34'), Decimal('48518928.88'), Decimal('99994343.83'))]",
 "[('Arzu Film', 9, Decimal('8.9'), Decimal('9.3')), ('Castle Rock Entertainment', 44, Decimal('6.5'), Decimal('9.3')), ('Paramount Pictures', 317, Decimal('6.6'), Decimal('9.2')), ('Content Matters', 1, Decimal('9.1'), Decimal('9.1')), ('Centar Film', 2, Decimal('9.0'), Decimal('9')), ('Shree Raajalakshmi Films', 1, Decimal('9.0'), Decimal('9')), ('Warner Bros.', 363, Decimal('6.7'), Decimal('9'))]",
 "[('1900s', 172, 5186, Decimal('3.3')), ('1910s', 241, 5790, Decimal('4.2')), ('1920s', 340, 8565, Decimal('4.0')), ('1930s', 423, 9181, Decimal('4.6')), ('1940s', 571, 10666, Decimal('5.4')), ('1950s', 705, 10421, Decimal('6.8')), ('1960s', 931, 13150, Decimal('7.1')), ('1970s', 969, 15170, Decimal('6.4')), ('1980s', 908, 10751, Decimal('8.4')), ('1990s', 280, 3101, Decimal('9.0')), ('2000s', 28, 366, Decimal('7.7')), ('2010s', 1, 5, Decimal('20.0'))]",
 "[('David', 3220), ('John', 3203), ('Michael', 3112), ('Robert', 2155), ('Paul', 1683), ('James', 1592), ('Peter', 1588), ('Richard', 1464), ('Mark', 1365), ('Daniel', 1188)]",
 '[(32035,)]',
 "[('Friday', 31343), ('Thursday', 17356), ('Wednesday', 11202), ('Saturday', 7767), ('Tuesday', 5645), ('Monday', 4684), ('Sunday', 3236)]"]

query_list = []
output = []


with open(file) as f:
    queries = [i.strip() for i in f.readlines()]

queries = ' '.join(queries)
q = queries.split('*/')

for i in q:
    if ";" in i:
        end = i.find(';')
        start = i.find('SELECT')
        query_list.append(i[start:end+1])


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
    assert ans[9] == output[9]

    
    
cur.close()
conn.close()

