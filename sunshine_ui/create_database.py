import sqlite3

conn = sqlite3.connect("database_sunshine.db") # или :memory: чтобы сохранить в RAM
cursor = conn.cursor()



wand_troggle = False
music_troggle = False
off_troggle = False
sleep_troggle = False
paint_troggle = False

cursor.execute("""CREATE TABLE info
                  (int id, 
                  boolean wand_troggle,
                  boolean music_troggle,
                  boolean off_troggle,
                  boolean sleep_troggle,
                  boolean paint_troggle,
                  
                   
                   release_date text,
                   publisher text, media_type text)
               """)

conn.commit()
